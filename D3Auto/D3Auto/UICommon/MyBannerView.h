//
//  MyBannerView.h
//  D3Auto
//
//  Created by zhongfang on 15/10/29.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyBannerViewDelegate <NSObject>

@required
- (void)onClickedBannerURL:(NSString* _Nonnull)url;

@end


@interface MyBannerView : UIScrollView

@property (nonnull, nonatomic, strong) id <MyBannerViewDelegate> myBannerViewDelegate;


- (void)updateUI:(NSArray* _Nullable)imgArray urlArray:(NSArray* _Nullable)urlArray;

@end
