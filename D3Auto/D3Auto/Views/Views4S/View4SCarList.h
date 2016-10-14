//
//  View4SCarList.h
//  D3Auto
//
//  Created by zhongfang on 15/11/2.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol View4SCarListDelegate <NSObject>

@required
- (void)onClickedCar:(NSString* _Nonnull)carID;


@end


@interface View4SCarList : UIView

@property (nullable, nonatomic, weak) id <View4SCarListDelegate> delegate;


- (void)onUpdateCarList:(NSArray* _Nonnull)carListArray;

@end
