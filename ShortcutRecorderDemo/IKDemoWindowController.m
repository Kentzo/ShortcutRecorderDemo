//
//  IKDemoWindowController.m
//  ShortcutRecorderDemo
//
//  Created by Ilya Kulakov on 18.01.13.
//  Copyright (c) 2013 Ilya Kulakov. All rights reserved.
//

#import <PTHotKey/PTHotKeyCenter.h>
#import "IKDemoWindowController.h"


@implementation IKDemoWindowController
{
    SRValidator *_validator;
}

#pragma mark SRRecorderControlDelegate

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder canRecordShortcut:(NSDictionary *)aShortcut
{
    __autoreleasing NSError *error = nil;
    BOOL isTaken = NO;
    
    if ((aRecorder != self.pingShortcutRecorder && SRShortcutEqualToShortcut(aShortcut, self.pingShortcutRecorder.objectValue)) ||
        (aRecorder != self.globalPingShortcutRecorder && SRShortcutEqualToShortcut(aShortcut, self.globalPingShortcutRecorder.objectValue)))
    {
        isTaken = YES;
        NSDictionary *userInfo = @{
            NSLocalizedFailureReasonErrorKey: SRLoc(@"The key combination %@ can't be used!"),
            NSLocalizedDescriptionKey: SRLoc(@"The key combination \"%@\" can't be used because it's already used by other shortcut.")
        };
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                    code:0
                                userInfo:userInfo];
    }
    else
    {
        isTaken = [_validator isKeyCode:[aShortcut[SRShortcutKeyCode] unsignedShortValue]
                          andFlagsTaken:[aShortcut[SRShortcutModifierFlagsKey] unsignedIntegerValue]
                                  error:&error];
    }

    if (isTaken)
    {
        NSBeep();
        [NSApp presentError:error];
    }

    return !isTaken;
}

- (BOOL)shortcutRecorderShouldBeginRecording:(SRRecorderControl *)aRecorder
{
    [[PTHotKeyCenter sharedCenter] pause];
    return YES;
}

- (void)shortcutRecorderDidEndRecording:(SRRecorderControl *)aRecorder
{
    [[PTHotKeyCenter sharedCenter] resume];
}


#pragma mark SRValidatorDelegate

- (BOOL)shortcutValidatorShouldUseASCIIStringForKeyCodes:(SRValidator *)aValidator
{
    return YES;
}


#pragma mark NSObject

- (void)awakeFromNib
{
    [super awakeFromNib];
    _validator = [[SRValidator alloc] initWithDelegate:self];
}

@end
