//
//  AppDelegate.h
//  RETester
//
//  Created by Titus Cheng on 6/15/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TCRETester.h"
//#import <WebKit/WebKit.h>
@class DialogController;

@interface AppDelegate : NSObject <NSBrowserDelegate, NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>
{
    NSMutableArray *matches;
    NSMutableArray *parsed_result;
    NSTableView *my_link_browser;
    NSAlert *alert;
    DialogController *dialogController;
    IBOutlet NSTextField *my_regular_exp_field;
    IBOutlet NSScrollView *my_original_view;
    IBOutlet NSButton *my_transform_button;
    IBOutlet NSTextField *my_escaped_exp_field;
    IBOutlet NSButton *my_navigate_button;
    IBOutlet NSTextField *my_url_link;
    IBOutlet NSPopUpButton *my_re_options;
    IBOutlet NSScrollView *link_browser;
    IBOutlet NSTextField *regexInfoLabel;
    IBOutlet NSTextField *copyStatusLabel;
    TCRETester *my_regex_tester;
}

@property (assign) IBOutlet NSWindow *window;


@end
