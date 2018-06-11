//
//  SIFileDirectDownloadTool.m
//  SuperId
//
//  Created by Ye Tao on 2017/12/27.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "SIFileDirectDownloadTool.h"
#import <AFNetworking/AFNetworking.h>

@implementation SIFileDirectDownloadTool

+ (void)downLoadWithUrl:(NSURL *)url completionHandler:(void (^)(NSURL *filePath))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask =
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
                    [[NSFileManager defaultManager] removeItemAtPath:url.path error:nil];
                }
                return url;
            }
            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                if (completionHandler) {
                    completionHandler(filePath);
                }
            }];
    [downloadTask resume];
}

@end
