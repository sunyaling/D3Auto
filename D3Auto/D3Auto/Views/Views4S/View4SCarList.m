//
//  View4SCarList.m
//  D3Auto
//
//  Created by zhongfang on 15/11/2.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "View4SCarList.h"

#import "Model4SCarList.h"
#import "UIImageView+OnlineImage.h"


@interface View4SCarList() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView*            _tableView;
    
    NSMutableArray*         _dataArray;
}
@end


@implementation View4SCarList

@synthesize delegate = _delegate;

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
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)initUIWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
}

#pragma -mark UITableViewDelegate
// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

// 每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Model4SCarGroup* group = _dataArray[section];
    return group.carArray.count;
}

// 每行的单元格
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Model4SCarGroup* group = _dataArray[indexPath.section];
    Model4SCar* car = group.carArray[indexPath.row];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    UIImage* imgLoading = [UIImage imageNamed:@"transparent_90_90"];
    cell.imageView.image = imgLoading;
    
    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgLoading.size.width, imgLoading.size.height)];
    [iv setOnlineImage:car.image];
    [cell.imageView addSubview:iv];
    
    cell.textLabel.text = car.name;
    CGRect r = cell.textLabel.frame;
    cell.textLabel.frame = CGRectMake(r.origin.x, r.origin.y-5, r.size.width, r.size.height);
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ 万",car.guidePriceLowest,car.guidePriceHighest];
    cell.detailTextLabel.textColor = [UIColor redColor];
    r = cell.detailTextLabel.frame;
    cell.detailTextLabel.frame = CGRectMake(r.origin.x, r.origin.y+5, r.size.width, 40);
    cell.detailTextLabel.center = CGPointMake(0, 0);
    
    return cell;
}

// 每组标题头名称
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Model4SCarGroup* group = _dataArray[section];
    return group.name;
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
    return 80;
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
    
    // 刷新数据
    Model4SCarGroup* group = _dataArray[indexPath.section];
    Model4SCar* car = group.carArray[indexPath.row];
   
    [_delegate onClickedCar:car.carID];
}

#pragma - mark update info from viewcontroller
- (void)onUpdateCarList:(NSArray*)carListArray
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:carListArray];
    
    [_tableView reloadData];
}

@end
