//
//  Net4S.h
//  D3Auto
//
//  Created by zhongfang on 15/10/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetBase.h"


@interface Net4S : NetBase

+ (instancetype _Nonnull)sharedInstance;


// ------ 4S店界面滚动广告
- (void)req4SBanner:(void (^ _Nonnull)(id _Nonnull success))success
               fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure;

// ------ 推荐的品牌及车型列表
- (void)req4SRcmdList:(void (^ _Nonnull)(id _Nonnull success))success
                 fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
        andBrandCount:(NSInteger)bCount
          andCarCount:(NSInteger)cCount;

// ------ 品牌列表
- (void)req4SBrandList:(void (^ _Nonnull)(id _Nonnull success))success
                  fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
           andRetLevel:(NSInteger)retLevel;

// ------ 车辆列表(带分类信息)
- (void)reqCarListWithBrand:(void (^ _Nonnull)(id _Nonnull success))success
                       fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                  andCateID:(NSString* _Nonnull)cateID;

// ------ 车辆详情
- (void)req4SCarDetail:(void (^ _Nonnull)(id _Nonnull success))success
                  fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
             andCateID:(NSString* _Nonnull)carID;

// ------ 车辆列表(不带分类信息)
- (void)reqCarListWithoutBrand:(void (^ _Nonnull)(id _Nonnull success))success
                          fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                       brandID:(NSString* _Nonnull)brandID;

// ------ 增加车辆价格信息
- (void)reqAddCarPrice:(void (^ _Nonnull)(id _Nonnull success))success
                  fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                   dic:(NSDictionary* _Nonnull)dic;

// ------ 删除车辆价格信息
- (void)reqDelCarPrice:(void (^ _Nonnull)(id _Nonnull success))success
                  fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
               priceID:(NSString* _Nonnull)priceID;

// ------ 某个4s店的车辆价格列表
- (void)reqListCarPrice:(void (^ _Nonnull)(id _Nonnull success))success
                   fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                 shopID:(NSString* _Nonnull)shopID;

// ------ 获取某个配置的商店列表
- (void)reqAttrShopList:(void (^ _Nonnull)(id _Nonnull success))success
                   fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                  carID:(NSString* _Nonnull)carID
                 attrID:(NSString* _Nonnull)attrID;



@end
