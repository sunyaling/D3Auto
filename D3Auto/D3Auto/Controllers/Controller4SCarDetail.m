//
//  Controller4SCarDetail.m
//  D3Auto
//
//  Created by zhongfang on 15/11/3.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Controller4SCarDetail.h"

#import "Net4S.h"
#import "MyAlertNotice.h"
#import "RDVTabBarController.h"
#import "View4SCarDetailRoot.h"
#import "Model4SCarDetail.h"
#import "MyWebViewController.h"
#import "MyImgBrowserController.h"
#import "Controller4SListWithAttr.h"

@interface Controller4SCarDetail () <View4SCarDetailRootDelegate>
{
    NSString*                   _carID;
    
    View4SCarDetailRoot*        _carDetailRootView;
    
    Model4SCarDetail*           _model4SCarDetail;
}
@end

@implementation Controller4SCarDetail

- (instancetype)initWithCarID:(NSString*)carID
{
    if ( self = [super init])
    {
        [self initDataWithCarID:carID];
        [self initUI];
        
        [self reqDataWithCarID:carID];
    }
    return self;
}


#pragma - mark base function
- (void)initDataWithCarID:(NSString*)carID
{
    _carID = carID;
    
    _model4SCarDetail = [[Model4SCarDetail alloc] init];
}

- (void)initUI
{
    _carDetailRootView = [[View4SCarDetailRoot alloc] initWithFrame:self.view.frame];
    [_carDetailRootView  setDelegate:self];
    self.view = _carDetailRootView;
}

- (void)didReceiveMemoryWarning {
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

#pragma - mark delegate
- (void)onClickedShowGallery
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [_model4SCarDetail.galleryArray count]; i++ )
    {
        Model4SCarGallery* _modeG = [_model4SCarDetail.galleryArray objectAtIndex:i];
        [array addObject:_modeG.imgNormal];
    }
    MyImgBrowserController* controller = [[MyImgBrowserController alloc] initWithImageArray:array];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedDetaiInfo
{
    MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController loadHTMLString:_model4SCarDetail.carDesc];
}
- (void)onClickedDealerInfo
{
    Controller4SListWithAttr* controller = [[Controller4SListWithAttr alloc] initWithCarID:_carID attrID:@""];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)onClickedPriceList:(NSString*)attrID
{
    Controller4SListWithAttr* controller = [[Controller4SListWithAttr alloc] initWithCarID:_carID attrID:attrID];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma - mark net notify
- (void)updateCarDetail:(NSDictionary*)carDic
{
    // 相册数据处理
    NSArray* netGalleryArray = [carDic objectForKey:@"gallery"];
    NSMutableArray* galleryArray = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [netGalleryArray count]; i++ )
    {
        NSDictionary* dic = [netGalleryArray objectAtIndex:i];
        Model4SCarGallery* galleryModel = [[Model4SCarGallery alloc] initWithImgID:[dic valueForKey:@"img_id"] andCarID:[dic valueForKey:@"car_id"] andImgDesc:[dic valueForKey:@"img_desc"] andImgNormal:[dic valueForKey:@"img_normal"] andImgThumb:[dic valueForKey:@"img_thumb"]];
        [galleryArray addObject:galleryModel];
    }
    [_model4SCarDetail setGalleryArray:galleryArray];
    
    // 配置数据处理
    NSArray* netAttrArray = [carDic objectForKey:@"attribute"];
    NSMutableArray* attrArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [netAttrArray count]; i++)
    {
        NSDictionary* dic = [netAttrArray objectAtIndex:i];
        if ( [[dic valueForKey:@"parent_id"] intValue] != 0 )
            continue;
        
        Model4SCarAttr* attrModel = [[Model4SCarAttr alloc] initWithAttrID:[dic valueForKey:@"attr_id"] andCarID:[dic valueForKey:@"car_id"] andParentID:[dic valueForKey:@"parent_id"] andAttrName:[dic valueForKey:@"attr_name"] andGuidePrice:[dic valueForKey:@"guide_price"] andAttrDesc:[dic valueForKey:@"attr_desc"] andIsShow:[dic valueForKey:@"is_show"]];
        [attrArray addObject:attrModel];
    }
    
    for (int i = 0; i < [attrArray count]; i++)
    {
        Model4SCarAttr* attrModel = attrArray[i];
        NSString* attrID = attrModel.attrID;
        for (int j = 0; j < [netAttrArray count]; j++)
        {
            NSDictionary* dic = [netAttrArray objectAtIndex:j];
            if ( [attrID compare:[dic objectForKey:@"parent_id"]] == NSOrderedSame )
            {
                Model4SCarAttr* model = [[Model4SCarAttr alloc] initWithAttrID:[dic valueForKey:@"attr_id"] andCarID:[dic valueForKey:@"car_id"] andParentID:[dic valueForKey:@"parent_id"] andAttrName:[dic valueForKey:@"attr_name"] andGuidePrice:[dic valueForKey:@"guide_price"] andAttrDesc:[dic valueForKey:@"attr_desc"] andIsShow:[dic valueForKey:@"is_show"]];
                [attrModel addChildren:model];
            }
        }
        
    }
    
    [_model4SCarDetail setAttrArray:attrArray];
    
    [_model4SCarDetail setCarID:[carDic valueForKey:@"car_id"]];
    [_model4SCarDetail setCateID:[carDic valueForKey:@"cate_id"]];
    [_model4SCarDetail setCarName:[carDic valueForKey:@"car_name"]];
    [_model4SCarDetail setGuidePriceLowest:[carDic valueForKey:@"guide_price_lowest"]];
    [_model4SCarDetail setGuidePriceHighest:[carDic valueForKey:@"guide_price_highest"]];
    [_model4SCarDetail setCarImg:[carDic valueForKey:@"car_img"]];
    [_model4SCarDetail setIsOnSale:[carDic valueForKey:@"is_on_sale"]];
    [_model4SCarDetail setSaleStartTime:[carDic valueForKey:@"sale_start_time"]];
    [_model4SCarDetail setCarDesc:[carDic valueForKey:@"car_desc"]];
    [_model4SCarDetail setIsShow:[carDic valueForKey:@"is_show"]];
    [_model4SCarDetail setShowInNav:[carDic valueForKey:@"show_in_nav"]];

    [_carDetailRootView setModel4SCarDetail:_model4SCarDetail];
    [_carDetailRootView updateCarDetail];
}

#pragma - mark network
- (void)reqDataWithCarID:(NSString*)carID
{
    [[Net4S sharedInstance] req4SCarDetail:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [self updateCarDetail:success[@"data"]];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) { } andCateID:carID];
}

@end
