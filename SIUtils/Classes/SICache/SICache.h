//
//  SICache.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/1.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kSICacheResouceIdKey = @"ResouceIdKey";

@interface SICache : NSObject

+ (instancetype)defaultCache;

+ (instancetype)chatMessageCache;

+ (instancetype)memmoryCache;

+ (instancetype)talkingMemberCache;

- (instancetype)initWithName:(NSString *)name;

+ (instancetype)cacheWithName:(NSString *)name;

- (BOOL)containsObjectForKey:(NSString *)key;

- (void)containsObjectForKey:(NSString *)key withBlock:(void (^)(NSString *key, BOOL contains))block;

- (id)objectForKey:(NSString *)key;

- (void)objectForKey:(NSString *)key withBlock:(void (^)(NSString *key, id<NSCoding> object))block;

- (void)setObject:(id)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects;

@end

@interface SISafeCache : NSObject

+ (instancetype)safeCache;

- (void)setObject:(NSString *)object forKey:(NSString *)key;

- (NSString *)objectForKey:(NSString *)key;

@end
