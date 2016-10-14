//
//  ControllerMainRepaire.m
//  D3Auto
//
//  Created by zhongfang on 15/10/27.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "ControllerMainRepaire.h"

#import "Config.h"
#import "NetUser.h"
#import "NetRepair.h"
#import "ModelUserInfo.h"
#import "RDVTabBarController.h"
#import "ViewRepairRoot.h"
#import "MyAlertNotice.h"
#import "MyWebViewController.h"
#import "ControllerRepairShopList.h"
#import "ControllerRepairShopDetail.h"

@interface ControllerMainRepaire () < ViewRepairRootDelegate, CLLocationManagerDelegate >
{
    ViewRepairRoot*     _rootView;
    
    CLLocationManager*  _location;
    
    NSMutableArray*     _nearbyArray;               // 附近店铺列表
    NSMutableArray*     _star5Array;                // 五星店铺列表
    NSMutableArray*     _repairArray;               // 维修保养店铺列表
    NSMutableArray*     _modifyArray;               // 专业改装店铺列表
}
@end

@implementation ControllerMainRepaire

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData
{
    _nearbyArray = [[NSMutableArray alloc] init];
    _star5Array = [[NSMutableArray alloc] init];
    _repairArray = [[NSMutableArray alloc] init];
    _modifyArray = [[NSMutableArray alloc] init];
    
    _location = [[CLLocationManager alloc] init];
    if ( [CLLocationManager locationServicesEnabled] )
    {
        [_location setDelegate:self];
        [_location setDesiredAccuracy:kCLLocationAccuracyBest];
        [_location setDistanceFilter:DEF_LOC_DISTANCE];
    }
    
    [self reqData];
    [self reqBroadcastList:NO];
}
- (void)initUI
{
    self.view.backgroundColor = DEF_COLOR_BG;
    
    _rootView = [[ViewRepairRoot alloc] initWithFrame:self.view.frame];
    [_rootView setDelegate:self];
    self.view = _rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reqBroadcastList:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    UINavigationController* pNv = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [pNv setNavigationBarHidden:YES animated:YES];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
        [_location startUpdatingLocation];
}

- (BOOL)verifyLocAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
        return YES;
    
    NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
    NSString* tipAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-定位服务\"选项中，允许%@访问位置信息", appName];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:tipAuthorization preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){[self.navigationController popViewControllerAnimated:YES];}];
    [alert addAction:btnAction];
    [self presentViewController: alert animated: YES completion: nil];
        
    return NO;
}

#pragma -mark View4SRootDelegate
- (void)onClickedBannerURL:(NSString* _Nonnull)url
{
    MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)onClickedSOS
{
    if ( [self verifyLocAuthorization] == NO )
        return;
    
    // 点击紧急求救 进入商店列表 请求拉取附近的商店
    ControllerRepairShopList* controller = [[ControllerRepairShopList alloc] initWithMode:ENUM_SHOP_LIST_SOS];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedNearbyShop:(NSInteger)index
{
    // 点击了某个商店 进入该商店详情
    if ( [_nearbyArray count] < index )
        return;
    ModelUserInfo* userInfo = [_nearbyArray objectAtIndex:index];
    NSLog(@"The nearby repair shop ID is : %@" ,userInfo.shopID);
    
    ControllerRepairShopDetail* controller = [[ControllerRepairShopDetail alloc] initWithShopID:userInfo.shopID];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedNearbyShopMore
{
    if ( [self verifyLocAuthorization] == NO )
        return;
    
    // 点击了更多商店 进入商店列表 重新拉取附近的商店
    ControllerRepairShopList* controller = [[ControllerRepairShopList alloc] initWithMode:ENUM_SHOP_LIST_NEARBY];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedNearbyShopRefresh
{
    if ( [self verifyLocAuthorization] == NO )
        return;
    
    // 点击刷新商店 重新拉取商店 但不重新定位
    [self reqShopListNearby];
}
- (void)onClicked5StarShop:(NSInteger)index
{
    if ( [_star5Array count] < index )
        return;
    ModelUserInfo* userInfo = [_star5Array objectAtIndex:index];
    NSLog(@"The star-5 repair shop ID is : %@" ,userInfo.shopID);
    
    ControllerRepairShopDetail* controller = [[ControllerRepairShopDetail alloc] initWithShopID:userInfo.shopID];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedRepair:(NSInteger)index
{
    if ( [self verifyLocAuthorization] == NO )
        return;
    
    if ( [_repairArray count] < index )
        return;
    NSDictionary* dic = [_repairArray objectAtIndex:index];
    NSLog(@"The repair id onclicked is : %@", [dic valueForKey:@"cate_id"]);
    
    ControllerRepairShopList* controller = [[ControllerRepairShopList alloc] initWithMode:ENUM_SHOP_LIST_SERVICE andServiceID:[dic valueForKey:@"cate_id"]];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedModify:(NSInteger)index
{
    if ( [self verifyLocAuthorization] == NO )
        return;
    
    if ( [_modifyArray count] < index )
        return;
    NSDictionary* dic = [_modifyArray objectAtIndex:index];
    NSLog(@"The modify id onclicked is : %@", [dic valueForKey:@"cate_id"]);
    
    ControllerRepairShopList* controller = [[ControllerRepairShopList alloc] initWithMode:ENUM_SHOP_LIST_SERVICE andServiceID:[dic valueForKey:@"cate_id"]];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedGetPos
{
    if ( [self verifyLocAuthorization] == NO )
        return;
    
    [_location startUpdatingLocation];
}
- (void)onClickedRefreshInfo
{
    [self reqBroadcastList:YES];
}
- (void)onClickedCmtInfo:(NSString* _Nonnull)info
{
    [self reqBroadcastCommit:info];
}

#pragma -mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation* loc = [locations firstObject];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    NSLog(@"经度:%f, 纬度:%f, 海拔:%f, 航向:%f, 行走速度:%f", coordinate.longitude, coordinate.latitude, loc.altitude, loc.course, loc.speed);
    [[NSUserDefaults standardUserDefaults] setDouble:coordinate.longitude forKey:DEF_KEY_LONGITUDE];
    [[NSUserDefaults standardUserDefaults] setDouble:coordinate.latitude forKey:DEF_KEY_LATITUDE];
    
    // 请求附近汽修店铺
    [self reqShopListNearby];
    
    // 获得城市名称
    CLGeocoder* geocoder = [[CLGeocoder alloc]init];
    CLLocation* address = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"详细信息:%@", placemark.addressDictionary);
        if ( placemark.addressDictionary != nil )
        {
            NSString* cityName = [placemark.addressDictionary valueForKey:@"City"];
            if ( cityName != nil && [cityName compare:@""] != NSOrderedSame )
            {
                [_rootView updateCityName:cityName];
                [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:DEF_KEY_CITY_NAME];
            }
        }
    }];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusNotDetermined:
        {
            if ([_location respondsToSelector:@selector(requestAlwaysAuthorization)])
                [_location requestWhenInUseAuthorization];
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma -mark network
- (void)reqData
{
    // banner
    [[NetRepair sharedInstance] req4SBanner:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            NSMutableArray* imgArray = [[NSMutableArray alloc] init];
            NSMutableArray* urlArray = [[NSMutableArray alloc] init];
            
            NSArray* bannerArray = success[@"data"];
            NSUInteger iCount = [bannerArray count];
            if ( iCount <= 0 )
                return;
            
            for (int i = 0; i < iCount; i++ )
            {
                NSDictionary* dic = bannerArray[i];
                if ( [dic valueForKey:@"photo"] && [dic valueForKey:@"url"] )
                {
                    [imgArray addObject:[dic valueForKey:@"photo"]];
                    [urlArray addObject:[dic valueForKey:@"url"]];
                }
            }
            
            [_rootView updateBanner:imgArray urlArray:urlArray];
        }
    } fail:^(NSError *error) {
        
    }];
    
    // 5-star shop
    [[NetRepair sharedInstance] req5StarShopList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_star5Array removeAllObjects];
            
            NSArray* shopArray = success[@"data"];
            for ( int i = 0; i < [shopArray count]; i++ )
            {
                NSDictionary* dic = shopArray[i];
                ModelUserInfo* userInfo = [[ModelUserInfo alloc] init];
                userInfo.userID = [dic valueForKey:@"user_id"];
                userInfo.shopID = [dic valueForKey:@"shop_id"];
                userInfo.shopName = [dic valueForKey:@"shop_name"];
                
                [_star5Array addObject:userInfo];
            }
            
            [_rootView update5StarShop:_star5Array];
        }
    } fail:^(NSError *error) { }];
    
    // repair
    [[NetRepair sharedInstance] reqServiceList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            if ( 0 < [success[@"data"] count] )
            {
                [_repairArray removeAllObjects];
                [_repairArray addObjectsFromArray:success[@"data"]];
                for ( int i = 0; i < [_repairArray count]; i++ )
                {
                    NSDictionary* dic = [_repairArray objectAtIndex:i];
                    if ( [[dic valueForKey:@"parent_id"] compare:@"0"] == NSOrderedSame )
                        [_repairArray removeObjectAtIndex:i];
                }
                [_rootView updateRepairService:_repairArray];
            }
        }
    } fail:^(NSError *error) { } cateID:@"1"];
    
    // modify
    [[NetRepair sharedInstance] reqServiceList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            if ( 0 < [success[@"data"] count] )
            {
                [_modifyArray removeAllObjects];
                [_modifyArray addObjectsFromArray:success[@"data"]];
                for ( int i = 0; i < [_modifyArray count]; i++ )
                {
                    NSDictionary* dic = [_modifyArray objectAtIndex:i];
                    if ( [[dic valueForKey:@"parent_id"] compare:@"0"] == NSOrderedSame )
                        [_modifyArray removeObjectAtIndex:i];
                }
                [_rootView updateModifyService:_modifyArray];
            }
        }
    } fail:^(NSError *error) { } cateID:@"2"];
}

- (void)reqShopListNearby
{
    [[NetRepair sharedInstance] reqNearbyShopList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_nearbyArray removeAllObjects];
            
            NSArray* shopArray = success[@"data"];
            for ( int i = 0; i < [shopArray count]; i++ )
            {
                NSDictionary* dic = shopArray[i];
                ModelUserInfo* userInfo = [[ModelUserInfo alloc] init];
                userInfo.userID = [dic valueForKey:@"user_id"];
                userInfo.shopID = [dic valueForKey:@"shop_id"];
                userInfo.shopName = [dic valueForKey:@"shop_name"];
                
                [_nearbyArray addObject:userInfo];
            }
            
            [_rootView updateNearbyShop:_nearbyArray];
        }
    } fail:^(NSError *error) { }];
}

- (void)reqBroadcastList:(BOOL)needNotice
{
    // 频度判断
    NSInteger now = [[NSDate date] timeIntervalSince1970];
    NSInteger infoLastRefreshTime = [[NSUserDefaults standardUserDefaults] integerForKey:DEF_KEY_BCREF_TIME];
    NSInteger interval = now - infoLastRefreshTime;
    if ( interval < DEF_BCAST_REF_INTER )
    {
        if ( needNotice )
        {
            NSInteger needWaitSec = DEF_BCAST_REF_INTER - interval;
            NSString* notice = [NSString stringWithFormat:@"提交频率太高，请在%ld分%ld秒后重试！", needWaitSec/60, needWaitSec%60];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:notice preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:btnAction];
            [self presentViewController: alert animated: YES completion: nil];
        }
        return;
    }
        
    [[NetUser sharedInstance] reqBroadcastList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSince1970] forKey:DEF_KEY_BCREF_TIME];
            
            NSArray* array = success[@"data"];
            NSMutableArray* infoArray = [[NSMutableArray alloc] init];
            if ( array && 0 < [array count] )
            {
                for ( int i = 0; i < [array count]; i++ )
                {
                    NSDictionary* dic = [array objectAtIndex:i];
                    if ( dic && [dic valueForKey:@"info_content"] )
                        [infoArray addObject:[dic valueForKey:@"info_content"]];
                }
                [_rootView updateBroadcastInfo:infoArray];
                
                if ( needNotice )
                    [MyAlertNotice showMessage:@"刷新广播消息成功！" timer:2.0f];
            }
        }
    } fail:^(NSError *error) { } ];
}

- (void)reqBroadcastCommit:(NSString*)info
{
    // 频度判断
    NSInteger now = [[NSDate date] timeIntervalSince1970];
    NSInteger infoLastCmtTime = [[NSUserDefaults standardUserDefaults] integerForKey:DEF_KEY_BCCMT_TIME];
    NSInteger interval = now - infoLastCmtTime;
    if ( interval < DEF_BCAST_CMT_INTER )
    {
        NSInteger needWaitSec = DEF_BCAST_CMT_INTER - interval;
        NSString* notice = [NSString stringWithFormat:@"提交频率太高，请在%ld分%ld秒后重试！", needWaitSec/60, needWaitSec%60];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:notice preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:btnAction];
        [self presentViewController: alert animated: YES completion: nil];
        return;
    }
    
    [[NetUser sharedInstance] reqBroadcastCmt:^(id success) {
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSince1970] forKey:DEF_KEY_BCCMT_TIME];
            [MyAlertNotice showMessage:@"提交成功！" timer:2.0f];
            
            NSArray* array = success[@"data"];
            NSMutableArray* infoArray = [[NSMutableArray alloc] init];
            if ( array && 0 < [array count] )
            {
                for ( int i = 0; i < [array count]; i++ )
                {
                    NSDictionary* dic = [array objectAtIndex:i];
                    if ( dic && [dic valueForKey:@"info_content"] )
                        [infoArray addObject:[dic valueForKey:@"info_content"]];
                }
                [_rootView updateBroadcastInfo:infoArray];
            }
        }
        else
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
    
    } fail:^(NSError *error) { } info:info];
}

@end
