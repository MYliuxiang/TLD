//
//  AppDelegate.m
//  TLD
//
//  Created by liuxiang on 2021/1/20.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "HomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeVC new]];

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [[AppService shareInstance] registerAppService:application didFinishLaunchingWithOptions:launchOptions];
    [WXApi registerApp:kAppKey_Wechat universalLink:kUniversalLink_Wechat];

    return YES;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {

    [[PayHelper shareInstance] payForResults:url];
  
    return YES;
}




@end
