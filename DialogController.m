//
//  DialogController.m
//  RETester
//
//  Created by Titus Cheng on 6/16/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import "DialogController.h"

@interface DialogController ()

@end

@implementation DialogController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)init
{
    self = [super initWithWindowNibName:@"DialogController" owner:self];
    [self.window center];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSLog(@"Nib file is loaded");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)copyAndCloseButtonPushed:(id)sender {
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: [textField stringValue] forType:NSStringPboardType];
    [textField selectText:self];
    [self.window orderOut:nil];
    
}

- (void)setText:(NSString *)content
{
    [textField setStringValue:content];
}

@end
