//
//  SIConfigCenter.h
//  SuperId
//
//  Created by Ye Tao on 2017/3/13.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kSIConfigCenterKeyServer = @"server";

static NSString *const kSIConfigCenterKeyLink = @"link";

static NSString *const kSIConfigCenterKeyLabel = @"label";

static NSString *const kSIConfigCenterKeyGate = @"gate";

static NSString *const kSIConfigCenterFileName = @"config";

static NSString *const kSIConfigCenterKeyShare = @"share";

static NSString *const kSIConfigCenterKeyRouter = @"Router";

static NSString *const kSIConfigCenterKeyVersion = @"version";

@interface SIConfigCenter : NSObject

+ (instancetype)sharedInstance;

+ (id)configForKey:(NSString *)key;

- (id)configForKeyPath:(NSString *)keyPath;

- (void)setCache:(id)cache forKey:(NSString *)key;

- (id)cacheForKey:(NSString *)key;

@end
