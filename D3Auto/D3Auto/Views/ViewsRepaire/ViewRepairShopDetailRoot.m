//
//  ViewRepairShopDetailRoot.m
//  D3Auto
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ViewRepairShopDetailRoot.h"

#import "Utils.h"
#import "Config.h"
#import "MyGalleryView.h"


@interface ViewRepairShopDetailRoot()
{
    MyGalleryView*          _galleryView;
    
    UILabel*                _nameLabel;
    UILabel*                _addressLabel;
    UILabel*                _telLabel;
    UILabel*                _mobileLabel;
    
    UIImageView*            _star1View;
    UIImageView*            _star2View;
    UIImageView*            _star3View;
    UIImageView*            _star4View;
    UIImageView*            _star5View;
}
@end


@implementation ViewRepairShopDetailRoot

@synthesize delegate = _delegate;

@synthesize modelShopDetail = _modelShopDetail;

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
    self.frame = frame;
    self.backgroundColor = DEF_COLOR_BG;
    
    CGPoint relaPos = CGPointMake(0, 0);
    float height = 300;
    
    // 相册
    _galleryView = [[MyGalleryView alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y, frame.size.width, height)];
    [self addSubview:_galleryView];
    
    // 名称 地址 电话
    relaPos.y = relaPos.y + height + 10;
    height = 100;
    UIView* baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, relaPos.y, frame.size.width, height)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:baseInfoView];
    
    CGPoint infoPos = CGPointMake(15, 5);
    float infoH = 20;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoPos.x, infoPos.y, frame.size.width-2*infoPos.x, infoH)];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setText:@"店铺名称"];
    [_nameLabel setTextColor:[UIColor grayColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:17]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [baseInfoView addSubview:_nameLabel];
    
    infoPos.y = infoPos.y + infoH + 5;
    infoH = 20;
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoPos.x, infoPos.y, frame.size.width-2*infoPos.x, infoH)];
    [_addressLabel setBackgroundColor:[UIColor clearColor]];
    [_addressLabel setText:@"店铺地址"];
    [_addressLabel setTextColor:[UIColor lightGrayColor]];
    [_addressLabel setFont:[UIFont systemFontOfSize:15]];
    [_addressLabel setTextAlignment:NSTextAlignmentLeft];
    [baseInfoView addSubview:_addressLabel];
    
    // 拨打座机
    infoPos.y = infoPos.y + infoH + 5;
    infoH = 40;
    _telLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - infoH, frame.size.width/2, infoH)];
    [_telLabel setTextColor:DEF_COLOR_LGTBLUE];
    [_telLabel.layer setBorderColor:DEF_COLOR_BG.CGColor];
    [_telLabel.layer setBorderWidth:0.5f];
    [_telLabel setTextAlignment:NSTextAlignmentCenter];
    [_telLabel setFont:[UIFont systemFontOfSize:12]];
    [baseInfoView addSubview:_telLabel];
    _telLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCallTel:)];
    [_telLabel addGestureRecognizer:gesture];
    
    // 拨打手机
    _mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, height - infoH, frame.size.width/2, infoH)];
    [_mobileLabel setTextColor:DEF_COLOR_LGTBLUE];
    [_mobileLabel.layer setBorderColor:DEF_COLOR_BG.CGColor];
    [_mobileLabel.layer setBorderWidth:0.5f];
    [_mobileLabel setTextAlignment:NSTextAlignmentCenter];
    [_mobileLabel setFont:[UIFont systemFontOfSize:12]];
    [baseInfoView addSubview:_mobileLabel];
    _mobileLabel.userInteractionEnabled = YES;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCallMobile:)];
    [_mobileLabel addGestureRecognizer:gesture];
    
    
    // 星级
    relaPos.y = relaPos.y + height + 10;
    height = 40;
    UIView* starLevelView = [[UIView alloc] initWithFrame:CGRectMake(relaPos.x, relaPos.y, frame.size.width-2*relaPos.x, height)];
    [starLevelView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:starLevelView];
    
    NSString* starWds = @"星级：";
    float starWdsW = [Utils widthForString:starWds fontSize:15];
    UILabel* starNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, starWdsW, height)];
    [starNameLabel setBackgroundColor:[UIColor clearColor]];
    [starNameLabel setText:starWds];
    [starNameLabel setTextColor:[UIColor lightGrayColor]];
    [starNameLabel setFont:[UIFont systemFontOfSize:15]];
    [starLevelView addSubview:starNameLabel];
    
    int distance = 10;      // 星星之间的距离
    UIImage* starImg = [UIImage imageNamed:@"star_lvl_dis"];
    
    _star1View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, starImg.size.width, starImg.size.height)];
    [_star1View setImage:starImg];
    [_star1View setCenter:CGPointMake(starNameLabel.frame.origin.x + starNameLabel.frame.size.width + distance + starImg.size.width/2, height/2)];
    [starLevelView addSubview:_star1View];
    
    _star2View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, starImg.size.width, starImg.size.height)];
    [_star2View setImage:starImg];
    [_star2View setCenter:CGPointMake(_star1View.frame.origin.x + _star1View.frame.size.width + distance, height/2)];
    [starLevelView addSubview:_star2View];
    
    _star3View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, starImg.size.width, starImg.size.height)];
    [_star3View setImage:starImg];
    [_star3View setCenter:CGPointMake(_star2View.frame.origin.x + _star2View.frame.size.width + distance, height/2)];
    [starLevelView addSubview:_star3View];
    
    _star4View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, starImg.size.width, starImg.size.height)];
    [_star4View setImage:starImg];
    [_star4View setCenter:CGPointMake(_star3View.frame.origin.x + _star3View.frame.size.width + distance, height/2)];
    [starLevelView addSubview:_star4View];
    
    _star5View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, starImg.size.width, starImg.size.height)];
    [_star5View setImage:starImg];
    [_star5View setCenter:CGPointMake(_star4View.frame.origin.x + _star4View.frame.size.width + distance, height/2)];
    [starLevelView addSubview:_star5View];
}

- (void)updateShopDetail
{
    [_nameLabel  setText:_modelShopDetail.shopName];
    [_addressLabel setText:_modelShopDetail.shopAddress];
    [_telLabel setText:[NSString stringWithFormat:@"拨打座机：%@",_modelShopDetail.shopTel]];
    [_mobileLabel setText:[NSString stringWithFormat:@"拨打手机：%@",_modelShopDetail.shopMobile]];
    
    if ( 1 <= _modelShopDetail.starLevel )
    {
        [_star1View  setImage:[UIImage imageNamed:@"star_lvl_ena"]];
    }
    if ( 2 <= _modelShopDetail.starLevel )
    {
        [_star2View  setImage:[UIImage imageNamed:@"star_lvl_ena"]];
    }
    if ( 3 <= _modelShopDetail.starLevel )
    {
        [_star3View  setImage:[UIImage imageNamed:@"star_lvl_ena"]];
    }
    if ( 4 <= _modelShopDetail.starLevel )
    {
        [_star4View  setImage:[UIImage imageNamed:@"star_lvl_ena"]];
    }
    if ( 5 <= _modelShopDetail.starLevel )
    {
        [_star5View  setImage:[UIImage imageNamed:@"star_lvl_ena"]];
    }
    
    NSMutableArray* galleryArray = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [_modelShopDetail.galleryArray count]; i++ )
    {
        ModelRepairShopGallery* gallery = [_modelShopDetail.galleryArray objectAtIndex:i];
        [galleryArray addObject:gallery.imgNormal];
    }
    [_galleryView updateWithDataArray:galleryArray];
}

#pragma mark - on clicked event
- (void)onClickedCallTel:(UITapGestureRecognizer*)sender
{
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_modelShopDetail.shopTel]]]];
    [self addSubview:callWebview];
}

- (void)onClickedCallMobile:(UITapGestureRecognizer*)sender
{
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_modelShopDetail.shopMobile]]]];
    [self addSubview:callWebview];
}


@end
