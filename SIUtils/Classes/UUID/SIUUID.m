//
//  SIUUID.m
//  SuperId
//
//  Created by Ye Tao on 2017/8/1.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIUUID.h"
#import "SICache.h"

@interface SIUUID ()

@property (nonatomic, strong) NSString *uuid;

@end

@implementation SIUUID

+ (NSString *)uuid {
    return [SIUUID new].uuid;
}

- (NSString *)uuid {
    if (!_uuid) {
        _uuid = [[SISafeCache safeCache] objectForKey:@"com.superid.uuid"];
        if (!_uuid) {
            _uuid = [[NSUUID UUID] UUIDString];
            [[SISafeCache safeCache] setObject:_uuid forKey:@"com.superid.uuid"];
        }
    }
    return _uuid;
}

@end
