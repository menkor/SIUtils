//
//  UIImageView+SIKit.h
//  SuperId
//
//  Created by Ye Tao on 2017/11/14.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import <UIKit/UIKit.h>

@interface UIImageView (SISetImage)

- (void)si_setImageWithURL:(nullable NSString *)url;

- (void)si_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder;

- (void)si_setImageWithURL:(nullable NSString *)url
                 completed:(nullable void (^)(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL))completedBlock;

- (void)si_setImageWithURL:(nullable NSString *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)si_setImageWithVideoURL:(nullable NSString *)url;

@end

@interface UIButton (SISetImage)

- (void)si_setImageWithURL:(nullable NSString *)url forState:(UIControlState)state;

- (void)si_setImageWithURL:(nullable NSString *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder;

@end
