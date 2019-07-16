//
//  SIFileDirectDownloadTool.m
//  SuperId
//
//  Created by Ye Tao on 2017/12/27.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIFileDirectDownloadTool.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFURLSessionManager.h>
#import <SIDefine/SIGlobalMacro.h>

@implementation SIFileDirectDownloadTool

+ (void)downLoadWithUrl:(NSURL *)url completionHandler:(void (^)(NSURL *filePath))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    weakfy(manager);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block NSURLSessionDownloadTask *downloadTask;
    downloadTask =
        [manager downloadTaskWithRequest:request
            progress:nil
            destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *cachesDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                                   inDomain:NSUserDomainMask
                                                                          appropriateForURL:nil
                                                                                     create:NO
                                                                                      error:nil];
                NSURL *url = [cachesDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
                    //NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil];
                    //NSDate *localModificationDate = attr[NSFileModificationDate];
                    //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    //NSString *lastModified = httpResponse.allHeaderFields[@"Last-Modified"];
                    ////http://userguide.icu-project.org/formatparse/datetime
                    ////Wed, 03 Jul 2019 02:21:45 GMT
                    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    ////df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
                    //formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";
                    //formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                    //formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                    //NSDate *lastModifiedDate = [formatter dateFromString:lastModified];
                    //if ([localModificationDate timeIntervalSinceDate:lastModifiedDate] > 0) {
                    //    [downloadTask cancel];
                    //    return nil;
                    //}
                    [[NSFileManager defaultManager] removeItemAtPath:url.path error:nil];
                }
                return url;
            }
            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                if (completionHandler) {
                    completionHandler(filePath);
                }
                [weak_manager invalidateSessionCancelingTasks:YES];
            }];
    [downloadTask resume];
}

@end
