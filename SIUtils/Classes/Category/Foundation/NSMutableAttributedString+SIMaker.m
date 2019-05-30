//
//  NSMutableAttributedString+SIMaker.m
//  SIMaterial_Example
//
//  Created by Ye Tao on 2018/8/22.
//  Copyright © 2018年 ungacy. All rights reserved.
//

#import "NSMutableAttributedString+SIMaker.h"
#import <SITheme/SIColor.h>
#import <SITheme/SIFont.h>

@implementation NSMutableAttributedString (SIMaker)

- (void)append:(NSString *)text hex:(unsigned long)hex font:(UIFont *)font {
    if (!text) {
        return;
    }
    NSAttributedString *some = [[NSAttributedString alloc] initWithString:text
                                                               attributes:@{
                                                                   NSForegroundColorAttributeName: [SIColor colorWithHex:hex],
                                                                   NSFontAttributeName: font,

                                                               }];
    [self appendAttributedString:some];
}

- (void)append:(NSString *)text hex:(unsigned long)hex {
    [self append:text hex:hex font:[SIFont systemFontOfSize:12]];
}

- (void)append:(NSString *)text {
    [self append:text hex:0x4A4A4A font:[SIFont systemFontOfSize:12]];
}

@end
