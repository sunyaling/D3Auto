//
//  Config.h
//  D3Auto
//
//  Created by zhongfang on 15/10/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetBase.h"

#import "MyAlertNotice.h"

@implementation NetBase

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


#pragma mark - inner use function

- (void)getRequest:(NSString *)url
        parameters:(id)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url
      parameters:parameters
         success:success
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {
                        [MyAlertNotice showMessage:@"网络错误，请检查网络！" timer:2.0f];
                        failure(operation, error);
                    }];
}

- (void)postRequest:(NSString *)url
        parameters:(id)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url
       parameters:parameters
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {
                        [MyAlertNotice showMessage:@"网络错误，请检查网络！" timer:2.0f];
                        failure(operation, error);
                    }];
}

- (void)postPhotos:(NSString *)url
        parameters:(id)parameters
     bodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
           process:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))process
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation* operation = [manager POST:url parameters:parameters constructingBodyWithBlock:block success:success failure:failure];

    // 进度
    [operation setUploadProgressBlock:process];
}



@end
