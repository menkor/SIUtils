//
//  PHAsset+SIPath.m
//  SuperId
//
//  Created by Ye Tao on 2017/5/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "PHAsset+SIPath.h"

@implementation PHAsset (SIPath)

- (NSString *)path {
    __block NSString *localPath;
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:self
                                                      options:imageRequestOptions
                                                resultHandler:^(NSData *imageData, NSString *dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary *info) {
                                                    if ([info objectForKey:@"PHImageFileURLKey"]) {
                                                        // file:///var/mobile/Media/DCIM/###APPLE/IMG_####.JPG
                                                        NSURL *filePath = [info objectForKey:@"PHImageFileURLKey"];
                                                        localPath = filePath.absoluteString;
                                                    }
                                                }];
    return localPath;
}

- (UIImage *)image {
    __block UIImage *image;
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:self
                                                      options:imageRequestOptions
                                                resultHandler:^(NSData *imageData, NSString *dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary *info) {
                                                    if ([info objectForKey:@"PHImageFileURLKey"]) {
                                                        // file:///var/mobile/Media/DCIM/###APPLE/IMG_####.JPG
                                                        image = [UIImage imageWithData:imageData];
                                                    }
                                                }];
    return image;
}

@end
