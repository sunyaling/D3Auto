//
//  ControllerRepairShopDetail.m
//  D3Auto
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerRepairShopDetail.h"

#import "NetRepair.h"
#import "MyAlertNotice.h"
#import "RDVTabBarController.h"
#import "ViewRepairShopDetailRoot.h"
#import "ModelRepairShopDetail.h"
#import "MyWebViewController.h"

@interface ControllerRepairShopDetail () <ViewRepairShopDetailRootDelegate>
{
    NSString*                       _shopID;
    
    ViewRepairShopDetailRoot*       _shopRootView;
    
    ModelRepairShopDetail*          _modelShopDetail;
}
@end

@implementation ControllerRepairShopDetail

- (instancetype)initWithShopID:(NSString*)shopID
{
    if ( self = [super init])
    {
        [self initDataWithShopID:shopID];
        [self initUI];
        
        [self reqDataWithShopID:shopID];
    }
    return self;
}


#pragma - mark base function
- (void)initDataWithShopID:(NSString*)shopID
{
    _shopID = shopID;
    
    _modelShopDetail = [[ModelRepairShopDetail alloc] init];
}

- (void)initUI
{
    _shopRootView = [[ViewRepairShopDetailRoot alloc] initWithFrame:self.view.frame];
    [_shopRootView setDelegate:self];
    self.view = _shopRootView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma - mark root view delegate



#pragma - mark net notify
- (void)updateShopDetail:(NSDictionary*)carDic
{
    // 相册数据处理
    NSArray* netGalleryArray = [carDic objectForKey:@"gallery"];
    NSMutableArray* galleryArray = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [netGalleryArray count]; i++ )
    {
        NSDictionary* dic = [netGalleryArray objectAtIndex:i];
        ModelRepairShopGallery* galleryModel = [[ModelRepairShopGallery alloc] initWithImgID:[dic valueForKey:@"img_id"] andShopID:[dic valueForKey:@"shop_id"] andImgDesc:[dic valueForKey:@"img_desc"] andImgNormal:[dic valueForKey:@"img_normal"] andImgThumb:[dic valueForKey:@"img_thumb"]];
        [galleryArray addObject:galleryModel];
    }
    [_modelShopDetail setGalleryArray:galleryArray];
    
    [_modelShopDetail setShopID:[carDic valueForKey:@"shop_id"]];
    [_modelShopDetail setUserID:[carDic valueForKey:@"user_id"]];
    [_modelShopDetail setShopName:[carDic valueForKey:@"shop_name"]];
    [_modelShopDetail setShopEmail:[carDic valueForKey:@"shop_email"]];
    [_modelShopDetail setShopTel:[carDic valueForKey:@"shop_tel"]];
    [_modelShopDetail setShopMobile:[carDic valueForKey:@"shop_mobile"]];
    [_modelShopDetail setShopAddress:[carDic valueForKey:@"address"]];
    [_modelShopDetail setLongitude:[[carDic valueForKey:@"longitude"] doubleValue]];
    [_modelShopDetail setLatitude:[[carDic valueForKey:@"latitude"] doubleValue]];
    [_modelShopDetail setStarLevel:[[carDic valueForKey:@"star_level"] intValue]];
    
    [_shopRootView setModelShopDetail:_modelShopDetail];
    [_shopRootView updateShopDetail];
}

#pragma - mark network
- (void)reqDataWithShopID:(NSString*)shopID
{
    [[NetRepair sharedInstance] reqRepairShopDetail:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [self updateShopDetail:success[@"data"]];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) { } andShopID:shopID];
}

@end

