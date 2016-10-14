//
//  ControllerArticleDetail.m
//  D3Auto
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerArticleDetail.h"

#import "NetArticle.h"
#import "ModelArticle.h"
#import "MyNetLoading.h"
#import "RDVTabBarController.h"

@interface ControllerArticleDetail () <UIWebViewDelegate>
{
    ModelArticle*           _articleModel;
    
    UIWebView*              _webView;
    MyNetLoading*           _netLoading;
}
@end

@implementation ControllerArticleDetail

- (instancetype)initWithArticleID:(NSUInteger)articleID
{
    if ( self = [super init] )
    {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [_webView setDelegate:self];
        [self.view addSubview:_webView];
        
        // loading
        _netLoading = [[MyNetLoading alloc] init];
        [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        [self.view addSubview:_netLoading];
        
        [self reqArticleList:articleID];
    }
    return self;
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
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - web view delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_netLoading startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_netLoading stopAnimating];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - network
- (void)reqArticleList:(NSUInteger)articleID
{
    [[NetArticle sharedInstance] reqArticleDetail:^(id success) {
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            NSDictionary* dic = success[@"data"];
            _articleModel = [[ModelArticle alloc] init];
            _articleModel.articleID = [[dic valueForKey:@"article_id"] integerValue];
            _articleModel.cateID = [[dic valueForKey:@"cate_id"] integerValue];
            _articleModel.thumb = [dic valueForKey:@"article_thumb"];
            _articleModel.title = [dic valueForKey:@"article_title"];
            _articleModel.abstract = [dic valueForKey:@"article_abstract"];
            _articleModel.author = [dic valueForKey:@"author"];
            _articleModel.keywords = [dic valueForKey:@"keywords"];
            _articleModel.content = [dic valueForKey:@"content"];
            _articleModel.isShow = [[dic valueForKey:@"is_show"] integerValue];
            _articleModel.addTime = [[dic valueForKey:@"add_time"] integerValue];
            _articleModel.sortOrder = [[dic valueForKey:@"sort_order"] integerValue];
            _articleModel.clickCount = [[dic valueForKey:@"click_count"] integerValue];
            _articleModel.praiseCount = [[dic valueForKey:@"praise_count"] integerValue];
            
            [_webView loadHTMLString:_articleModel.content baseURL:nil];
        }
    
    } fail:^(NSError* error) {} articleID:articleID];

}

@end
