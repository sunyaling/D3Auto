//
//  ModelArticle.h
//  D3Auto
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelArticle : NSObject

@property (nonatomic) NSUInteger articleID;

@property (nonatomic) NSUInteger cateID;

@property (nullable, nonatomic, copy) NSString* thumb;

@property (nullable, nonatomic, copy) NSString* title;

@property (nullable, nonatomic, copy) NSString* abstract;

@property (nullable, nonatomic, copy) NSString* author;

@property (nullable, nonatomic, copy) NSString* keywords;

@property (nullable, nonatomic, copy) NSString* content;

@property (nonatomic) BOOL isShow;

@property (nonatomic) NSUInteger addTime;

@property (nonatomic) NSUInteger sortOrder;

@property (nonatomic) NSUInteger clickCount;

@property (nonatomic) NSUInteger praiseCount;


@end
