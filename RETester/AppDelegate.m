//
//  AppDelegate.m
//  RETester
//
//  Created by Titus Cheng on 6/15/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import "AppDelegate.h"
#import "DialogController.h"

#define UWTACOMA_MAIN_PAGE_CATEGORY_PATTERN @"<P><B>\(\?:\\w\|\\s\|-\)\+<\/B><BR>\(\?:\\n\*\|<!--\\n\(\?:<\|\\w\|\\s\|=\|\"\|:\|\\\/\|\\\.\|>\|;\)\+\\n-->\)\+<ul>\\n\(\(\?:\(\(<!--\\s\)\*\)<LI><a href=\\w\+\\\.html>\(\?:\\w\|\\s\|-\)\+\\\(\(\?:\\w\|\\s\|\\&\|\\;\)\+\\\)<\/a><\/li>\(\\s-->\)\*\\s\*\(\\n\|\\r\)\*\)\)\+<\/ul>"

#define UWTACOMA_MAIN_PAGE_LINK_PATTERN @"\(\?!\(<!--\\s\)\*<li><a href=\)\\w\+\\\.html\(\?=>\(\\w\|\\s\|\\\(\|\\\)\|&\|\\;\|\\-\)\+<\/a><\/li>\(\\s-->\)\*\)"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Reset all items in pop box */
    [my_re_options removeAllItems];
    my_regex_tester = [[TCRETester alloc] init];
    my_regex_tester = [[TCRETester alloc] init];
    matches = [[NSMutableArray alloc] init];
    my_link_browser = (NSTableView *)[link_browser documentView];
    [self setUpTable];
    alert = [[NSAlert alloc] init];
    parsed_result = [[NSMutableArray alloc] init];
}

- (void)setUpTable
{
    my_link_browser = (NSTableView *)[link_browser documentView];
    [my_link_browser setDelegate:self];
    [my_link_browser setDataSource:self];
}


- (IBAction)parseButtonPressed:(id)sender {
 //   my_regex_tester = [[TCRETester alloc] init];
    NSString *regular_expression = [my_regular_exp_field stringValue];
    if(![regular_expression isEqual:@""])
    {
        /* Remove previous highlighted match strings */
        [self clearMatchesInOriginalView];
        
        /* Highlight matched strings */
        if(![[[[my_original_view documentView] textStorage] string] isEqual:@""])
        {
            [matches addObjectsFromArray:[my_regex_tester parseSource:[my_regex_tester getMaintText] fromPattern:regular_expression]];
            [self highlightMatches];
            [self populateTableView];
            [regexInfoLabel setStringValue:[NSString stringWithFormat:@"%ld matches found!", [matches count]]];
        }
        /* Convert regular expression into string literal */
        [my_escaped_exp_field setStringValue:[my_regex_tester escapePatternFromString:regular_expression]];
    
    }
}
             
- (void)populateTableView
{
    NSString *text = [[[my_original_view documentView] textStorage] string];
    [parsed_result removeAllObjects];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        [parsed_result addObject:[text substringWithRange:matchRange]];
        NSLog(@"%@", [text substringWithRange:matchRange]);
    }
    [my_link_browser reloadData];

}



- (IBAction)saveButtonPressed:(id)sender {
    if(![[my_regular_exp_field stringValue] isEqual:@""])
    {
        [my_re_options addItemWithTitle:[my_regular_exp_field stringValue]];
    }

}


- (IBAction)copyButtonPressed:(id)sender {
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: [my_escaped_exp_field stringValue] forType:NSStringPboardType];
    [my_escaped_exp_field selectText:self];
}

- (void)copy:(NSString *)content
{
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString:content forType:NSStringPboardType];
}

- (IBAction)fetchButtonPressed:(id)sender {
    NSString *link = [my_url_link stringValue];
    if(![link isEqual:@""]){
        NSString *data;
        if(![link hasPrefix:@"http://www."])
        {
            link = [@"http://www." stringByAppendingFormat:@"%@", link];
        }
        else if(![link hasPrefix:@"http://"])
        {
            link = [@"http://" stringByAppendingFormat:@"%@", link];
        }
        data = [my_regex_tester fetchDataFromURL:link];
        if(data){
            [my_regex_tester setMainText:data];
            [[my_original_view documentView] setString:data];
        } else{
            NSLog(@"Can't fetch data");
        }
    }
}

- (IBAction)reOptionsChanged:(id)sender {
    [my_regular_exp_field setStringValue:[my_re_options titleOfSelectedItem]];
}
- (IBAction)escapeREButtonPressed:(id)sender {
    if(!dialogController) {
        dialogController = [[DialogController alloc] init];
    }
    if([[my_regular_exp_field stringValue] isEqualToString:@""])
    {
        alert = [[[NSAlert alloc] init] autorelease];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Oops, something is wrong"];
        [alert setInformativeText:@"Regular expression is empty!"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        
    }
    else
    {
     //   [dialogController.window center];
        [dialogController showWindow:self];
        [dialogController setText:[my_regex_tester escapePatternFromString:[my_regular_exp_field stringValue]]];
    }
}
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        
    }
}
- (IBAction)insertClicked:(id)sender {
    
//    NSInteger selectedIndex = [my_link_browser selectedRow];
//    [[self.window firstResponder] insertText:[parsed_result objectAtIndex:selectedIndex]];
    
}


- (void)clearMatchesInOriginalView
{
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        [[[my_original_view documentView] textStorage] removeAttribute:NSBackgroundColorAttributeName range:matchRange];
    }
    [matches removeAllObjects];
}


- (void)highlightMatches
{
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        [[[my_original_view documentView] textStorage] addAttribute:NSBackgroundColorAttributeName value:[NSColor yellowColor] range:matchRange];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger count = 0;
    if(parsed_result)
    {
        count = [parsed_result count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    id returnValue=nil;
    
    NSString *columnIdentifier = [tableColumn identifier];
    
    NSString *theLink = [parsed_result objectAtIndex:row];
    
    if([columnIdentifier isEqualToString:@"Available Links"])
    {
        returnValue = theLink;
    }
    return returnValue;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSInteger index = [my_link_browser selectedRow];
    NSString *result = [parsed_result objectAtIndex:index];
    [self copy:result];
    [copyStatusLabel setStringValue:[NSString stringWithFormat:@"\"%@\"  copied!", result]];
    
}







@end
