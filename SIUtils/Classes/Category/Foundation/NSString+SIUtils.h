//
//  NSString+SIUtils.h
//  SuperId
//
//  Created by Ye Tao on 2017/9/20.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SIUtils)

+ (NSString *)randomKeyWithLength:(NSUInteger)length;

+ (NSString *)imageCacheLocation;

+ (NSString *)uploadCacheLocation;

+ (NSString *)chatCacheLocation;

- (NSString *)fullCachePath;

- (void)clearCachePath;

- (id)jsonObject;

@end
