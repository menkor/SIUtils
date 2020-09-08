//
//  SICache.m
//  SuperId
//
//  Created by Ye Tao on 2017/3/1.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SICache.h"
#import <SAMKeychain/SAMKeychain.h>
#import <YYKit/YYCache.h>
#import <YYKit/YYDiskCache.h>
#import <YYKit/YYMemoryCache.h>

#define kSICacheDefaultName @"com.superid.cache.default"

#define kSICacheMemmoryName @"com.superid.cache.memmory"

#define kSICacheTalkingMemberName @"com.superid.cache.talking.member"

#define kSICacheTalkingChatMessage @"com.superid.cache.talking.message"

@interface SICache ()

@property (nonatomic, strong) YYCache *cache;

@end

@implementation SICache

+ (instancetype)defaultCache {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] initWithName:kSICacheDefaultName];
    });
    return instance;
}

+ (instancetype)chatMessageCache {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] initWithName:kSICacheTalkingChatMessage];
    });
    return instance;
}

+ (instancetype)memmoryCache {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] initWithName:kSICacheMemmoryName];
    });
    return instance;
}

+ (instancetype)talkingMemberCache {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] initWithName:kSICacheTalkingMemberName];
    });
    return instance;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        if ([name isEqualToString:kSICacheMemmoryName]) {
            YYMemoryCache *cache = [[YYMemoryCache alloc] init];
            cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
            cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
            _cache = (YYCache *)cache;
        } else {
            _cache = [[YYCache alloc] initWithName:name];
        }
    }
    return self;
}

+ (instancetype)cacheWithName:(NSString *)name {
    SICache *cache = [[SICache alloc] initWithName:name];
    return cache;
}

- (BOOL)containsObjectForKey:(NSString *)key {
    return [self.cache containsObjectForKey:key];
}

- (void)containsObjectForKey:(NSString *)key withBlock:(void (^)(NSString *key, BOOL contains))block {
    return [self.cache containsObjectForKey:key withBlock:block];
}

- (id<NSCoding>)objectForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

- (void)objectForKey:(NSString *)key withBlock:(void (^)(NSString *key, id<NSCoding> object))block {
    [self.cache objectForKey:key withBlock:block];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    [self.cache setObject:object forKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [self.cache setObject:value forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.cache removeObjectForKey:key];
}

- (void)removeAllObjects {
    [self.cache removeAllObjects];
}

- (void)totalCostWithBlock:(void (^)(NSInteger totalCost))block {
    if (block) {
        [self.cache.diskCache totalCostWithBlock:^(NSInteger size) {
            block(size);
        }];
    }
}

@end

@interface SISafeCache ()

@property (nonatomic, copy) NSString *serviceName;

@end

@implementation SISafeCache

+ (instancetype)safeCache {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[SISafeCache alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _serviceName = [[NSBundle mainBundle] bundleIdentifier];
    }
    return self;
}

- (void)setObject:(NSString *)object forKey:(NSString *)key {
    [SAMKeychain setPassword:object forService:_serviceName account:key];
}

- (id<NSCoding>)objectForKey:(NSString *)key {
    return [SAMKeychain passwordForService:_serviceName account:key];
}

@end
