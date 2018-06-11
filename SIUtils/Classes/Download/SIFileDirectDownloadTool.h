//
//  SIFileDirectDownloadTool.h
//  SuperId
//
//  Created by Ye Tao on 2017/12/27.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIFileDirectDownloadTool : NSObject

+ (void)downLoadWithUrl:(NSURL *)url completionHandler:(void (^)(NSURL *filePath))completionHandler;

@end
