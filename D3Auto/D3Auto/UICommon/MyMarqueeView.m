//
//  MyMarqueeView.m
//  D3Auto
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "MyMarqueeView.h"

#import "Utils.h"

@interface MyMarqueeView()
{
    NSTimer *_timer;                    // 定时器
    
    NSMutableArray* _textArray;         // 显示的文本序列
    NSUInteger _currentIndex;           // 当前文字索引
    
    CGRect _frame;                      // 控件的框架大小
    
    UIFont *_font;                      // 文本的字体
    CGFloat _fontSize;
    
    CGFloat _XOffset;                   // 定时器每次执行偏移后，累计的偏移量之和
    
    CGSize _curTextSize;                // 当前显示文本的框架大小
}

@end


@implementation MyMarqueeView

#pragma mark -
#pragma mark 内部调用

#define OFFSET_ONCE -1

- (id)initWithFrame:(CGRect)frame textArray:(NSMutableArray *)textArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if ( textArray == nil )
            _textArray = [[NSMutableArray alloc] init];
        else
            _textArray = [[NSMutableArray alloc] initWithArray:textArray];
        
        if ( [_textArray count] <= 0 )
            [_textArray addObject:@"暂无信息"];
        
        _frame = frame;
        _currentIndex = 0;
        
        _fontSize = 16.0F;
        _font = [UIFont systemFontOfSize:_fontSize];
        self.backgroundColor = [UIColor clearColor];

        _XOffset = frame.size.width;
        
        _curTextSize = [self computeTextSize:[_textArray objectAtIndex:0]];
        
        [self startRun];
    }
    return self;
}

//改变一个TRect的起始点位置，但是其终止店点的位置不变，因此会导致整个框架大小的变化
- (CGRect)moveNewPoint:(CGPoint)point rect:(CGRect)rect
{
    CGSize tmpSize;
    tmpSize.height = rect.size.height + (rect.origin.y - point.y);
    tmpSize.width = rect.size.width + (rect.origin.x - point.x);
    return CGRectMake(point.x, point.y, tmpSize.width, tmpSize.height);
}

//开启定时器
- (void)startRun
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

//关闭定时器
- (void)cancelRun
{
    if (_timer)
    {
        [_timer invalidate];
    }
}

//定时器执行的操作
- (void)timerAction
{
    _XOffset += OFFSET_ONCE;
    if (_XOffset + _curTextSize.width<= 0)
    {
        _currentIndex += 1;
        if ( [_textArray count] <= _currentIndex )
            _currentIndex = 0;
        
        _curTextSize = [self computeTextSize:[_textArray objectAtIndex:_currentIndex]];
        
        _XOffset += _curTextSize.width;
        _XOffset += _frame.size.width;
    }
    [self setNeedsDisplay];
    
}

//计算在给定字体下，文本仅显示一行需要的框架大小
- (CGSize)computeTextSize:(NSString *)text
{
    if ( text == nil )
        return CGSizeMake(0, 0);
    
    float stringW = [Utils widthForString:text fontSize:_fontSize];
    float stringH = _fontSize;

    return CGSizeMake(stringW, stringH);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    // Drawing code
    CGFloat startYOffset = (rect.size.height - _curTextSize.height)/2;
    rect = [self moveNewPoint:CGPointMake(_XOffset, startYOffset) rect:rect];
        
    while (0 <= rect.size.width)
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
        NSString* strText = [_textArray objectAtIndex:_currentIndex];
        if ( strText == nil )
            continue;
        [strText drawAtPoint:CGPointMake(rect.origin.x, rect.origin.y) withAttributes:dic];
            
        rect = [self moveNewPoint:CGPointMake(rect.origin.x+_curTextSize.width+_frame.size.width, rect.origin.y) rect:rect];
    }
}

#pragma mark -
#pragma mark 外部调用
- (void)setFont:(UIFont *)font size:(float)fontSize
{
    _font = font;
    _fontSize = fontSize;
}
- (void)setText:(NSArray *)textArray
{
    [_textArray removeAllObjects];
    [_textArray addObjectsFromArray:textArray];
    if ( [_textArray count] <= 0 )
        [_textArray addObject:@"暂无信息"];
    
    _currentIndex = 0;
    _XOffset = _frame.size.width;
    _curTextSize = [self computeTextSize:[_textArray objectAtIndex:0]];
}

@end
