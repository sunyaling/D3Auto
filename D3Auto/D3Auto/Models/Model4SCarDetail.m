//
//  Model4SCarDetail.m
//  D3Auto
//
//  Created by zhongfang on 15/11/3.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Model4SCarDetail.h"


@implementation Model4SCarGallery

@synthesize imgID = _imgID;

@synthesize carID = _carID;

@synthesize imgDesc = _imgDesc;

@synthesize imgNormal = _imgNormal;

@synthesize imgThumb = _imgThumb;

- (Model4SCarGallery* _Nonnull)initWithImgID:(NSString* _Nonnull)imgID andCarID:(NSString* _Nonnull)carID andImgDesc:(NSString* _Nonnull)imgDesc andImgNormal:(NSString* _Nonnull)imgNormal andImgThumb:(NSString* _Nonnull)imgThumb
{
    if ( self = [super init] )
    {
        _imgID = imgID;
        _carID = carID;
        _imgDesc = imgDesc;
        _imgNormal = imgNormal;
        _imgThumb = imgThumb;
    }
    return self;
}

@end



@implementation Model4SCarAttr

@synthesize attrID = _attrID;

@synthesize carID = _carID;

@synthesize parentID = _parentID;

@synthesize attrName = _attrName;

@synthesize guidePrice = _guidePrice;

@synthesize attrDesc = _attrDesc;

@synthesize isShow = _isShow;

@synthesize children = _children;

- (Model4SCarAttr* _Nonnull)initWithAttrID:(NSString* _Nonnull)attrID andCarID:(NSString* _Nonnull)carID andParentID:(NSString* _Nonnull)parentID andAttrName:(NSString* _Nonnull)attrName andGuidePrice:(NSString* _Nonnull)guidePrice andAttrDesc:(NSString* _Nonnull)attrDesc andIsShow:(NSString* _Nonnull)isShow
{
    if ( self = [super init] )
    {
        _attrID = attrID;
        _carID = carID;
        _parentID = parentID;
        _attrName = attrName;
        _guidePrice = guidePrice;
        _attrDesc = attrDesc;
        _isShow = isShow;
        
        self.children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addChildren:(Model4SCarAttr *)child
{
    [self.children addObject:child];
}

@end



@implementation Model4SCarDetail

@synthesize carID = _carID;

@synthesize cateID = _cateID;

@synthesize carName = _carName;

@synthesize guidePriceLowest = _guidePriceLowest;

@synthesize guidePriceHighest = _guidePriceHighest;

@synthesize carImg = _carImg;

@synthesize isOnSale = _isOnSale;

@synthesize saleStartTime = _saleStartTime;

@synthesize carDesc = _carDesc;

@synthesize isShow = _isShow;

@synthesize showInNav = _showInNav;

@synthesize galleryArray = _galleryArray;

@synthesize attrArray = _attrArray;

- (Model4SCarDetail* _Nonnull)init
{
    if ( self = [super init] )
    {
        _galleryArray = [[NSMutableArray alloc] init];
        _attrArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setGalleryArray:(NSMutableArray * _Nullable)galleryArray
{
    [_galleryArray addObjectsFromArray:galleryArray];
}

- (void)setAttrArray:(NSMutableArray * _Nullable)attrArray
{
    [_attrArray addObjectsFromArray:attrArray];
}


@end