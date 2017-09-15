//
//  Confetti.h
//  ConfettiObjc
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat lowerBound;
    CGFloat upperBound;
} ConfettiFloatRange;

ConfettiFloatRange ConfettiFloatRangeMake(CGFloat lowerBound, CGFloat upperBound);

typedef struct {
    ConfettiFloatRange rangeX;
    ConfettiFloatRange rangeY;
} ConfettiPointRange;

ConfettiPointRange ConfettiPointRangeMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

#pragma mark -

@interface Confetti : NSObject

#pragma mark *** 属性 ***

///色彩组(默认R G B三种颜色)
@property (nonatomic, strong) NSArray<UIColor *> *colors;
///密度(每秒生成数量 默认20)
@property (nonatomic, assign) NSInteger density;
///移动时间(从初始位置移动到结束位置的时间 默认5秒)
@property (nonatomic, assign) ConfettiFloatRange durationRange;

#pragma mark *** 禁用方法 ***

- (instancetype)init NS_UNAVAILABLE;

#pragma mark *** 构造方法 ***

- (instancetype)initWithStartRange:(ConfettiPointRange)startRange endRange:(ConfettiPointRange)endRange;

#pragma mark *** 逻辑 ***

///开始撒花
- (void)start;
- (void)startOnView:(UIView *)view;

///结束撒花
- (void)end;
///结束并直接移除所有花
- (void)endWithRemoveAllConfetti;
///延迟结束并直接移除所有花
- (void)endWithRemoveAllConfettiAfterDelay:(NSTimeInterval)delay;

@end
