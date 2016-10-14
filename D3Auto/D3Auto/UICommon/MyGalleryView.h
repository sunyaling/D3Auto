//
//  MyGalleryView.h
//  D3Auto
//
//  Created by zhongfang on 15/11/3.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGalleryView : UIView


// 刷新相册 array的每一个元素都是图片的url
- (void)updateWithDataArray:(NSMutableArray*)galleryArray;

@end



