//
//  ControllerMainMine.m
//  D3Auto
//
//  Created by zhongfang on 15/10/27.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerMainMine.h"

#import "Config.h"
#import "NetUser.h"
#import "ViewMineRoot.h"
#import "MyAlertNotice.h"
#import "ControllerLogin.h"
#import "ControllerUserInfo.h"
#import "RDVTabBarController.h"
#import "MyWebViewController.h"

@interface ControllerMainMine () <ViewMineRootDelegate>
{
    ViewMineRoot*           _rootView;
}
@end

@implementation ControllerMainMine

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
    _rootView = [[ViewMineRoot alloc] initWithFrame:self.view.frame];
    [_rootView setDelegate:self];
    self.view = _rootView;
}
- (void)initUI
{
    //self.title = @"我的";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [_rootView onUpdateViewUI];
}

#pragma - mark ViewMainRootDelegate
- (void)onClickedLogin
{
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:DEF_KEY_IS_LOGIN] )
    {
        ControllerUserInfo* viewController = [[ControllerUserInfo alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        ControllerLogin* viewController = [[ControllerLogin alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)onClickedLogout
{
    NetUser* net = [NetUser sharedInstance];
    
    [net reqLogout:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [MyAlertNotice showMessage:@"登出成功" timer:2.0f];
            
            [_rootView onUpdateViewUI];
        }
        
    } fail:^(NSError *error) { } ];
}
- (void)onClickedHelp
{
    MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:DEF_URL_HELP];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)onClickedAbout
{
    MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:DEF_URL_ABOUT];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
