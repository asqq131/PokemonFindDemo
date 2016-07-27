//
//  NSString+InvalidNull.m
//  ZWScrollTableViewCtrlDemo
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSString+InvalidNull.h"

@implementation NSString (InvalidNull)

+ (NSString *)stringUtils:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    
    if([string isEqualToString:@"<null>"]) {
        string = @"";
    }
    
    if(string == nil) {
        string = @"";
    }
    
    if(string.length == 0) {
        string = @"";
    }
    
    if([string isEqualToString:@"null"]) {
        string = @"";
    }
    
    if([string isEqualToString:@"(null)"]) {
        string = @"";
    }
    
    return string;
}

- (BOOL)isInvalid {
    return [self isEqualToString:@""];
}

@end
