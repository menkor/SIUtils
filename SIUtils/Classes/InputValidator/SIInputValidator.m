//
//  SIInputValidator.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/8.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIInputValidator.h"

static NSDictionary *_SIInputValidatorRegexMap;

@interface SIInputValidator : NSObject

//+ (BOOL)validateWithType:(SIInputValidatorType)type string:(NSString *)string;

@end

@implementation SIInputValidator

+ (void)load {
    _SIInputValidatorRegexMap = @{
        @(SIInputValidatorTypeInt): @"^(\\-*[1-9][0-9]*)|0$",
        @(SIInputValidatorTypeFloat): @"^(0*|[1-9][0-9]*)+(\\.[0-9]{0,2})?$",
        @(SIInputValidatorTypeUsername): @"[\u4e00-\u9fa5a-zA-Z]+",
        @(SIInputValidatorTypeVerifyCode): @"[0-9]{0,6}",
        @(SIInputValidatorTypePhoneNum): @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$",
        @(SIInputValidatorTypeEmail): @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}",
        @(SIInputValidatorTypeID): @"^(\\d{14}|\\d{17})(\\d|[xX])$",
        @(SIInputValidatorTypePassword): @"((?=.*[a-zA-Z])(?=.*[0-9])|(?=.*[0-9])(?=.*[@#$%&/=?_.,:;\\-])|(?=.*[a-zA-Z])(?=.*[@#$%&/=?_.,:;\\-])|(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@#$%&/=?_.,:;\\-])).{6,32}",
        @(SIInputValidatorTypePassport): @"^1[45][0-9]{7}|([P|p|S|s]\\d{7})|([S|s|G|g]\\d{8})|([Gg|Tt|Ss|Ll|Qq|Dd|Aa|Ff]\\d{8})|([H|h|M|m]\\d{8，10})$",
        @(SIInputValidatorTypeAllianceName): @"[\u4e00-\u9fa5a-zA-Z0-9]{2,15}",
        @(SIInputValidatorTypeAllianceCode): @"[A-Z]{2,15}",
    };
}

+ (BOOL)validateWithType:(SIInputValidatorType)type string:(NSString *)string {
    NSString *regex = _SIInputValidatorRegexMap[@(type)]; //正则表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

@end

@implementation NSString (InputCheck)

- (BOOL)validateWithType:(SIInputValidatorType)type {
    return [SIInputValidator validateWithType:type string:self];
}

@end