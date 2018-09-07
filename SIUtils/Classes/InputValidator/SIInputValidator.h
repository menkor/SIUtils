//
//  SIInputValidator.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/8.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SIInputValidatorType) {
    SIInputValidatorTypeInt,
    SIInputValidatorTypeFloat,  //2位小数
    SIInputValidatorTypeDouble, //随便位小数
    SIInputValidatorTypeUsername,
    SIInputValidatorTypeVerifyCode,
    SIInputValidatorTypePhoneNum,
    SIInputValidatorTypeEmail,
    SIInputValidatorTypeID,
    SIInputValidatorTypePassword,
    SIInputValidatorTypePassport,
    SIInputValidatorTypeAllianceName,
    SIInputValidatorTypeAllianceCode,
};

@interface NSString (InputCheck)

- (BOOL)validateWithType:(SIInputValidatorType)type;

@end
