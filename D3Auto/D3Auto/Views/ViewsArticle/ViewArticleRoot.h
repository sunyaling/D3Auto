//
//  ViewArticleRoot.h
//  D3Auto
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ViewArticleRootDelegate <NSObject>

// banner
@required
- (void)onClickedBannerURL:(NSString* _Nonnull)url;         // 点击了滚动广告

- (void)nextPage;

- (void)onClickedArticle:(NSInteger)index;                  // 点击了文章进入详情


@end




@interface ViewArticleRoot : UIView

@property (nullable, nonatomic, weak) id <ViewArticleRootDelegate> delegate;


- (void)updateBanner:(NSArray* _Nonnull)imgArray urlArray:(NSArray* _Nonnull)urlArray;                              // 更新滚动广告UI

- (void)updateArticleList:(NSArray* _Nonnull) articleArray hasMore:(NSInteger)hasMore;                                    // 更新文章列表

@end
