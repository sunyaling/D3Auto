//
//  NetRepair.m
//  D3Auto
//
//  Created by apple on 15/11/18.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetRepair.h"

#import "DataCenter.h"
#import "MyAlertNotice.h"

@implementation NetRepair

static NetRepair * instance;

+ (instancetype)sharedInstance
{
    if (instance == nil)
    {
        instance = [[NetRepair alloc] init];
    }
    return instance;
}


#pragma mark - banner
- (void)req4SBanner:(void (^)(id success))success fail:(void (^)(NSError * error))failure
{
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/repair/banner_data"];
    [super getRequest:url
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - service list
- (void)reqServiceList:(void (^)(id success))success fail:(void (^)(NSError * error))failure cateID:(NSString* _Nonnull)cateID
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:cateID forKey:@"cate_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/repair/service_list"];
    [super postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - service add
- (void)reqServiceAdd:(void (^)(id success))success fail:(void (^)(NSError * error))failure serviceArray:(NSArray* _Nonnull)serviceArray
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:serviceArray forKey:@"service_array"];
    [dicJson setObject:sessionDic forKey:@"session"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/repair/service_add"];
    [super postRequest:url
            parameters:dicJson
               success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - service shop list
- (void)reqServiceShopList:(void (^)(id success))success fail:(void (^)(NSError * error))failure serviceID:(NSString* _Nonnull)serviceID{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    double longitude = [userDefault doubleForKey:DEF_KEY_LONGITUDE];
    double latitude = [userDefault doubleForKey:DEF_KEY_LATITUDE];
    
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:serviceID forKey:@"service_id"];
    [dicJson setValue:[NSString stringWithFormat:@"%lf",longitude] forKey:@"longitude"];
    [dicJson setValue:[NSString stringWithFormat:@"%lf",latitude] forKey:@"latitude"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/repair/shop_list_service"];
    [super postRequest:url
            parameters:dicJson
               success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - nearby shop list
- (void)reqNearbyShopList:(void (^)(id success))success fail:(void (^)(NSError * error))failure
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    double longitude = [userDefault doubleForKey:DEF_KEY_LONGITUDE];
    double latitude = [userDefault doubleForKey:DEF_KEY_LATITUDE];

    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:[NSString stringWithFormat:@"%lf",longitude] forKey:@"longitude"];
    [dicJson setValue:[NSString stringWithFormat:@"%lf",latitude] forKey:@"latitude"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/repair/shop_list_nearby"];
    [super postRequest:url
            parameters:dicJson
               success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - 5-star shop list
- (void)req5StarShopList:(void (^)(id success))success fail:(void (^)(NSError * error))failure
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    double longitude = [userDefault doubleForKey:DEF_KEY_LONGITUDE];
    double latitude = [userDefault doubleForKey:DEF_KEY_LATITUDE];
    
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:[NSString stringWithFormat:@"%lf",longitude] forKey:@"longitude"];
    [dicJson setValue:[NSString stringWithFormat:@"%lf",latitude] forKey:@"latitude"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/repair/shop_list_star5"];
    [super postRequest:url
            parameters:dicJson
               success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - shop detail
- (void)reqRepairShopDetail:(void (^)(id success))success fail:(void (^)(NSError * error))failure andShopID:(NSString* _Nonnull)shopID
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:shopID forKey:@"shop_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/repair/shop_info"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}




@end
