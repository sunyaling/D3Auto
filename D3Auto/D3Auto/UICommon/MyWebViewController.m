//
//  MyWebViewController.m
//  D3Auto
//
//  Created by zhongfang on 15/11/4.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "MyWebViewController.h"

#import "Utils.h"
#import "MyNetLoading.h"
#import "RDVTabBarController.h"

@interface MyWebViewController () <UIWebViewDelegate>
{
    NSString*       _rootURL;
    UIWebView*      _goodsInfoWebView;

    MyNetLoading*   _netLoading;
}
@end

@implementation MyWebViewController

@synthesize hideNavigationBar = _hideNavigationBar;

- (MyWebViewController* _Nonnull)initWithUrl:(NSString* _Nullable)url
{
    self = [super init];
    if (self) {
        [self initData];
        [self initUIWithUrl:url];
    }
    return self;
}

-(void)initData
{
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedBack)];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    _rootURL = @"";
    _hideNavigationBar = NO;
}

-(void)initUIWithUrl:(NSString* _Nonnull)url
{
    _rootURL = url;
    CGRect frameR = self.view.frame;
    
    _goodsInfoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frameR.size.width, frameR.size.height)];
    [_goodsInfoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    _goodsInfoWebView.delegate = self;
    [self.view addSubview: _goodsInfoWebView];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:_hideNavigationBar animated:YES];
}

-(void)loadHTMLString:(NSString*)string
{
    [_goodsInfoWebView loadHTMLString:string baseURL:nil];
}

#pragma mark - clicked event
- (void)onClickedBack
{
    if ( _goodsInfoWebView.canGoBack )
    {
        [_goodsInfoWebView goBack];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - web view delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_netLoading startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_netLoading stopAnimating];
    self.title = [_goodsInfoWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* reqURL = request.URL;
    NSString* reqURLString = [NSString stringWithString:[reqURL absoluteString]];
    
    // 起始页不跳转controller
    if ( [reqURLString compare:_rootURL] == NSOrderedSame )
        return YES;
    
    // 取得app跳转内容
    NSString* strAPP = [Utils getCommondFromURL:reqURLString];
    if ( strAPP == nil || [strAPP compare:@""] == NSOrderedSame )
        return YES;
    
    if ( [strAPP compare:@"default"] == NSOrderedSame )
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}


@end

