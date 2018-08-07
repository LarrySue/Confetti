//
//  Confetti.m
//  ConfettiObjc
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "Confetti.h"

ConfettiFloatRange ConfettiFloatRangeMake(CGFloat lowerBound, CGFloat upperBound) {
    ConfettiFloatRange range;
    
    range.lowerBound = lowerBound;
    range.upperBound = upperBound;
    
    return range;
}

ConfettiPointRange ConfettiPointRangeMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    ConfettiPointRange range;
    
    range.rangeX = ConfettiFloatRangeMake(x, x + width);
    range.rangeY = ConfettiFloatRangeMake(y, y + height);
    
    return range;
}

CGFloat confettiRandom(CGFloat lowerBound, CGFloat upperBound, NSInteger precision) {
    NSInteger offset = pow(10, precision);
    
    return (arc4random_uniform(upperBound * offset - lowerBound * offset) + lowerBound * offset) / offset;
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

///花池
@property (nonatomic, strong) NSMutableArray<UIView *> *confettiPool;
///自动释放锁
@property (nonatomic, assign) BOOL autoFree;

@end

@implementation Confetti

#pragma mark *** 构造方法 ***

- (instancetype)initWithStartRange:(ConfettiPointRange)startRange endRange:(ConfettiPointRange)endRange {
    if (self = [super init]) {
        self.startRange = startRange;
        self.endRange = endRange;
        self.view = [UIApplication sharedApplication].delegate.window;
        
        self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
        self.density = 20;
        self.durationRange = ConfettiFloatRangeMake(5.0, 5.0);
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(throwConfetti)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.paused = YES;
        
        self.confettiPool = [NSMutableArray array];
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
- (void)startOnView:(UIView *)view {
    self.view = view;
    [self start];
}
- (void)start {
    self.autoFree = YES;
    self.displayLink.paused = NO;
}

///结束撒花
- (void)end {
    self.displayLink.paused = YES;
}
///结束并直接移除所有花
- (void)endWithRemoveAllConfetti {
    [self end];
    self.autoFree = NO;
    for (UIView *confetti in self.confettiPool) {
        [confetti removeFromSuperview];
    }
    [self.confettiPool removeAllObjects];
}
///延迟结束并直接移除所有花
- (void)endWithRemoveAllConfettiAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(endWithRemoveAllConfetti) withObject:nil afterDelay:delay];
}

#pragma mark *** 回调 ***

- (void)throwConfetti {
    
    CGFloat startLowerX = self.startRange.rangeX.lowerBound;
    CGFloat startUpperX = self.startRange.rangeX.upperBound;
    CGFloat startLowerY = self.startRange.rangeY.lowerBound;
    CGFloat startUpperY = self.startRange.rangeY.upperBound;
    
    CGFloat endLowerX = self.endRange.rangeX.lowerBound;
    CGFloat endUpperX = self.endRange.rangeX.upperBound;
    CGFloat endLowerY = self.endRange.rangeY.lowerBound;
    CGFloat endUpperY = self.endRange.rangeY.upperBound;
    
    UIView *confetti = [[UIView alloc] initWithFrame:CGRectMake(confettiRandom(startLowerX, startUpperX, 1), confettiRandom(startLowerY, startUpperY, 1), 15.0, 15.0)];
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(3.0, 3.0, confettiRandom(5.0, 8.0, 1), confettiRandom(5.0, 8.0, 1))];
    
    confetti.backgroundColor = [UIColor clearColor];
    
    colorView.backgroundColor = self.colors[(NSInteger)confettiRandom(0, self.colors.count, 0)];
    colorView.layer.transform = CATransform3DMakeRotation(confettiRandom(0, M_PI * 2, 1), confettiRandom(-1, 1, 2), confettiRandom(-1, 1, 2), confettiRandom(-1, 1, 2));
    
    [self.view addSubview:confetti];
    [confetti addSubview:colorView];
    [self.confettiPool addObject:confetti];
    
    [UIView animateWithDuration:confettiRandom(self.durationRange.lowerBound, self.durationRange.upperBound, 1) animations:^{
        confetti.layer.transform = CATransform3DMakeTranslation(confettiRandom(endLowerX, endUpperX, 1), confettiRandom(endLowerY, endUpperY, 1), 0);
    } completion:^(BOOL finished) {
        if (finished && self.autoFree) {
            [confetti removeFromSuperview];
            if ([self.confettiPool containsObject:confetti]) {
                [self.confettiPool removeObject:confetti];
            }
        }
    }];
}

#pragma mark *** setter ***

- (void)setDensity:(NSInteger)density {
    _density = density;
    
    self.displayLink.preferredFramesPerSecond = density;
}

@end
