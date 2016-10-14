//
//  Model4SCarDetail.h
//  D3Auto
//
//  Created by zhongfang on 15/11/3.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <Foundation/Foundation.h>

// 相册
@interface Model4SCarGallery : NSObject

@property (nullable, nonatomic, copy) NSString* imgID;

@property (nullable, nonatomic, copy) NSString* carID;

@property (nullable, nonatomic, copy) NSString* imgDesc;

@property (nullable, nonatomic, copy) NSString* imgNormal;

@property (nullable, nonatomic, copy) NSString* imgThumb;

- (Model4SCarGallery* _Nonnull)initWithImgID:(NSString* _Nonnull)imgID andCarID:(NSString* _Nonnull)carID andImgDesc:(NSString* _Nonnull)imgDesc andImgNormal:(NSString* _Nonnull)imgNormal andImgThumb:(NSString* _Nonnull)imgThumb;

@end


// 配置
@interface Model4SCarAttr : NSObject

@property (nullable, nonatomic, copy) NSString* attrID;

@property (nullable, nonatomic, copy) NSString* carID;

@property (nullable, nonatomic, copy) NSString* parentID;

@property (nullable, nonatomic, copy) NSString* attrName;

@property (nullable, nonatomic, copy) NSString* guidePrice;

@property (nullable, nonatomic, copy) NSString* attrDesc;

@property (nullable, nonatomic, copy) NSString* isShow;

@property (nullable, nonatomic, strong) NSMutableArray* children;

- (Model4SCarAttr* _Nonnull)initWithAttrID:(NSString* _Nonnull)attrID andCarID:(NSString* _Nonnull)carID andParentID:(NSString* _Nonnull)parentID andAttrName:(NSString* _Nonnull)attrName andGuidePrice:(NSString* _Nonnull)guidePrice andAttrDesc:(NSString* _Nonnull)attrDesc andIsShow:(NSString* _Nonnull)isShow;

- (void)addChildren:(Model4SCarAttr* _Nonnull)child;

@end



@interface Model4SCarDetail : NSObject

@property (nullable, nonatomic, copy) NSString* carID;

@property (nullable, nonatomic, copy) NSString* cateID;

@property (nullable, nonatomic, copy) NSString* carName;

@property (nullable, nonatomic, copy) NSString* guidePriceLowest;

@property (nullable, nonatomic, copy) NSString* guidePriceHighest;

@property (nullable, nonatomic, copy) NSString* carImg;

@property (nullable, nonatomic, copy) NSString* isOnSale;

@property (nullable, nonatomic, copy) NSString* saleStartTime;

@property (nullable, nonatomic, copy) NSString* carDesc;

@property (nullable, nonatomic, copy) NSString* isShow;

@property (nullable, nonatomic, copy) NSString* showInNav;

@property (nullable, nonatomic, strong) NSMutableArray* galleryArray;

@property (nullable, nonatomic, strong) NSMutableArray* attrArray;

- (void)setGalleryArray:(NSMutableArray * _Nullable)galleryArray;

- (void)setAttrArray:(NSMutableArray * _Nullable)attrArray;

@end



