//
//  UIImageView+SIKit.m
//  SuperId
//
//  Created by Ye Tao on 2017/11/14.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "UIImage+SIUtils.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

static NSMutableCharacterSet *SISetImage_EscapeSet;

NSString *SIRequestURLEncode(id value) {
    if (![value isKindOfClass:[NSString class]]) {
        return value;
    }
    if (!SISetImage_EscapeSet) {
        SISetImage_EscapeSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [SISetImage_EscapeSet removeCharactersInString:@"+;&=$,"];
    }
    value = [value stringByRemovingPercentEncoding] ?: value;
    return [value stringByAddingPercentEncodingWithAllowedCharacters:SISetImage_EscapeSet];
}

static inline NSURL *SIKitEncodeUrlString(NSString *url) {
    return [NSURL URLWithString:SIRequestURLEncode([url stringByRemovingPercentEncoding])];
}

@implementation UIImageView (SISetImage)

- (void)si_setImageWithURL:(nullable NSString *)url {
    [self si_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)si_setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder {
    [self si_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)si_setImageWithURL:(NSString *)url completed:(void (^)(UIImage *_Nullable, NSError *_Nullable, SDImageCacheType, NSURL *_Nullable))completedBlock {
    [self si_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)si_setImageWithURL:(nullable NSString *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self sd_setImageWithURL:SIKitEncodeUrlString(url) placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

- (void)si_setImageWithVideoURL:(NSString *)urlString {
    NSURL *url = SIKitEncodeUrlString(urlString);
    [[SDWebImageManager sharedManager].imageCache
        queryCacheOperationForKey:url.absoluteString
                          options:0
                             done:^(UIImage *_Nullable image,
                                    NSData *_Nullable data,
                                    SDImageCacheType cacheType) {
                                 if (image) {
                                     self.image = image;
                                 } else {
                                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                         UIImage *cache = [UIImage thumbnailImageForVideo:url atTime:1];
                                         [cache saveForUrl:url];
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             self.image = cache;
                                         });
                                     });
                                 }
                             }];
}

@end

@implementation UIButton (SISetImage)

- (void)si_setImageWithURL:(nullable NSString *)url forState:(UIControlState)state {
    [self sd_setImageWithURL:SIKitEncodeUrlString(url) forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)si_setImageWithURL:(nullable NSString *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder {
    [self sd_setImageWithURL:SIKitEncodeUrlString(url) forState:state placeholderImage:placeholder options:0 completed:nil];
}

@end
