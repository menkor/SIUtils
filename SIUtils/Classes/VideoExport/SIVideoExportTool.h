//
//  SIVideoExportTool.h
//  SuperId
//
//  Created by Ye Tao on 2018/4/18.
//  Copyright © 2018年 SuperID. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIVideoExportTool : NSObject

+ (instancetype)tool;

@property (nonatomic, copy) NSString *outputPath;

@property (nonatomic, copy) NSString *presetName;

- (void)getVideoOutputPathWithAsset:(id)asset success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure;

@end