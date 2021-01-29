//
//  PayHelper.m
//  TLD
//
//  Created by liuxiang on 2021/1/21.
//

#import "PayHelper.h"

@implementation PayHelper
+ (instancetype)shareInstance
{
    static PayHelper *_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)openAliPay:(NSString *)orderString aliPayResult:(AliPayResult)aliPayResult
{
//    self.aliPayResult = aliPayResult;
    self.aliPayResult = aliPayResult;
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kScheme_AliPay callback:^(NSDictionary *resultDic) {
            [self handleAliPayResult:resultDic];
    }];
    
}

- (void)openWxPay:(NSDictionary *)orderDic aliPayResult:(WxPayResult)wxPayResult{
    self.wxPayResult = wxPayResult;
    if ([orderDic count] <= 0) {
        return;
    }
    
    PayReq *req = [[PayReq alloc] init];
    req.nonceStr = orderDic[@"noncestr"];
    req.partnerId = orderDic[@"partnerid"];
    req.prepayId = orderDic[@"prepayid"];
    req.openID = orderDic[@"appid"];
    
    /*
     sign = 016BEEA9A0E5C5BFB717A25599EE2B86;
     timestamp = 1611296676;
     */
   
    
    
//    double currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
//    long long iTime = (long long)currentTime;
//    req.timeStamp  = currentTime;

    
    req.timeStamp  = [orderDic[@"timestamp"] longLongValue];
    req.package = orderDic[@"package"];
    req.sign = orderDic[@"sign"];
    [WXApi sendReq:req completion:^(BOOL success) {
            
    }];
    
}

- (void)payForResults:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleAliPayResult:resultDic];
        }];
    } else if ([url.scheme isEqualToString:kAppKey_Wechat] && [url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:[PayHelper shareInstance]];
       
        
    }
    
}

- (void)handleAliPayResult:(NSDictionary *)resultDic{
    
    NSString *resultStr = resultDic[@"result"];
    NSString *memo = resultDic[@"memo"];
    int resultStatus = [resultDic[@"resultStatus"] intValue];
    switch (resultStatus) {
    case 6001:
        memo = @"用户取消支付";
        break;
        
    case 8000:
        memo = @"正在处理中，等待商家确认";
        break;
        
    case 4000:
        memo = @"订单支付失败";
        break;
        
    case 6002:
        memo = @"网络连接出错";
        break;
    case 9000:
        memo = @"支付宝支付成功";
        break;
    default:
        memo = @"支付失败";
        break;
    }
    BOOL payResult = resultStatus == 9000;
    if (self.aliPayResult != nil)
    {
        self.aliPayResult(payResult,memo,resultStr);
    }
    
    
}

#pragma mark WXDelegate
- (void)onResp:(BaseResp *)resp{
    
    if ([resp isKindOfClass:[PayResp class]]) {
        if (self.wxPayResult != nil) {
            self.wxPayResult(resp.errCode, resp.errStr);
        }
    }
   
}

- (void)onReq:(BaseReq *)req{
    
}



@end
