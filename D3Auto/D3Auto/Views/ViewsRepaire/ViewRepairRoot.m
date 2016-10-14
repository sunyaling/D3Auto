//
//  ViewRepairRoot.m
//  D3Auto
//
//  Created by apple on 15/11/18.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ViewRepairRoot.h"

#import "Config.h"
#import "MyAlertNotice.h"
#import "MyBannerView.h"
#import "MyMarqueeView.h"
#import "ModelUserInfo.h"
#import "UIImageView+OnlineImage.h"

#define DEF_NEARBY_COUNT_ROW    2       // 附近商店显示行数
#define DEF_NEARBY_COUNT_COL    4       // 附近商店显示列数

#define DEF_5STAR_COUNT_ROW     1       // 五星商店显示行数
#define DEF_5STAR_COUNT_COL     5       // 五星商店显示列数

#define DEF_ITEM_COUNT_ROW      2       // 维修和改装项目显示行数
#define DEF_ITEM_COUNT_COL      5       // 维修和改装项目显示列数

@interface ViewRepairRoot() <MyBannerViewDelegate, UITextViewDelegate, UIScrollViewDelegate>
{
    UIScrollView*       _scrollView;
    
    MyBannerView*       _bannerView;
    
    UILabel*            _posLabel;                  // 城市名称
    
    UIView*             _shopNearlyView;            // 附近店铺
    UIView*             _star5ShopView;             // 五星店铺
    UIView*             _repairView;                // 维修保养
    UIView*             _modifyView;                // 专业改装
    UIView*             _infoView;                  // 信息发布
    
    MyMarqueeView*      _marquee;                   // 信息显示跑马灯
    UILabel*            _infoCountLabel;            // 信息发布字数计数
    UITextView*         _infoTextView;              // 信息发布内容
    
    UILabel*            _keyboardCompleteLabel;     // 键盘收起按钮
}
@end


@implementation ViewRepairRoot

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
    
}

- (void)initUIWithFrame:(CGRect)frame
{
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-DEF_TABBAR_H+DEF_STATUSBAR_H);
    
    CGRect viewBounds = self.bounds;
    viewBounds.origin.y = viewBounds.origin.y + DEF_STATUSBAR_H;
    self.bounds = viewBounds;
    
    // 内部信息
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [_scrollView setBackgroundColor:DEF_COLOR_BG];
    [_scrollView setDelegate:self];
    [self addSubview:_scrollView];
    
    float top = 0;
    float height = 200;
    
    // 滚动广告
    _bannerView = [[MyBannerView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
    [_bannerView setMyBannerViewDelegate:self];
    [_scrollView addSubview:_bannerView];
    
    // 定位和搜索
    top = top + height;
    height = 40;
    UIView* searchView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:searchView];
    
    //_posLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    //[_posLabel setCenter:CGPointMake(frame.size.width/8 - 15, height/2)];
    _posLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
    [_posLabel setCenter:CGPointMake(frame.size.width/8-5, height/2)];
    [_posLabel setTextColor:[UIColor redColor]];
    [_posLabel setTextAlignment:NSTextAlignmentLeft];
    [_posLabel setFont:[UIFont systemFontOfSize:13]];
    [searchView addSubview:_posLabel];
    
    UILabel* posBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
    [posBtnLabel setCenter:CGPointMake(self.frame.size.width/8 + 25, height/2)];
    [posBtnLabel setTextColor:[UIColor blueColor]];
    [posBtnLabel setText:@"[定位]"];
    [posBtnLabel setTextAlignment:NSTextAlignmentRight];
    [posBtnLabel setFont:[UIFont systemFontOfSize:13]];
    [searchView addSubview:posBtnLabel];
    posBtnLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedGetPos:)];
    [posBtnLabel addGestureRecognizer:gesture];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, height-10)];
    [lineView setCenter:CGPointMake(frame.size.width/4, height/2)];
    [lineView setBackgroundColor:DEF_COLOR_LINE];
    [searchView addSubview:lineView];
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.frame.size.width*2/8, 0, self.frame.size.width*6/8, height-10)];
    [searchBar setCenter:CGPointMake(searchBar.center.x, height/2)];
    [searchBar setPlaceholder:NSLocalizedString(@"全球唯一A3 e-tron磁力电音版", nil)];
    [searchBar setBackgroundColor:[UIColor clearColor]];
    [searchBar setAlpha:0.8];
    searchBar.keyboardType = UIKeyboardTypeDefault;
    [searchView addSubview:searchBar];
    
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
    
    // 附近店铺 标题
    top = top + height;
    height = 30;
    UILabel* shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top, self.frame.size.width, height)];
    [shopLabel setText:@"附近店铺"];
    [shopLabel setTextColor:[UIColor grayColor]];
    [shopLabel setFont:[UIFont systemFontOfSize:13]];
    [shopLabel setBackgroundColor:[UIColor clearColor]];
    [shopLabel setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:shopLabel];
    
    // 附近店铺 内容
    top = top + height;
    height = 180;
    _shopNearlyView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width*4/5, height)];
    [_shopNearlyView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_shopNearlyView];
    
    // 附近店铺按钮 刷新 更多
    CGPoint refCenterP = CGPointMake(frame.size.width * 9 / 10, top + height / 4 );
    UIImage* btnImg = [UIImage imageNamed:[NSString stringWithFormat:@"shop_icon_%d",0]];
    
    UIButton * btnRefre = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
    [btnRefre setImage:btnImg forState:UIControlStateNormal];
    [btnRefre setCenter:refCenterP];
    [btnRefre addTarget:self action:@selector(onClickedNearbyRefresh) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnRefre];
    
    refCenterP.y += 30;
    UILabel * lblRefre = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _shopNearlyView.frame.size.width / DEF_NEARBY_COUNT_COL, 10)];
    [lblRefre setText:@"刷新"];
    [lblRefre setTextColor:[UIColor lightGrayColor]];
    [lblRefre setFont:[UIFont systemFontOfSize:10]];
    [lblRefre setTextAlignment:NSTextAlignmentCenter];
    [lblRefre setCenter:refCenterP];
    [_scrollView addSubview:lblRefre];
    
    CGPoint moreCenterP = CGPointMake(frame.size.width * 9 / 10, top + height * 3 / 4 );
    btnImg = [UIImage imageNamed:[NSString stringWithFormat:@"shop_icon_%d",4]];
    
    UIButton * btnMore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
    [btnMore setImage:btnImg forState:UIControlStateNormal];
    [btnMore setCenter:moreCenterP];
    [btnMore addTarget:self action:@selector(onClickedNearbyMore) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnMore];
    
    moreCenterP.y += 30;
    UILabel * lblMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _shopNearlyView.frame.size.width / DEF_NEARBY_COUNT_COL, 10)];
    [lblMore setText:@"更多"];
    [lblMore setTextColor:[UIColor lightGrayColor]];
    [lblMore setFont:[UIFont systemFontOfSize:10]];
    [lblMore setTextAlignment:NSTextAlignmentCenter];
    [lblMore setCenter:moreCenterP];
    [_scrollView addSubview:lblMore];
    
    // 五星店铺 标题
    top = top + height;
    height = 30;
    UILabel* star5ShopLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top, self.frame.size.width, height)];
    [star5ShopLabel setText:@"五星店铺"];
    [star5ShopLabel setTextColor:[UIColor grayColor]];
    [star5ShopLabel setFont:[UIFont systemFontOfSize:13]];
    [star5ShopLabel setBackgroundColor:[UIColor clearColor]];
    [star5ShopLabel setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:star5ShopLabel];
    
    // 五星店铺 内容
    top = top + height;
    height = 80;
    _star5ShopView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
    [_star5ShopView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_star5ShopView];
    
    // 维修保养 标题
    top = top + height;
    height = 30;
    UILabel* repairLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top, self.frame.size.width, height)];
    [repairLabel setText:@"维修保养"];
    [repairLabel setTextColor:[UIColor grayColor]];
    [repairLabel setFont:[UIFont systemFontOfSize:13]];
    [repairLabel setBackgroundColor:[UIColor clearColor]];
    [repairLabel setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:repairLabel];
    
    // 维修保养 内容
    top = top + height;
    height = 160;
    _repairView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
    [_repairView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_repairView];
    
    // 专业改装 标题
    top = top + height;
    height = 30;
    UILabel* modifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top, self.frame.size.width, height)];
    [modifyLabel setText:@"专业改装"];
    [modifyLabel setTextColor:[UIColor grayColor]];
    [modifyLabel setFont:[UIFont systemFontOfSize:13]];
    [modifyLabel setBackgroundColor:[UIColor clearColor]];
    [modifyLabel setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:modifyLabel];
    
    // 专业改装 内容
    top = top + height;
    height = 160;
    _modifyView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
    [_modifyView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_modifyView];
    
    // 信息发布 标题
    top = top + height;
    height = 30;
    UILabel* infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top, self.frame.size.width, height)];
    [infoLabel setText:@"信息发布"];
    [infoLabel setTextColor:[UIColor grayColor]];
    [infoLabel setFont:[UIFont systemFontOfSize:13]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:infoLabel];
    
    // 信息发布 内容
    top = top + height;
    height = 200;
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
    [_infoView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_infoView];

    _marquee = [[MyMarqueeView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30) textArray:nil];
    [_infoView addSubview:_marquee];
    
    // 编辑
    _infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, _marquee.frame.origin.y + _marquee.frame.size.height + 5, self.frame.size.width-20, 120)];
    _infoTextView.text = @"车辆丢失、车钥匙丢失、二手车买卖、专业开锁、求购二手车等...";
    _infoTextView.keyboardType = UIKeyboardAppearanceDefault;
    _infoTextView.backgroundColor = [UIColor whiteColor];
    _infoTextView.textAlignment = NSTextAlignmentLeft;
    _infoTextView.font = [UIFont systemFontOfSize:11];
    _infoTextView.textColor = [UIColor grayColor];
    _infoTextView.clearsContextBeforeDrawing = YES;
    _infoTextView.delegate = self;
    _infoTextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _infoTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _infoTextView.layer.borderWidth = 1.0f;
    _infoTextView.layer.cornerRadius = 3.0f;
    [_infoView addSubview:_infoTextView];
    
    _infoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_infoTextView.frame.size.width-50, _infoTextView.frame.size.height-30, 50, 30)];
    _infoCountLabel.backgroundColor = [UIColor clearColor];
    _infoCountLabel.text = @"0";
    _infoCountLabel.textColor = DEF_COLOR_LGTRED;
    _infoCountLabel.font = [UIFont systemFontOfSize:13];
    _infoCountLabel.textAlignment = NSTextAlignmentCenter;
    [_infoTextView addSubview:_infoCountLabel];
    
    // 刷新信息
    UILabel* tellLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, _infoView.frame.size.height-40, (self.frame.size.width-100)/2, 40)];
    [tellLabel setText:@"刷新信息"];
    [tellLabel setTextColor:DEF_COLOR_LGTBLUE];
    [tellLabel.layer setBorderColor:DEF_COLOR_BG.CGColor];
    [tellLabel.layer setBorderWidth:0.5f];
    [tellLabel setTextAlignment:NSTextAlignmentCenter];
    [tellLabel setFont:[UIFont systemFontOfSize:12]];
    [_infoView addSubview:tellLabel];
    tellLabel.userInteractionEnabled = YES;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedRefreshInfo:)];
    [tellLabel addGestureRecognizer:gesture];
    
    // 提交信息
    UILabel* mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, _infoView.frame.size.height-40, (self.frame.size.width-100)/2, 40)];
    [mobileLabel setText:@"提交信息"];
    [mobileLabel setTextColor:DEF_COLOR_LGTBLUE];
    [mobileLabel.layer setBorderColor:DEF_COLOR_BG.CGColor];
    [mobileLabel.layer setBorderWidth:0.5f];
    [mobileLabel setTextAlignment:NSTextAlignmentCenter];
    [mobileLabel setFont:[UIFont systemFontOfSize:12]];
    [_infoView addSubview:mobileLabel];
    mobileLabel.userInteractionEnabled = YES;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnClickedCommit:)];
    [mobileLabel addGestureRecognizer:gesture];
    
    // scrollview position
    [_scrollView setContentSize:CGSizeMake(frame.size.width, top+height+DEF_TABBAR_H)];
    

    // SOS
    UIImage* imgSOS = [UIImage imageNamed:@"repair_btn_sos"];
    UIButton* btnSOS = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-imgSOS.size.width-10, 100, imgSOS.size.width, imgSOS.size.height)];
    [btnSOS setImage:imgSOS forState:UIControlStateNormal];
    [btnSOS addTarget:self action:@selector(onClickedSOS:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSOS];
    
    // 滚动到顶部
    UIImage* img2Top = [UIImage imageNamed:@"common_scroll_2_top"];
    UIButton* btn2Top = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-img2Top.size.width-10, self.frame.size.height-img2Top.size.height-DEF_TABBAR_H-10, img2Top.size.width, img2Top.size.height)];
    [btn2Top setImage:img2Top forState:UIControlStateNormal];
    [btn2Top addTarget:self action:@selector(onClickedScroll2Top:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2Top];
    
    // 键盘弹出相关处理
    // 键盘收起按钮
    _keyboardCompleteLabel = [[UILabel alloc] init];
    _keyboardCompleteLabel.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.8];
    _keyboardCompleteLabel.text = @"完成";
    _keyboardCompleteLabel.font = [UIFont systemFontOfSize:12];
    _keyboardCompleteLabel.textColor = [UIColor redColor];
    _keyboardCompleteLabel.userInteractionEnabled = YES;
    [_keyboardCompleteLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_keyboardCompleteLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCancelKboradClicked:)];
    [_keyboardCompleteLabel addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    NSLog(@"---->动态键盘高度:%f",distanceToMove);
    
    CGRect exitBtFrame = CGRectMake(self.frame.size.width-40, self.frame.size.height-distanceToMove-30.0f, 50.0f, 30.0f);
    _keyboardCompleteLabel.frame = exitBtFrame;
    _keyboardCompleteLabel.hidden = NO;

    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.y += distanceToMove;
    [_scrollView setContentOffset:contentOffset animated:YES];
}
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    _keyboardCompleteLabel.hidden = YES;
    
    CGSize contentSize = _scrollView.contentSize;
    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.y = (contentSize.height - _scrollView.frame.size.height);
    [_scrollView setContentOffset:contentOffset animated:YES];
}

#pragma -mark clicked event
- (void)onClickedScroll2Top:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)onClickedSOS:(id)sender
{
    [_delegate onClickedSOS];
}
- (void)onClickedGetPos:(UITapGestureRecognizer*)sender
{
    [_delegate onClickedGetPos];
}
- (void)onClickedRefreshInfo:(id)sender
{
    [_delegate onClickedRefreshInfo];
}
- (void)OnClickedCommit:(id)sender
{
    if ( _infoTextView == nil || [_infoTextView.text compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"评论内容不能为空" timer:2.0f];
        return;
    }
    [_infoTextView resignFirstResponder];
    [_delegate onClickedCmtInfo:_infoTextView.text];
}
-(void)onCancelKboradClicked:(id)sender
{
    if ( _infoTextView )
        [_infoTextView resignFirstResponder];
}
#pragma -mark from controller
- (void)updateBanner:(NSArray* _Nonnull)imgArray urlArray:(NSArray* _Nonnull)urlArray
{
    [_bannerView updateUI:imgArray urlArray:urlArray];
}
- (void)updateCityName:(NSString* _Nonnull) cityName
{
    [_posLabel setText:cityName];
}
- (void)updateNearbyShop:(NSArray* _Nonnull)shopArray
{
    for ( UIView* view in _shopNearlyView.subviews )
        [view removeFromSuperview];
    
    if ( DEF_NEARBY_COUNT_COL*DEF_NEARBY_COUNT_ROW < [shopArray count] )
        shopArray = [shopArray subarrayWithRange:NSMakeRange(0, DEF_NEARBY_COUNT_COL*DEF_NEARBY_COUNT_ROW-1)];
    
    // 自定义缩放比 网络图片时全尺寸 与iphone逻辑分辨率不同
    for (int i = 0; i < [shopArray count]; i ++)
    {
        float x = i % DEF_NEARBY_COUNT_COL * _shopNearlyView.frame.size.width / DEF_NEARBY_COUNT_COL + _shopNearlyView.frame.size.width / DEF_NEARBY_COUNT_COL / 2;
        float y = _shopNearlyView.frame.size.height / 4 + i / DEF_NEARBY_COUNT_COL * _shopNearlyView.frame.size.height / 2;
        CGPoint p = CGPointMake(x, y);
        
        UIImage* btnImg = [UIImage imageNamed:[NSString stringWithFormat:@"shop_icon_%d",i]];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
        [btn setImage:btnImg forState:UIControlStateNormal];
        btn.tag = i + DEF_TAG_BASE_NUM;
        [btn setCenter:p];
        [btn addTarget:self action:@selector(onClickedNearby:) forControlEvents:UIControlEventTouchUpInside];
        [_shopNearlyView addSubview:btn];
        
        ModelUserInfo* userInfo = shopArray[i];
        
        p.y += 30;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _shopNearlyView.frame.size.width / DEF_NEARBY_COUNT_COL, 10)];
        [lbl setText:userInfo.shopName];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setFont:[UIFont systemFontOfSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setCenter:p];
        [_shopNearlyView addSubview:lbl];
    }
}
- (void)update5StarShop:(NSArray* _Nonnull)shopArray
{
    for ( UIView* view in _star5ShopView.subviews )
        [view removeFromSuperview];
    
    if ( DEF_5STAR_COUNT_COL*DEF_5STAR_COUNT_ROW < [shopArray count] )
        shopArray = [shopArray subarrayWithRange:NSMakeRange(0, DEF_5STAR_COUNT_COL*DEF_5STAR_COUNT_ROW-1)];
    
    // 自定义缩放比 网络图片时全尺寸 与iphone逻辑分辨率不同
    for (int i = 0; i < [shopArray count]; i ++)
    {
        float x = i % DEF_5STAR_COUNT_COL * _star5ShopView.frame.size.width / DEF_5STAR_COUNT_COL + _star5ShopView.frame.size.width / DEF_5STAR_COUNT_COL / 2;
        float y = _star5ShopView.frame.size.height / 2 - 10;
        CGPoint p = CGPointMake(x, y);
        
        UIImage* btnImg = [UIImage imageNamed:@"star_5_icon"];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
        [btn setImage:btnImg forState:UIControlStateNormal];
        btn.tag = i + DEF_TAG_BASE_NUM;
        [btn setCenter:p];
        [btn addTarget:self action:@selector(onClicked5StarShop:) forControlEvents:UIControlEventTouchUpInside];
        [_star5ShopView addSubview:btn];
        
        ModelUserInfo* userInfo = shopArray[i];
        
        p.y += 35;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _star5ShopView.frame.size.width / DEF_5STAR_COUNT_COL, 10)];
        [lbl setText:userInfo.shopName];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setFont:[UIFont systemFontOfSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setCenter:p];
        [_star5ShopView addSubview:lbl];
    }
}
- (void)updateRepairService:(NSArray* _Nonnull)repairArray
{
    if ( DEF_ITEM_COUNT_COL*DEF_ITEM_COUNT_ROW < [repairArray count] )
        repairArray = [repairArray subarrayWithRange:NSMakeRange(0, DEF_ITEM_COUNT_COL*DEF_ITEM_COUNT_ROW-1)];
    
    // 自定义缩放比 网络图片时全尺寸 与iphone逻辑分辨率不同
    for (int i = 0; i < [repairArray count]; i ++)
    {
        float x = i % DEF_ITEM_COUNT_COL * _repairView.frame.size.width / DEF_ITEM_COUNT_COL + _repairView.frame.size.width / 10;
        float y = _repairView.frame.size.height / 4 + i / DEF_ITEM_COUNT_COL * _repairView.frame.size.height / 2;
        CGPoint p = CGPointMake(x, y);
        
        UIImage* btnImg = [UIImage imageNamed:@"transparent_90_90"];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
        [btn setImage:btnImg forState:UIControlStateNormal];
        btn.tag = i + DEF_TAG_BASE_NUM;
        [btn setCenter:p];
        [btn addTarget:self action:@selector(onClickedRepair:) forControlEvents:UIControlEventTouchUpInside];
        [_repairView addSubview:btn];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
        [imageView setOnlineImage:repairArray[i][@"cate_img"]];
        [imageView setCenter:CGPointMake(btn.frame.size.width/2, btn.frame.size.height/2)];
        [btn addSubview:imageView];
        
        p.y += 30;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _repairView.frame.size.width / DEF_ITEM_COUNT_COL, 10)];
        [lbl setText:repairArray[i][@"cate_name"]];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setFont:[UIFont systemFontOfSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setCenter:p];
        [_repairView addSubview:lbl];
    }
}
- (void)updateModifyService:(NSArray* _Nonnull)modifyArray
{
    if ( DEF_ITEM_COUNT_COL*DEF_ITEM_COUNT_ROW < [modifyArray count] )
        modifyArray = [modifyArray subarrayWithRange:NSMakeRange(0, DEF_ITEM_COUNT_COL*DEF_ITEM_COUNT_ROW-1)];
    
    // 自定义缩放比 网络图片时全尺寸 与iphone逻辑分辨率不同
    for (int i = 0; i < [modifyArray count]; i ++)
    {
        float x = i % DEF_ITEM_COUNT_COL * _modifyView.frame.size.width / DEF_ITEM_COUNT_COL + _modifyView.frame.size.width / 10;
        float y = _modifyView.frame.size.height / 4 + i / DEF_ITEM_COUNT_COL * _modifyView.frame.size.height / 2;
        CGPoint p = CGPointMake(x, y);
        
        UIImage* btnImg = [UIImage imageNamed:@"transparent_90_90"];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
        [btn setImage:btnImg forState:UIControlStateNormal];
        btn.tag = i + DEF_TAG_BASE_NUM;
        [btn setCenter:p];
        [btn addTarget:self action:@selector(onClickedModify:) forControlEvents:UIControlEventTouchUpInside];
        [_modifyView addSubview:btn];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width, btnImg.size.height)];
        [imageView setOnlineImage:modifyArray[i][@"cate_img"]];
        [imageView setCenter:CGPointMake(btn.frame.size.width/2, btn.frame.size.height/2)];
        [btn addSubview:imageView];
        
        p.y += 30;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _modifyView.frame.size.width / DEF_ITEM_COUNT_COL, 10)];
        [lbl setText:modifyArray[i][@"cate_name"]];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setFont:[UIFont systemFontOfSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setCenter:p];
        [_modifyView addSubview:lbl];
    }
}
- (void)updateBroadcastInfo:(NSArray* _Nonnull)broadcastArray
{
    [_marquee setText:broadcastArray];
}

#pragma -mark MyBannerViewDelegate
- (void)onClickedBannerURL:(NSString* _Nonnull)url
{
    [_delegate onClickedBannerURL:url];
}

#pragma mark - click event
- (void)onClickedNearby:(id)sender
{
    UIButton * clickBtn = (UIButton*)sender;
    NSInteger index = clickBtn.tag - DEF_TAG_BASE_NUM;
    [_delegate onClickedNearbyShop:index];
}
- (void)onClickedNearbyRefresh
{
    [_delegate onClickedNearbyShopRefresh];
}
- (void)onClickedNearbyMore
{
    [_delegate onClickedNearbyShopMore];
}
- (void)onClicked5StarShop:(id)sender
{
    UIButton * clickBtn = (UIButton*)sender;
    NSInteger index = clickBtn.tag - DEF_TAG_BASE_NUM;
    [_delegate onClicked5StarShop:index];
}
- (void)onClickedRepair:(id)sender
{
    UIButton * clickBtn = (UIButton*)sender;
    NSInteger index = clickBtn.tag - DEF_TAG_BASE_NUM;
    [_delegate onClickedRepair:index];
}
- (void)onClickedModify:(id)sender
{
    UIButton * clickBtn = (UIButton*)sender;
    NSInteger index = clickBtn.tag - DEF_TAG_BASE_NUM;
    [_delegate onClickedModify:index];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ( [textView.text compare:@""] == NSOrderedSame )
        textView.text = @"车辆丢失、车钥匙丢失、二手车买卖、专业开锁、求购二手车。。。等";
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString* cmtContent = textView.text;
    if ( 500 < [cmtContent length] )
    {
        [MyAlertNotice showMessage:@"字数超限" timer:2.0f];
        cmtContent = [cmtContent substringToIndex:500];
        [textView setText:cmtContent];
        
        return;
    }
    if ( 450 < [cmtContent length] )
    {
        [_infoCountLabel setTextColor:[UIColor redColor]];
    }
    
    [_infoCountLabel setText:[NSString stringWithFormat:@"%lu",[cmtContent length]]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ( _infoTextView )
        [_infoTextView resignFirstResponder];
}
@end
