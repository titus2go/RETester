//
//  REController.m
//  RETester
//
//  Created by Titus Cheng on 6/15/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import "REController.h"
#import "AppDelegate.h"

#define UWTACOMA_MAIN_PAGE_CATEGORY_PATTERN @"<P><B>\(\?:\\w\|\\s\|-\)\+<\/B><BR>\(\?:\\n\*\|<!--\\n\(\?:<\|\\w\|\\s\|=\|\"\|:\|\\\/\|\\\.\|>\|;\)\+\\n-->\)\+<ul>\\n\(\(\?:\(\(<!--\\s\)\*\)<LI><a href=\\w\+\\\.html>\(\?:\\w\|\\s\|-\)\+\\\(\(\?:\\w\|\\s\|\\&\|\\;\)\+\\\)<\/a><\/li>\(\\s-->\)\*\\s\*\(\\n\|\\r\)\*\)\)\+<\/ul>"

@implementation REController

- (id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"Something");
}

- (void)windowDidLoad
{
    [self start];
    NSLog(@"This is happening");
}

- (void)start
{
//    NSError *error = NULL;
//    NSString *data = [NSString stringWithContentsOfFile:@"data.txt" encoding:NSUTF8StringEncoding error:&error];
//    if(!data)
//    {
//        data = @"Not reading data";
//        NSLog(@"%@", error);
//    }
//    [[my_original_view documentView] setString:data];
    [my_re_options removeAllItems];
}

- (IBAction)transformButtonPressed:(id)sender
{
    NSError *error = NULL;
    NSString *data = [NSString stringWithContentsOfFile:@"data.txt" encoding:NSUTF8StringEncoding error:&error];
    if(!data)
    {
        data = @"Not reading data";
        NSLog(@"%@", error);
    }
    if(![[[[my_original_view documentView] textStorage] string] isEqual:@""])
    {
        data = [[[my_original_view documentView] textStorage] string];
    }
    [[my_original_view documentView] setString:data];
    original_text = [[[my_original_view documentView] textStorage] string];
    [self extract];
    [my_re_options removeAllItems];
    
}
- (IBAction)copyButtonPressed:(id)sender {
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: [my_escaped_exp_field stringValue] forType:NSStringPboardType];
    [my_escaped_exp_field selectText:self];
}
- (IBAction)REOptionChanged:(id)sender
{
    [my_regular_exp_field setStringValue:[my_re_options titleOfSelectedItem]];
}
- (IBAction)saveButtonPressed:(id)sender {
    if(![[my_regular_exp_field stringValue] isEqual:@""])
    {
        [my_re_options addItemWithTitle:[my_regular_exp_field stringValue]];
    }

}

- (IBAction)navigateButtonPressed:(id)sender
{
    NSString *link = [my_url_link stringValue];
    if(![link hasPrefix:@"http://www."])
    {
        link = [@"http://www." stringByAppendingFormat:@"%@", link];
    }
    else if(![link hasPrefix:@"http://"])
    {
        link = [@"http://" stringByAppendingFormat:@"%@", link];
    }
    [[my_original_view documentView] setString:[self getDataFrom:link]];
}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        return nil;
    }
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

- (void)extract
{
    
    NSError *error = NULL;
    NSString *expression = my_regular_exp_field.stringValue;
    [my_escaped_exp_field setStringValue:[NSRegularExpression escapedPatternForString:expression]];
    NSString *Text = [[[my_original_view documentView] textStorage] string];
    regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:Text options:0 range:NSMakeRange(0, [Text length])];
    NSArray *matches = [regex matchesInString:Text
                                    options:0
                                    range:NSMakeRange(0, [Text length])];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        [[[my_original_view documentView] textStorage] addAttribute:NSBackgroundColorAttributeName value:[NSColor yellowColor] range:matchRange];
 //       [[[my_transformed_view documentView] textStorage] showFindIndicatorForRange:matchRange];
     //  NSLog(@"Here it is");
    }
    
}

@end
