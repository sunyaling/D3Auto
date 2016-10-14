//
//  ModelRepairService.m
//  D3Auto
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ModelRepairService.h"

@implementation ModelRepairService

@synthesize serviceID = _serviceID;

@synthesize serviceName = _serviceName;

@synthesize serviceImg = _serviceImg;

@synthesize isChecked = _isChecked;

- (ModelRepairService* _Nonnull)initWithServiceID:(NSString* _Nonnull)serviceID andServiceName:(NSString* _Nonnull)serviceName serviceImg:(NSString* _Nonnull)serviceImg
{
    if ( self = [super init] )
    {
        _serviceID = serviceID;
        _serviceName = serviceName;
        _serviceImg = serviceImg;
        _isChecked = NO;
    }
    return self;
}

@end



@implementation ModelRepairServiceGroup

@synthesize serviceID = _serviceID;

@synthesize serviceName = _serviceName;

@synthesize serviceImg = _serviceImg;

@synthesize array = _array;

- (ModelRepairServiceGroup* _Nonnull)initWithServiceID:(NSString* _Nonnull)serviceID andServiceName:(NSString* _Nonnull)serviceName serviceImg:(NSString* _Nonnull)serviceImg andArray:(NSArray* _Nullable)array
{
    if ( self = [super init] )
    {
        _serviceID = serviceID;
        _serviceName = serviceName;
        _serviceImg = serviceImg;
        self.array = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

@end





