//
//  View4SCarDetailRoot.h
//  D3Auto
//
//  Created by zhongfang on 15/11/3.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Model4SCarDetail.h"

@protocol View4SCarDetailRootDelegate <NSObject>

@required
- (void)onClickedShowGallery;                               // 点击显示相册

- (void)onClickedDetaiInfo;                                 // 点击车辆详情进入详情界面

- (void)onClickedDealerInfo;                                // 点击经销商

- (void)onClickedPriceList:(NSString* _Nonnull)attrID;      // 点击进入价格列表

@end



@interface View4SCarDetailRoot : UIView

@property (nullable, nonatomic, weak) id <View4SCarDetailRootDelegate> delegate;

@property (nullable, nonatomic, weak) Model4SCarDetail* model4SCarDetail;

- (void)updateCarDetail;

@end
