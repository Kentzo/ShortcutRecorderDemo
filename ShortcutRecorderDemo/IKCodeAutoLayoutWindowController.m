//
//  IKCodeAutoLayoutWindowController.m
//  ShortcutRecorderDemo
//
//  Created by Ilya Kulakov on 21.01.13.
//  Copyright (c) 2013 Ilya Kulakov. All rights reserved.
//

#import "IKCodeAutoLayoutWindowController.h"


@implementation IKCodeAutoLayoutWindowController

#pragma mark NSWindowController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    SRRecorderControl *pingShortcutRecorder = [[SRRecorderControl alloc] initWithFrame:NSZeroRect];
    pingShortcutRecorder.delegate = self;
    SRRecorderControl *globalPingShortcutRecorder = [[SRRecorderControl alloc] initWithFrame:NSZeroRect];
    globalPingShortcutRecorder.delegate = self;
    NSTextField *pingLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
    pingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    pingLabel.font = [NSFont systemFontOfSize:13];
    pingLabel.editable = NO;
    pingLabel.selectable = NO;
    pingLabel.bezeled = NO;
    pingLabel.alignment = NSRightTextAlignment;
    pingLabel.stringValue = @"Ping:";
    pingLabel.drawsBackground = NO;
    [pingLabel setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    NSTextField *globalPingLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
    globalPingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    globalPingLabel.font = [NSFont systemFontOfSize:13];
    globalPingLabel.editable = NO;
    globalPingLabel.selectable = NO;
    globalPingLabel.bezeled = NO;
    globalPingLabel.alignment = NSRightTextAlignment;
    globalPingLabel.stringValue = @"Global Ping:";
    globalPingLabel.drawsBackground = NO;
    [globalPingLabel setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    NSView *v = self.window.contentView;
    [v addSubview:pingShortcutRecorder];
    [v addSubview:globalPingShortcutRecorder];
    [v addSubview:pingLabel];
    [v addSubview:globalPingLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(pingShortcutRecorder, globalPingShortcutRecorder, pingLabel, globalPingLabel);
    [v addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[pingLabel(==globalPingLabel)]-[pingShortcutRecorder(>=100)]-|"
                                                              options:NSLayoutFormatAlignAllBaseline
                                                              metrics:nil
                                                                views:views]];
    [v addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[globalPingLabel(==80)]-[globalPingShortcutRecorder(==pingShortcutRecorder)]-|"
                                                              options:NSLayoutFormatAlignAllBaseline
                                                              metrics:nil
                                                                views:views]];
    [v addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[pingShortcutRecorder(==25)]-[globalPingShortcutRecorder(==25)]-|"
                                                              options:0
                                                              metrics:nil
                                                                views:views]];
    
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    self.pingShortcutRecorder = pingShortcutRecorder;
    [self.pingShortcutRecorder bind:NSValueBinding
                           toObject:defaults
                        withKeyPath:@"values.ping"
                            options:nil];
    self.globalPingShortcutRecorder = globalPingShortcutRecorder;
    [self.globalPingShortcutRecorder bind:NSValueBinding
                                 toObject:defaults
                              withKeyPath:@"values.globalPing"
                                  options:nil];
}

@end
