//
//  HomeViewController.h
//  ConfettiObjc
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

#pragma mark *** 禁用方法 ***

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

#pragma mark *** 工厂方法 ***

+ (instancetype)homeViewController;

@end
