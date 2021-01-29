//
//  AppService.h
//  BHGY
//
//  Created by liuxiang on 2020/7/3.
//  Copyright © 2020 liuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppService : NSObject

+ (instancetype)shareInstance;
- (void)registerAppService:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;



@end

NS_ASSUME_NONNULL_END
