//
//  UIColor+SIKit.m
//  SuperId
//
//  Created by Ye Tao on 2017/12/23.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "UIColor+SIKit.h"

@implementation UIColor (SIKit)

- (NSNumber *)si_toHex {
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    //ignore alpha ?
    NSUInteger hex = (lroundf(red * 255) << 16) + (lroundf(green * 255) << 8) + blue;
    return @(hex);
}

@end
