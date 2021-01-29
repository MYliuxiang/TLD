//
//  SeeContractVC.h
//  TLD
//
//  Created by 刘翔 on 2021/1/20.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SeeContractVC : BaseViewController

@property(nonatomic,copy) NSString *url;

@property(nonatomic, strong) WKWebView *webView;

@property(nonatomic, strong) WKWebViewConfiguration *configuration;
@end

NS_ASSUME_NONNULL_END
