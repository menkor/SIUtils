//
//  NSString+SIUtils.m
//  SuperId
//
//  Created by Ye Tao on 2017/9/20.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "NSString+SIUtils.h"

@implementation NSString (SIKit)

+ (NSString *)randomKeyWithLength:(NSUInteger)length {
    //30(48)-39(57) -> 10  60(97)-7a(122) -> 26 == 36
    NSUInteger count = length;
    NSMutableString *result = [NSMutableString stringWithCapacity:count];
    for (NSUInteger index = 0; index < count; index++) {
        NSInteger random = arc4random() % 36;
        if (random <= 9) {
            [result appendFormat:@"%c", (unichar)(random + 48)];
        } else {
            [result appendFormat:@"%c", (unichar)(random + 97 - 10)];
        }
    }
    return result;
}

+ (NSString *)randomStringKeyWithLength:(NSUInteger)length {
    NSUInteger count = length;
    NSMutableString *result = [NSMutableString stringWithCapacity:count];
    for (NSUInteger index = 0; index < count; index++) {
        NSInteger random = arc4random() % 26;
        [result appendFormat:@"%c", (unichar)(random + 97)];
    }
    return result;
}

+ (NSString *)cacheLocationWithName:(NSString *)name {
    NSString *tmpDir = [NSString stringWithFormat:@"/%@/%@", name, [NSString randomKeyWithLength:5]];
    NSString *fullPath = tmpDir.fullCachePath;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpDir;
}

+ (NSString *)uploadCacheLocation {
    return [self cacheLocationWithName:@"upload"];
}

- (NSString *)fullCachePath {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    return [paths.firstObject stringByAppendingPathComponent:self];
}

- (void)clearCachePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.stringByDeletingLastPathComponent error:nil];
    }
}

+ (void)clearCacheLocationWithName:(NSString *)name {
    NSString *path = [self cacheLocationWithName:name].fullCachePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

- (NSDictionary *)jsonObject {
    if (self.length == 0) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error) {
        return nil;
    }
    return object;
}

@end
