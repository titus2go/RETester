//
//  REController.h
//  RETester
//
//  Created by Titus Cheng on 6/15/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REController : NSWindowController  <NSApplicationDelegate>
{
    NSString *original_text;
    NSString *transformed_text;
    NSRegularExpression *regex;
    IBOutlet NSTextField *my_regular_exp_field;
    IBOutlet NSScrollView *my_original_view;
    IBOutlet NSButton *my_transform_button;
    IBOutlet NSTextField *my_escaped_exp_field;
    IBOutlet NSButton *my_navigate_button;
    IBOutlet NSTextField *my_url_link;
    IBOutlet NSPopUpButton *my_re_options;
}

- (void)start;

@end
