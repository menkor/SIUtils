//
//  UIView+SIAutoSize.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/28.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (SIAutoSize)

- (void)si_widthToFit;

@end

@interface UILabel (SIAutoSize)

- (void)si_widthToFit;

- (void)si_widthToFitMax:(CGFloat)max;

- (void)si_setNumberOfLine:(NSUInteger)lines;

- (void)si_sizeToFit:(CGFloat)width;

- (CGSize)si_size;

@end

@interface UITextField (SIAutoSize)

- (void)si_widthToFit;

- (void)si_widthToFitWithMinWidth:(CGFloat)min;

- (void)si_sizeToFit:(CGFloat)width;

@end
