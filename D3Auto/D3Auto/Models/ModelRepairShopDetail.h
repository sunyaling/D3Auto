//
//  ModelRepairShopDetail.h
//  D3Auto
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <Foundation/Foundation.h>


// 相册
@interface ModelRepairShopGallery : NSObject

@property (nullable, nonatomic, copy) NSString* imgID;

@property (nullable, nonatomic, copy) NSString* shopID;

@property (nullable, nonatomic, copy) NSString* imgDesc;

@property (nullable, nonatomic, copy) NSString* imgNormal;

@property (nullable, nonatomic, copy) NSString* imgThumb;

- (ModelRepairShopGallery* _Nonnull)initWithImgID:(NSString* _Nonnull)imgID andShopID:(NSString* _Nonnull)shopID andImgDesc:(NSString* _Nonnull)imgDesc andImgNormal:(NSString* _Nonnull)imgNormal andImgThumb:(NSString* _Nonnull)imgThumb;

@end




@interface ModelRepairShopDetail : NSObject

@property (nullable, nonatomic, copy) NSString* shopID;

@property (nullable, nonatomic, copy) NSString* userID;

@property (nullable, nonatomic, copy) NSString* shopName;

@property (nullable, nonatomic, copy) NSString* shopEmail;

@property (nullable, nonatomic, copy) NSString* shopTel;

@property (nullable, nonatomic, copy) NSString* shopMobile;

@property (nullable, nonatomic, copy) NSString* shopAddress;

@property (nonatomic) double longitude;

@property (nonatomic) double latitude;

@property (nonatomic) int starLevel;

@property (nullable, nonatomic, strong) NSMutableArray* galleryArray;

- (void)setGalleryArray:(NSMutableArray * _Nullable)galleryArray;


@end
