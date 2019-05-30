//
//  UIView+SIKit.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kSIBottomLineDefaultLeftMargin = 12;

typedef NS_ENUM(NSUInteger, SILinePosition) {
    SILinePositionTop,
    SILinePositionBottom,
    SILinePositionLeft,
    SILinePositionRight,
};

@interface SILineMaker : NSObject

- (SILineMaker * (^)(SILinePosition position))position; //default is `SILinePositionBottom`

- (SILineMaker * (^)(CGFloat height))height; //default is `0.5`

- (SILineMaker * (^)(UIColor *color))color; //default is `[SIColor colorWithHex:0xdcdcdc] `

- (SILineMaker * (^)(UIOffset offset))offset; //default is `UIOffsetMake(12, 0)`

- (SILineMaker * (^)(BOOL dashline))dashline; //default is `NO`

- (UIView *)make;

@end

@interface UIView (SIKit)

+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

- (UIView *)si_lineMake:(void (^)(SILineMaker *make))block;

@end

@interface NSString (SIKit_Height)

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

@end
