//
//  PHAsset+SIPath.h
//  SuperId
//
//  Created by Ye Tao on 2017/5/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (SIPath)

- (NSString *)path;

- (UIImage *)image;

@end
