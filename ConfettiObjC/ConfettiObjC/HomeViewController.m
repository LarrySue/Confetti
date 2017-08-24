//
//  HomeViewController.m
//  ConfettiObjc
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "HomeViewController.h"

#import "Confetti.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(1.0)]

@interface HomeViewController ()

@property (nonatomic, assign) BOOL isGoing;
@property (nonatomic, strong) Confetti *confetti;

@end

@implementation HomeViewController

#pragma mark *** 私有构造方法***

- (instancetype)initPrivate {
    if (self = [super init]) {
        self.isGoing = NO;
    }
    return self;
}

#pragma mark *** 工厂方法 ***

+ (instancetype)homeViewController {
    return [[self alloc] initPrivate];
}

#pragma mark *** 周期 ***

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ConfettiPointRange startRange = ConfettiPointRangeMake(CGRectMake(0, 0, ScreenWidth, 0));
    ConfettiPointRange endRange = ConfettiPointRangeMake(CGRectMake(-ScreenWidth * 1.5, ScreenHeight * 1.5, ScreenWidth * 3.0, ScreenHeight * 0.5));
    
    self.confetti = [[Confetti alloc] initWithView:self.view startRange:startRange endRange:endRange];
    
    ///此属性若不定义 则采用默认红绿蓝三色
    self.confetti.colors = @[RGB(0, 255.0, 255.0),
                             RGB(0, 191.0, 255.0),
                             RGB(255.0, 255.0, 0),
                             RGB(238.0, 44.0, 44.0),
                             RGB(154.0, 205.0, 50.0)];
    ///此属性若不定义 则默认密度为每秒20个
    self.confetti.density = 15;
}

#pragma mark *** 回调 ***

///点击按钮
- (IBAction)goButtonDidClick:(UIButton *)button {
    if (self.isGoing) {
        self.isGoing = false;
        [button setTitle:@"GO !" forState:UIControlStateNormal];
        [self.confetti end];
    } else {
        self.isGoing = true;
        [button setTitle:@"STOP !" forState:UIControlStateNormal];
        [self.confetti start];
    }
}

@end
