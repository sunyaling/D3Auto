//
//  Model4SBrandList.h
//  D3Auto
//
//  Created by zhongfang on 15/10/30.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface Model4SBrand : NSObject

@property (nonatomic) NSInteger brandID;

@property (nonatomic) NSInteger parentID;

@property (nullable, nonatomic, copy) NSString* name;

@property (nullable, nonatomic, copy) NSString* image;

- (Model4SBrand* _Nonnull)initWithBrandID:(NSInteger)brandID andParentID:(NSInteger)parentID andName:(NSString* _Nonnull)name andImage:(NSString* _Nonnull)image;

@end



@interface Model4SBrandGroup : NSObject

@property (nonatomic) NSInteger groupID;

@property (nullable, nonatomic, copy) NSString* name;

@property (nullable, nonatomic, strong) NSMutableArray* brandArray;

- (Model4SBrandGroup* _Nonnull)initWithGroupID:(NSInteger)groupID andName:(NSString* _Nullable)name andBrandArray:(NSArray* _Nullable)brandArray;

@end