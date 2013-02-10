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
    BOOL isTaken = [_validator isKeyCode:[aShortcut[SRShortcutKeyCode] unsignedShortValue] andFlagsTaken:[aShortcut[SRShortcutModifierFlagsKey] unsignedIntegerValue] error:&error];

    if (isTaken)
    {
        NSBeep();
        [self presentError:error
            modalForWindow:self.window
                  delegate:nil
        didPresentSelector:NULL
               contextInfo:NULL];
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

- (BOOL)shortcutValidator:(SRValidator *)aValidator isKeyCode:(unsigned short)aKeyCode andFlagsTaken:(NSUInteger)aFlags reason:(NSString **)outReason
{
#define IS_TAKEN(aRecorder) (recorder != (aRecorder) && SRShortcutEqualToShortcut(shortcut, [(aRecorder) objectValue]))
    SRRecorderControl *recorder = (SRRecorderControl *)self.window.firstResponder;

    if (![recorder isKindOfClass:[SRRecorderControl class]])
        return NO;

    NSDictionary *shortcut = SRShortcutWithCocoaModifierFlagsAndKeyCode(aFlags, aKeyCode);

    if (IS_TAKEN(_pingShortcutRecorder) ||
        IS_TAKEN(_globalPingShortcutRecorder))
    {
        *outReason = @"it's already used. To use this shortcut, first remove or change the other shortcut";
        return YES;
    }
    else
        return NO;
#undef IS_TAKEN
}

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
