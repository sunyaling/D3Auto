//
//  MineViewController_iph.m
//  YunYiGou
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 yunfeng. All rights reserved.
//

#import "ControllerUserInfo.h"

#import "Config.h"
#import "NetUser.h"
#import "MyNetLoading.h"
#import "MyAlertNotice.h"
#import "ModelUserInfo.h"
#import "RDVTabBarController.h"
#import "ControllerFill4SInfo.h"
#import "ControllerUserInfoEdit.h"
#import "ControllerFillRepairInfo.h"
#import "Controller4SCarPriceList.h"
#import "ControllerRepairSelService.h"
#import "ControllerUploadPhoto.h"


@interface ControllerUserInfo () <UITableViewDataSource,UITableViewDelegate>
{
    int                     _iTVCellH;
    
    ModelUserInfo*          _userInfoModel;
    UITableView*            _userInfoTableView;
    MyNetLoading*           _netLoading;
    
    NSMutableArray*         _userInfoArray;
}
@end

@implementation ControllerUserInfo

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

-(void)initData
{
    _iTVCellH = 40;
    _userInfoArray = [[NSMutableArray alloc] init];
    
    [self setDatas];
}

- (void)setDatas
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_KEY_USER_INFO];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ( _userInfoModel == nil )
        return;
    
    if ( _userInfoArray != nil )
        [_userInfoArray removeAllObjects];
    
    for ( int i = 0; i < 3; i++ )
    {
        NSMutableArray* sectionArray = [[NSMutableArray alloc] init];
        if ( i == 0 )
        {
            // group 1
            NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
            [contentDic setValue:@"用户名" forKey:@"title"];
            [contentDic setValue:_userInfoModel.account forKey:@"detail"];
            [contentDic setObject:@"onClickedCouldNotBeEdit" forKey:@"clicked_func"];
            [sectionArray addObject:contentDic];
            
            contentDic = [[NSMutableDictionary alloc] init];
            [contentDic setValue:@"性别" forKey:@"title"];
            NSString* sexDet = [_userInfoModel.sex compare:@"0"] == NSOrderedSame ? @"女" : @"男";
            [contentDic setValue:sexDet forKey:@"detail"];
            [contentDic setObject:@"onClickedEditSex" forKey:@"clicked_func"];
            [sectionArray addObject:contentDic];
            
            contentDic = [[NSMutableDictionary alloc] init];
            [contentDic setValue:@"生日" forKey:@"title"];
            [contentDic setValue:_userInfoModel.birthday forKey:@"detail"];
            [contentDic setObject:@"onClickedEditBirthday" forKey:@"clicked_func"];
            [sectionArray addObject:contentDic];
            
            contentDic = [[NSMutableDictionary alloc] init];
            [contentDic setValue:@"用户类别" forKey:@"title"];
            NSString* accountType = @"普通用户";
            if ( [_userInfoModel.shopType intValue] == ENUM_ACCOUNT_TYPE_4S )
                accountType = @"4S店用户";
            else if ( [_userInfoModel.shopType intValue] == ENUM_ACCOUNT_TYPE_REPAIR )
                accountType = @"汽修店用户";
            [contentDic setValue:accountType forKey:@"detail"];
            [contentDic setObject:@"onClickedCouldNotBeEdit" forKey:@"clicked_func"];
            [sectionArray addObject:contentDic];
            
            contentDic = [[NSMutableDictionary alloc] init];
            [contentDic setValue:@"邮箱地址" forKey:@"title"];
            [contentDic setValue:_userInfoModel.email forKey:@"detail"];
            [contentDic setObject:@"onClickedEditEmail" forKey:@"clicked_func"];
            [sectionArray addObject:contentDic];
        }
        else if ( i == 1 )
        {
            // group 2
            NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
            [contentDic setValue:@"修改密码" forKey:@"title"];
            [contentDic setObject:@"onClickedEditPswd" forKey:@"clicked_func"];
            [sectionArray addObject:contentDic];
            
        }
        else if ( i == 2 )
        {
            // group 3
            if ( [_userInfoModel.shopType intValue] == ENUM_ACCOUNT_TYPE_NORMAL )
            {
                NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
                [contentDic setValue:@"升级为4S店用户" forKey:@"title"];
                [contentDic setObject:@"onClickedUp24S" forKey:@"clicked_func"];
                [sectionArray addObject:contentDic];
                
                contentDic = [[NSMutableDictionary alloc] init];
                [contentDic setValue:@"升级为汽修用户" forKey:@"title"];
                [contentDic setObject:@"onClickedUp2Repair" forKey:@"clicked_func"];
                [sectionArray addObject:contentDic];
            }
            else if ( [_userInfoModel.shopType intValue] == ENUM_ACCOUNT_TYPE_4S )
            {
                if ( [_userInfoModel.shopStatus intValue] == ENUM_ACCOUNT_STATUS_EXAMINING )
                {
                    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"升级申请审核中" forKey:@"title"];
                    [contentDic setObject:@"onClickedLoading" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                }
                else if ( [_userInfoModel.shopStatus intValue] == ENUM_ACCOUNT_STATUS_FROZEN )
                {
                    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"4S店铺功能冻结" forKey:@"title"];
                    [contentDic setObject:@"onClickedLoading" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                }
                else if ( [_userInfoModel.shopStatus intValue] == ENUM_ACCOUNT_STATUS_PASSED )
                {
                    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"车辆价格列表" forKey:@"title"];
                    [contentDic setObject:@"onClickedPriceList" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                    
                    contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"上传4S店铺照片" forKey:@"title"];
                    [contentDic setObject:@"onClickedAddPic" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                    
                    contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"编辑4S店铺信息" forKey:@"title"];
                    [contentDic setObject:@"onClickedEdit4SShopInfo" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                }
            }
            else if ( [_userInfoModel.shopType intValue] == ENUM_ACCOUNT_TYPE_REPAIR )
            {
                if ( [_userInfoModel.shopStatus intValue] == ENUM_ACCOUNT_STATUS_EXAMINING )
                {
                    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"升级申请审核中" forKey:@"title"];
                    [contentDic setObject:@"onClickedLoading" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                }
                else if ( [_userInfoModel.shopStatus intValue] == ENUM_ACCOUNT_STATUS_FROZEN )
                {
                    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"汽修店铺功能冻结" forKey:@"title"];
                    [contentDic setObject:@"onClickedLoading" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                }
                else if ( [_userInfoModel.shopStatus intValue] == ENUM_ACCOUNT_STATUS_PASSED )
                {
                    NSMutableDictionary* contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"选择服务项目" forKey:@"title"];
                    [contentDic setObject:@"onClickedSelService" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                    
                    contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"上传汽修店铺照片" forKey:@"title"];
                    [contentDic setObject:@"onClickedAddPic" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                    
                    contentDic = [[NSMutableDictionary alloc] init];
                    [contentDic setValue:@"编辑汽修店铺信息" forKey:@"title"];
                    [contentDic setObject:@"onClickedEditRepairShopInfo" forKey:@"clicked_func"];
                    [sectionArray addObject:contentDic];
                }
            }
        }
        
        [_userInfoArray addObject:sectionArray];
    }
}


-(void)initUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
 
    self.title = @"用户信息";
    
    CGRect frameR = self.view.frame;
    
    if ( _userInfoModel == nil || _userInfoModel.userID == nil || _userInfoModel.account == nil )
    {
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frameR.size.height/2-80, frameR.size.width, 21)];
        [nameLabel setText:@"暂无信息"];
        [nameLabel setNumberOfLines:1];
        [nameLabel setTextColor:[UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:1]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:20]];
        [self.view addSubview:nameLabel];
        
        return;
    }
    
    _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frameR.size.width, frameR.size.height) style:UITableViewStyleGrouped];
    [_userInfoTableView setBackgroundColor:DEF_COLOR_BG];
    _userInfoTableView.dataSource = self;
    _userInfoTableView.delegate = self;
    [self.view addSubview:_userInfoTableView];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
    
    // 重新装载数据 用于刷新修改后的值
    [self setDatas];
    [_userInfoTableView reloadData];
}

#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_userInfoArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoListCell"];
    if ( cell == nil )
    {
        [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, _iTVCellH)];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UserInfoListCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray* sectionArray = [_userInfoArray objectAtIndex:indexPath.section];
    NSDictionary* infoDic = [sectionArray objectAtIndex:indexPath.row];
    
    NSString* title = [infoDic valueForKey:@"title"]==nil ? @"" : [infoDic valueForKey:@"title"];
    NSString* detail = [infoDic valueForKey:@"detail"]==nil ? @"" : [infoDic valueForKey:@"detail"];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* sectionArray = _userInfoArray[section];
    return sectionArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _iTVCellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    return 10;
}
// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray* sectionArray = [_userInfoArray objectAtIndex:indexPath.section];
    NSDictionary* infoDic = [sectionArray objectAtIndex:indexPath.row];
    
    NSString* clickedFunc = [infoDic valueForKey:@"clicked_func"]==nil ? @"" : [infoDic valueForKey:@"clicked_func"];
    if ( [clickedFunc compare:@"onClickedLoading"] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"请等待" timer:2.0f];
    }
    else if ( [clickedFunc compare:@"onClickedEditSex"] == NSOrderedSame )
    {
        ControllerUserInfoEdit *viewControllerEdit = [[ControllerUserInfoEdit alloc] init];
        [viewControllerEdit setEditMode:ENUM_EDIT_MODE_SEX account:_userInfoModel.account oldInfo:_userInfoModel.sex];
        [self.navigationController pushViewController:viewControllerEdit animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedEditBirthday"] == NSOrderedSame )
    {
        ControllerUserInfoEdit *viewControllerEdit = [[ControllerUserInfoEdit alloc] init];
        [viewControllerEdit setEditMode:ENUM_EDIT_MODE_BIRTHDAY account:_userInfoModel.account oldInfo:_userInfoModel.birthday];
        [self.navigationController pushViewController:viewControllerEdit animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedEditEmail"] == NSOrderedSame )
    {
        ControllerUserInfoEdit *viewControllerEdit = [[ControllerUserInfoEdit alloc] init];
        [viewControllerEdit setEditMode:ENUM_EDIT_MODE_EMAIL account:_userInfoModel.account oldInfo:_userInfoModel.email];
        [self.navigationController pushViewController:viewControllerEdit animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedEditPswd"] == NSOrderedSame )
    {
        ControllerUserInfoEdit *viewControllerEdit = [[ControllerUserInfoEdit alloc] init];
        [viewControllerEdit setEditMode:ENUM_EDIT_MODE_PASSWORD account:_userInfoModel.account oldInfo:@""];
        [self.navigationController pushViewController:viewControllerEdit animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedUp24S"] == NSOrderedSame )
    {
        ControllerFill4SInfo* controller = [[ControllerFill4SInfo alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedPriceList"] == NSOrderedSame )
    {
        Controller4SCarPriceList* controller = [[Controller4SCarPriceList alloc] initWithShopID:_userInfoModel.shopID];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedUp2Repair"] == NSOrderedSame )
    {
        ControllerFillRepairInfo* controller = [[ControllerFillRepairInfo alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedSelService"] == NSOrderedSame )
    {
        ControllerRepairSelService* controller = [[ControllerRepairSelService alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedAddPic"] == NSOrderedSame )
    {
        ControllerUploadPhoto* controller = [[ControllerUploadPhoto alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ( [clickedFunc compare:@"onClickedEdit4SShopInfo"] == NSOrderedSame )
    {

        
    }
    else if ( [clickedFunc compare:@"onClickedEditRepairShopInfo"] == NSOrderedSame )
    {
        
        
    }
    else
    {
        [MyAlertNotice showMessage:@"不可修改" timer:2.0f];
    }
}




@end
