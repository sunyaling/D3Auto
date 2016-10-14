//
//  Controller4SListWithAttr.m
//  D3Auto
//
//  Created by zhongfang on 15/11/13.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Controller4SListWithAttr.h"

#import "Net4S.h"
#import "MyNetLoading.h"
#import "MyAlertNotice.h"

@interface Controller4SListWithAttr () <UITableViewDataSource,UITableViewDelegate>
{
    NSString*           _carID;
    NSString*           _attrID;
    NSInteger           _tableViewCellH;
    
    UITableView*        _tableView;
    
    NSMutableArray*     _priceArray;
    
    MyNetLoading*       _netLoading;
}
@end

@implementation Controller4SListWithAttr

- (instancetype)initWithCarID:(NSString*)carID attrID:(NSString*)attrID
{
    if ( self = [super init] )
    {
        _carID = carID;
        _attrID = attrID;
        
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData
{
    _tableViewCellH = 130;
    
    _priceArray = [[NSMutableArray alloc] init];
    
    [self reqCarAttrPriceList];
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

#pragma mark - tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PriceListCell"];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PriceListCell"];
        [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableViewCellH)];
    }
    else
    {
        for ( UIView* subView in cell.subviews )
            [subView removeFromSuperview];
    }
    
    NSDictionary * dic = [_priceArray objectAtIndex:indexPath.row];
    [cell setBackgroundColor:DEF_COLOR_BG];
    
    CGRect cFrame = cell.frame;
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, cFrame.size.width, cFrame.size.height-10)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:bgView];
    
    
    CGPoint pos = CGPointMake(10, 10);
    int height = 20;
    
    // 店铺名称
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(pos.x, pos.y, cFrame.size.width/2-pos.x, height)];
    if ( [dic valueForKey:@"shop_name"] != NULL )
        [nameLabel setText:[dic valueForKey:@"shop_name"]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setFont:[UIFont systemFontOfSize:18]];
    [bgView addSubview:nameLabel];
    
    // 价格
    UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cFrame.size.width/2, pos.y, cFrame.size.width/2-pos.x, height)];
    if ( [dic valueForKey:@"car_attr_price"] != NULL )
        [priceLabel setText:[NSString stringWithFormat:@"%@万元",[dic valueForKey:@"car_attr_price"]]];
    [priceLabel setTextColor:DEF_COLOR_LGTRED];
    [priceLabel setTextAlignment:NSTextAlignmentRight];
    [priceLabel setFont:[UIFont systemFontOfSize:16]];
    [bgView addSubview:priceLabel];
    
    // 店铺地址
    pos.y = pos.y + height + 10;
    height = 18;
    UILabel* addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(pos.x, pos.y, cFrame.size.width-2*pos.x, height)];
    if ( [dic valueForKey:@"address"] != NULL )
        [addressLabel setText:[dic valueForKey:@"address"]];
    [addressLabel setTextColor:[UIColor grayColor]];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    [bgView addSubview:addressLabel];
    
    // 促销信息
    pos.y = pos.y + height + 10;
    height = 18;
    UILabel* promotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(pos.x, pos.y, cFrame.size.width-2*pos.x, height)];
    if ( [dic valueForKey:@"car_attr_price"] != NULL )
        [promotionLabel setText:[dic valueForKey:@"promotion_info"]];
    [promotionLabel setTextColor:[UIColor grayColor]];
    [promotionLabel setTextAlignment:NSTextAlignmentLeft];
    [promotionLabel setFont:[UIFont systemFontOfSize:14]];
    [bgView addSubview:promotionLabel];
    
    // 拨打座机
    pos.y = pos.y + height + 5;
    height = 30;
    UILabel* tellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, pos.y, cFrame.size.width/2, height)];
    if ( [dic valueForKey:@"shop_tel"] != NULL )
        [tellLabel setText:[NSString stringWithFormat:@"座机：%@",[dic valueForKey:@"shop_tel"]]];
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
    if ( [dic valueForKey:@"shop_mobile"] != NULL )
        [mobileLabel setText:[NSString stringWithFormat:@"手机：%@",[dic valueForKey:@"shop_mobile"]]];
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
    return [_priceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableViewCellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic = [_priceArray objectAtIndex:indexPath.row];
    

}

#pragma mark - on clicked event
- (void)onClickedCallTel:(UITapGestureRecognizer*)sender
{
    UIView* tellLabel = sender.view;
    
    // 数据处理
    NSInteger index = tellLabel.tag - DEF_TAG_BASE_NUM;
    if ( index < 0 || [_priceArray count] <= index )
        return;
    
    NSDictionary * dic = [_priceArray objectAtIndex:index];
    
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",[dic valueForKey:@"shop_tel"]];
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)onClickedCallMobile:(UITapGestureRecognizer*)sender
{
    UIView* mobileLabel = sender.view;
    
    // 数据处理
    NSInteger index = mobileLabel.tag - DEF_TAG_BASE_NUM;
    if ( index < 0 || [_priceArray count] <= index )
        return;
    
    NSDictionary * dic = [_priceArray objectAtIndex:index];
    
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",[dic valueForKey:@"shop_mobile"]];
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark - network
- (void)reqCarAttrPriceList
{
    [_netLoading startAnimating];
    
    [[Net4S sharedInstance] reqAttrShopList:^(id success) {
        
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
        
    } carID:_carID attrID:_attrID];
}


@end
