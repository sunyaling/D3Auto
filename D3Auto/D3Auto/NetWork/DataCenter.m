//
//  DataCenter.m
//  D3Auto
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "DataCenter.h"

#import "Config.h"

@implementation DataCenter


static DataCenter * instance;

+ (instancetype)sharedInstance
{
    if (instance == nil)
    {
        instance = [[DataCenter alloc] init];
    }
    return instance;
}


- (NSDictionary*)getSessionDic
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
 
    NSString* sessionID = [userDefault stringForKey:DEF_KEY_SESSION_ID];
    NSString* userID = [userDefault stringForKey:DEF_KEY_USER_ID];
    if ( sessionID == nil || [sessionID compare:@""] == NSOrderedSame
        || userID == nil || [userID compare:@""] == NSOrderedSame
        || [userDefault boolForKey:DEF_KEY_IS_LOGIN] == false )
    {
        [self cleanLoginInfo];
        return nil;
    }
    
    NSMutableDictionary* sessionDic = [[NSMutableDictionary alloc] init];
    [sessionDic setValue:sessionID forKey:@"sid"];
    [sessionDic setValue:userID forKey:@"uid"];
    
    return sessionDic;
}

- (NSDictionary*)getPaginationDic:(NSInteger)page count:(NSInteger)count
{
    NSMutableDictionary* pageDic = [[NSMutableDictionary alloc] init];
    [pageDic setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [pageDic setValue:[NSString stringWithFormat:@"%ld",count] forKey:@"count"];
    
    return pageDic;
}

- (void)cleanLoginInfo
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:@"" forKey:DEF_KEY_SESSION_ID];
    [userDefault setObject:@"" forKey:DEF_KEY_USER_ID];
    
    [userDefault setBool:NO forKey:DEF_KEY_IS_LOGIN];
}

- (void)storageUserInfo:(NSDictionary* _Nonnull)userDic session:(NSDictionary* _Nonnull)sessionDic
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:NO forKey:DEF_KEY_IS_LOGIN];
    
    ModelUserInfo* userInfo = [[ModelUserInfo alloc] init];
    userInfo.userID = [userDic valueForKey:@"user_id"];
    userInfo.account = [userDic valueForKey:@"user_name"];
    userInfo.email = [userDic valueForKey:@"email"];
    userInfo.sex = [userDic valueForKey:@"gender"];
    userInfo.birthday = [userDic valueForKey:@"birthday"];
    userInfo.qq = [userDic valueForKey:@"im_qq"];
    userInfo.mobile = [userDic valueForKey:@"phone_mob"];
    userInfo.registerTime = [userDic valueForKey:@"reg_time"];
    userInfo.defaultCarID = [userDic valueForKey:@"default_car_id"];
    userInfo.defaultCarName = [userDic valueForKey:@"default_car_name"];
    
    userInfo.shopType = [userDic valueForKey:@"shop_type"];
    userInfo.shopID = [userDic valueForKey:@"shop_id"];
    userInfo.shopStatus = [userDic valueForKey:@"shop_status"];
    userInfo.shopName = [userDic valueForKey:@"shop_name"];
    userInfo.shopEmail = [userDic valueForKey:@"shop_email"];
    userInfo.shopTel = [userDic valueForKey:@"shop_tel"];
    userInfo.shopMobile = [userDic valueForKey:@"shop_mobile"];
    userInfo.shopAddress = [userDic valueForKey:@"shop_address"];
    userInfo.shopProvinceID = [userDic valueForKey:@"province"];
    userInfo.shopCityID = [userDic valueForKey:@"city"];
    userInfo.shopDistrictID = [userDic valueForKey:@"district"];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [userDefault setObject:data forKey:DEF_KEY_USER_INFO];
    
    [userDefault setBool:YES forKey:DEF_KEY_IS_LOGIN];
    
    [userDefault setObject:[sessionDic objectForKey:@"sid"] forKey:DEF_KEY_SESSION_ID];
    [userDefault setObject:[sessionDic objectForKey:@"uid"] forKey:DEF_KEY_USER_ID];
}



@end
