//
//  UIView+SILayout.m
//  SuperId
//
//  Created by Ye Tao on 2018/3/29.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#import "UIView+SILayout.h"

@implementation UIView (SILayout)

- (CGFloat)si_left {
    return self.frame.origin.x;
}

- (void)setSi_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)si_top {
    return self.frame.origin.y;
}

- (void)setSi_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)si_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setSi_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)si_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSi_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)si_width {
    return self.frame.size.width;
}

- (void)setSi_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)si_height {
    return self.frame.size.height;
}

- (void)setSi_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)si_centerX {
    return self.center.x;
}

- (void)setSi_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)si_centerY {
    return self.center.y;
}

- (void)setSi_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)si_origin {
    return self.frame.origin;
}

- (void)setSi_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)si_size {
    return self.frame.size;
}

- (void)setSi_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
