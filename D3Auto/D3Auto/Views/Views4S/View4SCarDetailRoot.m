//
//  View4SCarDetailRoot.m
//  D3Auto
//
//  Created by zhongfang on 15/11/3.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "View4SCarDetailRoot.h"

#import "Config.h"
#import "UIImageView+OnlineImage.h"

@interface View4SCarDetailRoot() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView*            _tableView;
    
    UIImageView*            _coverView;         // 车辆图片
    
    UILabel*                _nameLabel;         // 名字
    
    UILabel*                _priceName;         // 指导价名字
    
    UILabel*                _priceValue;        // 指导价的值
}
@end

@implementation View4SCarDetailRoot

@synthesize delegate = _delegate;

@synthesize model4SCarDetail = _model4SCarDetail;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self initData];
        [self initUIWithFrame:frame];
    }
    return self;
}

- (void)initData
{
}

- (void)initUIWithFrame:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    
    [self setTBHeader:frame];
}

- (void)setTBHeader:(CGRect)frame
{
    UIView* headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    CGPoint relaPos = CGPointMake(0, 0);
    float height = 300;
    
    // 相册封面
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y, frame.size.width, height)];
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *registerReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedShowGallery)];
    [_coverView addGestureRecognizer:registerReco];
    [headerView addSubview:_coverView];

    // 名字
    relaPos.x = 20;
    relaPos.y = relaPos.y + height + 10;
    height = 20;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y, frame.size.width-2*relaPos.x, height)];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setTextColor:[UIColor blackColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:18]];
    [headerView addSubview:_nameLabel];
    
    // 厂商指导价
    relaPos.y = relaPos.y + height + 6;
    height = 15;
    _priceName = [[UILabel alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y, 85, height)];
    [_priceName setText:@"厂商指导价："];
    [_priceName setTextAlignment:NSTextAlignmentLeft];
    [_priceName setTextColor:[UIColor lightGrayColor]];
    [_priceName setFont:[UIFont systemFontOfSize:13]];
    [headerView addSubview:_priceName];
    
    // 价格区间
    height = 18;
    _priceValue = [[UILabel alloc] initWithFrame:CGRectMake(relaPos.x+_priceName.frame.size.width, relaPos.y, 160, height)];
    [_priceValue setCenter:CGPointMake(_priceValue.center.x, _priceName.center.y)];
    [_priceValue setTextAlignment:NSTextAlignmentLeft];
    [_priceValue setTextColor:[UIColor redColor]];
    [_priceValue setFont:[UIFont systemFontOfSize:17]];
    [headerView addSubview:_priceValue];
    
    // 分割线
    relaPos.x -= 10;
    relaPos.y = relaPos.y + height + 10;
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y-1, frame.size.width-2*relaPos.x, 0.5f)];
    [lineView setBackgroundColor:DEF_COLOR_LINE];
    [headerView addSubview:lineView];
    
    // 车辆描述
    relaPos.x += 10;
    relaPos.y = relaPos.y + 10;
    height = 40;
    UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y, frame.size.width-2*relaPos.x, height)];
    [descLabel.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [descLabel.layer setCornerRadius:5];
    [descLabel.layer setBorderWidth:1];
    [descLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [descLabel setText:@"车辆描述"];
    [descLabel setNumberOfLines:1];
    [descLabel setTextColor:[UIColor grayColor]];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [descLabel setFont:[UIFont systemFontOfSize:14]];
    [headerView addSubview:descLabel];
    
    descLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCarDesc)];
    [descLabel addGestureRecognizer:tapGesture];
    
    // 经销商信息
    relaPos.y = relaPos.y + height + 10;
    height = 40;
    UILabel* dealerLabel = [[UILabel alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y, frame.size.width-2*relaPos.x, height)];
    [dealerLabel.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [dealerLabel.layer setCornerRadius:5];
    [dealerLabel.layer setBorderWidth:1];
    [dealerLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [dealerLabel setText:@"经销商信息"];
    [dealerLabel setNumberOfLines:1];
    [dealerLabel setTextColor:[UIColor grayColor]];
    [dealerLabel setTextAlignment:NSTextAlignmentCenter];
    [dealerLabel setFont:[UIFont systemFontOfSize:14]];
    [headerView addSubview:dealerLabel];
    
    dealerLabel.userInteractionEnabled = YES;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedDealer)];
    [dealerLabel addGestureRecognizer:tapGesture];
    
    [headerView setFrame:CGRectMake(0, 0, frame.size.width, relaPos.y+height+20)];
    _tableView.tableHeaderView = headerView;
}

- (void)updateCarDetail
{
    if ( _model4SCarDetail == nil )
        return;
    
    if ( 0 < [_model4SCarDetail.galleryArray count] )
    {
        Model4SCarGallery* gallery = [_model4SCarDetail.galleryArray objectAtIndex:0];
        [_coverView setOnlineImage:gallery.imgNormal];
    }
    
    [_nameLabel setText:_model4SCarDetail.carName];
    
    [_priceValue setText:[NSString stringWithFormat:@"%@ - %@ 万", _model4SCarDetail.guidePriceLowest, _model4SCarDetail.guidePriceHighest]];
    
    [_tableView reloadData];
}

#pragma -mark UITableViewDelegate
// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_model4SCarDetail.attrArray count];
}

// 每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Model4SCarAttr* group = _model4SCarDetail.attrArray[section];
    return group.children.count;
}

// 每行的单元格
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Model4SCarAttr* group = _model4SCarDetail.attrArray[indexPath.section];
    Model4SCarAttr* attr = group.children[indexPath.row];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = attr.attrName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"指导价：%@万", attr.guidePrice];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

// 每组标题头名称
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Model4SCarAttr* group = _model4SCarDetail.attrArray[section];
    return group.attrName;
}

// 分组标题内容高du
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 30;
    return 10;
}

// 每行高du
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

// 尾部说明内容高du
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
} 

// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Model4SCarAttr* group = _model4SCarDetail.attrArray[indexPath.section];
    Model4SCarAttr* attr = group.children[indexPath.row];
    
    NSLog(@"Attribute id is: %@", attr.attrID);
    
    [_delegate onClickedPriceList:attr.attrID];
}

#pragma - mark on clicked event
- (void)onClickedShowGallery
{
    [_delegate onClickedShowGallery];
}
- (void)onClickedCarDesc
{
    [_delegate onClickedDetaiInfo];
}
- (void)onClickedDealer
{
    [_delegate onClickedDealerInfo];
}

@end
