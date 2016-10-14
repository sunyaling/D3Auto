//
//  Config.h
//  D3Auto
//
//  Created by zhongfang on 15/10/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "Config.h"

@interface NetBase : NSObject

- (void)getRequest:(NSString *)url
        parameters:(id)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postRequest:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postPhotos:(NSString *)url
        parameters:(id)parameters
     bodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
           process:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))process
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




@end
