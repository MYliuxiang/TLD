//
//  AppService.m
//  BHGY
//
//  Created by liuxiang on 2020/7/3.
//  Copyright © 2020 liuxiang. All rights reserved.
//

#import "AppService.h"

@implementation AppService
//单例
+ (instancetype)shareInstance
{
    static AppService *_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instace = [[self alloc] init];
    });
    return _instace;
}


- (instancetype)init
{
    self = [super init];
    if(self)
    {
       
        
    }
    return self;
}

- (void)registerAppService:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self handleKeyBoard];
    [AMapServices sharedServices].apiKey =@"c682c38433709a64219a76c1f96768d5";

    
}



- (void)handleKeyBoard{
    //键盘处理
//      IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//      manager.enable = YES;
//      manager.shouldResignOnTouchOutside = YES;
//      manager.shouldToolbarUsesTextFieldTintColor = YES;
//      manager.enableAutoToolbar = NO;
    
    
    // wrnavgation
    [WRNavigationBar wr_widely];
     [WRNavigationBar wr_setBlacklist:@[@"TZImgePickHelper",@"TZImagePickerController",
     @"TZPhotoPickerController",
     @"TZGifPhotoPreviewController",
     @"TZAlbumPickerController",
     @"TZPhotoPreviewController",
     @"TZVideoPlayerController",@"RCConversationViewController"]];


    
  
}




@end

