//
//  AppDelegate.m
//  Wizly
//
//  Created by Bezhou Feng on 1/17/15.
//  Copyright (c) 2015 Central Park Ed. All rights reserved.
//

#import "AppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "WZYColors.h"
#import "WZYLaunchViewController.h"
#import "WZYNavController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Authenticate Parse
  [Parse enableLocalDatastore];
  [Parse setApplicationId:@"MI2opErToPmNKOOoiM66fOwwrJ94sJk4DESasinz"
                clientKey:@"favtfq2poNchyqk1jZdyPzGdphcVI0l5PXjTTNVT"];

  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

  [PFFacebookUtils initializeFacebook];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [WZYColors mainBackgroundColor];

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
  [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [FBAppCall handleOpenURL:url
                sourceApplication:sourceApplication
                      withSession:[PFFacebookUtils session]];
}

@end
