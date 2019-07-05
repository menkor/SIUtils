//
//  UIImage+SIUtils.h
//  SuperId
//
//  Created by Ye Tao on 2017/9/20.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SIUtils)
/**
 *  view转化成image
 */
+ (UIImage *)imageWithView:(UIView *)view;

/**
 *  返回一张自由拉伸的图片
 *
 *  @param name 图片的名字
 *
 *  @return 图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 *
 *  @param name 图片的名字
 *  @param left 图片距离左边拉伸的比例
 *  @param top  图片距离顶部拉伸的比例
 *
 *  @return 图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/**
 *  返回一张纯颜色的图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  返回一张纯颜色的图片
 *
 *  @param color 颜色
 *
 *  @param size 分辨率
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)dotImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  根据图片路径加载一张图片
 *
 *  @param name 图片名字
 *
 *  @return 图片
 */
+ (UIImage *)imageWithFile:(NSString *)name;

/**
 *  自由改变Image的大小
 *
 *  @param size 目的大小
 *
 *  @return 修改后的Image
 */

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (UIImage *)imageWithImage:(UIImage *)img size:(CGSize)size bgColor:(UIColor *)color;

- (UIImage *)grayScale;

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

- (void)saveForUrl:(NSURL *)url;

- (UIImage *)fixOrientation;

- (NSString *)qrcode;

+ (void)save:(UIImage *)image;

+ (void)save:(UIImage *)image result:(void (^)(BOOL OK))result;

@end
