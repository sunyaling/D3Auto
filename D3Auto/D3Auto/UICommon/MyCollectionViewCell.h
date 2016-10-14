/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A collection view cell that displays a thumbnail image.
  
 */

@import UIKit;


@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage* thumbnailImage;
@property (nonatomic, strong) UIImage* originalImage;

@property (nonatomic) BOOL isSelected;

@end
