//
//  NetRepair.h
//  D3Auto
//
//  Created by apple on 15/11/18.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetBase.h"

@interface NetRepair : NetBase

+ (instancetype _Nonnull)sharedInstance;


// ------ 汽修店界面滚动广告
- (void)req4SBanner:(void (^ _Nonnull)(id _Nonnull success))success
               fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure;

// ------ 汽修服务类型
- (void)reqServiceList:(void (^ _Nonnull)(id _Nonnull success))success
                  fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                cateID:(NSString* _Nonnull)cateID;


// ------ 增加汽修服务项目
- (void)reqServiceAdd:(void (^ _Nonnull)(id _Nonnull success))success
                 fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
         serviceArray:(NSArray* _Nonnull)serviceArray;

// ------ 获取满足服务项目的商店列表
- (void)reqServiceShopList:(void (^ _Nonnull)(id _Nonnull success))success
                      fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                 serviceID:(NSString* _Nonnull)serviceID;

// ------ 获取一定范围内的汽修店列表
- (void)reqNearbyShopList:(void (^ _Nonnull)(id _Nonnull success))success
                     fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure;

// ------ 获取五星店铺列表
- (void)req5StarShopList:(void (^ _Nonnull)(id _Nonnull success))success
                    fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure;

// ------ 获取店铺详情信息
- (void)reqRepairShopDetail:(void (^ _Nonnull)(id _Nonnull success))success
                       fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                  andShopID:(NSString* _Nonnull)shopID;



@end
