//
//  UIImageView+OnlineImage.m
//  AImageDownloader
//
//  Created by Jason Lee on 12-3-8.
//  Copyright (c) 2012年 Taobao. All rights reserved.
//

#import "UIImageView+OnlineImage.h"

@implementation UIImageView (OnlineImage)

- (void)setOnlineImage:(NSString *)url
{
    [self setOnlineImage:url placeholderImage:nil];
}

- (void)setOnlineImage:(NSString *)url placeholderImage:(UIImage *)image
{
    self.image = image;
    
    AsyncImageDownloader *downloader = [AsyncImageDownloader sharedImageDownloader];
    [downloader startWithUrl:url delegate:self];
}

#pragma mark -
#pragma mark - AsyncImageDownloader Delegate

- (void)imageDownloader:(AsyncImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = image;
        if ( self.frame.size.height == 0 ) {
            float view_w = self.frame.size.width;
            float img_w = image.size.width;
            float view_h = view_w / img_w * image.size.height;
            
            float y = 0;
            if ( self.superview != nil )
            {
                float super_h = self.superview.frame.size.height;
                y = (super_h - view_h) / 2;
            }
            
            [self setFrame:CGRectMake(self.frame.origin.x, y, view_w, view_h)];
        }
    });
}

@end
