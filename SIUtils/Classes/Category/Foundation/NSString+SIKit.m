//
//  NSString+SIKit.m
//  SuperId
//
//  Created by Ye Tao on 2017/9/20.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "NSString+SIKit.h"
#import <YYKit/YYLabel.h>

@implementation NSString (SIKit)

- (CGFloat)si_heightFitWidth:(CGFloat)width font:(UIFont *)font {
    CGFloat height = [self si_sizeFitWidth:width font:font].height;
    return ceil(height);
}

- (CGSize)si_sizeFitWidth:(CGFloat)width font:(UIFont *)font {
    if (self.length == 0) {
        return CGSizeZero;
    }
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:NSStringDrawingTruncatesLastVisibleLine |
                                      NSStringDrawingUsesLineFragmentOrigin |
                                      NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName: font}
                              context:NULL]
        .size;
}

- (CGFloat)si_widthWithFont:(UIFont *)font {
    return [self si_sizeFitWidth:CGFLOAT_MAX font:font].width;
}

@end

@implementation NSAttributedString (SIKit)

- (CGFloat)si_heightFitWidth:(CGFloat)width {
    return [self si_sizeFitWidth:width].height;
}

- (CGFloat)si_heightFitWidth:(CGFloat)width inset:(UIEdgeInsets)inset {
    return [self si_sizeFitWidth:width inset:inset].height;
}

- (CGSize)si_sizeFitWidth:(CGFloat)width {
    return [self si_sizeFitWidth:width inset:UIEdgeInsetsZero];
}

- (CGSize)si_sizeFitWidth:(CGFloat)width inset:(UIEdgeInsets)inset {
    if (self.length == 0) {
        return CGSizeZero;
    }
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.insets = inset;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:self];
    CGSize size = layout.textBoundingSize;
    return size;
}

- (CGSize)si_size {
    return [self si_sizeFitWidth:CGFLOAT_MAX];
}

- (CGFloat)si_width {
    YYTextContainer *titleContarer = [YYTextContainer new];
    titleContarer.size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    return [YYTextLayout layoutWithContainer:titleContarer text:self].textBoundingSize.width;
}

@end
