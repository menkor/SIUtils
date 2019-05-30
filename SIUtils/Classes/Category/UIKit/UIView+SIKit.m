//
//  UIView+SIKit.m
//  SuperId
//
//  Created by Ye Tao on 2017/3/24.
//  Copyright © 2017年 SuperId. All rights reserved.
//

#import "UIView+SIKit.h"
#import <Masonry/Masonry.h>
#import <SITheme/SIColor.h>

@interface SILineMaker ()

@property (nonatomic, weak) UIView *view;

@property (nonatomic, assign) SILinePosition si_position;

@property (nonatomic, assign) CGFloat si_height;

@property (nonatomic, strong) UIColor *si_color;

@property (nonatomic, assign) UIOffset si_offset;

@property (nonatomic, assign) BOOL si_dashline;

@end

@interface SILineMakerLineView : UIView

@property (nonatomic, assign) BOOL isDashline;

@property (nonatomic, strong) CAShapeLayer *dashline;

@property (nonatomic, strong) SILineMaker *maker;

@end

@implementation SILineMakerLineView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isDashline) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGRect frame = self.bounds;
        [path moveToPoint:CGPointMake(0, CGRectGetHeight(frame))];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.dashline.path = path.CGPath;
        self.dashline.frame = frame;
        self.dashline.strokeColor = self.maker.si_color.CGColor;
        self.backgroundColor = [SIColor clearColor];
    } else {
        self.backgroundColor = self.maker.si_color;
    }
}

- (CAShapeLayer *)dashline {
    if (!_dashline) {
        _dashline = [CAShapeLayer layer];
        [self.layer addSublayer:_dashline];
        _dashline.lineWidth = 0.5;
        _dashline.fillColor = nil;
        _dashline.lineDashPattern = @[@(3), @(3)];
    }
    return _dashline;
}

@end

@implementation SILineMaker

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        _view = view;
        _si_position = SILinePositionBottom;
        _si_height = 0.5;
        _si_offset = UIOffsetMake(12, 0);
        _si_color = [SIColor colorWithHex:0xdcdcdc];
    }
    return self;
}

- (SILineMaker * (^)(SILinePosition position))position {
    SILineMaker * (^block)(SILinePosition position) = ^SILineMaker *(SILinePosition position) {
        self.si_position = position;
        return self;
    };
    return block;
}

- (SILineMaker * (^)(CGFloat height))height {
    SILineMaker * (^block)(CGFloat height) = ^SILineMaker *(CGFloat height) {
        self.si_height = height;
        return self;
    };
    return block;
}

- (SILineMaker * (^)(UIColor *))color {
    SILineMaker * (^block)(UIColor *color) = ^SILineMaker *(UIColor *color) {
        self.si_color = color;
        return self;
    };
    return block;
}

- (SILineMaker * (^)(UIOffset offset))offset {
    SILineMaker * (^block)(UIOffset offset) = ^SILineMaker *(UIOffset offset) {
        self.si_offset = offset;
        return self;
    };
    return block;
}

- (SILineMaker * (^)(BOOL dashline))dashline {
    SILineMaker * (^block)(BOOL dashline) = ^SILineMaker *(BOOL dashline) {
        self.si_dashline = dashline;
        return self;
    };
    return block;
}

- (UIView *)make {
    SILineMakerLineView *line = [[SILineMakerLineView alloc] initWithFrame:CGRectZero];
    line.maker = self;
    line.isDashline = self.si_dashline;
    SILinePosition position = self.si_position;
    CGFloat height = self.si_height;
    UIOffset offset = self.si_offset;
    [self.view addSubview:line];
    switch (position) {
        case SILinePositionTop: {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(offset.horizontal);
                make.right.mas_equalTo(self.view);
                make.height.mas_equalTo(height);
                make.top.mas_equalTo(self.view).offset(offset.vertical);
            }];
        } break;
        case SILinePositionBottom: {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(offset.horizontal);
                make.right.mas_equalTo(self.view);
                make.height.mas_equalTo(height);
                make.bottom.mas_equalTo(self.view).offset(-offset.vertical);
            }];
        } break;

        case SILinePositionLeft: {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).offset(-offset.vertical);
                make.left.mas_equalTo(self.view).offset(offset.horizontal);
                make.width.mas_equalTo(height);
                make.bottom.mas_equalTo(self.view);
            }];
        } break;
        case SILinePositionRight: {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).offset(-offset.vertical);
                make.right.mas_equalTo(self.view).offset(offset.horizontal);
                make.width.mas_equalTo(height);
                make.bottom.mas_equalTo(self.view);
            }];
        } break;
        default:
            break;
    }

    return line;
}

@end

@implementation UIView (SIKit)

- (UIView *)si_lineMake:(void (^)(SILineMaker *))block {
    UIView *view = self;
    if ([self isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)self;
        view = cell.contentView;
    }
    SILineMaker *lineMaker = [[SILineMaker alloc] initWithView:view];
    if (block) {
        block(lineMaker);
    }
    return lineMaker.make;
}

+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    CGSize maxSize = CGSizeMake(width, font.lineHeight * 2);
    CGSize size = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil]
                      .size;
    return ceilf(size.height);
}

@end

@implementation NSString (SIKit_Height)

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil]
                      .size;
    return ceilf(size.height);
}

@end
