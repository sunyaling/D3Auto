//
//  Controller4SCarPriceList.m
//  D3Auto
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Controller4SCarPriceList.h"

#import "Utils.h"
#import "Net4S.h"
#import "Config.h"
#import "MyNetLoading.h"
#import "MyAlertNotice.h"
#import "RDVTabBarController.h"
#import "Controller4SCarPriceAdd.h"


@interface Controller4SCarPriceList() <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*             _priceArray;
    UITableView*                _tableView;
    
    int                         _iTVCellH;
    NSString*                   _shopID;
    MyNetLoading*               _netLoading;
}

@end

@implementation Controller4SCarPriceList

- (instancetype)initWithShopID:(NSString*)shopID
{
    self = [super init];
    if (self)
    {
        [self initData];
        [self initUI];
        
        _shopID = shopID;
    }
    return self;
}

-(void)initData
{
    _iTVCellH = 80;
    _priceArray = [[NSMutableArray alloc] init];
}

-(void)initUI
{
    CGRect frame = self.view.frame;
    
    // 地址列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    
    // 底部新建地址按钮
    UILabel* addPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,  40)];
    [addPriceLabel setCenter:CGPointMake(frame.size.width/2, frame.size.height-addPriceLabel.frame.size.height/2)];
    addPriceLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:83.0/255 blue:80.0/255 alpha:1.0];
    addPriceLabel.text = @"+ 增加报价";
    addPriceLabel.textColor = [UIColor whiteColor];
    addPriceLabel.userInteractionEnabled = YES;
    [addPriceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:addPriceLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddPriceClicked:)];
    [addPriceLabel addGestureRecognizer:tap];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"本店价格列表";
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
    
    [self requestPriceList];
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.view.frame;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CarPriceCell"];
    CGRect cellR = CGRectMake(0, 0, tableView.frame.size.width, _iTVCellH);
    if ( cell == nil )
    {
        [cell setFrame:cellR];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarPriceCell"];
        cell.backgroundColor = DEF_COLOR_BG;
    }
    else
    {
        for ( UIView* subView in cell.subviews )
        {
            [subView removeFromSuperview];
        }
    }
    
    [cell setTag:indexPath.row];
    
    NSDictionary * dic = [_priceArray objectAtIndex:indexPath.row];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 3, _tableView.frame.size.width, _iTVCellH-6)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:view];
    
    CGPoint relationP = CGPointMake(20, 0);
    int height = 20;
    
    NSString* carWds = [NSString stringWithFormat:@"车型：%@ %@ %@ ",[dic objectForKey:@"brand_cate_name"],[dic objectForKey:@"car_name"],[dic objectForKey:@"car_attr_name"]];
    UILabel* carWdsLable = [[UILabel alloc] initWithFrame:CGRectMake(relationP.x, relationP.y, cell.frame.size.width-2*relationP.y, height)];
    [carWdsLable setText:carWds];
    [carWdsLable setTextColor:[UIColor grayColor]];
    [carWdsLable setTextAlignment:NSTextAlignmentLeft];
    [carWdsLable setFont:[UIFont systemFontOfSize:(height-5)]];
    [view addSubview:carWdsLable];
    
    relationP.y = relationP.y + height + 5;
    height = 20;
    UILabel* pricePriceLable = [[UILabel alloc] initWithFrame:CGRectMake(relationP.x, relationP.y, cell.frame.size.width-2*relationP.y, height)];
    [pricePriceLable setText:[NSString stringWithFormat:@"价格：%@ 万元",[dic valueForKey:@"car_attr_price"]]];
    [pricePriceLable setNumberOfLines:1];
    [pricePriceLable setTextColor:[UIColor redColor]];
    [pricePriceLable setTextAlignment:NSTextAlignmentLeft];
    [pricePriceLable setFont:[UIFont systemFontOfSize:(height-5)]];
    [view addSubview:pricePriceLable];
    
    relationP.y = relationP.y + height + 5;
    height = 20;
    NSString* promotionWds = [NSString stringWithFormat:@"促销：%@", [dic objectForKey:@"promotion_info"]];
    UILabel* promotionLable = [[UILabel alloc] initWithFrame:CGRectMake(relationP.x, relationP.y, frame.size.width-2*relationP.y, height)];
    [promotionLable setText:promotionWds];
    [promotionLable setNumberOfLines:1];
    [promotionLable setTextColor:[UIColor lightGrayColor]];
    [promotionLable setTextAlignment:NSTextAlignmentLeft];
    [promotionLable setFont:[UIFont systemFontOfSize:(height-5)]];
    [view addSubview:promotionLable];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_priceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _iTVCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( [_priceArray count] <= indexPath.row )
        return;
    
    //NSDictionary * dic = [_priceArray objectAtIndex:indexPath.row];
    //int priceID = [[dic objectForKey:@"id"] intValue];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ( 0 <= indexPath.row && indexPath.row < [_priceArray count] )
        {
            NSDictionary* priceDic = [_priceArray objectAtIndex:indexPath.row];
            [self requestDelPrice:[priceDic objectForKey:@"price_id"]];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


#pragma mark - on clicked
-(void)onPriceEditClicked:(UIButton*)sender
{
    NSInteger index = sender.tag - 1;
    if ( index < 0 || [_priceArray count] <= index )
        return;
    
}

-(void)onAddPriceClicked:(UITapGestureRecognizer*)sender
{
    Controller4SCarPriceAdd* controller = [[Controller4SCarPriceAdd alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - network
-(void)requestPriceList
{
    [_netLoading startAnimating];
    [[Net4S sharedInstance] reqListCarPrice:^(id success) {
        [_netLoading stopAnimating];
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_priceArray removeAllObjects];
            [_priceArray addObjectsFromArray:success[@"data"]];
            
            [_tableView reloadData];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) {
        [_netLoading stopAnimating];
    } shopID:_shopID];
}

-(void)requestDelPrice:(NSString*)priceID
{
    [_netLoading startAnimating];
    [[Net4S sharedInstance] reqDelCarPrice:^(id success) {
        [_netLoading stopAnimating];
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [MyAlertNotice showMessage:@"删除成功" timer:2.0f];
            [self requestPriceList];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) {
        [_netLoading stopAnimating];
        [MyAlertNotice showMessage:@"删除失败" timer:2.0f];
    } priceID:priceID];
}


@end

