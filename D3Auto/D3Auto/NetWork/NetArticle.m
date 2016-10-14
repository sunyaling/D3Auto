//
//  NetArticle.m
//  D3Auto
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "NetArticle.h"

#import "DataCenter.h"


@implementation NetArticle

static NetArticle * instance;

+ (instancetype)sharedInstance
{
    if (instance == nil)
    {
        instance = [[NetArticle alloc] init];
    }
    return instance;
}


#pragma mark - banner
- (void)reqBanner:(void (^)(id success))success fail:(void (^)(NSError * error))failure
{
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/article/banner_data"];
    [super getRequest:url
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - article list
- (void)reqArticleList:(void (^)(id success))success fail:(void (^)(NSError * error))failure page:(NSInteger)page count:(NSInteger)count
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setObject:[[DataCenter sharedInstance] getPaginationDic:page count:count] forKey:@"pagination"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/article/article_list"];
    [super postRequest:url
            parameters:dicJson
               success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}

#pragma mark - article detail
- (void)reqArticleDetail:(void (^)(id success))success fail:(void (^)(NSError * error))failure articleID:(NSUInteger)articleID
{
    NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    [dicJson setValue:[NSString stringWithFormat:@"%ldu",articleID] forKey:@"article_id"];
    
    NSString * url = [DEF_SERVER_URL stringByAppendingFormat:@"/?url=/article/article_detail"];
    [super postRequest:url
            parameters:dicJson
               success:^(AFHTTPRequestOperation *operation, id responseObject) { success(responseObject); }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }
     ];
}





@end
