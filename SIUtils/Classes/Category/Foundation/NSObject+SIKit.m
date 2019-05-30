//
//  NSObject+SIKit.m
//  SuperId
//
//  Created by Ye Tao on 2017/5/27.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "NSObject+SIKit.h"
#import "SICache.h"

@implementation NSObject (SIContainer)

- (void)si_push {
    //if ([NSStringFromClass([self class]) isEqualToString:@"SIAffairInfo"]) {
    //    SIDLog(@"si_push %@", self);
    //}
    [[SICache memmoryCache] setObject:self forKey:NSStringFromClass([self class])];
}

- (void)si_pop {
    //if ([NSStringFromClass([self class]) isEqualToString:@"SIAffairInfo"]) {
    //    SIDLog(@"si_pop %@", self);
    //}
    [[SICache memmoryCache] setObject:nil forKey:NSStringFromClass([self class])];
}

+ (instancetype)si_current {
    id some = [[SICache memmoryCache] objectForKey:NSStringFromClass(self)];
    return some;
}

+ (instancetype)si_fromAddress:(NSString *)address {
    return (__bridge id)(void *)[address integerValue];
}

@end
