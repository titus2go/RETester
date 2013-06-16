//
//  TCRETester.h
//  RETester
//
//  Created by Titus Cheng on 6/15/13.
//  Copyright (c) 2013 Titus Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCRETester : NSObject
{
    NSRegularExpression *regex;
    NSString *main_text;
    NSError *error;
    
}

- (NSArray *)parseSource:(NSString *)text fromPattern:(NSString *)pattern;
- (NSMutableArray *)parseSourceToStringArray:(NSString *)text fromPattern:(NSString *)pattern;
- (NSString *)escapePatternFromString:(NSString *)pattern;
- (NSString *)fetchDataFromURL:(NSString *)url;
- (void)setMainText:(NSString *)text;
- (NSString *)getMaintText;

@end
