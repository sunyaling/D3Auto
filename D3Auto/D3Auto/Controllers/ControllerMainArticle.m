//
//  ControllerMainArticle.m
//  D3Auto
//
//  Created by zhongfang on 15/10/27.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerMainArticle.h"

#import "Config.h"
#import "NetArticle.h"
#import "ModelArticle.h"
#import "RDVTabBarController.h"
#import "ViewArticleRoot.h"
#import "MyWebViewController.h"
#import "ControllerArticleDetail.h"
@interface ControllerMainArticle () <ViewArticleRootDelegate>
{
    NSMutableArray*         _articleArray;
    
    ViewArticleRoot*        _rootView;
    
    NSInteger               _page;          // 页数
    NSInteger               _count;         // 每页条数
    NSInteger               _hasMore;       // 是否有更多 0无 1有
}
@end

@implementation ControllerMainArticle

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
    _articleArray = [[NSMutableArray alloc] init];
    
    _page = 1;
    _count = 10;
    _hasMore = 1;
}
- (void)initUI
{
    self.view.backgroundColor = DEF_COLOR_BG;
    
    _rootView = [[ViewArticleRoot alloc] initWithFrame:self.view.frame];
    [_rootView setDelegate:self];
    self.view = _rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self reqBanner];
    [self reqArticleList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    UINavigationController* pNv = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [pNv setNavigationBarHidden:YES animated:YES];
}

#pragma -mark ViewAritcleRootDelegate
- (void)onClickedBannerURL:(NSString* _Nonnull)url
{
    MyWebViewController* viewController = [[MyWebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)nextPage
{
    if ( _hasMore == 0 )
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"已经是最后一页了！" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:btnAction];
        [self presentViewController: alert animated: YES completion: nil];
        return;
    }
    
    _page += 1;
    [self reqArticleList];
}
- (void)onClickedArticle:(NSInteger)index
{
    if ( 0 <= index && index < [_articleArray count] )
    {
        ModelArticle* articleModel = [_articleArray objectAtIndex:index];
        ControllerArticleDetail* controller = [[ControllerArticleDetail alloc] initWithArticleID:articleModel.articleID];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma -mark network
- (void)reqBanner
{
    // banner
    [[NetArticle sharedInstance] reqBanner:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            NSMutableArray* imgArray = [[NSMutableArray alloc] init];
            NSMutableArray* urlArray = [[NSMutableArray alloc] init];
            
            NSArray* bannerArray = success[@"data"];
            NSUInteger iCount = [bannerArray count];
            if ( iCount <= 0 )
                return;
            
            for (int i = 0; i < iCount; i++ )
            {
                NSDictionary* dic = bannerArray[i];
                if ( [dic valueForKey:@"photo"] && [dic valueForKey:@"url"] )
                {
                    [imgArray addObject:[dic valueForKey:@"photo"]];
                    [urlArray addObject:[dic valueForKey:@"url"]];
                }
            }
            
            [_rootView updateBanner:imgArray urlArray:urlArray];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)reqArticleList
{
    // banner
    [[NetArticle sharedInstance] reqArticleList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            NSArray* array = success[@"data"];
            NSUInteger iCount = [array count];
            if ( iCount <= 0 )
                return;
            
            for (int i = 0; i < iCount; i++ )
            {
                NSDictionary* dic = array[i];
                
                ModelArticle* article = [[ModelArticle alloc] init];
                article.articleID = [[dic valueForKey:@"article_id"] integerValue];
                article.cateID = [[dic valueForKey:@"cate_id"] integerValue];
                article.thumb = [dic valueForKey:@"article_thumb"];
                article.title = [dic valueForKey:@"article_title"];
                article.abstract = [dic valueForKey:@"article_abstract"];
                article.author = [dic valueForKey:@"author"];
                article.keywords = [dic valueForKey:@"keywords"];
                // article.content = [dic valueForKey:@"content"]; 列表不拉取文章内容
                article.isShow = [[dic valueForKey:@"is_show"] integerValue];
                article.addTime = [[dic valueForKey:@"add_time"] integerValue];
                article.sortOrder = [[dic valueForKey:@"sort_order"] integerValue];
                article.clickCount = [[dic valueForKey:@"click_count"] integerValue];
                article.praiseCount = [[dic valueForKey:@"praise_count"] integerValue];
                
                [_articleArray addObject:article];
            }
            
            NSDictionary* pageDic = success[@"paginated"];
            _hasMore = [[pageDic valueForKey:@"more"] integerValue];
            
            [_rootView updateArticleList:_articleArray hasMore:_hasMore];
        }
    } fail:^(NSError *error) {
        
    } page:_page count:_count ];
}






@end
