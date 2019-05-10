//
//  SITimerQueue.h
//  SuperId
//
//  Created by Ye Tao on 2017/8/1.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSTimeInterval kSITimerQueueNoExist = -1;

@interface SITimerQueue : NSObject

+ (instancetype)sharedInstance;

- (void)enqueueWithKey:(NSString *)key countDown:(NSTimeInterval)countDown;

/**
 get current interval of key

 @param key key set before
 @return -1[kSITimerQueueNoExist] means on unit exist in current queue
 */
- (NSTimeInterval)dequeueWithKey:(NSString *)key;

@end
