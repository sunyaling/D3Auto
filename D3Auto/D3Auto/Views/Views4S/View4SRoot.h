//
//  View4SRoot.h
//  D3Auto
//
//  Created by zhongfang on 15/10/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Model4SBrandList.h"
#import "Model4SCarList.h"

@protocol View4SRootDelegate <NSObject>

// banner
@required
- (void)onClickedBannerURL:(NSString* _Nonnull)url;

// recommond
- (void)onClickedCate:(NSString* _Nonnull)cateID;

// brand list
- (void)onClickedCar:(NSString* _Nonnull)carID;


@end


@interface View4SRoot : UIView

@property (nullable, nonatomic, weak) id <View4SRootDelegate> delegate;


- (void)updateBanner:(NSArray* _Nonnull)imgArray urlArray:(NSArray* _Nonnull)urlArray;                              // 更新滚动广告UI

- (void)updateRecommond:(NSMutableArray* _Nonnull)brandArray andCarArray:(NSMutableArray* _Nonnull)carArray;        // Dic: id name image

- (void)updateBrandList:(NSArray* _Nonnull) brandListDicArray;                                                      // 更新品牌列表

- (void)updateCarList:(NSArray* _Nonnull) carListArray;                                                             // 更新车辆列表

- (void)updateCityName:(NSString* _Nonnull) cityName;

@end


