//
//  Model4SBrandList.m
//  D3Auto
//
//  Created by zhongfang on 15/10/30.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Model4SBrandList.h"


@implementation Model4SBrand

@synthesize brandID = _brandID;

@synthesize parentID = _parentID;

@synthesize name = _name;

@synthesize image = _image;

- (Model4SBrand* _Nonnull)initWithBrandID:(NSInteger)brandID andParentID:(NSInteger)parentID andName:(NSString* _Nonnull)name andImage:(NSString* _Nonnull)image
{
    if ( self = [super init] )
    {
        _brandID = brandID;
        _parentID = parentID;
        _name = name;
        _image = image;
    }
    return self;
}

@end



@implementation Model4SBrandGroup

@synthesize groupID = _groupID;

@synthesize name = _name;

@synthesize brandArray = _brandArray;

- (Model4SBrandGroup* _Nonnull)initWithGroupID:(NSInteger)groupID andName:(NSString* _Nullable)name andBrandArray:(NSArray* _Nullable)brandArray
{
    if ( self = [super init] )
    {
        _groupID = groupID;
        _name = name;
        self.brandArray = [[NSMutableArray alloc] initWithArray:brandArray];
    }
    return self;
}

@end