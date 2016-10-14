//
//  MyImgBrowserController.m
//  D3Auto
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "MyImgBrowserController.h"

#import "Config.h"
#import "RDVTabBarController.h"
#import "UIImageView+OnlineImage.h"

#define ZOOM_STEP 1.5

@interface MyImgBrowserController () <UIScrollViewDelegate>
{
    UIScrollView*           _scrollView;
}

@property (nonnull, nonatomic, strong) NSMutableArray* imgArray;

@end

@implementation MyImgBrowserController

@synthesize imgArray = _imgArray;

- (instancetype)initWithImageArray:(NSArray* _Nonnull)imageArray
{
    if ( self = [super init] )
    {
        [self initDataWithImageArray:imageArray];
        [self initUI];
    }
    return self;
}

- (void)initDataWithImageArray:(NSArray* _Nonnull)imageArray
{
    _imgArray = [[NSMutableArray alloc] initWithArray:imageArray];
}

- (void)initUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_scrollView setBackgroundColor:[UIColor blackColor]];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setDelegate:self];
    [_scrollView setBouncesZoom:YES];
    [self.view addSubview:_scrollView];
    
    for ( int i = 0; i < [_imgArray count]; i++ )
    {
        UIImageView* imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, 0)];
        //[imageView setIsMatchW:YES];
        [imageView setTag:(DEF_TAG_BASE_NUM+i)];
        [imageView setUserInteractionEnabled:YES];
        
        // add gesture recognizers to the image view
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
        
        [doubleTap setNumberOfTapsRequired:2];
        [twoFingerTap setNumberOfTouchesRequired:2];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [imageView addGestureRecognizer:twoFingerTap];
        
        // 初始化时 先设置第一张图片
        if ( i == 0 )
            [imageView setOnlineImage:[_imgArray objectAtIndex:i]];
        
        [_scrollView addSubview:imageView];
    }
    
    // TODO: contentSize.y 为0时可能会放大
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * [_imgArray count], 0)];//_scrollView.frame.size.height)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:YES animated:YES];
    
    if ( [_imgArray count] <= 0 )
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"相册数据为空！" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){[self.navigationController popViewControllerAnimated:YES];}];
        [alert addAction:btnAction];
        [self presentViewController: alert animated: YES completion: nil];
    }
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return [_scrollView viewWithTag:(currentPage+DEF_TAG_BASE_NUM)];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    UIImageView* imageView = [_scrollView viewWithTag:(currentPage+DEF_TAG_BASE_NUM)];
    [imageView setOnlineImage:[_imgArray objectAtIndex:currentPage]];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    // single tap does nothing for now
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:!navigationController.navigationBarHidden animated:YES];
    
    NSLog(@"handleSingleTap");
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    // double tap zooms in
    float newScale = [_scrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
    
    
    NSLog(@"handleDoubleTap with scale is: %f ", newScale);
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer
{
    // two-finger tap zooms out
    float newScale = [_scrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
    
    
    NSLog(@"handleTwoFingerTap with scale is: %f ", newScale);
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [_scrollView frame].size.height / scale;
    zoomRect.size.width  = [_scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



@end

