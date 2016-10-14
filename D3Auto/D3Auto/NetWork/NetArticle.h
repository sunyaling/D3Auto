//
//  NetArticle.h
//  D3Auto
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetBase.h"

@interface NetArticle : NetBase

+ (instancetype _Nonnull)sharedInstance;


// ------ 滚动广告
- (void)reqBanner:(void (^ _Nonnull)(id _Nonnull success))success
             fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure;

// ------ 文章列表
- (void)reqArticleList:(void (^ _Nonnull)(id _Nonnull success))success
                  fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                  page:(NSInteger)page
                 count:(NSInteger)count;

// ------ 文章详情
- (void)reqArticleDetail:(void (^ _Nonnull)(id _Nonnull success))success
                    fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
               articleID:(NSUInteger)articleID;

@end
