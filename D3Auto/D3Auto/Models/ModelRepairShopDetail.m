//
//  ModelRepairShopDetail.m
//  D3Auto
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ModelRepairShopDetail.h"


@implementation ModelRepairShopGallery

@synthesize imgID = _imgID;

@synthesize shopID = _shopID;

@synthesize imgDesc = _imgDesc;

@synthesize imgNormal = _imgNormal;

@synthesize imgThumb = _imgThumb;

- (ModelRepairShopGallery* _Nonnull)initWithImgID:(NSString* _Nonnull)imgID andShopID:(NSString* _Nonnull)shopID andImgDesc:(NSString* _Nonnull)imgDesc andImgNormal:(NSString* _Nonnull)imgNormal andImgThumb:(NSString* _Nonnull)imgThumb
{
    if ( self = [super init] )
    {
        _imgID = imgID;
        _shopID = shopID;
        _imgDesc = imgDesc;
        _imgNormal = imgNormal;
        _imgThumb = imgThumb;
    }
    return self;
}

@end



@implementation ModelRepairShopDetail

@synthesize shopID = _shopID;

@synthesize userID = _userID;

@synthesize shopName = _shopName;

@synthesize shopEmail = _shopEmail;

@synthesize shopTel = _shopTel;

@synthesize shopMobile = _shopMobile;

@synthesize shopAddress = _shopAddress;

@synthesize longitude = _longitude;

@synthesize latitude = _latitude;

@synthesize starLevel = _starLevel;

@synthesize galleryArray = _galleryArray;

- (ModelRepairShopDetail* _Nonnull)init
{
    if ( self = [super init] )
    {
        _galleryArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setGalleryArray:(NSMutableArray * _Nullable)galleryArray
{
    [_galleryArray addObjectsFromArray:galleryArray];
}


@end