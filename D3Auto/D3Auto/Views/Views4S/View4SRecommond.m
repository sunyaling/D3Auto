//
//  View4SRecommond.m
//  D3Auto
//
//  Created by zhongfang on 15/10/30.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "View4SRecommond.h"

@interface View4SRecommond()
{
    CGRect              _thisFrame;
    
    NSMutableArray*     _brandRecmdArray;
    NSMutableArray*     _carRecmdArray;
}

@end


@implementation View4SRecommond

#define DEF_BRAND_NUM   5
#define DEF_CAR_NUM     3

@synthesize delegate = _delegate;

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
    _thisFrame = CGRectMake(0, 0, 0, 0);
    
    _brandRecmdArray = [[NSMutableArray alloc] init];
    _carRecmdArray = [[NSMutableArray alloc] init];
}

- (void)initUIWithFrame:(CGRect)frame
{
    _thisFrame = frame;
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 重磅推荐
    float height = 14;
    UILabel* rcmdLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, -height - 3, frame.size.width - 30, height)];
    [rcmdLabel setText:@"重磅推荐"];
    [rcmdLabel setTextAlignment:NSTextAlignmentLeft];
    [rcmdLabel setTextColor:[UIColor lightGrayColor]];
    [rcmdLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:rcmdLabel];
}

- (void)updateUI
{
    if ( [_brandRecmdArray count] <=0 || [_carRecmdArray count] <= 0 )
        return;
    
    while ( DEF_BRAND_NUM < [_brandRecmdArray count] )
    {
        [_brandRecmdArray removeLastObject];
    }
    
    while ( DEF_CAR_NUM < [_carRecmdArray count] )
    {
        [_carRecmdArray removeLastObject];
    }
    
    // 品牌推荐
    float fScale = 0.5f;        // 自定义缩放比
    for (int i = 0; i < [_brandRecmdArray count]; i ++)
    {
        CGPoint p = CGPointMake(_thisFrame.size.width / 2 / DEF_BRAND_NUM + i * _thisFrame.size.width / DEF_BRAND_NUM, _thisFrame.size.height / 5);
        
        UIImage* btnImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_brandRecmdArray[i][@"cate_img"]]]];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width*fScale, btnImg.size.height*fScale)];
        [btn setImage:btnImg forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = i + 1000;
        [btn setCenter:p];
        [btn addTarget:self action:@selector(onClickedBtnBrand:) forControlEvents:UIControlEventTouchUpInside];
        
        p.y += 30;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _thisFrame.size.width / DEF_BRAND_NUM, 10)];
        [lbl setText:_brandRecmdArray[i][@"cate_name"]];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setFont:[UIFont systemFontOfSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setCenter:p];
        [self addSubview:lbl];
    }
    
    // 车辆推荐
    fScale = 0.5f;
    for (int i = 0; i < [_carRecmdArray count]; i ++)
    {
        CGPoint p = CGPointMake(_thisFrame.size.width / 2 / DEF_CAR_NUM + i * _thisFrame.size.width / DEF_CAR_NUM, _thisFrame.size.height * 3.5 / 5);
        
        UIImage* btnImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_carRecmdArray[i][@"car_img"]]]];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnImg.size.width*fScale, btnImg.size.height*fScale)];
        [btn setImage:btnImg forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = i + 1000;
        [btn setCenter:p];
        [btn addTarget:self action:@selector(onClickedBtnCar:) forControlEvents:UIControlEventTouchUpInside];
        
        p.y += 30;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _thisFrame.size.width / DEF_CAR_NUM, 10)];
        [lbl setText:_carRecmdArray[i][@"car_name"]];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setFont:[UIFont systemFontOfSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setCenter:p];
        [self addSubview:lbl];
    }
}

#pragma -mark clicked event
-(void)onClickedBtnBrand:(id)sender
{
    UIButton * clickBtn = (UIButton*)sender;
    NSLog(@"The button's tag you clicked is: %ld", clickBtn.tag);
    
    NSInteger index = clickBtn.tag - 1000;
    NSDictionary* dic = _brandRecmdArray[index];
    [_delegate onClickedRecommond:YES andClickedID:[dic valueForKey:@"cate_id"]];
}

-(void)onClickedBtnCar:(id)sender
{
    UIButton * clickBtn = (UIButton*)sender;
    NSLog(@"The button's tag you clicked is: %ld", clickBtn.tag);
    
    NSInteger index = clickBtn.tag - 1000;
    NSDictionary* dic = _carRecmdArray[index];
    [_delegate onClickedRecommond:NO andClickedID:[dic valueForKey:@"car_id"]];
}


#pragma -mark controller -> rootview -> here
- (void)onUpdateRecommond:(NSMutableArray* _Nonnull)brandArray andCarArray:(NSMutableArray* _Nonnull)carArray
{
    [_brandRecmdArray removeAllObjects];
    [_carRecmdArray removeAllObjects];
    
    [_brandRecmdArray addObjectsFromArray:brandArray];
    [_carRecmdArray addObjectsFromArray:carArray];
    
    [self updateUI];
}

@end
