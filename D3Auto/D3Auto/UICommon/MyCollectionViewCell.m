/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A collection view cell that displays a thumbnail image.
  
 */

#import "MyCollectionViewCell.h"

@interface MyCollectionViewCell ()


@property (nonatomic, strong) UIImageView *imageView;

@end



@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)];
        [self addSubview:self.imageView];
        self.isSelected = NO;
    }
    return self;
}


- (void)setThumbnailImage:(UIImage *)thumbnailImage
{
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    self.imageView.image = originalImage;
}

@end
