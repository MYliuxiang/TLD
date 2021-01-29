//
//  TZImgePicekHelper.h
//  BHGY
//
//  Created by liuxiang on 2020/7/14.
//  Copyright © 2020 liuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZImgePickHelper : TZImagePickerController<TZImagePickerControllerDelegate>

- (instancetype)initMaxCount:(NSInteger)maxImagesCount;

@end

NS_ASSUME_NONNULL_END
