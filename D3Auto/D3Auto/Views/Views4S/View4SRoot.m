//
//  View4SRoot.m
//  D3Auto
//
//  Created by zhongfang on 15/10/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "View4SRoot.h"

#import "Config.h"
#import "MyBannerView.h"
#import "View4SCarList.h"
#import "View4SRecommond.h"
#import "UIImageView+OnlineImage.h"

@interface View4SRoot() <UITableViewDelegate, UITableViewDataSource, MyBannerViewDelegate, View4SRecommondDelegate, View4SCarListDelegate>
{
    UITableView*            _tableView;
    
    MyBannerView*           _bannerView;
    
    View4SRecommond*        _recommondView;
    
    View4SCarList*          _carListView;
    
    NSMutableArray*         _dataArray;
    
    UILabel*                _posLabel;
}

typedef enum
{
    ENUM_BTN_TAG_START      = 11000,
    
    ENUM_BTN_TAG_FORUM,
    ENUM_BTN_TAG_CLUB,
    ENUM_BTN_TAG_USED,
    ENUM_BTN_TAG_DEPRECIATE,
    ENUM_BTN_TAG_COLLECTION,
    
    ENUM_BTN_TAG_END
}
ENUM_BTN_TAG;
@end


@implementation View4SRoot


@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
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
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-DEF_TABBAR_H+DEF_STATUSBAR_H);
    
    CGRect viewBounds = self.bounds;
    viewBounds.origin.y = viewBounds.origin.y + DEF_STATUSBAR_H;
    self.bounds = viewBounds;
    
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    
    [self setTBHeader:self.frame];
    
    // 点击品牌之后显示的车辆列表
    _carListView = [[View4SCarList alloc] initWithFrame:CGRectMake(self.frame.size.width, DEF_STATUSBAR_H, self.frame.size.width, self.frame.size.height)];
    [_carListView setHidden:YES];
    [_carListView setDelegate:self];
    [self addSubview:_carListView];
}

- (void)setTBHeader:(CGRect)frame
{
    UIView* headerView = [[UIView alloc] init];
    
    float top = 0;
    float height = 200;
    
    // 滚动广告
    _bannerView = [[MyBannerView alloc] initWithFrame:CGRectMake(0, top, frame.size.width, height)];
    [_bannerView setMyBannerViewDelegate:self];
    [headerView addSubview:_bannerView];
    
    // 快捷按钮
    top += height;
    height = 80;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, top, frame.size.width, height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:view];
    
    NSArray * iArr = @[@"4s_btn_forum", @"4s_btn_club", @"4s_btn_used", @"4s_btn_depreciate", @"4s_btn_collection"];
    NSArray * sArr = @[@"论坛", @"车友会", @"二手车", @"降价", @"收藏"];
    
    for (int i = 0; i < [iArr count]; i ++)
    {
        CGPoint p = CGPointMake(frame.size.width / 10 + i * frame.size.width / 5, height / 2 - 7);
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [btn setImage:[UIImage imageNamed:iArr[i]] forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.tag = ENUM_BTN_TAG_START + 1 + i;
        [btn setCenter:p];
        [btn addTarget:self action:@selector(onClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        p.y += 30;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 5, 10)];
        [lbl setText:sArr[i]];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setFont:[UIFont systemFontOfSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setCenter:p];
        [view addSubview:lbl];
    }
    
    // 分割线
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height-1, frame.size.width, 0.5f)];
    [lineView setBackgroundColor:DEF_COLOR_LINE];
    [view addSubview:lineView];

    // 新闻
    top += height;
    height = 40;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, top, frame.size.width, height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:view];
    
    UIImageView* iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4s_img_news"]];
    [iconView setCenter:CGPointMake(frame.size.width/8, height/2)];
    [view addSubview:iconView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, height-10)];
    [lineView setCenter:CGPointMake(frame.size.width/4, height/2)];
    [lineView setBackgroundColor:DEF_COLOR_LINE];
    [view addSubview:lineView];
    
    UIImageView* imgHot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4s_img_hot"]];
    [imgHot setCenter:CGPointMake(frame.size.width*2.5/8, height/2)];
    [view addSubview:imgHot];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width*3/8, 0, frame.size.width*5/8, height-20)];
    [titleLabel setCenter:CGPointMake(titleLabel.center.x, height/2)];
    [titleLabel setText:@"好想买辆跑车送自己"];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:titleLabel];
    
    // 定位和搜索
    top = top + height + 10;
    height = 40;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, top, frame.size.width, height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:view];
    
    //_posLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    //[_posLabel setCenter:CGPointMake(frame.size.width/8 - 15, height/2)];
    _posLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
    [_posLabel setCenter:CGPointMake(frame.size.width/8, height/2)];
    [_posLabel setTextColor:[UIColor redColor]];
    [_posLabel setText:@"沈阳市"];
    [_posLabel setTextAlignment:NSTextAlignmentLeft];
    [_posLabel setFont:[UIFont systemFontOfSize:13]];
    //[view addSubview:_posLabel];
    
    UILabel* posBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
    [posBtnLabel setCenter:CGPointMake(frame.size.width/8 + 15, height/2)];
    [posBtnLabel setTextColor:[UIColor blueColor]];
    [posBtnLabel setText:@"[定位]"];
    [posBtnLabel setTextAlignment:NSTextAlignmentRight];
    [posBtnLabel setFont:[UIFont systemFontOfSize:13]];
    //[view addSubview:posBtnLabel];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, height-10)];
    [lineView setCenter:CGPointMake(frame.size.width/4, height/2)];
    [lineView setBackgroundColor:DEF_COLOR_LINE];
    [view addSubview:lineView];
    
    //UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(frame.size.width*2/8, 0, frame.size.width*6/8, height-10)];
    //[searchBar setCenter:CGPointMake(searchBar.center.x, height/2)];
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*7/8, height-10)];
    [searchBar setCenter:CGPointMake(frame.size.width/2, height/2)];
    [searchBar setPlaceholder:NSLocalizedString(@"全球唯一A3 e-tron磁力电音版", nil)];
    [searchBar setBackgroundColor:[UIColor clearColor]];
    [searchBar setAlpha:0.8];
    searchBar.keyboardType = UIKeyboardTypeDefault;
    [view addSubview:searchBar];
    
    // 清除整个search的背景
    for (UIView *view in searchBar.subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0)
        {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    // 设置search的内部颜色
    for (UIView* subview in [[searchBar.subviews lastObject] subviews])
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField*)subview;
            textField.backgroundColor = DEF_COLOR_BG;
        }
    }
    
    // 推荐
    top = top + height + 20;
    height = 130;
    _recommondView = [[View4SRecommond alloc] initWithFrame:CGRectMake(0, top, frame.size.width, height)];
    [_recommondView setDelegate:self];
    [headerView addSubview:_recommondView];
    
    [headerView setFrame:CGRectMake(0, 0, frame.size.width, top+height)];

    _tableView.tableHeaderView = headerView;
}



#pragma -mark on clicked button
-(void)onClickedBtn:(id)sender
{
    UIButton * clickBtn = (UIButton*)sender;
    NSLog(@"The button's tag you clicked is: %ld", clickBtn.tag);
    switch (clickBtn.tag)
    {
        case ENUM_BTN_TAG_FORUM:
        {

        }
            break;
        case ENUM_BTN_TAG_CLUB:
        {

        }
            break;
        case ENUM_BTN_TAG_USED:
        {

        }
            break;
        case ENUM_BTN_TAG_DEPRECIATE:
        {

        }
            break;
        case ENUM_BTN_TAG_COLLECTION:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma -mark from controller
- (void)updateBanner:(NSArray* _Nonnull)imgArray urlArray:(NSArray* _Nonnull)urlArray
{
    [_bannerView updateUI:imgArray urlArray:urlArray];
}

- (void)updateBrandList:(NSArray* _Nonnull) brandListDicArray
{
    [_dataArray addObjectsFromArray:brandListDicArray];

    [_tableView reloadData];
}

- (void)updateRecommond:(NSMutableArray* _Nonnull)brandArray andCarArray:(NSMutableArray* _Nonnull)carArray;
{
    [_recommondView onUpdateRecommond:brandArray andCarArray:carArray];
}

- (void)updateCarList:(NSArray* _Nonnull) carListArray
{
    [_carListView onUpdateCarList:carListArray];
}

- (void)updateCityName:(NSString* _Nonnull) cityName
{
    [_posLabel setText:cityName];
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
    Model4SBrandGroup* group = _dataArray[section];
    return group.brandArray.count;
}

// 每行的单元格
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Model4SBrandGroup* group = _dataArray[indexPath.section];
    Model4SBrand* brand = group.brandArray[indexPath.row];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    UIImage* imgLoading = [UIImage imageNamed:@"transparent_90_90"];
    cell.imageView.image = imgLoading;
    
    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgLoading.size.width, imgLoading.size.height)];
    [iv setOnlineImage:brand.image];
    [cell.imageView addSubview:iv];

    cell.textLabel.text = brand.name;
    
    return cell;
}

// 每组标题头名称
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Model4SBrandGroup* group = _dataArray[section];
    return group.name;
}

// 标题索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (Model4SBrandGroup* group in _dataArray)
    {
        [array addObject:group.name];
    }
    return array;
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
    return 60;
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
    Model4SBrandGroup* group = _dataArray[indexPath.section];
    Model4SBrand* brand = group.brandArray[indexPath.row];
    [_delegate onClickedCate:[NSString stringWithFormat:@"%ld", brand.brandID]];
    
    if ( _carListView.hidden == YES )
    {
        // 隐藏时 动画结束请求数据
        [UIView transitionWithView:_carListView duration:0.3f options:0 animations:^{
            [_carListView setHidden:NO];
            CGRect r = _carListView.frame;
            [_carListView setFrame:CGRectMake(100, r.origin.y, r.size.width, r.size.height)];
        }completion:^(BOOL finished){}];
    }
}

// 滚动事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ( _carListView.hidden == NO )
    {
        // 滑动时隐藏车辆列表
        [UIView transitionWithView:_carListView duration:0.3f options:0 animations:^{
            CGRect r = _carListView.frame;
            [_carListView setFrame:CGRectMake(self.frame.size.width, r.origin.y, r.size.width, r.size.height)];
        }completion:^(BOOL finished){
            [_carListView setHidden:YES];
        }];
    }
}

#pragma -mark MyBannerViewDelegate
- (void)onClickedBannerURL:(NSString* _Nonnull)url
{
    [_delegate onClickedBannerURL:url];
}

#pragma -mark View4SecommondDelegate
- (void)onClickedRecommond:(BOOL)isBrand andClickedID:(NSString*)clickedID
{
    NSLog(@"Recommond ID clicked is: %@", clickedID);
    
    if (isBrand)
    {
        [_delegate onClickedCate:clickedID];
        
        if ( _carListView.hidden == YES )
        {
            // 隐藏时 动画结束请求数据
            [UIView transitionWithView:_carListView duration:0.3f options:0 animations:^{
                [_carListView setHidden:NO];
                CGRect r = _carListView.frame;
                [_carListView setFrame:CGRectMake(100, r.origin.y, r.size.width, r.size.height)];
            }completion:^(BOOL finished){}];
        }
    }
    else
    {
        if ( _carListView.hidden == NO )
        {
            // 滑动时隐藏车辆列表
            [UIView transitionWithView:_carListView duration:0.3f options:0 animations:^{
                CGRect r = _carListView.frame;
                [_carListView setFrame:CGRectMake(self.frame.size.width, r.origin.y, r.size.width, r.size.height)];
            }completion:^(BOOL finished){
                [_carListView setHidden:YES];
                
                [_delegate onClickedCar:clickedID];
            }];
        }
        else
        {
            [_delegate onClickedCar:clickedID];
        }
    }
}

#pragma -mark View4SCarListDelegate
- (void)onClickedCar:(NSString *)carID
{
    if ( _carListView.hidden == NO )
    {
        // 滑动时隐藏车辆列表
        [UIView transitionWithView:_carListView duration:0.3f options:0 animations:^{
            CGRect r = _carListView.frame;
            [_carListView setFrame:CGRectMake(self.frame.size.width, r.origin.y, r.size.width, r.size.height)];
        }completion:^(BOOL finished){
            [_carListView setHidden:YES];
            
            [_delegate onClickedCar:carID];
        }];
    }
}

@end
