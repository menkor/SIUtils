//
//  SIInputValidator.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/8.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIInputValidator.h"

static NSDictionary *_SIInputValidatorRegexMap;

@interface SIInputValidator ()

//+ (BOOL)validateWithType:(SIInputValidatorType)type string:(NSString *)string;

@end

@implementation SIInputValidator

+ (void)load {
    _SIInputValidatorRegexMap = @{
        @(SIInputValidatorTypeInt): @"^(\\-*[1-9][0-9]*)|0$",
        @(SIInputValidatorTypeFloat): @"^(0*|[1-9][0-9]*)+(\\.[0-9]{0,2})?$",
        @(SIInputValidatorTypeDouble): @"^(0*|[1-9][0-9]*)+(\\.[0-9]*)?$",
        @(SIInputValidatorTypeUsername): @"[\u4e00-\u9fa5a-zA-Z·]+",
        @(SIInputValidatorTypeVerifyCode): @"[0-9]{0,6}",
        @(SIInputValidatorTypePhoneNum): @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$",
        @(SIInputValidatorTypeEmail): @"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\\.)+[a-zA-Z]{2,}))$",
        @(SIInputValidatorTypeID): @"^(\\d{14}|\\d{17})(\\d|[xX])$",
        @(SIInputValidatorTypePassword): @"((?=.*[a-zA-Z])(?=.*[0-9])|(?=.*[0-9])(?=.*[@#$%&/=?_.,:;\\-])|(?=.*[a-zA-Z])(?=.*[@#$%&/=?_.,:;\\-])|(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@#$%&/=?_.,:;\\-])).{8,32}",
        @(SIInputValidatorTypePassport): @"^1[45][0-9]{7}|([P|p|S|s]\\d{7})|([S|s|G|g]\\d{8})|([Gg|Tt|Ss|Ll|Qq|Dd|Aa|Ff]\\d{8})|([H|h|M|m]\\d{8，10})$",
        @(SIInputValidatorTypeAllianceName): @"[\u4e00-\u9fa5a-zA-Z0-9]{2,15}",
        @(SIInputValidatorTypeAllianceCode): @"[A-Z]{2,15}",
    };
}

+ (BOOL)validateWithType:(SIInputValidatorType)type string:(NSString *)string {
    NSString *regex = _SIInputValidatorRegexMap[@(type)]; //正则表达式
    if (!regex) {
        return YES;
    }
    return [self validateWithRegex:regex string:string];
}

+ (BOOL)validateWithRegex:(NSString *)regex string:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

+ (NSString *)regexFor:(SIInputValidatorType)type {
    return _SIInputValidatorRegexMap[@(type)];
}

@end

@implementation NSString (InputCheck)

- (BOOL)validateWithRegex:(NSString *)regex {
    return [SIInputValidator validateWithRegex:regex string:self];
}

- (BOOL)validateWithType:(SIInputValidatorType)type {
    return [SIInputValidator validateWithType:type string:self];
}

@end
