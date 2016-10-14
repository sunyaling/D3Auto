//
//  Model4SCarList.m
//  D3Auto
//
//  Created by zhongfang on 15/11/2.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Model4SCarList.h"

@implementation Model4SCar

@synthesize carID = _carID;

@synthesize cateID = _cateID;

@synthesize name = _name;

@synthesize image = _image;

@synthesize guidePriceLowest = _guidePriceLowest;

@synthesize guidePriceHighest = _guidePriceHighest;

- (Model4SCar* _Nonnull)initWithCarID:(NSString* _Nonnull)carID andCateID:(NSString* _Nonnull)cateID andName:(NSString* _Nonnull)name andImage:(NSString* _Nonnull)image andLowPrice:(NSString* _Nonnull)guidePriceLowest andHighPrice:(NSString* _Nonnull)guidePriceHighest
{
    if ( self = [super init] )
    {
        _carID = carID;
        _cateID = cateID;
        _name = name;
        _image = image;
        _guidePriceLowest = guidePriceLowest;
        _guidePriceHighest = guidePriceHighest;
    }
    return self;
}

@end


@implementation Model4SCarGroup

@synthesize cateID = _cateID;

@synthesize name = _name;

@synthesize carArray = _carArray;

- (Model4SCarGroup* _Nonnull)initWithCateID:(NSString* _Nonnull)cateID andName:(NSString* _Nullable)name andCarArray:(NSArray* _Nullable)carArray
{
    if ( self = [super init] )
    {
        _cateID = cateID;
        _name = name;
        self.carArray = [[NSMutableArray alloc] initWithArray:carArray];
    }
    return self;
}

@end
