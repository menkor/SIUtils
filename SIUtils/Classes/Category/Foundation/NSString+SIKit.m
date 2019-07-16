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

- (NSMutableAttributedString *)match:(NSString *)key highlightAttr:(NSDictionary *)hightlightAttr defaultAttr:(NSDictionary *)defaultAttr {
    NSMutableAttributedString *matchContent = [[NSMutableAttributedString alloc] initWithString:self attributes:defaultAttr];
    if (key.length > 0) {
        NSRange range = NSMakeRange(0, 0);
        while (range.location != NSNotFound) {
            range = [self rangeOfString:key options:NSCaseInsensitiveSearch range:NSMakeRange(NSMaxRange(range), self.length - NSMaxRange(range))];
            if (range.location != NSNotFound) {
                [matchContent setAttributes:hightlightAttr range:range];
            }
        }
    }
    return matchContent;
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

- (void)matchRegex:(NSString *)regexString replace:(NSString * (^)(NSString *capture))replace highlightAttr:(NSDictionary *)hightlightAttr {
    NSError *regexError;
    NSString *string = self.string;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&regexError];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSMutableAttributedString *one = self;
    if (results.count == 0) {
        return;
    }
    for (NSTextCheckingResult *result in results.reverseObjectEnumerator) {
        for (int index = result.numberOfRanges - 1; index >= 1; index--) {
            NSRange range = [result rangeAtIndex:index];
            NSString *capture = [string substringWithRange:range];
            NSString *replacement = capture;
            if (replace) {
                replacement = replace(capture);
            }
            if (replacement) {
                NSAttributedString *replacementAttributedString = [[NSAttributedString alloc] initWithString:replacement attributes:hightlightAttr];
                [one replaceCharactersInRange:range withAttributedString:replacementAttributedString];
            }
        }
    }
}

@end
