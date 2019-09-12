//
//  UIView+SIAutoSize.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/28.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (SIAutoSize)

- (CGFloat)si_widthToFit;

- (CGFloat)si_widthToFitMax:(CGFloat)max;

@end

@interface UILabel (SIAutoSize)

- (CGFloat)si_widthToFit;

- (CGFloat)si_widthToFitMax:(CGFloat)max;

- (void)si_setNumberOfLine:(NSUInteger)lines;

- (CGSize)si_sizeToFit:(CGFloat)width;

- (CGSize)si_size;

@end

@interface UITextField (SIAutoSize)

- (CGFloat)si_widthToFit;

- (CGFloat)si_widthToFitWithMinWidth:(CGFloat)min;

- (CGSize)si_sizeToFit:(CGFloat)width;

@end
