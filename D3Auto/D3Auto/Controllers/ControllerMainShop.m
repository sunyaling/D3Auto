//
//  Controller_main_shop.m
//  D3Auto
//
//  Created by zhongfang on 15/10/27.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerMainShop.h"

#import "Utils.h"
#import "Config.h"
#import "MyNetLoading.h"
#import "RDVTabBarController.h"
#import "ControllerLogin.h"
#import "MyWebViewController.h"

@interface ControllerMainShop () <UIWebViewDelegate>
{
    UIWebView*          _webView;
    MyNetLoading*       _netLoading;
    
    NSString*           _shopIndex;             // 商城起始页url
    BOOL                _isLogin;               // 本地保存当前登录信息 用于校对登陆状态是否发生了改变
}

@end

@implementation ControllerMainShop

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
    _shopIndex = @"";
    _isLogin = NO;
}
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect viewBounds = self.view.bounds;
    viewBounds.origin.y = viewBounds.origin.y + DEF_STATUSBAR_H;
    self.view.bounds = viewBounds;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-DEF_TABBAR_H+DEF_STATUSBAR_H)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self indexPageURL]]]];
    _webView.delegate = self;
    [self.view addSubview: _webView];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    UINavigationController* pNv = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [pNv setNavigationBarHidden:YES animated:YES];
    
    // 登录态改变 重新拉取页面
    if ( _isLogin != [[NSUserDefaults standardUserDefaults] boolForKey:DEF_KEY_IS_LOGIN] )
       [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self indexPageURL]]]];
}

- (NSString* _Nonnull)indexPageURL
{
    NSString* shopURL = DEF_SHOP_URL;
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* sessionID = [userDefault stringForKey:DEF_KEY_SESSION_ID];
    NSString* userID = [userDefault stringForKey:DEF_KEY_USER_ID];
    if ( sessionID != nil && [sessionID compare:@""] != NSOrderedSame
        && userID != nil && [userID compare:@""] != NSOrderedSame
        && [userDefault boolForKey:DEF_KEY_IS_LOGIN] )
    {
        _isLogin = YES;
        shopURL = [NSString stringWithFormat:@"%@?app=login&session=%@&user_id=%@", DEF_SHOP_URL, sessionID, userID];
    }
    
    _shopIndex = shopURL;
    return shopURL;
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* reqURL = request.URL;
    NSString* reqURLString = [NSString stringWithString:[reqURL absoluteString]];
    
    // 起始页不跳转controller
    if ( [reqURLString compare:_shopIndex] == NSOrderedSame )
        return YES;
    
    // 取得app跳转内容
    NSString* strAPP = [Utils getCommondFromURL:reqURLString];
    if ( strAPP == nil || [strAPP compare:@""] == NSOrderedSame )
    {
        // 没有“app＝”指示或者数据处理错误都直接跳转
        MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:reqURLString];
        viewController.hideNavigationBar = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ( [strAPP compare:@"cart"] == NSOrderedSame )
    {
        // 购物车
        MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:reqURLString];
        viewController.hideNavigationBar = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ( [strAPP compare:@"category"] == NSOrderedSame )
    {
        // 分类
        MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:reqURLString];
        viewController.hideNavigationBar = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        // 没有找到跳转类型 直接跳转
        MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:reqURLString];
        viewController.hideNavigationBar = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    return NO;
}


@end
