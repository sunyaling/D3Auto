//
//  NetUser.m
//  D3Auto
//
//  Created by zhongfang on 15/11/7.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetUser.h"

#import "DataCenter.h"
#import "MyAlertNotice.h"

@implementation NetUser

static NetUser * instance;

+ (instancetype)sharedInstance
{
    if (instance == nil)
    {
        instance = [[NetUser alloc] init];
    }
    return instance;
}

- (void)reqSessionVerify
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:sessionDic forKey:@"session"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/user_info"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  // 数据持久化
                  if ( responseObject[@"status"] && [[responseObject[@"status"] valueForKey:@"succeed"] intValue] == 1 )
                  {
                      NSDictionary* userDic = responseObject[@"data"][@"user"];
                      NSDictionary* sessionDic = responseObject[@"data"][@"session"];
                      [[DataCenter sharedInstance] storageUserInfo:userDic session:sessionDic];
                  }
                  else
                  {
                      [MyAlertNotice showMessage:[responseObject[@"status"] valueForKey:@"error_desc"] timer:2.0f];
                      [[DataCenter sharedInstance] cleanLoginInfo];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { }];
}

- (void)reqRegister:(void (^)(id success))success fail:(void (^)(NSError * error))failure account:(NSString*)account password:(NSString*)password email:(NSString*)email
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:account forKey:@"account"];
    [dicJson setValue:password forKey:@"password"];
    [dicJson setValue:email forKey:@"email"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/register"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

- (void)reqLogin:(void (^)(id success))success fail:(void (^)(NSError * error))failure account:(NSString*)account password:(NSString*)password userType:(NSString*)userType
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:account forKey:@"account"];
    [dicJson setValue:password forKey:@"password"];
    [dicJson setValue:userType forKey:@"user_type"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/login"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [[DataCenter sharedInstance] cleanLoginInfo];
                            failure(error);
                        }];
}

- (void)reqLogout:(void (^)(id success))success fail:(void (^)(NSError * error))failure
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:sessionDic forKey:@"session"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/logout"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if ( responseObject[@"status"] && [[responseObject[@"status"] valueForKey:@"succeed"] intValue] == 1 )
                  {
                      [[DataCenter sharedInstance] cleanLoginInfo];
                      success(responseObject);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

- (void)reqEditUserInfo:(void (^ _Nonnull)(id _Nonnull success))success
                   fail:(void (^ _Nonnull)(NSError* _Nonnull error))failure
                account:(NSString* _Nullable)account
                  email:(NSString* _Nullable)email
                    sex:(NSString* _Nullable)sex
               birthday:(NSString* _Nullable)birthday
                     qq:(NSString* _Nullable)qq
                 mobile:(NSString* _Nullable)mobile
               oldPaswd:(NSString* _Nullable)oldPaswd
               newPaswd:(NSString* _Nullable)newPaswd
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:sessionDic forKey:@"session"];
    
    if ( account != nil )
        [dicJson setValue:account forKey:@"account"];
    if ( email != nil )
        [dicJson setValue:email forKey:@"email"];
    if ( sex != nil )
        [dicJson setValue:sex forKey:@"sex"];
    if ( birthday != nil )
        [dicJson setValue:birthday forKey:@"birthday"];
    if ( qq != nil )
        [dicJson setValue:qq forKey:@"qq"];
    if ( mobile != nil )
        [dicJson setValue:mobile forKey:@"mobile"];
    
    if ( oldPaswd != nil && newPaswd != nil )
    {
        [dicJson setValue:oldPaswd forKey:@"old_password"];
        [dicJson setValue:newPaswd forKey:@"new_password"];
    }
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/edit_user_info"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  // 数据持久化
                  if ( responseObject[@"status"] && [[responseObject[@"status"] valueForKey:@"succeed"] intValue] == 1 )
                  {
                      NSDictionary* userDic = responseObject[@"data"][@"user"];
                      NSDictionary* sessionDic = responseObject[@"data"][@"session"];
                      [[DataCenter sharedInstance] storageUserInfo:userDic session:sessionDic];
                      
                      success(responseObject);
                  }
                  else
                  {
                      [MyAlertNotice showMessage:[responseObject[@"status"] valueForKey:@"error_desc"] timer:2.0f];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - region
- (void)reqRegion:(void (^)(id success))success fail:(void (^)(NSError * error))failure parentID:(int)parentID
{
    NSMutableDictionary* dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:[NSString stringWithFormat:@"%d", parentID] forKey:@"parent_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/region"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - add 4S user
- (void)reqAdd4SUser:(void (^)(id success))success fail:(void (^)(NSError * error))failure dic:(NSDictionary*)dic
{
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/user_authz_2_4s"];
    [self postRequest:url
           parameters:dic
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - add repair user
- (void)reqAddRepairUser:(void (^)(id success))success fail:(void (^)(NSError * error))failure dic:(NSDictionary*)dic
{
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/user_authz_2_repair"];
    [self postRequest:url
           parameters:dic
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - upload photos
- (void)reqUploadPhotos:(void (^)(id success))success
                   fail:(void (^)(NSError * error))failure
                process:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))process
             photoArray:(NSArray*)array
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:sessionDic forKey:@"session"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/upload_shop_photo"];
    [self postPhotos:url
          parameters:dicJson
       bodyWithBlock:^(id<AFMultipartFormData> formData) {
                        for ( int i = 0; i < [array count]; i++ )
                        {
                            NSData *imageData = UIImageJPEGRepresentation(array[i], 0.1);
                            [formData appendPartWithFileData:imageData
                                                        name:[NSString stringWithFormat:@"shop_photo_%d",i]
                                                    fileName:[NSString stringWithFormat:@"shop_photo_%d.jpg",i]
                                                    mimeType:@"image/jpeg"];
                        }
                    }
             process:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) { process(totalBytesWritten,totalBytesExpectedToWrite); }
             success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); } ];
}

#pragma mark - commit broadcast info
- (void)reqBroadcastCmt:(void (^)(id success))success fail:(void (^)(NSError * error))failure info:(NSString*)info
{
    NSDictionary* sessionDic = [[DataCenter sharedInstance] getSessionDic];
    if ( sessionDic == nil )
    {
        [MyAlertNotice showMessage:@"登录信息不存在！" timer:2.0f];
        return;
    }
    
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:sessionDic forKey:@"session"];
    [dicJson setObject:info forKey:@"info_content"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/broadcast_commit"];
    [self postRequest:url
           parameters:dicJson
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];
}

#pragma mark - get broadcast list
- (void)reqBroadcastList:(void (^)(id success))success fail:(void (^)(NSError * error))failure
{
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/user/broadcast_list"];
    [super getRequest:url
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}




@end
