//
//  DataCenter.h
//  D3Auto
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelUserInfo.h"

@interface DataCenter : NSObject

+ (instancetype _Nonnull)sharedInstance;

// session dictionary 信息不存在返回nil
- (NSDictionary* _Nullable)getSessionDic;

// page dictionary 页码信息
- (NSDictionary* _Nullable)getPaginationDic:(NSInteger)page count:(NSInteger)count;

// 清空登陆信息
- (void)cleanLoginInfo;

// 用户登录返回数据 持久化
- (void)storageUserInfo:(NSDictionary* _Nonnull)userDic
                session:(NSDictionary* _Nonnull)sessionDic;



@end
