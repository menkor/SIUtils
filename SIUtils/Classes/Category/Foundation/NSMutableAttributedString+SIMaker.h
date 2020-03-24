//
//  NSMutableAttributedString+SIMaker.h
//  SIMaterial_Example
//
//  Created by Ye Tao on 2018/8/22.
//  Copyright © 2018年 ungacy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (SIMaker)

- (void)append:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

- (void)append:(NSString *)text hex:(unsigned long)hex font:(UIFont *)font;

/*
 [SIFont systemFontOfSize:12]
 */
- (void)append:(NSString *)text hex:(unsigned long)hex;

/*
 #4A4A4A
 
 [SIFont systemFontOfSize:12]
 */

- (void)append:(NSString *)text;

@end
