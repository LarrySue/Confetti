//
//  AppDelegate.m
//  ConfettiObjc
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    HomeViewController *vc = [HomeViewController homeViewController];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    vc.title = @"Confetti";
    
    self.window.rootViewController = navVc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
