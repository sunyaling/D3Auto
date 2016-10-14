//
//  MyArticleCell.m
//  D3Auto
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "MyArticleCell.h"

@implementation MyArticleCell

@synthesize timeLabel = _timeLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setTextColor:[UIColor lightGrayColor]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int timeLbH = 12;
    [_timeLabel setFrame:CGRectMake(self.frame.size.width/2-10, self.frame.size.height-timeLbH-5, self.frame.size.width/2, timeLbH)];
    [_timeLabel setFont:[UIFont systemFontOfSize:(timeLbH-2)]];
    
    int imageViewY = self.imageView.frame.origin.y;
    CGRect r = self.textLabel.frame;
    self.textLabel.frame = CGRectMake(r.origin.x, imageViewY, r.size.width, r.size.height);
}

@end
