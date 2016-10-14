//
//  Net4S.m
//  D3Auto
//
//  Created by zhongfang on 15/10/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Net4S.h"

#import "DataCenter.h"
#import "MyAlertNotice.h"


@implementation Net4S


static Net4S * instance;

+ (instancetype)sharedInstance
{
    if (instance == nil)
    {
        instance = [[Net4S alloc] init];
    }
    return instance;
}


#pragma mark - banner
- (void)req4SBanner:(void (^)(id success))success fail:(void (^)(NSError * error))failure
{
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/banner_data"];
    [super getRequest:url
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
    ];
}

#pragma mark - recommond list
- (void)req4SRcmdList:(void (^)(id success))success fail:(void (^)(NSError * error))failure andBrandCount:(NSInteger)bCount andCarCount:(NSInteger)cCount
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:[NSString stringWithFormat:@"%ld", bCount] forKey:@"need_ret_num_brand"];
    [dicJson setValue:[NSString stringWithFormat:@"%ld", cCount] forKey:@"need_ret_num_car"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/recommend_info"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - brand list
- (void)req4SBrandList:(void (^)(id success))success fail:(void (^)(NSError * error))failure andRetLevel:(NSInteger)retLevel
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:[NSString stringWithFormat:@"%ld", retLevel] forKey:@"need_ret_lvl"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/list_brand"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - car list
- (void)reqCarListWithBrand:(void (^)(id success))success fail:(void (^)(NSError * error))failure andCateID:(NSString* _Nonnull)cateID
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:cateID forKey:@"cate_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/car_list_with_brand"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - car detail
- (void)req4SCarDetail:(void (^)(id success))success fail:(void (^)(NSError * error))failure andCateID:(NSString* _Nonnull)carID
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:carID forKey:@"car_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/car_info"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - car list
- (void)reqCarListWithoutBrand:(void (^)(id success))success fail:(void (^)(NSError * error))failure brandID:(NSString* _Nonnull)brandID
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:brandID forKey:@"cate_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/car_list_without_brand"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - car attr price manage
- (void)reqAddCarPrice:(void (^)(id success))success fail:(void (^)(NSError * error))failure dic:(NSDictionary*)dic
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    NSMutableDictionary* dicJson = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [dicJson setObject:sessionDic forKey:@"session"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/car_attr_price_add"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}
// ------ 删除车辆价格信息
- (void)reqDelCarPrice:(void (^)(id success))success fail:(void (^)(NSError* error))failure priceID:(NSString*)priceID
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    NSMutableDictionary* dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:sessionDic forKey:@"session"];
    [dicJson setValue:priceID forKey:@"price_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/car_attr_price_del"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}
// ------ 某个4s店的车辆价格列表
- (void)reqListCarPrice:(void (^)(id success))success fail:(void (^)(NSError* error))failure shopID:(NSString*)shopID
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    NSMutableDictionary* dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:sessionDic forKey:@"session"];
    [dicJson setValue:shopID forKey:@"shop_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/car_attr_price_list"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - shop list
- (void)reqAttrShopList:(void (^)(id success))success fail:(void (^)(NSError * error))failure carID:(NSString*)carID attrID:(NSString*)attrID
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:carID forKey:@"car_id"];
    [dicJson setValue:attrID forKey:@"car_attr_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/4s/shop_list_with_attr"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

@end
