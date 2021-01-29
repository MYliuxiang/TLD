//
//  SeeContractVC.m
//  TLD
//
//  Created by 刘翔 on 2021/1/20.
//

#import "SeeContractVC.h"

@interface SeeContractVC ()<WKNavigationDelegate>

@property(nonatomic, strong) UIView *mainView;

@property(nonatomic, strong) UIProgressView *progressView;

@end

@implementation SeeContractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"查看电子运输合同";
//    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
//        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
//        NSSet *websiteDataTypes = [NSSet setWithArray:types];
//        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//
//        }];
//    }else{
//        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
//        NSLog(@"%@", cookiesFolderPath);
//        NSError *errors;
//        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
//
//    }
   
    [self addMainView];
    [self creatWebView];

    
    NSURLRequest *request;
    request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.url]];

   
    [self.webView loadRequest:request];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 添加进度条
- (void)addMainView {
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kScreenWidth, kScreenHeight)];
    mainView.backgroundColor = [UIColor clearColor];
    _mainView = mainView;
    [self.view addSubview:mainView];
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    progressView.progress = 0;
    progressView.progressTintColor = [UIColor colorWithHexString:@"#F9DE4A"];
    _progressView = progressView;
    [mainView addSubview:progressView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(Height_NavBar, 0, kBottomSafeHeight, 0));
    }];
}

- (WKWebView *)webView
{
    if (_webView == nil) {
        _configuration = [[WKWebViewConfiguration alloc] init];
        // 实例化对象
        _configuration.userContentController = [WKUserContentController new];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:_configuration];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        [self.mainView addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.mainView).insets(UIEdgeInsetsMake(2, 0, kBottomSafeHeight, 0));
        }];
        
        // 添加观察者
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL]; // 进度
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL]; // 标题
    }
    return _webView;
}

- (void)creatWebView {
   
}
- (void)setUrl:(NSURL *)url {
    _url = url;
   
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    
    
}
#pragma mark - 监听加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == _webView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }  else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            if (self.title.length == 0) {
                self.title = self.webView.title;

            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
// 当对象即将销毁的时候调用
- (void)dealloc {
    NSLog(@"webView释放");
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    _webView.navigationDelegate = nil;
}
#pragma mark - WKNavigationDelegate
#pragma mark - 截取当前加载的URL
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow); // 必须实现 不然会崩溃
    
}






@end
