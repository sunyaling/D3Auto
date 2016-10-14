//
//  MineRoot.m
//  D3Auto
//
//  Created by zhongfang on 15/11/6.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ViewMineRoot.h"

#import "Config.h"
#import "ModelUserInfo.h"
#import "MyAlertNotice.h"

@interface ViewMineRoot() <UIScrollViewDelegate>
{
    UIScrollView*       _scrollView;
    
    UILabel*            _accountLabel;
    UILabel*            _typeLabel;
    
}
@end

@implementation ViewMineRoot

@synthesize delegate = _delegate;

@synthesize isLogin = _isLogin;

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
    _isLogin = NO;
}

- (void)initUIWithFrame:(CGRect)frame
{
    [self setBackgroundColor:DEF_COLOR_BG];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [_scrollView setAlwaysBounceVertical:YES];
    [self addSubview:_scrollView];
    
    CGPoint pos = CGPointMake(0, 0);
    float height = 0;
    
    // 账号信息背景
    UIImage* infoBGImg = [UIImage imageNamed:@"mine_user_info_bg"];
    height = infoBGImg.size.height;
    UIImageView* infoBG = [[UIImageView alloc] initWithFrame:CGRectMake(pos.x, pos.y, frame.size.width, height)];
    [infoBG setImage:infoBGImg];
    infoBG.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedLogin)];
    [infoBG addGestureRecognizer:tapGesture];
    [_scrollView addSubview:infoBG];
    
    UIImage* headerBGImg = [UIImage imageNamed:@"mine_user_header"];
    UIImageView* headerBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerBGImg.size.width, headerBGImg.size.height)];
    [headerBG setCenter:CGPointMake(headerBGImg.size.width, height/2)];
    [headerBG setImage:headerBGImg];
    [infoBG addSubview:headerBG];
    
    float accountLabelX = headerBG.frame.origin.x+headerBG.frame.size.width+20;
    float accountLabelH = 20;
    _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(accountLabelX, headerBG.frame.origin.y, frame.size.width-accountLabelX, accountLabelH)];
    [_accountLabel setText:@""];
    [_accountLabel setTextColor:[UIColor whiteColor]];
    [_accountLabel setTextAlignment:NSTextAlignmentLeft];
    [_accountLabel setFont:[UIFont systemFontOfSize:18]];
    [infoBG addSubview:_accountLabel];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(accountLabelX, _accountLabel.frame.origin.y+accountLabelH+10, frame.size.width-accountLabelX, accountLabelH)];
    [_typeLabel setText:@""];
    [_typeLabel setTextColor:[UIColor whiteColor]];
    [_typeLabel setTextAlignment:NSTextAlignmentLeft];
    [_typeLabel setFont:[UIFont systemFontOfSize:18]];
    [infoBG addSubview:_typeLabel];
    
    UIView* countMngView = [[UIView alloc] initWithFrame:CGRectMake(0, height-20, frame.size.width, 20)];
    [countMngView setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3]];
    [infoBG addSubview:countMngView];
    UILabel* countMngLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height-20, frame.size.width-30, 20)];
    [countMngLabel setText:@"账户管理 >"];
    [countMngLabel setNumberOfLines:1];
    [countMngLabel setTextColor:[UIColor lightGrayColor]];
    [countMngLabel setTextAlignment:NSTextAlignmentRight];
    [countMngLabel setFont:[UIFont systemFontOfSize:12]];
    [infoBG addSubview:countMngLabel];
    
    // 帮助
    pos.y = pos.y + height + 12;
    height = 40;
    UIView* helpView = [[UIView alloc] initWithFrame:CGRectMake(0, pos.y, frame.size.width, height)];
    [helpView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:helpView];
    helpView.userInteractionEnabled = YES;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedHelp)];
    [helpView addGestureRecognizer:tapGesture];
    
    UIImageView* helpIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    [helpIcon setImage:[UIImage imageNamed:@"mine_btn_icon_help"]];
    [helpView addSubview:helpIcon];
    
    CGRect helpFrame = helpView.frame;
    UILabel* helpLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, helpFrame.size.width-120, helpFrame.size.height)];
    [helpLable setText:@"帮助"];
    [helpLable setNumberOfLines:1];
    [helpLable setTextColor:[UIColor grayColor]];
    [helpLable setTextAlignment:NSTextAlignmentLeft];
    [helpLable setFont:[UIFont systemFontOfSize:14]];
    [helpView addSubview:helpLable];
    
    // 关于
    pos.y = pos.y + height + 12;
    height = 40;
    UIView* aboutView = [[UIView alloc] initWithFrame:CGRectMake(0, pos.y, frame.size.width, height)];
    [aboutView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:aboutView];
    aboutView.userInteractionEnabled = YES;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedAbout)];
    [aboutView addGestureRecognizer:tapGesture];
    
    UIImageView* adviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    [adviceIcon setImage:[UIImage imageNamed:@"mine_btn_icon_about"]];
    [aboutView addSubview:adviceIcon];
    
    CGRect adviceBtnF = aboutView.frame;
    UILabel* adviceLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, adviceBtnF.size.width-120, adviceBtnF.size.height)];
    [adviceLable setText:@"关于"];
    [adviceLable setNumberOfLines:1];
    [adviceLable setTextColor:[UIColor grayColor]];
    [adviceLable setTextAlignment:NSTextAlignmentLeft];
    [adviceLable setFont:[UIFont systemFontOfSize:14]];
    [aboutView addSubview:adviceLable];
    
    // 登出
    pos.y = pos.y + height + 12;
    height = 40;
    UIView* logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, pos.y, frame.size.width, height)];
    [logoutView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:logoutView];
    logoutView.userInteractionEnabled = YES;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedLogout)];
    [logoutView addGestureRecognizer:tapGesture];
    
    UIImageView* logoutIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    [logoutIcon setImage:[UIImage imageNamed:@"mine_btn_icon_logout"]];
    [logoutView addSubview:logoutIcon];
    
    CGRect logoutBtnF = aboutView.frame;
    UILabel* logoutLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, logoutBtnF.size.width-120, logoutBtnF.size.height)];
    [logoutLable setText:@"登出"];
    [logoutLable setNumberOfLines:1];
    [logoutLable setTextColor:[UIColor grayColor]];
    [logoutLable setTextAlignment:NSTextAlignmentLeft];
    [logoutLable setFont:[UIFont systemFontOfSize:14]];
    [logoutView addSubview:logoutLable];
    
}

#pragma mark - clicked event
- (void)onClickedLogin
{
    if ( _delegate )
        [_delegate onClickedLogin];
}
- (void)onClickedLogout
{
    if ( _delegate )
        [_delegate onClickedLogout];
}
- (void)onClickedHelp
{
    if ( _delegate )
        [_delegate onClickedHelp];
}
- (void)onClickedAbout
{
    if ( _delegate )
        [_delegate onClickedAbout];
}

#pragma mark - controller notice
- (void)onUpdateViewUI
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:DEF_KEY_IS_LOGIN];
    if ( !_isLogin && isLogin )
        [MyAlertNotice showMessage:@"登录成功" timer:1.0f];
    
    _isLogin = isLogin;
    [_accountLabel setText:@""];
    [_typeLabel setText:@""];
    
    if ( _isLogin )
    {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_KEY_USER_INFO];
        ModelUserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ( userInfo == nil )
            return;
        
        [_accountLabel setText:userInfo.account];
        [_typeLabel setText:@"普通用户"];
        
        if ( [userInfo.account intValue] == ENUM_ACCOUNT_TYPE_4S )
        {
            [_typeLabel setText:@"4S店用户"];
        }
        else if ( [userInfo.account intValue] == ENUM_ACCOUNT_TYPE_REPAIR )
        {
            [_typeLabel setText:@"汽修店用户"];
        }
    }
}


@end
