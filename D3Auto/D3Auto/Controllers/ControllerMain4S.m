//
//  Controller_main_4s.m
//  D3Auto
//
//  Created by zhongfang on 15/10/27.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "ControllerMain4S.h"

#import "View4SRoot.h"
#import "Net4S.h"
#import "Config.h"
#import "Controller4SCarDetail.h"
#import "MyWebViewController.h"
#import "RDVTabBarController.h"

@interface ControllerMain4S () < View4SRootDelegate, CLLocationManagerDelegate >
{
    View4SRoot*         _rootView;
    
    CLLocationManager*  _location;
}

@end

@implementation ControllerMain4S

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
    _location = [[CLLocationManager alloc] init];
    if ( [CLLocationManager locationServicesEnabled] )
    {
        [_location setDelegate:self];
        [_location setDesiredAccuracy:kCLLocationAccuracyBest];
        [_location setDistanceFilter:DEF_LOC_DISTANCE];
    }
    
    [self reqData];
}
- (void)initUI
{
    _rootView = [[View4SRoot alloc] initWithFrame:self.view.frame];
    [_rootView setDelegate:self];
    self.view = _rootView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    //[self startTrackingLocation];
}

- (void)startTrackingLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined)
        [_location requestWhenInUseAuthorization];
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
        [_location startUpdatingLocation];
}

#pragma -mark View4SRootDelegate
- (void)onClickedBannerURL:(NSString* _Nonnull)url
{
    MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)onClickedCate:(NSString*)cateID
{
    [self reqCarListWithoutBrand:cateID];
}
- (void)onClickedCar:(NSString *)carID
{
    Controller4SCarDetail* viewController = [[Controller4SCarDetail alloc] initWithCarID:carID];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma -mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation* loc = [locations firstObject];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    NSLog(@"经度:%f, 纬度:%f, 海拔:%f, 航向:%f, 行走速度:%f", coordinate.longitude, coordinate.latitude, loc.altitude, loc.course, loc.speed);
    
    CLGeocoder* geocoder = [[CLGeocoder alloc]init];
    CLLocation* address = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        [_rootView updateCityName:[placemark.addressDictionary valueForKey:@"City"]];
    }];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{    switch (status)
    {
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


#pragma -mark Net Notify
- (void)updateRecommond:(NSArray*)bArray andCArray:(NSArray*)cArray
{
    NSMutableArray* brandArray = [[NSMutableArray alloc] initWithArray:bArray];
    NSMutableArray* carArray = [[NSMutableArray alloc] initWithArray:cArray];
    
    [_rootView updateRecommond:brandArray andCarArray:carArray];
}

- (void)updateBrand:(NSArray*)bArray
{
    NSMutableArray* groupArray = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [bArray count]; i++ )
    {
        NSDictionary* dic = bArray[i];
        if ( [[dic valueForKey:@"parent_id"] intValue] != 0 )
            continue;
            
        NSInteger groupID = [[dic objectForKey:@"cate_id"] intValue];
        NSMutableArray* brandArray = [[NSMutableArray alloc] init];
        for ( int j = 0; j < [bArray count]; j++ )
        {
            NSDictionary* dic2 = bArray[j];
            if ( [[dic2 valueForKey:@"parent_id"] intValue] != groupID )
                continue;
            NSInteger cateID = [[dic2 valueForKey:@"cate_id"] intValue];
            Model4SBrand* brand = [[Model4SBrand alloc] initWithBrandID:cateID andParentID:groupID andName:[dic2 valueForKey:@"cate_name"] andImage:[dic2 valueForKey:@"cate_img"]];
            [brandArray addObject:brand];
        }
        Model4SBrandGroup* group = [[Model4SBrandGroup alloc] initWithGroupID:groupID andName:[dic objectForKey:@"cate_name"] andBrandArray:brandArray];
        [groupArray addObject:group];
    }
    [_rootView updateBrandList:groupArray];
}

- (void)updateCarList:(NSArray*)cArray
{
    NSMutableArray* groupArray = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [cArray count]; i++ )
    {
        NSDictionary* dic = cArray[i];
        NSArray* netCarArray = [dic objectForKey:@"children"];
        if ([netCarArray count] <= 0)
            continue;
        
        NSMutableArray* carArray = [[NSMutableArray alloc] init];
        for ( int j = 0; j < [netCarArray count]; j++ )
        {
            NSDictionary* carDic = [netCarArray objectAtIndex:j];
            Model4SCar* car = [[Model4SCar alloc] initWithCarID:[carDic valueForKey:@"car_id"] andCateID:[carDic valueForKey:@"cate_id"] andName:[carDic valueForKey:@"car_name"] andImage:[carDic valueForKey:@"car_img"] andLowPrice:[carDic valueForKey:@"guide_price_lowest"] andHighPrice:[carDic valueForKey:@"guide_price_highest"]];
            [carArray addObject:car];
        }
        
        Model4SCarGroup* group = [[Model4SCarGroup alloc] initWithCateID:[dic valueForKey:@"cate_id"] andName:[dic valueForKey:@"cate_name"] andCarArray:carArray];
        [groupArray addObject:group];
    }
    [_rootView updateCarList:groupArray];
}

#pragma -mark NetWork
- (void)reqData
{
    // banner
    [[Net4S sharedInstance] req4SBanner:^(id success) {
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
    
    // recommond
    [[Net4S sharedInstance] req4SRcmdList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [self updateRecommond:success[@"data"][@"rcmd_brand_list"] andCArray:success[@"data"][@"rcmd_car_list"]];
        }
    } fail:^(NSError *error) { } andBrandCount:5 andCarCount:3];
    
    // brand list
    [[Net4S sharedInstance] req4SBrandList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [self updateBrand:success[@"data"]];
        }
    } fail:^(NSError *error) { } andRetLevel:2];
}
    
- (void)reqCarListWithoutBrand:(NSString*)cateID
{
    [[Net4S sharedInstance] reqCarListWithBrand:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [self updateCarList:success[@"data"]];
        }
    } fail:^(NSError *error) { } andCateID:cateID];
}



@end
