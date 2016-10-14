//
//  MyGalleryView.m
//  D3Auto
//
//  Created by zhongfang on 15/11/3.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "MyGalleryView.h"

#import "Model4SCarDetail.h"
#import "UIImageView+OnlineImage.h"

@interface MyGalleryView () <UIScrollViewDelegate>
{
    UIScrollView*           _scrollView;
    
    UILabel*                _posLabel;              // 位置显示
}
@end


@implementation MyGalleryView

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
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setDelegate:self];
    
    [self addSubview:_scrollView];
    
    _posLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-30-10, frame.size.height-30-10, 30, 30)];
    [_posLabel setBackgroundColor:[UIColor clearColor]];
    [_posLabel setTextColor:[UIColor whiteColor]];
    [_posLabel setFont:[UIFont systemFontOfSize:13]];
    [_posLabel setTextAlignment:NSTextAlignmentCenter];
    [_posLabel.layer setCornerRadius:15.0];
    [_posLabel.layer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f].CGColor];
    [_posLabel setText:@"0/0"];
    [_posLabel setTag:0];           // tag存总数
    [self addSubview:_posLabel];
}


-(void)updateWithDataArray:(NSMutableArray*)galleryArray
{
    CGRect r = self.frame;
    
    for (int i = 0; i < [galleryArray count]; i ++)
    {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:r ];
        [iv setOnlineImage:galleryArray[i]];
        [iv setCenter:CGPointMake(r.size.width/2 + i*r.size.width, r.size.height/2)];
        [_scrollView addSubview:iv];
    }
    
    [_scrollView setContentSize:CGSizeMake(r.size.width * [galleryArray count], 0)];
    
    NSInteger currentCount = 0;
    if ( [galleryArray count] <= 0 )
        currentCount = 0;
    
    NSString* strPos = [NSString stringWithFormat:@"%ld/%ld", currentCount, [galleryArray count]];
    [_posLabel setTag:[galleryArray count]];
    [_posLabel setText:strPos];
}

// 页码显示
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.frame.size.width;
    
    int currentPage = abs((int)_scrollView.contentOffset.x) / pagewidth + 1;
    [_posLabel setText:[NSString stringWithFormat:@"%d/%ld", currentPage, _posLabel.tag]];
}


@end