//
//  NSString+SIKit.h
//  SuperId
//
//  Created by Ye Tao on 2017/9/20.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SIKit)

- (CGFloat)si_heightFitWidth:(CGFloat)width font:(UIFont *)font;

- (CGSize)si_sizeFitWidth:(CGFloat)width font:(UIFont *)font;

- (CGFloat)si_widthWithFont:(UIFont *)font;

- (NSMutableAttributedString *)match:(NSString *)key highlightAttr:(NSDictionary *)hightlightAttr defaultAttr:(NSDictionary *)defaultAttr;

@end

@interface NSAttributedString (SIKit)

- (CGFloat)si_heightFitWidth:(CGFloat)width;

- (CGFloat)si_heightFitWidth:(CGFloat)width inset:(UIEdgeInsets)inset;

- (CGSize)si_sizeFitWidth:(CGFloat)width;

- (CGSize)si_sizeFitWidth:(CGFloat)width inset:(UIEdgeInsets)inset;

- (CGSize)si_size;

- (CGFloat)si_width;

- (void)matchRegex:(NSString *)regexString replace:(NSString * (^)(NSString *capture))replace highlightAttr:(NSDictionary *)hightlightAttr;

@end
