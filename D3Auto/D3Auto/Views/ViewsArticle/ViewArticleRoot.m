//
//  ViewArticleRoot.m
//  D3Auto
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ViewArticleRoot.h"

#import "Config.h"
#import "MyBannerView.h"
#import "ModelArticle.h"
#import "MyArticleCell.h"
#import "UIImageView+OnlineImage.h"
#import "EGORefreshTableFooterView.h"

@interface ViewArticleRoot() <MyBannerViewDelegate, EGORefreshTableDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView*        _tableView;
    NSMutableArray*     _articleArray;
    
    MyBannerView*       _bannerView;
    
    int                 _tableViewCellH;
    
    EGORefreshTableFooterView*  _refreshFooterView;
    BOOL                        _reloading;                //  Reloading var should really be your tableviews datasource
}
@end


@implementation ViewArticleRoot

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
    _tableViewCellH = 80;
    
    _articleArray = [[NSMutableArray alloc] init];
    
    _reloading = NO;
}

- (void)initUIWithFrame:(CGRect)frame
{
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-DEF_TABBAR_H+DEF_STATUSBAR_H);

    CGRect viewBounds = self.bounds;
    viewBounds.origin.y = viewBounds.origin.y + DEF_STATUSBAR_H;
    self.bounds = viewBounds;
    
    // 文章信息
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_tableView];
    
    float top = 0;
    float height = 200;
    
    // 滚动广告
    _bannerView = [[MyBannerView alloc] initWithFrame:CGRectMake(0, top, _tableView.frame.size.width, height)];
    [_bannerView setMyBannerViewDelegate:self];
    _tableView.tableHeaderView = _bannerView;
    
    // create the footerView
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    _refreshFooterView.delegate = self;
    [_tableView addSubview:_refreshFooterView];
}

#pragma mark - UITableViewDelegate
// 总共行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_articleArray count];
}
// 每行的单元格
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelArticle* article = _articleArray[indexPath.row];
    
    MyArticleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleListCell"];
    if ( cell == nil )
        cell = [[MyArticleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ArticleListCell"];
    else
    {
        for ( UIView* view in cell.imageView.subviews )
            [view removeFromSuperview];
    }
    
    UIImage* imgLoading = [UIImage imageNamed:@"transparent_160_120"];
    cell.imageView.image = imgLoading;
    
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgLoading.size.width, imgLoading.size.height)];
    [iv setTag:(indexPath.row+DEF_TAG_BASE_NUM)];
    [iv setOnlineImage:article.thumb];
    [cell.imageView addSubview:iv];
    
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = article.abstract;
    
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:article.addTime];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string = [dateFormat stringFromDate:date];
                                                   
    cell.timeLabel.text = string;
    
    return cell;
}
// 每行高du
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableViewCellH;
}
// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_delegate onClickedArticle:indexPath.row];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshFooterView)
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_refreshFooterView)
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    _reloading = YES;
    
    if(aRefreshPos == EGORefreshFooter)
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.2];
}
//加载调用的方法
-(void)getNextPageView
{
    [_delegate nextPage];
    _reloading = NO;

    if (_refreshFooterView)
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma -mark MyBannerViewDelegate
- (void)onClickedBannerURL:(NSString* _Nonnull)url
{
    [_delegate onClickedBannerURL:url];
}

#pragma -mark from controller
- (void)updateBanner:(NSArray* _Nonnull)imgArray urlArray:(NSArray* _Nonnull)urlArray
{
    [_bannerView updateUI:imgArray urlArray:urlArray];
}
- (void)updateArticleList:(NSArray* _Nonnull) articleArray hasMore:(NSInteger)hasMore
{
    [_articleArray removeAllObjects];
    [_articleArray addObjectsFromArray:articleArray];
    [_tableView reloadData];
    
    if ( hasMore == 0 )
        [_refreshFooterView setHidden:YES];
    else
        [_refreshFooterView setHidden:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        [_refreshFooterView setFrame:CGRectMake(0.0f, _tableView.contentSize.height, _tableView.frame.size.width, _tableView.contentSize.height)];
    });
}



@end
