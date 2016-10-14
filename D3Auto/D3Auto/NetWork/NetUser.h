//
//  NetUser.h
//  D3Auto
//
//  Created by zhongfang on 15/11/7.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetBase.h"

@interface NetUser : NetBase

+ (instancetype _Nonnull)sharedInstance;

// ------ 用户session校验
- (void)reqSessionVerify;

// ------ 用户注册
- (void)reqRegister:(void (^ _Nonnull)(id _Nonnull success))success
               fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
            account:(NSString* _Nonnull)account
           password:(NSString* _Nonnull)password email:(NSString* _Nonnull)email;

// ------ 用户登录
- (void)reqLogin:(void (^ _Nonnull)(id _Nonnull success))success
            fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
         account:(NSString* _Nonnull)account
        password:(NSString* _Nonnull)password
        userType:(NSString* _Nonnull)userType;

// ------ 用户登出
- (void)reqLogout:(void (^ _Nonnull)(id _Nonnull success))success
             fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure;

// ------ 用户基本信息修改
- (void)reqEditUserInfo:(void (^ _Nonnull)(id _Nonnull success))success
                   fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                account:(NSString* _Nullable)account
                  email:(NSString* _Nullable)email
                    sex:(NSString* _Nullable)sex
               birthday:(NSString* _Nullable)birthday
                     qq:(NSString* _Nullable)qq
                 mobile:(NSString* _Nullable)mobile
               oldPaswd:(NSString* _Nullable)oldPaswd
               newPaswd:(NSString* _Nullable)newPaswd;

// ------ 区域信息
- (void)reqRegion:(void (^ _Nonnull)(id _Nonnull success))success
             fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
         parentID:(int)parentID;

// ------ 增加4S店用户信息
- (void)reqAdd4SUser:(void (^ _Nonnull)(id _Nonnull success))success
                fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                 dic:(NSDictionary* _Nonnull)dic;

// ------ 增加汽修用户信息
- (void)reqAddRepairUser:(void (^ _Nonnull)(id _Nonnull success))success
                    fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                     dic:(NSDictionary* _Nonnull)dic;

// ------ 上传商店图片
- (void)reqUploadPhotos:(void (^ _Nonnull)(id _Nonnull success))success
                   fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                process:(void (^ _Nonnull)(long long totalBytesWritten, long long totalBytesExpectedToWrite))process
             photoArray:(NSArray* _Nonnull)array;

// ------ 提交广播信息
- (void)reqBroadcastCmt:(void (^ _Nonnull)(id _Nonnull success))success
                   fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                   info:(NSString* _Nonnull)info;

// ------ 拉取广播信息列表
- (void)reqBroadcastList:(void (^ _Nonnull)(id _Nonnull success))success
                    fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure;

@end
