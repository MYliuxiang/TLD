//
//  WCQRCodeVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ScanQRResultBlock)(NSString *resultStr);

@interface WCQRCodeVC : UIViewController
@property(nonatomic,copy)ScanQRResultBlock reslutBlock;

@end
