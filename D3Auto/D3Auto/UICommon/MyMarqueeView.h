//
//  MyMarqueeView.h
//  D3Auto
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyMarqueeView : UIView


- (id)initWithFrame:(CGRect)frame textArray:(NSMutableArray *)textArray;

- (void)setFont:(UIFont *)font size:(float)fontSize;
- (void)setText:(NSArray *)textArray;

@end