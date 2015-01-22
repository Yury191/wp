//
//  AppDelegate.m
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "AppDelegate.h"

#import "WZYLaunchViewController.h"

@interface WZYNavController : UINavigationController
@end

@implementation WZYNavController

- (UIStatusBarStyle)preferredStatusBarStyle {
  return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
  return [self.topViewController prefersStatusBarHidden];
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  WZYLaunchViewController *rootVC = [[WZYLaunchViewController alloc] init];

  WZYNavController *navController =
      [[WZYNavController alloc] initWithRootViewController:rootVC];
  [navController setNavigationBarHidden:YES];
  [navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  [navController.navigationBar setShadowImage:[UIImage new]];
  [navController.navigationBar setTranslucent:YES];
  navController.navigationBar.tintColor = [UIColor whiteColor];

  self.window.rootViewController = navController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
