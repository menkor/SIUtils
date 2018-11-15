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

+ (NSString *)randomStringKeyWithLength:(NSUInteger)length;

+ (NSString *)cacheLocationWithName:(NSString *)name;

+ (NSString *)uploadCacheLocation;

- (NSString *)fullCachePath;

- (void)clearCachePath;

+ (void)clearCacheLocationWithName:(NSString *)name;

- (id)jsonObject;

- (NSMutableAttributedString *)match:(NSString *)key highlightAttr:(NSDictionary *)hightlightAttr defaultAttr:(NSDictionary *)defaultAttr;

@end
