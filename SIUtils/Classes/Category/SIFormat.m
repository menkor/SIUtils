//
//  SIFormat.m
//  SuperId
//
//  Created by Ye Tao on 2017/3/27.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIFormat.h"
#import "NSDate+Format.h"
#import <UIKit/UIKit.h>

//yyyy年MM月dd日
NSString *const kSIFormatBirthday = @"birthday";
//1MB 1KB 1.11GB
NSString *const kSIFormatFileSize = @"size";
/*
 yyyy-MM-dd HH:mm
 */
NSString *const kSIFormatModifyTime = @"modifyTime";

NSString *const kSIFormatTaskTime = @"taskTime"; //yyyy/MM/dd HH:mm
/*
 yyyy年MM月dd日 HH:mm
 */
NSString *const kSIFormatCNModifyTime = @"CNModifyTime";
//yyyy-MM-dd
NSString *const kSIFormatShortDate = @"shortDate";
//yyyy.MM.dd
NSString *const kSIFormatShortDotDate = @"shortDotDate";
//[YY年]MM月dd日
NSString *const kSIFormatShortMonthDate = @"shortMonthDate";

NSString *const kSIFormatInvalidateDate = @"invalidateDate";

NSString *const kSIFormatSecondToMinute = @"secondToMinute";

NSString *const kSIFormatFullTime = @"fullTime";
//11,111.00
NSString *const kSIFormatNumber = @"number";

#define kSIFormatTaskTimeFormatDict @{              \
    kSIFormatFullTime: @"yyyy-MM-dd HH:mm:SS",      \
    kSIFormatModifyTime: @"yyyy-MM-dd HH:mm",       \
    kSIFormatTaskTime: @"yyyy/MM/dd HH:mm",         \
    kSIFormatCNModifyTime: @"yyyy年MM月dd日 HH:mm", \
    kSIFormatBirthday: @"yyyy年MM月dd日",           \
    kSIFormatShortDate: @"yyyy-MM-dd",              \
    kSIFormatShortDotDate: @"yyyy.MM.dd",           \
    kSIFormatShortMonthDate: @"MM月dd日",           \
    kSIFormatInvalidateDate: @"MM月dd日HH:mm",      \
}

@interface SIFormat ()

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation SIFormat

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dict = [NSMutableDictionary dictionaryWithCapacity:2];
        [self initData];
    }
    return self;
}

- (void)initData {
    _dict[kSIFormatFileSize] = ^NSString *(id raw) {
        CGFloat size = [raw integerValue];
        if (size > pow(1024, 3)) { //GB
            return [NSString stringWithFormat:@"%.2fGB", (size / pow(1024, 3))];
        } else if (size > pow(1024, 2)) { //MB
            return [NSString stringWithFormat:@"%.2fMB", (size / pow(1024, 2))];
        } else if (size > 1024) { //KB
            return [NSString stringWithFormat:@"%.2fKB", (size / 1024)];
        } else { //B
            return [NSString stringWithFormat:@"%.2fB", size];
        }
    };

    _general = ^NSString *(id raw, NSString *format) {
        NSDate *date;
        if ([raw isKindOfClass:[NSNumber class]]) {
            NSTimeInterval timeInterval = [raw integerValue] / 1000;
            if (timeInterval == 0) {
                return @"";
            }
            date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        } else if ([raw isKindOfClass:[NSDate class]]) {
            date = raw;
        } else {
            return @"";
        }
        return [date stringFromFormat:format];
    };
    __weak typeof(self) weak_self = self;
    [kSIFormatTaskTimeFormatDict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        _dict[key] = ^NSString *(id raw) {
            return weak_self.general(raw, obj);
        };
    }];

    _dict[kSIFormatSecondToMinute] = ^NSString *(NSNumber *raw) {
        NSUInteger minutes = raw.unsignedIntegerValue / 60;
        NSUInteger seconds = raw.unsignedIntegerValue % 60;
        return [NSString stringWithFormat:@"%zd:%02zd", minutes, seconds];
    };

    _dict[kSIFormatNumber] = ^NSString *(id raw) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00"];
        return [numberFormatter stringFromNumber:@([raw doubleValue])];
    };
}

- (SIFormatBlock)formatBlockForKey:(NSString *)key {
    return _dict[key];
}

@end

@implementation NSObject (SIFormat)

- (id)formatForKey:(NSString *)key {
    id value = self;
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        value = [self valueForKey:key];
    }
    SIFormatBlock block = [[SIFormat sharedInstance] formatBlockForKey:key];
    if (block) {
        return block(value);
    }
    return value;
}

@end

@implementation NSNumber (SIFormat)

- (NSString *)si_format {
    return [self formatForKey:kSIFormatNumber];
}

@end
