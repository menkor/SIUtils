//
//  NSDate+Format.h
//  SuperId
//
//  Created by Ye Tao on 2017/1/19.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Format)

- (NSString *)stringFromFormat:(NSString *)format;

@end

@interface NSString (DateFormat)

- (NSDate *)dateFromFormat:(NSString *)format;

@end
