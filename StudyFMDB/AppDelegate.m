//
//  AppDelegate.m
//  StudyFMDB
//
//  Created by aDu on 16/11/25.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"加载成功");
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"非活动状态");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"进入后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"进入前台");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"活跃状态");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"将要退出");
}

@end
