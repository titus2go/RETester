//
//  TCRETester.m
//  RETester
//
//  Created by Titus Cheng on 6/15/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import "TCRETester.h"

@implementation TCRETester

- (void)setMainText:(NSString *)text
{
    main_text = text;
}

- (NSString *)getMaintText
{
    if([main_text isEqual:@""] || [main_text isEqual:nil])
    {
        main_text = @"";
    }
    return main_text;
}

/* Returns an array of ranges */
- (NSArray *)parseSource:(NSString *)text fromPattern:(NSString *)pattern
{
    NSArray *matches;
    {
        regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    }
    return matches;
}

- (NSMutableArray *)parseSourceToStringArray:(NSString *)text fromPattern:(NSString *)pattern
{
    NSArray *links = [self parseSource:text fromPattern:pattern];
    NSMutableArray *temp_links = [[NSMutableArray alloc] init];
    for(NSTextCheckingResult *eachMatch in links)
    {
        NSRange matchRange = eachMatch.range;
        [temp_links addObject:[text substringWithRange:matchRange]];
    }
    return temp_links;
}

- (NSString *)escapePatternFromString:(NSString *)pattern
{
    return [NSRegularExpression escapedPatternForString:pattern];
}

- (NSString *)fetchDataFromURL:(NSString *)url
{
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



@end
