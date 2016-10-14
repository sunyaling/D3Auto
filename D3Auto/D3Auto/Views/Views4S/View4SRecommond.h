//
//  View4SRecommond.h
//  D3Auto
//
//  Created by zhongfang on 15/10/30.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol View4SRecommondDelegate <NSObject>

@required
- (void)onClickedRecommond:(BOOL)isBrand andClickedID:(NSString* _Nonnull)clickedID;                 // 点击推荐调用 isBrand:品牌或车型  clickedID:选中的ID

@end



@interface View4SRecommond : UIView

@property (nullable, nonatomic, weak) id <View4SRecommondDelegate> delegate;

- (void)onUpdateRecommond:(NSMutableArray* _Nonnull)brandArray andCarArray:(NSMutableArray* _Nonnull)carArray;

@end
