//
//  Model4SCarList.h
//  D3Auto
//
//  Created by zhongfang on 15/11/2.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>


/* 
 *  车辆属性
 */

@interface Model4SCar : NSObject

@property (nullable, nonatomic, copy) NSString* carID;

@property (nullable, nonatomic, copy) NSString* cateID;

@property (nullable, nonatomic, copy) NSString* name;

@property (nullable, nonatomic, copy) NSString* image;

@property (nullable, nonatomic, copy) NSString* guidePriceLowest;

@property (nullable, nonatomic, copy) NSString* guidePriceHighest;

- (Model4SCar* _Nonnull)initWithCarID:(NSString* _Nonnull)carID andCateID:(NSString* _Nonnull)cateID andName:(NSString* _Nonnull)name andImage:(NSString* _Nonnull)image andLowPrice:(NSString* _Nonnull)guidePriceLowest andHighPrice:(NSString* _Nonnull)guidePriceHighest;

@end



/*
 *  分类（厂商）属性
 */

@interface Model4SCarGroup : NSObject

@property (nullable, nonatomic, copy) NSString* cateID;

@property (nullable, nonatomic, copy) NSString* name;

@property (nullable, nonatomic, strong) NSMutableArray* carArray;

- (Model4SCarGroup* _Nonnull)initWithCateID:(NSString* _Nonnull)cateID andName:(NSString* _Nullable)name andCarArray:(NSArray* _Nullable)carArray;

@end