//
//  BaseViewController.m
//  Familysystem
//
//  Created by 李立 on 15/8/21.
//  Copyright (c) 2015年 LILI. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
#import "BaseNavigationController.h"


#define timeOutCount  15

@interface BaseViewController ()


@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation BaseViewController

- (void)dealloc
{
    NSLog(@"[%@] 释放了", NSStringFromClass([self class]));
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBottomSafeHeight, kScreenWidth, kBottomSafeHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    [self.view addSubview:self.bottomView];
   
//     self.navigationController.navigationBar.hidden = YES;
     self.automaticallyAdjustsScrollViewInsets = NO;
     [self setupNavBar];
   
    self.fd_prefersNavigationBarHidden = YES;

    
    
 
    

}

- (void)setupNavBar
{
    [self.view addSubview:self.customNavBar];

//    self.customNavBar.ba
    // 设置自定义导航栏背景图片
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    [self wr_setNavBarShadowImageHidden:YES];
    [self.customNavBar wr_setBottomLineHidden:YES];
    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"millcolorGrad"];

    self.customNavBar.backgroundColor = [UIColor colorWithHexString:@"#5BC73D"];
    self.customNavBar.titleLabelFont = [UIFont systemFontOfSize:16];
    self.customNavBar.titleLabelColor = [UIColor colorWithHexString:@"#333333"];
    

    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"fanhui"]];
    }
}

- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

  
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:![self isStatusBarVisible]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:NO];
    
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)isNaviBarVisible {
    return YES;
}

- (BOOL)isStatusBarVisible {
    return YES;
}


-(BOOL)prefersStatusBarHidden{
    return NO;
}


- (void)configNavigationBar {
    
//    self.hbd_barShadowHidden = YES;
//    self.hbd_barTintColor = [UIColor whiteColor];
//    [self wr_setNavBarTitleColor:NavTitleColor];
//    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
//    [self wr_setNavBarShadowImageHidden:YES];
//    self.hbd_titleTextAttributes = @{NSForegroundColorAttributeName:[MyColor colorWithHexString:@"#2E3145"],
//    NSFontAttributeName:[UIFont systemFontOfSize:17]};
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2E3145"],
      NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"返回箭头"] forBarMetrics:UIBarMetricsDefault];
////        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

#pragma mark -- 事件
- (void)tapAction:(UITapGestureRecognizer *)tap
{
//    [self.view endEditing:YES];
}

- (void)leftButtonAction:(UIButton *)sender
{
    //    [self.navigationController popViewControllerAnimated:YES];
    //FIX ME:这里需要根据前置页面是present或者push进来做一个判断
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        if (viewControllers[viewControllers.count - 1] == self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightButtonAction:(UIButton *)sender
{
    NSLog(@"右键事件");
    [self doRightNavBarRightBtnAction];
}

- (void)accountBeKickedAction:(NSNotification *)note
{
    [self doAccountBeKicked];
}

#pragma mark -- 属性
- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tap.cancelsTouchesInView = YES;
    }
    return _tap;
}



#pragma mark - 代理
#pragma mark - <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)doAccountBeKicked
{
    UINavigationController *rootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootVC.presentedViewController) {
        [rootVC.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [rootVC popToRootViewControllerAnimated:YES];
        }];
    }
    else
    {
        [rootVC popToRootViewControllerAnimated:YES];
    }
};

- (void)doRightNavBarRightBtnAction
{
    
};



@end
