//
//  Confetti.m
//  ConfettiObjc
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "Confetti.h"

ConfettiFloatRange ConfettiFloatRangeMake(CGFloat lower, CGFloat upper) {
    ConfettiFloatRange range;
    
    range.lower = lower;
    range.upper = upper;
    
    return range;
}

ConfettiPointRange ConfettiPointRangeMake(CGRect rect) {
    ConfettiPointRange range;
    
    range.rangeX = ConfettiFloatRangeMake(rect.origin.x, rect.origin.x + rect.size.width);
    range.rangeY = ConfettiFloatRangeMake(rect.origin.y, rect.origin.y + rect.size.height);
    
    return range;
}

CGFloat confettiRandom(CGFloat lower, CGFloat upper, NSInteger precision) {
    NSInteger offset = pow(10, precision);
    
    return (arc4random_uniform(upper * offset - lower * offset) + lower * offset) / offset;
}

@interface Confetti ()

///displayLink
@property (nonatomic, strong) CADisplayLink *displayLink;
///基准视图
@property (nonatomic, strong) UIView *view;
///起点范围
@property (nonatomic, assign) ConfettiPointRange startRange;
///终点范围
@property (nonatomic, assign) ConfettiPointRange endRange;

@end

@implementation Confetti

#pragma mark *** 构造方法 ***

- (instancetype)initWithStartRange:(ConfettiPointRange)startRange endRange:(ConfettiPointRange)endRange {
    if (self = [super init]) {
        self.startRange = startRange;
        self.endRange = endRange;
        
        self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
        self.density = 20;
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(throwConfetti)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.paused = YES;
    }
    return self;
}

#pragma mark *** 析构方法 ***

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark *** 逻辑 ***

///开始撒花
- (void)start {
    [self startOnView:[UIApplication sharedApplication].delegate.window];
}
- (void)startOnView:(UIView *)view {
    self.view = view;
    self.displayLink.paused = NO;
}
///结束撒花
- (void)end {
    self.displayLink.paused = YES;
}

#pragma mark *** 回调 ***

- (void)throwConfetti {
    
    CGFloat startLowerX = self.startRange.rangeX.lower;
    CGFloat startUpperX = self.startRange.rangeX.upper;
    CGFloat startLowerY = self.startRange.rangeY.lower;
    CGFloat startUpperY = self.startRange.rangeY.upper;
    
    CGFloat endLowerX = self.endRange.rangeX.lower;
    CGFloat endUpperX = self.endRange.rangeX.upper;
    CGFloat endLowerY = self.endRange.rangeY.lower;
    CGFloat endUpperY = self.endRange.rangeY.upper;
    
    UIView *confetti = [[UIView alloc] initWithFrame:CGRectMake(confettiRandom(startLowerX, startUpperX, 1), confettiRandom(startLowerY, startUpperY, 1), 15.0, 15.0)];
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(3.0, 3.0, confettiRandom(5.0, 8.0, 1), confettiRandom(5.0, 8.0, 1))];
    
    confetti.backgroundColor = [UIColor clearColor];
    
    colorView.backgroundColor = self.colors[(NSInteger)confettiRandom(0, self.colors.count, 0)];
    colorView.layer.transform = CATransform3DMakeRotation(confettiRandom(0, M_PI * 2, 1), confettiRandom(-1, 1, 2), confettiRandom(-1, 1, 2), confettiRandom(-1, 1, 2));
    
    [self.view addSubview:confetti];
    [confetti addSubview:colorView];
    
    [UIView animateWithDuration:confettiRandom(6.0, 8.0, 1) animations:^{
        confetti.layer.transform = CATransform3DMakeTranslation(confettiRandom(endLowerX, endUpperX, 1), confettiRandom(endLowerY, endUpperY, 1), 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [confetti removeFromSuperview];
        }
    }];
}

#pragma mark *** setter ***

- (void)setDensity:(NSInteger)density {
    _density = density;
    
    if ([[UIDevice alloc] init].systemVersion.doubleValue >= 10.0) {
        self.displayLink.preferredFramesPerSecond = density;
    } else {
        self.displayLink.frameInterval = 60 / density;
    }
}

@end
