//
//  UIView+SIAutoSize.m
//  SuperId
//
//  Created by Ye Tao on 2017/3/28.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "UIView+SIAutoSize.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYLabel.h>

@implementation NSObject (SIAutoSize)

- (CGFloat)si_widthToFit {
    return 0;
}

@end

@interface YYLabel (SIAutoSize)

- (CGFloat)si_widthToFit;

@end

@implementation UILabel (SIAutoSize)

- (CGFloat)si_widthToFit {
    CGFloat width = ceilf([self.text sizeWithAttributes:@{
                              NSFontAttributeName: self.font
                          }]
                              .width);
    if (!self.text && self.attributedText) {
        YYTextContainer *titleContarer = [YYTextContainer new];
        titleContarer.size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        width = [YYTextLayout layoutWithContainer:titleContarer text:self.attributedText.string].textBoundingSize.width;
    }
    self.adjustsFontSizeToFitWidth = YES;
    self.minimumScaleFactor = 0.5;
    self.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    return width;
}

- (CGFloat)si_widthToFitMax:(CGFloat)max {
    CGFloat width = ceilf([self.text sizeWithAttributes:@{
                              NSFontAttributeName: self.font
                          }]
                              .width);
    if (width > max) {
        width = max;
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumScaleFactor = 0.3;
    }
    self.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    return width;
}

- (CGSize)si_sizeToFit:(CGFloat)width {
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:NULL].size;
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return size;
}

- (CGSize)si_size {
    CGSize size = [self.text sizeWithAttributes:@{
        NSFontAttributeName: self.font
    }];
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    return size;
}

- (void)si_setNumberOfLine:(NSUInteger)lines {
    self.numberOfLines = lines;
    CGSize maxSize = CGSizeMake(self.frame.size.width, self.font.lineHeight * lines);
    CGSize size = [self.text boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName: self.font}
                                          context:nil]
                      .size;
    if (size.width == 0) {
        size.height = 0;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceilf(size.height));
    }];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.hyphenationFactor = 1; //0~1
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributesDict = @{NSParagraphStyleAttributeName: style};
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributesDict];
}

@end

@implementation YYLabel (SIAutoSize)

- (CGFloat)si_widthToFit {
    CGFloat width = ceilf([self.text sizeWithAttributes:@{
                              NSFontAttributeName: self.font
                          }]
                              .width);
    width = MIN(width, CGRectGetWidth([UIScreen mainScreen].bounds) - 100);
    self.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    return width;
}

@end

@implementation UITextField (SIAutoSize)

- (CGFloat)si_widthToFit {
    NSString *text = self.text;
    if (text.length == 0) {
        text = self.placeholder;
    }
    CGSize size = [text sizeWithAttributes:@{
        NSFontAttributeName: self.font
    }];
    CGFloat leftWidth = self.leftView.frame.size.width;
    CGFloat rightWidth = self.rightView.frame.size.width;
    CGFloat width = ceilf(size.width + leftWidth + rightWidth);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    return width;
}

- (CGFloat)si_widthToFitWithMinWidth:(CGFloat)min {
    CGSize size = [self.text sizeWithAttributes:@{
        NSFontAttributeName: self.font
    }];
    CGFloat leftWidth = self.leftView.frame.size.width;
    CGFloat rightWidth = self.rightView.frame.size.width;
    CGFloat width = MAX(ceilf(size.width + leftWidth + rightWidth), min);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    return width;
}

- (CGSize)si_sizeToFit:(CGFloat)width {
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:NULL].size;
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return size;
}

@end
