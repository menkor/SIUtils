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
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingTruncatesLastVisibleLine |
                                             NSStringDrawingUsesLineFragmentOrigin |
                                             NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: font}
                                     context:NULL]
                      .size;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
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

- (NSArray *)resultForMatch:(NSString *)match {
    NSString *string = self;
    NSError *regexError;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:match options:NSRegularExpressionCaseInsensitive error:&regexError];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (results.count == 0) {
        return nil;
    }
    NSTextCheckingResult *result = results.firstObject;
    if (results.count == 0) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int index = 1; index < result.numberOfRanges; index++) {
        NSRange range = [result rangeAtIndex:index];
        if (range.length == 0 || range.location > string.length || NSMaxRange(range) > string.length) {
            break;
        }
        NSString *capture = [string substringWithRange:range];
        if (capture) {
            [array addObject:capture];
        }
    }
    return array;
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

- (void)matchRegex:(NSString *)regexString replace:(NSString * (^)(NSRange range, NSString *capture))replace highlightAttr:(NSDictionary *)hightlightAttr {
    [self matchRegex:regexString
             replace:^NSAttributedString *(NSRange range, NSString *capture) {
                 NSString *replacement = capture;
                 if (replace) {
                     replacement = replace(range, capture);
                 }
                 if (replacement) {
                     NSAttributedString *replacementAttributedString = [[NSAttributedString alloc] initWithString:replacement attributes:hightlightAttr];
                     return replacementAttributedString;
                 }
                 return nil;
             }];
}

- (void)matchRegex:(NSString *)regexString replace:(NSAttributedString * (^)(NSRange range, NSString *capture))replace {
    NSError *regexError;
    NSString *string = self.string;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&regexError];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSMutableAttributedString *one = self;
    if (results.count == 0) {
        return;
    }
    for (NSTextCheckingResult *result in results.reverseObjectEnumerator) {
        NSInteger numberOfRanges = result.numberOfRanges;
        for (NSUInteger idx = numberOfRanges - 1; idx >= 1; --idx) {
            NSLog(@"matchRegex  rangeAtIndex %@", @(idx));
            NSRange range = [result rangeAtIndex:idx];
            if (range.length == 0) {
                continue;
                ;
            }
            NSString *capture = [string substringWithRange:range];
            NSString *replacement = capture;
            if (replace) {
                replacement = replace(range, capture);
            }
            if (replacement) {
                [one replaceCharactersInRange:range withAttributedString:replacement];
            }
        }
    }
}

@end
