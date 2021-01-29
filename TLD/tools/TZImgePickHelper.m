//
//  TZImgePicekHelper.m
//  BHGY
//
//  Created by liuxiang on 2020/7/14.
//  Copyright © 2020 liuxiang. All rights reserved.
//

#import "TZImgePickHelper.h"

@implementation TZImgePickHelper
+ (instancetype)shareInstance
{
    static TZImgePickHelper *_instace = nil;
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

- (instancetype)initMaxCount:(NSInteger)maxImagesCount{
    self = [super initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:self];
    if (self) {
        self.allowTakePicture = YES;
        self.allowTakeVideo = NO;
        self.allowPickingVideo = NO;
        self.allowPickingGif = NO;
        self.preferredLanguage =@"zh-Hans";
        self.allowPickingGif = NO;
        self.allowPickingOriginalPhoto = NO;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self addObserver:self forKeyPath:@"navigationBar.hidden" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"navigationBar.hidden"] && [object isKindOfClass:[TZImagePickerController class]]) {
        TZImagePickerController *tzImagePicker = (TZImagePickerController *)object;
        // 当前在预览页面，且导航栏显示着(被FD等第三方库打开了)，再隐藏下导航栏
        if ([tzImagePicker.topViewController isKindOfClass:[TZPhotoPreviewController class]] && [change[NSKeyValueChangeNewKey] intValue] == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tzImagePicker setNavigationBarHidden:YES];
            });
        }
    }
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    NSLog(@"helper释放了");
}



@end
