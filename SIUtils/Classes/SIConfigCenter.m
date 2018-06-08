//
//  SIConfigCenter.m
//  SuperId
//
//  Created by Ye Tao on 2017/3/13.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIConfigCenter.h"

@interface SIConfigCenter ()

@property (nonatomic, strong) NSDictionary *config;

@property (nonatomic, strong) NSCache *cache;

@end

@implementation SIConfigCenter

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:kSIConfigCenterFileName ofType:@"plist"];
        _config = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

+ (id)configForKey:(NSString *)key {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:key ofType:@"plist"];
    id config = [NSDictionary dictionaryWithContentsOfFile:path];
    if (!config) {
        config = [NSArray arrayWithContentsOfFile:path];
    }
    return config;
}

- (NSDictionary *)configForKeyPath:(NSString *)keyPath {
    return [_config valueForKeyPath:keyPath];
}

- (void)setCache:(id)cache forKey:(NSString *)key {
    [self.cache setObject:cache forKey:key];
}

- (id)cacheForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

@end
