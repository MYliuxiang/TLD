//
//  PayHelper.h
//  TLD
//
//  Created by liuxiang on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AliPayResult)(BOOL payResult,NSString *errStr,NSString *resultStr);
typedef void(^WxPayResult)(int errCode,NSString *errStr);

@interface PayHelper : NSObject<WXApiDelegate>

@property(nonatomic,copy)AliPayResult aliPayResult;
@property(nonatomic,copy)WxPayResult wxPayResult;


+ (instancetype)shareInstance;
- (void)payForResults:(NSURL *)url;
- (void)openAliPay:(NSString *)orderString aliPayResult:(AliPayResult)aliPayResult;
- (void)openWxPay:(NSDictionary *)orderDic aliPayResult:(WxPayResult)wxPayResult;


@end

NS_ASSUME_NONNULL_END
