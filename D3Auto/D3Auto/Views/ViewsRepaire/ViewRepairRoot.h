//
//  ViewRepairRoot.h
//  D3Auto
//
//  Created by apple on 15/11/18.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ViewRepairRootDelegate <NSObject>

// banner
@required
- (void)onClickedBannerURL:(NSString* _Nonnull)url;         // 点击了滚动广告

- (void)onClickedNearbyShop:(NSInteger)index;
- (void)onClickedNearbyShopMore;
- (void)onClickedNearbyShopRefresh;

- (void)onClickedSOS;                                       // 点击了紧急求救

- (void)onClicked5StarShop:(NSInteger)index;                // 点击五星店铺

- (void)onClickedRepair:(NSInteger)index;                   // 点击维修保养某项 将索引根据tag取出后传回controller

- (void)onClickedModify:(NSInteger)index;                   // 点击专业改装某项 将索引根据tag取出后传回controller

- (void)onClickedGetPos;                                    // 点击了定位

- (void)onClickedRefreshInfo;                               // 点击刷新信息
- (void)onClickedCmtInfo:(NSString* _Nonnull)info;          // 点击提交信息

@end


@interface ViewRepairRoot : UIView

@property (nullable, nonatomic, weak) id <ViewRepairRootDelegate> delegate;


- (void)updateBanner:(NSArray* _Nonnull)imgArray urlArray:(NSArray* _Nonnull)urlArray;                              // 更新滚动广告UI

- (void)updateCityName:(NSString* _Nonnull)cityName;

- (void)updateNearbyShop:(NSArray* _Nonnull)shopArray;

- (void)update5StarShop:(NSArray* _Nonnull)shopArray;

- (void)updateRepairService:(NSArray* _Nonnull)repairArray;

- (void)updateModifyService:(NSArray* _Nonnull)modifyArray;

- (void)updateBroadcastInfo:(NSArray* _Nonnull)broadcastArray;

@end
