//
//  ControllerRepairShopList.m
//  D3Auto
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerRepairShopList.h"

#import "Config.h"
#import "NetRepair.h"
#import "MyNetLoading.h"
#import "MyAlertNotice.h"
#import "ModelUserInfo.h"
#import "RDVTabBarController.h"
#import "ControllerRepairShopDetail.h"

@interface ControllerRepairShopList () <UITableViewDataSource,UITableViewDelegate>
{
    ENUM_SHOP_LIST_MODE _mode;
    
    NSInteger           _tableViewCellH;
    
    UITableView*        _tableView;
    
    NSMutableArray*     _shopArray;
    
    MyNetLoading*       _netLoading;
}
@end

@implementation ControllerRepairShopList

- (instancetype)initWithMode:(ENUM_SHOP_LIST_MODE)mode
{
    if ( self = [super init] )
    {
        _mode = mode;
        
        [self initData];
        [self initUI];
    }
    return self;
}

- (instancetype)initWithMode:(ENUM_SHOP_LIST_MODE)mode andServiceID:(NSString*)serviceID
{
    if ( self = [super init] )
    {
        _mode = mode;
        
        [self initData];
        [self initUI];
        
        [self reqCarAttrPriceList:serviceID];
    }
    return self;
}

- (void)initData
{
    _tableViewCellH = 100;
    
    _shopArray = [[NSMutableArray alloc] init];
    
    switch (_mode)
    {
        case ENUM_SHOP_LIST_SOS:
            [self reqShopListNearby];
            break;
        case ENUM_SHOP_LIST_NEARBY:
            [self reqShopListNearby];
            break;
        default:
            break;
    }
}

- (void)initUI
{
    CGRect frame = self.view.frame;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}

#pragma mark - super function
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListCell"];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopListCell"];
        [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableViewCellH)];
    }
    else
    {
        for ( UIView* subView in cell.subviews )
            [subView removeFromSuperview];
    }
    
    ModelUserInfo* userInfo = [_shopArray objectAtIndex:indexPath.row];
    [cell setBackgroundColor:DEF_COLOR_BG];
    
    CGRect cFrame = cell.frame;
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, cFrame.size.width, cFrame.size.height-10)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:bgView];
    
    
    CGPoint pos = CGPointMake(10, 10);
    int height = 20;
    
    // 店铺名称
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(pos.x, pos.y, cFrame.size.width/2-pos.x, height)];
    [nameLabel setText:userInfo.shopName];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setFont:[UIFont systemFontOfSize:18]];
    [bgView addSubview:nameLabel];
    
    // 店铺地址
    pos.y = pos.y + height + 10;
    height = 18;
    UILabel* addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(pos.x, pos.y, cFrame.size.width-2*pos.x, height)];
    [addressLabel setText:userInfo.shopAddress];
    [addressLabel setTextColor:[UIColor grayColor]];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    [bgView addSubview:addressLabel];
    
    // 拨打座机
    pos.y = pos.y + height + 5;
    height = 30;
    UILabel* tellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, pos.y, cFrame.size.width/2, height)];
    [tellLabel setText:[NSString stringWithFormat:@"座机：%@",userInfo.shopTel]];
    [tellLabel setTextColor:DEF_COLOR_LGTBLUE];
    [tellLabel.layer setBorderColor:DEF_COLOR_BG.CGColor];
    [tellLabel.layer setBorderWidth:0.5f];
    [tellLabel setTag:(DEF_TAG_BASE_NUM+indexPath.row)];
    [tellLabel setTextAlignment:NSTextAlignmentCenter];
    [tellLabel setFont:[UIFont systemFontOfSize:12]];
    [bgView addSubview:tellLabel];
    tellLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCallTel:)];
    [tellLabel addGestureRecognizer:gesture];
    
    // 拨打手机
    UILabel* mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(cFrame.size.width/2, pos.y, cFrame.size.width/2, height)];
    [mobileLabel setText:[NSString stringWithFormat:@"手机：%@",userInfo.shopMobile]];
    [mobileLabel setTextColor:DEF_COLOR_LGTBLUE];
    [mobileLabel.layer setBorderColor:DEF_COLOR_BG.CGColor];
    [mobileLabel.layer setBorderWidth:0.5f];
    [mobileLabel setTag:(DEF_TAG_BASE_NUM+indexPath.row)];
    [mobileLabel setTextAlignment:NSTextAlignmentCenter];
    [mobileLabel setFont:[UIFont systemFontOfSize:12]];
    [bgView addSubview:mobileLabel];
    mobileLabel.userInteractionEnabled = YES;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCallMobile:)];
    [mobileLabel addGestureRecognizer:gesture];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shopArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableViewCellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ModelUserInfo * userInfo = [_shopArray objectAtIndex:indexPath.row];
    
    NSLog(@"The shopID you clicked is : %@", userInfo.shopID);
    
    ControllerRepairShopDetail* controller = [[ControllerRepairShopDetail alloc] initWithShopID:userInfo.shopID];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - on clicked event
- (void)onClickedCallTel:(UITapGestureRecognizer*)sender
{
    UIView* tellLabel = sender.view;

    // 数据处理
    NSInteger index = tellLabel.tag - DEF_TAG_BASE_NUM;
    if ( index < 0 || [_shopArray count] <= index )
        return;
    
    ModelUserInfo* userInfo = [_shopArray objectAtIndex:index];
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",userInfo.shopTel];
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)onClickedCallMobile:(UITapGestureRecognizer*)sender
{
    UIView* mobileLabel = sender.view;
    
    // 数据处理
    NSInteger index = mobileLabel.tag - DEF_TAG_BASE_NUM;
    if ( index < 0 || [_shopArray count] <= index )
        return;
    
    ModelUserInfo* userInfo = [_shopArray objectAtIndex:index];
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",userInfo.shopMobile];
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark - network
- (void)reqCarAttrPriceList:(NSString*)serviceID
{
    [_netLoading startAnimating];
    
    [[NetRepair sharedInstance] reqServiceShopList:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_shopArray removeAllObjects];
            
            NSArray* shopArray = success[@"data"];
            for ( int i = 0; i < [shopArray count]; i++ )
            {
                NSDictionary* dic = shopArray[i];
                ModelUserInfo* userInfo = [[ModelUserInfo alloc] init];
                userInfo.userID = [dic valueForKey:@"user_id"];
                userInfo.shopID = [dic valueForKey:@"shop_id"];
                userInfo.shopName = [dic valueForKey:@"shop_name"];
                userInfo.shopTel = [dic valueForKey:@"shop_tel"];
                userInfo.shopMobile = [dic valueForKey:@"shop_mobile"];
                userInfo.shopAddress = [dic valueForKey:@"address"];
                
                [_shopArray addObject:userInfo];
            }
            
            [_tableView reloadData];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } serviceID:serviceID];
}

- (void)reqShopListNearby
{
    [_netLoading startAnimating];
    
    [[NetRepair sharedInstance] reqNearbyShopList:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_shopArray removeAllObjects];
            
            NSArray* shopArray = success[@"data"];
            for ( int i = 0; i < [shopArray count]; i++ )
            {
                NSDictionary* dic = shopArray[i];
                ModelUserInfo* userInfo = [[ModelUserInfo alloc] init];
                userInfo.userID = [dic valueForKey:@"user_id"];
                userInfo.shopID = [dic valueForKey:@"shop_id"];
                userInfo.shopName = [dic valueForKey:@"shop_name"];
                userInfo.shopTel = [dic valueForKey:@"shop_tel"];
                userInfo.shopMobile = [dic valueForKey:@"shop_mobile"];
                userInfo.shopAddress = [dic valueForKey:@"address"];
                
                [_shopArray addObject:userInfo];
            }
            
            [_tableView reloadData];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    }];
}

@end
