//
//  NetworkModel.h
//  YunYiGou
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 yunfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utils : NSObject

+ (float)heightForString:(NSString* _Nonnull)value fontSize:(float)fontSize andWidth:(float)width;

+ (float)widthForString:(NSString* _Nonnull)value fontSize:(float)fontSize;


// 从URL中解析出操作
+ (NSString* _Nullable)getCommondFromURL:(NSString* _Nonnull)strURL;

@end

