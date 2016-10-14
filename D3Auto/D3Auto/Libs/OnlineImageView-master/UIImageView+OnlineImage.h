//
//  UIImageView+OnlineImage.h
//  AImageDownloader
//
//  Created by Jason Lee on 12-3-8.
//  Copyright (c) 2012年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageDownloader.h"

@interface UIImageView (OnlineImage) <AsyncImageDownloaderDelegate>

//@property (nonatomic) BOOL isMatchW;                                            // 下载图片完成后是否适应宽重新布局

//@property (nonatomic) BOOL isNeedLoading;                                       // 下载图片是否需要等待动画

- (void)setOnlineImage:(NSString *)url;
- (void)setOnlineImage:(NSString *)url placeholderImage:(UIImage *)image;


@end
