//
//  NSDate+Format.m
//  SuperId
//
//  Created by Ye Tao on 2017/1/19.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "NSDate+Format.h"

@interface SIDateFormatterTool : NSObject

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation SIDateFormatterTool

+ (instancetype)sharedInstance {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

@end

@implementation NSDate (Format)

- (NSString *)stringFromFormat:(NSString *)format {
    NSDateFormatter *formatter = [SIDateFormatterTool sharedInstance].formatter;
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

@end

@implementation NSString (DateFormat)

- (NSDate *)dateFromFormat:(NSString *)format {
    NSDateFormatter *formatter = [SIDateFormatterTool sharedInstance].formatter;
    [formatter setDateFormat:format];
    return [formatter dateFromString:self];
}

@end
