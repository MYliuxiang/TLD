//
//  BaseNavigationController.m
//  Familysystem
//
//  Created by 李立 on 15/8/21.
//  Copyright (c) 2015年 LILI. All rights reserved.
//

#import "BaseNavigationController.h"


@interface BaseNavigationController ()


@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.modalPresentationStyle = UIModalPresentationFullScreen;
    if (@available(iOS 13.0, *)) {
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    } else {
        // Fallback on earlier versions
    }if (@available(iOS 12.0, *)) {
        if (@available(iOS 13.0, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        } else {
            // Fallback on earlier versions
        }
    } else {
        // Fallback on earlier versions
    }
    //设置系统返回按钮的颜色
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     self.delegate = self;
    
    //设置导航栏的背景图片
//    [self.navigationBar setBarTintColor:Color_nav];
}

-(UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

-(UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
////    // 实现显示导航按钮
//    if (navigationController.viewControllers.count == 1) {
//
//        // 显示标签栏
//        MainTabBarController *mainTBC = (MainTabBarController *)navigationController.tabBarController;
//        mainTBC.axcTabBar.hidden = NO;
//
//    } else {
//        // 隐藏标签栏
//        MainTabBarController *mainTBC = (MainTabBarController *)navigationController.tabBarController;
//        mainTBC.axcTabBar.hidden = YES;
//    }
//    
//}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}





@end
