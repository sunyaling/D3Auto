//
//  MineRoot.h
//  D3Auto
//
//  Created by zhongfang on 15/11/6.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewMineRootDelegate <NSObject>

@required
- (void)onClickedLogin;
- (void)onClickedLogout;
- (void)onClickedHelp;
- (void)onClickedAbout;

@end


@interface ViewMineRoot : UIView

@property (nonnull, nonatomic, strong) id <ViewMineRootDelegate> delegate;

@property (nonatomic) BOOL isLogin;


- (void)onUpdateViewUI;

@end
