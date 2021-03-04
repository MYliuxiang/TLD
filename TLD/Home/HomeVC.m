//
//  HomeVC.m
//  TLD
//
//  Created by liuxiang on 2021/1/20.
//

#import "HomeVC.h"
#import <WebKit/WebKit.h>
#import "SeeContractVC.h"
#import "PopSignatureView.h"
#import <MapKit/MapKit.h>
#import "WBQRCodeVC.h"
#import "WCQRCodeVC.h"



@interface HomeVC ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate,AMapLocationManagerDelegate,PopSignatureViewDelegate,TZImagePickerControllerDelegate>
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKWebViewConfiguration *configuration;
@property(nonatomic,strong) AMapLocationManager *locationManager;
@property(nonatomic,strong) NSMutableDictionary *locationInfoDic;

@end

@implementation HomeVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"j2aCls"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"j2aCls"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.locationInfoDic = [NSMutableDictionary dictionary];
    //开启定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.customNavBar.hidden = YES;
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"/H5"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:content baseURL:[NSURL fileURLWithPath: [NSString stringWithFormat:@"%@/H5/", [[NSBundle mainBundle] bundlePath]]]];

//    NSURL *url = [NSURL URLWithString:@"https://tld.0838mai.cn/h5/app"];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    [self.webView loadRequest:request];
    

}

- (WKWebView *)webView
{
    if (_webView == nil) {
       
        NSString *jspath = [[NSBundle mainBundle]pathForResource:@"j2aCls.js" ofType:nil];
        NSString *str = [NSString stringWithContentsOfFile:jspath encoding:NSUTF8StringEncoding error:nil];
        //注入时机是在webview加载状态WKUserScriptInjectionTimeAtDocumentStart、WKUserScriptInjectionTimeAtDocumentEnd
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:str injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addUserScript:userScript];
        [userContentController addScriptMessageHandler:self name:@"j2aCls"];


        _configuration = [[WKWebViewConfiguration alloc] init];
        // 实例化对象
        _configuration.userContentController = userContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:_configuration];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
        [self.view addSubview:_webView];
        __weak typeof(self) weakSelf = self;
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(Height_StatusBar, 0, kBottomSafeHeight, 0));
        }];
        
//        // 添加观察者
//        [_webView addObserver:weakSelf forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL]; // 进度
//        [_webView addObserver:weakSelf forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL]; // 标题
    }
    return _webView;
}

#pragma mark - WKScriptMessageHandler

//! WKWebView收到ScriptMessage时回调此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
    if ([message.name caseInsensitiveCompare:@"j2aCls"] == NSOrderedSame) {
        NSDictionary *dic = message.body;
        NSString *name = dic[@"name"];
        //存储token
        if ([name isEqualToString:@"SetToken"]) {
            NSString *obj = dic[@"token"];
            [LxUserDefaults setObject:obj forKey:Token];
            [LxUserDefaults synchronize];
        }
        
        //前端数据请求
        if ([name isEqualToString:@"SendMsgViaHost"]) {
            NSString *obj = dic[@"obj"];
            NSDictionary *params = @{@"msg":obj};
            //调用注册接口
            BADataEntity *entity = [BADataEntity new];
            entity.urlString = BaseUrl;
            entity.needCache = NO;
            entity.parameters = params;
            [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                NSDictionary *result = response;
                NSString *jsonStr = [result mj_JSONString];
                NSString *valueStr = [NSString stringWithFormat:@"responseViaHost('%@')",jsonStr];
                [MBProgressHUD hideHUDForView:lxWindow animated:YES];
                [self.webView evaluateJavaScript:valueStr
                          completionHandler:^(id response, NSError * error) {
                              NSLog(@"response: %@, \nerror: %@", response, error);
                }];

            } failureBlock:^(NSError *error) {
                [MBProgressHUD hideHUDForView:lxWindow animated:YES];
                [MBProgressHUD showError:@"网络异常" toView:lxWindow];

            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
        
        }
        
        //相册上传图片
        if ([name isEqualToString:@"DoSelectPictrue"]) {
            NSString *idCard = dic[@"idCard"];
            NSString *obj = dic[@"obj"];
//            NSString *two = dic[@"two"];
            [self takePhoto:idCard ext:obj];
        }
        
        //扫码功能
        if ([name isEqualToString:@"OpenScaner"]) {
            [self QRCodeScanVC];
        }
        
        //拉起微信支付
        if ([name isEqualToString:@"PaywithWxpay"]) {
            NSString *message = dic[@"message"];
            NSDictionary *dic = (NSDictionary *)[message mj_JSONObject];
            [[PayHelper shareInstance] openWxPay:dic aliPayResult:^(int errCode, NSString * _Nonnull errStr) {
                
            }];

        }
        //拉起支付宝支付
        if ([name isEqualToString:@"PaywithAlipay"]) {
            NSString *message = dic[@"message"];
            NSString *strUrl = [message stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
//            NSString *strUrl1 = [strUrl stringByReplacingOccurrencesOfString:@";" withString:@"&"];

           
            [[PayHelper shareInstance] openAliPay:strUrl aliPayResult:^(BOOL payResult, NSString * _Nonnull errStr, NSString * _Nonnull resultStr) {
            }];
        }
        
        ///调用手机导航
        if ([name isEqualToString:@"OpenNavigation"]) {
            NSString *lat = dic[@"lat"];
            NSString *lng = dic[@"lng"];
            [self NavigationWithlat:lat lng:lng];
            
        }
        
        ////签字板
        if ([name isEqualToString:@"OpenSignatureBoard"]) {
            
            PopSignatureView *socialSingnatureView = [[PopSignatureView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            socialSingnatureView.delegate = self;
            [socialSingnatureView show];
        }
        
        //查看电子运输合同
        if ([name isEqualToString:@"ShowContactDocument"]) {
            NSString *url = dic[@"url"];
            NSString *string = [NSString stringWithFormat:@"%@",url];

            BAFileDataEntity *entity = [BAFileDataEntity new];
            entity.urlString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            double currentTime =  [[NSDate date] timeIntervalSince1970];
            
            NSString *fileName = [NSString stringWithFormat:@"%.0f.docx",currentTime];
            
            
            [MBProgressHUD showHUDAddedTo:lxWindow animated:YES];
            [BANetManager ba_downLoadFileWithEntity:entity successBlock:^(id response) {

                    
                NSData *data = [[NSData alloc] initWithContentsOfFile:(NSString *)response];;
                NSDictionary *dic = [data mj_JSONObject];
                if (dic != nil) {
                    NSString *jsonStr = [dic mj_JSONString];
                    NSString *valueStr = [NSString stringWithFormat:@"responseViaHost('%@')",jsonStr];
                    [self.webView evaluateJavaScript:valueStr
                              completionHandler:^(id response, NSError * error) {
                                  NSLog(@"response: %@, \nerror: %@", response, error);
                    }];
                    
                }else{
                    SeeContractVC *vc = [[SeeContractVC alloc] init];
                    vc.url = (NSString *)response;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                [MBProgressHUD hideHUDForView:lxWindow animated:YES];
                
            } failureBlock:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:lxWindow animated:YES];
                [MBProgressHUD showError:@"网络异常" toView:lxWindow];
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
        
        }    
    }
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
   
    
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
        
    
    if (navigationAction.targetFrame == nil) {
       
        [webView loadRequest:navigationAction.request];
        
    }
 
    
    
    decisionHandler(WKNavigationActionPolicyAllow); // 必须实现 不然会崩溃


    
}


#pragma mark - WKUIDelegate delegate method
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    if (prompt) {
        //获取定位信息
        if ([prompt isEqualToString: @"getlocation"]) {
            [self.locationManager startUpdatingLocation];
            NSString *locationStr = [self.locationInfoDic mj_JSONString];
//            NSString *locationStr1 = @"{\"lat\":113.92576,\"lng\":22.53319}" ;
            completionHandler(locationStr);
        }
        
        //获取token
        if ([prompt isEqualToString:@"GetToken"]) {
            NSString *str = [NSString stringWithFormat:@"%@",[LxUserDefaults objectForKey:Token]];
            if (str.length == 0 || [str isEqualToString:@"(null)"]) {
                NSDictionary *dic = @{};
                str = [dic mj_JSONString];
            }
            completionHandler(str);

        }
        
        
    }
    

    
    
}

#pragma mark AMapLocationManager
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
   
    self.locationInfoDic[@"lat"] = @(location.coordinate.latitude);
    self.locationInfoDic[@"lng"] = @(location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];

}

#pragma mark - SocialSignatureViewDelegate
- (void)onSubmitBtn:(UIImage *)signatureImg {
    
    [self uploadImage:@[signatureImg] jsonStr:@"signature" ext:@""];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)NavigationWithlat:(NSString *)lat lng:(NSString *)lng{
    
    NSMutableArray *maps = [NSMutableArray array];
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name=北京&mode=driving&coord_type=gcj02",lat,lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",@"导航功能",@"nav123456",lat,lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"导航测试",@"nav123456",lat, lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=终点&coord_type=1&policy=0",lat, lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    //选择
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = maps.count;
    
    for (int i = 0; i < index; i++) {
        
        NSString * title = maps[i][@"title"];
        //苹果原生地图方法
        if (i == 0) {
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMapWithlat:lat lng:lng];
            }];
            [alert addAction:action];
            continue;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = maps[i][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [alert addAction:action];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//苹果地图
- (void)navAppleMapWithlat:(NSString *)lat lng:(NSString *)lng
{
//    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:self.destinationCoordinate2D];
    
    //终点坐标
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    
    
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };

    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
    
    
}

- (void)seltedPhoto:(NSString *)jsonStr ext:(NSString *)ext{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
       imagePickerVc.allowPickingVideo = NO;
       
       imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;

       // You can get the photos by block, the same as by delegate.
       // 你可以通过block或者代理，来得到用户选择的照片.
       [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
           
           [self uploadImage:photos jsonStr:jsonStr ext:ext];
           
           
       }];
       [self presentViewController:imagePickerVc animated:YES completion:nil];
       
}

- (void)uploadImage:(NSArray *)images jsonStr:(NSString *)jsonStr ext:(NSString *)ext{
    
    
    NSMutableArray *imageNames = [NSMutableArray array];
    for (UIImage *image in images) {
        double currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
        long long iTime = (long long)currentTime;
        NSString *imageName = [NSString stringWithFormat:@"%lld.png",iTime];
        [imageNames addObject:@"file"];
    }
    
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[LxUserDefaults objectForKey:Token]];
    NSDictionary *tokenDic = (NSDictionary *)[tokenStr mj_JSONObject];
    NSString *token = tokenDic[@"token"];
    
    NSDictionary *dic = @{@"function":@"uploadFiles",@"type":jsonStr,@"token":token,@"ext":ext};
    NSString *valueStr = [dic mj_JSONString];
     
    BAImageDataEntity *entity = [BAImageDataEntity new];
    entity.urlString = BaseUrl;
    entity.needCache = NO;
    entity.parameters = @{@"msg":valueStr};
    entity.imageType = @"png";
    entity.imageArray = images;
    entity.imageScale = 0.5;
    entity.fileNames = imageNames;
    [MBProgressHUD showHUDAddedTo:lxWindow animated:YES];
    [BANetManager ba_uploadImageWithEntity:entity successBlock:^(id response) {
        NSDictionary *result = response;
        NSString *jsonStr = [result mj_JSONString];
        NSString *valueStr = [NSString stringWithFormat:@"responseViaHost('%@')",jsonStr];
        [MBProgressHUD hideHUDForView:lxWindow animated:YES];
        [self.webView evaluateJavaScript:valueStr
                       completionHandler:^(id response, NSError * error) {
            NSLog(@"response: %@, \nerror: %@", response, error);
        }];
    } failurBlock:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:lxWindow animated:YES];
        [MBProgressHUD showError:@"网络异常" toView:lxWindow];

    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        
    }];
            
}

- (void)takePhoto:(NSString *)jsonStr ext:(NSString *)ext{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto:jsonStr ext:ext];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto:jsonStr ext:ext];
        }];
    } else {
        [self seltedPhoto:jsonStr ext:ext];
    }
}

#pragma  mark 二维码扫描
- (void)QRCodeScanVC {
    
    WBQRCodeVC *scanVC = [WBQRCodeVC new];
    scanVC.reslutBlock = ^(NSString *resultStr) {
        if (resultStr.length != 0) {
            
            NSDictionary *resultDic = @{@"sid":resultStr};
            NSString *jsonStr = [resultDic mj_JSONString];
            NSString *valueStr = [NSString stringWithFormat:@"responseQrcode('%@')",jsonStr];
            [self.webView evaluateJavaScript:valueStr
                      completionHandler:^(id response, NSError * error) {
                          NSLog(@"response: %@, \nerror: %@", response, error);
            }];
        }
    };
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                           
                                
                                [self.navigationController pushViewController:scanVC animated:YES];
                            });
                            NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        } else {
                            NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        }
                    }];
                    break;
                }
                case AVAuthorizationStatusAuthorized: {
                    [self.navigationController pushViewController:scanVC animated:YES];
                    break;
                }
                case AVAuthorizationStatusDenied: {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertC addAction:alertA];
                    [self presentViewController:alertC animated:YES completion:nil];
                    break;
                }
                case AVAuthorizationStatusRestricted: {
                    NSLog(@"因为系统原因, 无法访问相册");
                    break;
                }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
