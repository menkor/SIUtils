//
//  UIImage+SIKit.m
//  SuperId
//
//  Created by Ye Tao on 2017/9/20.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "UIImage+SIKit.h"
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/SDImageCache.h>
#import <SITheme/SIColor.h>
#import <SIUtils/UIImage+SIUtils.h>

@implementation UIImage (SIKit)

+ (UIImage *)materialCoverPlaceholder:(CGSize)size {
    NSString *key = @"com.superid.material.placeholder";
    UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
    if (!placeholder) {
        placeholder = [UIImage imageWithImage:[UIImage imageNamed:@"ic_material_none"]
                                         size:size
                                      bgColor:[SIColor colorWithHex:0xf7f7f7]];
        [[SDImageCache sharedImageCache] storeImage:placeholder forKey:key completion:nil];
    }
    return placeholder;
}

+ (UIImage *)announcementCoverPlaceholderWithSize:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        size = CGSizeMake(1, 1);
    }
    NSString *key = @"com.superid.announcement.placeholder";
    UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
    if (!placeholder) {
        placeholder = [UIImage imageWithImage:nil
                                         size:size
                                      bgColor:[SIColor colorWithHex:0xdcdcdc]];
        [[SDImageCache sharedImageCache] storeImage:placeholder forKey:key completion:nil];
    }
    return placeholder;
}

@end
