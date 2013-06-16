//
//  DialogController.h
//  RETester
//
//  Created by Titus Cheng on 6/16/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DialogController : NSWindowController
{
    IBOutlet NSTextField *textField;
    IBOutlet NSButton *copyAndClose;
}

- (void)setText:(NSString *)content;

@end
