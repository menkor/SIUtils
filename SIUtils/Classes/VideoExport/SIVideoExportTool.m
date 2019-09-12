//
//  SIVideoExportTool.m
//  SuperId
//
//  Created by Ye Tao on 2018/4/18.
//  Copyright © 2018年 SuperID. All rights reserved.
//

#import "SIVideoExportTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <SDAVAssetExportSession/SDAVAssetExportSession.h>

@implementation SIVideoExportTool

+ (instancetype)tool {
    SIVideoExportTool *tool = [SIVideoExportTool new];
    tool.resolution = CGSizeMake(960, 540);
    return tool;
}

/// Export Video / 导出视频
- (void)getVideoOutputPathWithAsset:(id)asset success:(void (^)(NSString *outputPath, CGSize outputSize))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    [self getVideoOutputPathWithAsset:asset presetName:self.presetName ?: AVAssetExportPreset640x480 success:success failure:failure];
}

- (void)getVideoOutputPathWithAsset:(id)asset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath, CGSize outputSize))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    if (!_outputPath) {
        NSParameterAssert(self.outputPath);
        if (failure) {
            failure(@"Please set `outputPath` first", nil);
        }
        return;
    }
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                        options:options
                                                  resultHandler:^(AVAsset *avasset, AVAudioMix *audioMix, NSDictionary *info) {
                                                      // NSLog(@"Info:\n%@",info);
                                                      AVURLAsset *videoAsset = (AVURLAsset *)avasset;
                                                      // NSLog(@"AVAsset URL: %@",myAsset.URL);
                                                      if (self.oldStyle) {
                                                          [self oldStartExportVideoWithVideoAsset:videoAsset presetName:presetName success:success failure:failure];
                                                      } else {
                                                          [self startExportVideoWithVideoAsset:videoAsset presetName:presetName success:success failure:failure];
                                                      }
                                                  }];
    }
}

/// Deprecated, Use -getVideoOutputPathWithAsset:failure:success:
- (void)getVideoOutputPathWithAsset:(id)asset completion:(void (^)(NSString *outputPath, CGSize outputSize))completion {
    [self getVideoOutputPathWithAsset:asset success:completion failure:nil];
}

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath, CGSize outputSize))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:videoAsset];
    encoder.outputFileType = AVFileTypeMPEG4;
    AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
    CGSize size = [[videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject naturalSize];
    if (videoComposition.renderSize.width) {
        // 修正视频转向
        encoder.videoComposition = videoComposition;
        size = videoComposition.renderSize;
    }
    CGFloat maxSide = MAX(self.resolution.width, self.resolution.height);
    CGFloat bitRate = 1.28;
    bitRate = bitRate * (maxSide / 960);
    //竖屏
    if (size.width < size.height) {
        if (size.height > maxSide) {
            NSInteger other = (maxSide / size.height) * size.width;
            if (other % 2 == 1) {
                other--;
            }
            size.width = other;
            size.height = maxSide;
        }
    } else {
        if (size.width > maxSide) {
            NSInteger other = (maxSide / size.width) * size.height;
            if (other % 2 == 1) {
                other--;
            }
            size.height = other;
            size.width = maxSide;
        }
    }

    encoder.outputURL = [NSURL fileURLWithPath:self.outputPath];
    encoder.videoSettings = @{
        AVVideoCodecKey: AVVideoCodecH264,
        AVVideoWidthKey: @(size.width),
        AVVideoHeightKey: @(size.height),
        AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
        AVVideoCompressionPropertiesKey: @{
            AVVideoAverageBitRateKey: @(bitRate * 1024 * 1024),
            AVVideoExpectedSourceFrameRateKey: @(25),
            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
        },
    };
    encoder.audioSettings = @{
        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
        AVNumberOfChannelsKey: @2,
        AVSampleRateKey: @44100,
        AVEncoderBitRateKey: @128000,
    };

    [encoder exportAsynchronouslyWithCompletionHandler:^{
        if (encoder.status == AVAssetExportSessionStatusCompleted) {
            //NSLog(@"Video export succeeded");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(self.outputPath, size);
                }
            });
        } else if (encoder.status == AVAssetExportSessionStatusCancelled) {
            //NSLog(@"Video export cancelled");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(@"导出任务已被取消", nil);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(@"视频导出失败", encoder.error);
                }
            });
            //NSLog(@"Video export failed with error: %@ (%d)", encoder.error.localizedDescription, encoder.error.code);
        }
    }];
}

- (void)oldStartExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath, CGSize outputSize))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];

    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];
        // NSLog(@"video outputPath = %@",outputPath);
        session.outputURL = [NSURL fileURLWithPath:self.outputPath];

        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;

        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            if (failure) {
                failure(@"该视频类型暂不支持导出", nil);
            }
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }

        AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
        if (videoComposition.renderSize.width) {
            // 修正视频转向
            session.videoComposition = videoComposition;
        }

        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (session.status) {
                    case AVAssetExportSessionStatusUnknown: {
                        NSLog(@"AVAssetExportSessionStatusUnknown");
                    } break;
                    case AVAssetExportSessionStatusWaiting: {
                        NSLog(@"AVAssetExportSessionStatusWaiting");
                    } break;
                    case AVAssetExportSessionStatusExporting: {
                        NSLog(@"AVAssetExportSessionStatusExporting");
                    } break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"AVAssetExportSessionStatusCompleted");
                        if (success) {
                            success(self.outputPath, CGSizeMake(0, 0));
                        }
                    } break;
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"AVAssetExportSessionStatusFailed");
                        if (failure) {
                            failure(@"视频导出失败", session.error);
                        }
                    } break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"AVAssetExportSessionStatusCancelled");
                        if (failure) {
                            failure(@"导出任务已被取消", nil);
                        }
                    } break;
                    default:
                        break;
                }
            });
        }];
    } else {
        if (failure) {
            NSString *errorMessage = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            failure(errorMessage, nil);
        }
    }
}

/// 获取优化后的视频转向信息
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);

        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];

        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter, M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if (degrees == 180) {
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter, M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if (degrees == 270) {
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter, M_PI_2 * 3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }

        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

/// 获取视频角度
- (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if ([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if (t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
            // Portrait
            degress = 90;
        } else if (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) {
            // PortraitUpsideDown
            degress = 270;
        } else if (t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {
            // LandscapeRight
            degress = 0;
        } else if (t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end
