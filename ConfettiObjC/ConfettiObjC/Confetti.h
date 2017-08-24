//
//  Confetti.h
//  ConfettiObjc
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

struct ConfettiFloatRange {
    CGFloat lower;
    CGFloat upper;
};
typedef struct ConfettiFloatRange ConfettiFloatRange;

ConfettiFloatRange ConfettiFloatRangeMake(CGFloat lower, CGFloat upper);

struct ConfettiPointRange {
    ConfettiFloatRange rangeX;
    ConfettiFloatRange rangeY;
};
typedef struct ConfettiPointRange ConfettiPointRange;

ConfettiPointRange ConfettiPointRangeMake(CGRect rect);

#pragma mark -

@interface Confetti : NSObject

#pragma mark *** 属性 ***

///色彩组
@property (nonatomic, strong) NSArray<UIColor *> *colors;
///密度(每秒生成数量)
@property (nonatomic, assign) NSInteger density;

#pragma mark *** 禁用方法 ***

- (instancetype)init NS_UNAVAILABLE;

#pragma mark *** 构造方法 ***

- (instancetype)initWithView:(UIView *)view startRange:(ConfettiPointRange)startRange endRange:(ConfettiPointRange)endRange;

#pragma mark *** 逻辑 ***

///开始撒花
- (void)start;
///结束撒花
- (void)end;

@end
