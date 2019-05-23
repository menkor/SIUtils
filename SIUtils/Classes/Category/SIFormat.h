//
//  SIFormat.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/27.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *SIFormatRawWithKey(id raw, NSString *key);

#pragma mark - Format

typedef NSString * (^SIFormatGeneralDateBlock)(id raw, NSString *format);

typedef NSString * (^SIFormatBlock)(id raw);

extern NSString *const kSIFormatBirthday; //yyyy年MM月dd日

extern NSString *const kSIFormatFileSize;

extern NSString *const kSIFormatModifyTime; //yyyy-MM-dd HH:mm

extern NSString *const kSIFormatFullTime; //yyyy-MM-dd HH:mm:SS

extern NSString *const kSIFormatTaskTime; //yyyy/MM/dd HH:mm

extern NSString *const kSIFormatCNModifyTime; //yyyy年MM月dd日 HH:mm

extern NSString *const kSIFormatShortDate; //yyyy-MM-dd

extern NSString *const kSIFormatShortDotDate; //yyyy.MM.dd

extern NSString *const kSIFormatShortMonthDate; //[YY年]MM月dd日

extern NSString *const kSIFormatInvalidateDate;

extern NSString *const kSIFormatNumber; //11,111.00

extern NSString *const kSIFormatSecondToMinute; //75″ to 1′25″

extern NSString *const kSIFormatTimeDuration; //75″ to 01:25

@interface SIFormat : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) SIFormatGeneralDateBlock general;

- (SIFormatBlock)formatBlockForKey:(NSString *)key;

@end
