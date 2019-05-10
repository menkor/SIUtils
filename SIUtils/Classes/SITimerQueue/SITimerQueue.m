//
//  SITimerQueue.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/1.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SITimerQueue.h"
#import "SICache.h"
#import <YCEasyTool/YCPollingEntity.h>

@interface SITimerQueue ()

@property (nonatomic, strong) SICache *cache;

@end

typedef void (^SITimerQueueUnitEndBlock)(void);

@interface SITimerQueueUnit : NSObject <NSCoding>

@property (nonatomic, assign) NSTimeInterval countDown;

@property (nonatomic, assign) NSTimeInterval current;

@property (nonatomic, readonly) NSTimeInterval timestamp;

@property (nonatomic, copy) SITimerQueueUnitEndBlock endBlock;

@end

@implementation SITimerQueueUnit {
    NSTimeInterval _timestamp;
    YCPollingEntity *_polling;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _timestamp = [aDecoder decodeDoubleForKey:@"timestamp"];
        _countDown = [aDecoder decodeDoubleForKey:@"countDown"];
        _current = [[NSDate date] timeIntervalSinceReferenceDate] - _timestamp;
        if (_current > 0) {
            [self _privateStart];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_timestamp forKey:@"timestamp"];
    [aCoder encodeDouble:_countDown forKey:@"countDown"];
}

- (instancetype)initWithCountDown:(NSTimeInterval)countDown {
    self = [super init];
    if (self) {
        _countDown = countDown;
        _current = countDown;
        _timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
        [self _privateStart];
    }
    return self;
}

- (void)_privateStart {
    if (!_polling) {
        _polling = [YCPollingEntity pollingEntityWithTimeInterval:1 max:_countDown];
        __weak __typeof__(self) weak_self = self;
        [_polling startRunningWithBlock:^(NSTimeInterval current) {
            if (weak_self.current <= 1) {
                [weak_self _privateStop];
            } else {
                weak_self.current -= 1;
            }
        }];
    }
}

- (void)_privateStop {
    [_polling stopRunning];
    if (self.endBlock) {
        self.endBlock();
    }
}

@end

@implementation SITimerQueue

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
        _cache = [SICache defaultCache];
    }
    return self;
}

- (void)enqueueWithKey:(NSString *)key countDown:(NSTimeInterval)countDown {
    SITimerQueueUnit *unit = [[SITimerQueueUnit alloc] initWithCountDown:countDown];
    [self.cache setObject:unit forKey:key];
    __weak __typeof__(self) weak_self = self;
    unit.endBlock = ^{
        [weak_self.cache removeObjectForKey:key];
    };
}

- (NSTimeInterval)dequeueWithKey:(NSString *)key {
    SITimerQueueUnit *unit = (SITimerQueueUnit *)[self.cache objectForKey:key];
    if (unit.current <= 0) {
        [self.cache removeObjectForKey:key];
    }
    return unit.current > 0 ? unit.current : -1;
}

@end
