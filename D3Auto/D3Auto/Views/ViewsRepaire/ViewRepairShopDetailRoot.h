//
//  ViewRepairShopDetailRoot.h
//  D3Auto
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelRepairShopDetail.h"


@protocol ViewRepairShopDetailRootDelegate <NSObject>

@end


@interface ViewRepairShopDetailRoot : UIView

@property (nullable, nonatomic, weak) id <ViewRepairShopDetailRootDelegate> delegate;

@property (nullable, nonatomic, weak) ModelRepairShopDetail* modelShopDetail;



- (void)updateShopDetail;


@end
