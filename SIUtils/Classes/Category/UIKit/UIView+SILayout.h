//
//  UIView+SILayout.h
//  SuperId
//
//  Created by Ye Tao on 2018/3/29.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SILayout)

@property (nonatomic) CGFloat si_left;    ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat si_top;     ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat si_right;   ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat si_bottom;  ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat si_width;   ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat si_height;  ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat si_centerX; ///< Shortcut for center.x
@property (nonatomic) CGFloat si_centerY; ///< Shortcut for center.y
@property (nonatomic) CGPoint si_origin;  ///< Shortcut for frame.origin.
@property (nonatomic) CGSize si_size;     ///< Shortcut for frame.size.

@end
