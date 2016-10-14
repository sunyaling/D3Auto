//
//  ControllerRepairSelService.m
//  D3Auto
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerRepairSelService.h"

#import "Config.h"
#import "NetRepair.h"
#import "MyNetLoading.h"
#import "MyAlertNotice.h"
#import "ModelRepairService.h"

#import "UIImageView+OnlineImage.h"

@interface ControllerRepairSelService () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger           _tableViewCellH;
    
    UITableView*        _tableView;
    
    NSMutableArray*     _serviceArray;
    
    MyNetLoading*       _netLoading;
}
@end

@implementation ControllerRepairSelService

- (instancetype)init
{
    if ( self = [super init] )
    {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData
{
    _tableViewCellH = 60;
    
    _serviceArray = [[NSMutableArray alloc] init];
    
    [self reqCarAttrServiceList];
}

- (void)initUI
{
    self.title = @"服务项目选择";
    CGRect frame = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(DEF_STATUSBAR_H, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
    
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(onClickedCommit)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
}

#pragma mark - tableview delegate
// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_serviceArray count];
}

// 每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ModelRepairServiceGroup* group = _serviceArray[section];
    return group.array.count;
}

// 每行的单元格
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelRepairServiceGroup* group = _serviceArray[indexPath.section];
    ModelRepairService* service = group.array[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"service_item"];
    if ( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"service_item"];
    
    UIImage* imgLoading = [UIImage imageNamed:@"transparent_90_90"];
    cell.imageView.image = imgLoading;
    
    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgLoading.size.width, imgLoading.size.height)];
    [iv setOnlineImage:service.serviceImg];
    [cell.imageView addSubview:iv];
    
    cell.textLabel.text = service.serviceName;
    
    if ( service.isChecked == NO )
        cell.accessoryType = UITableViewCellAccessoryNone;
    else
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

// 每组标题头名称
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ModelRepairService* group = _serviceArray[section];
    return group.serviceName;
}


// 分组标题内容高du
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

// 每行高du
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableViewCellH;
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
    ModelRepairServiceGroup* group = _serviceArray[indexPath.section];
    ModelRepairService* service = group.array[indexPath.row];
    
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ( service.isChecked == YES )
    {
        service.isChecked = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        service.isChecked = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    //[_delegate onClickedCar:car.carID];
}

#pragma mark - onclicked event
- (void)onClickedCommit
{
    NSMutableArray* serviceArray = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [_serviceArray count]; i++ )
    {
        ModelRepairServiceGroup* group = _serviceArray[i];
        for ( int j = 0; j < [group.array count]; j++ )
        {
            ModelRepairService* service = group.array[j];
            if ( service.isChecked == false)
                continue;
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            [dic setValue:service.serviceID forKey:@"service_id"];
            
            [serviceArray addObject:dic];
        }
    }
    
    if ( [serviceArray count] <= 0 )
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择您店里提供的服务" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:btnAction];
        [self presentViewController: alert animated: YES completion: nil];
        return;
    }
    
    [_netLoading startAnimating];
    
    [[NetRepair sharedInstance] reqServiceAdd:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [MyAlertNotice showMessage:@"操作成功" timer:2.0f];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } serviceArray:serviceArray];
}

#pragma mark - network
- (void)reqCarAttrServiceList
{
    [_netLoading startAnimating];
    
    [[NetRepair sharedInstance] reqServiceList:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            NSArray* sArray = success[@"data"];
            [_serviceArray removeAllObjects];
            
            NSMutableArray* serviceArray = [[NSMutableArray alloc] init];
            for ( int i = 0; i < [sArray count]; i++ )
            {
                [serviceArray removeAllObjects];
                
                NSDictionary* dic = sArray[i];
                if ( [[dic valueForKey:@"parent_id"] intValue] != 0 )
                    continue;
                
                NSInteger groupID = [[dic objectForKey:@"cate_id"] intValue];
                for ( int j = 0; j < [sArray count]; j++ )
                {
                    NSDictionary* dic2 = sArray[j];
                    if ( [[dic2 valueForKey:@"parent_id"] intValue] != groupID )
                        continue;
                    
                    ModelRepairService* service = [[ModelRepairService alloc] initWithServiceID:[dic2 valueForKey:@"cate_id"] andServiceName:[dic2 valueForKey:@"cate_name"] serviceImg:[dic2 valueForKey:@"cate_img"]];
                    [serviceArray addObject:service];
                }
                ModelRepairServiceGroup* serviceGroup = [[ModelRepairServiceGroup alloc] initWithServiceID:[dic objectForKey:@"cate_id"] andServiceName:[dic valueForKey:@"cate_name"] serviceImg:[dic valueForKey:@"cate_img"] andArray:serviceArray];
                [_serviceArray addObject:serviceGroup];
            }
            
            [_tableView reloadData];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } cateID:@"0"];
}


@end
