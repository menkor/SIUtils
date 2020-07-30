//
//  SIVideoExportTool.h
//  SuperId
//
//  Created by Ye Tao on 2018/4/18.
//  Copyright © 2018年 SuperID. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVMutableVideoComposition;
@class AVAsset;
@interface SIVideoExportTool : NSObject

+ (instancetype)tool;

@property (nonatomic, copy) NSString *outputPath;

@property (nonatomic, copy) NSString *presetName __deprecated;

@property (nonatomic, assign) CGSize resolution;

@property (nonatomic, assign) BOOL oldStyle;

@property (nonatomic, assign) BOOL origin;

- (void)getVideoOutputPathWithAsset:(id)asset success:(void (^)(NSString *outputPath, CGSize outputSize))success failure:(void (^)(NSString *errorMessage, NSError *error))failure;

+ (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset;

+ (CGSize)fixedSize:(CGSize)some resolution:(CGSize)resolution;

@end
