//
//  UIButton+SIKit.m
//  SuperId
//
//  Created by Ye Tao on 2018/4/8.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#import "UIButton+SIKit.h"

@implementation UIButton (SILayoutKit)

- (void)si_verticalLayout:(CGFloat)spacing {
    // the space between the image and text
    spacing = MAX(3.0, 0);

    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(
        0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);

    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(
        -(titleSize.height + spacing), 0.0, 0.0, -ceil(titleSize.width));

    // increase the content height to avoid clipping
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

@end
