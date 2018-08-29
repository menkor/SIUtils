//
//  NSObject+SIKit.h
//  SuperId
//
//  Created by Ye Tao on 2017/5/27.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SIContainer)

- (void)si_push;

- (void)si_pop;

+ (instancetype)si_current;

+ (instancetype)si_fromAddress:(NSString *)address;

@end
