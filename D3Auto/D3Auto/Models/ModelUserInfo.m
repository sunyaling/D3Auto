//
//  ModelUserInfo.m
//  D3Auto
//
//  Created by zhongfang on 15/11/6.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ModelUserInfo.h"

@implementation ModelUserInfo


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super init] )
    {
        self.userID         = [aDecoder decodeObjectForKey:@"userID"];
        self.account        = [aDecoder decodeObjectForKey:@"account"];
        self.email          = [aDecoder decodeObjectForKey:@"email"];
        self.sex            = [aDecoder decodeObjectForKey:@"sex"];
        self.birthday       = [aDecoder decodeObjectForKey:@"birthday"];
        self.qq             = [aDecoder decodeObjectForKey:@"qq"];
        self.mobile         = [aDecoder decodeObjectForKey:@"mobile"];
        self.registerTime   = [aDecoder decodeObjectForKey:@"registerTime"];
        self.defaultCarID   = [aDecoder decodeObjectForKey:@"defaultCarID"];
        self.defaultCarName = [aDecoder decodeObjectForKey:@"defaultCarName"];
        
        self.shopType       = [aDecoder decodeObjectForKey:@"shopType"];
        self.shopID         = [aDecoder decodeObjectForKey:@"shopID"];
        self.shopStatus     = [aDecoder decodeObjectForKey:@"shopStatus"];
        self.shopName       = [aDecoder decodeObjectForKey:@"shopName"];
        self.shopEmail      = [aDecoder decodeObjectForKey:@"shopEmail"];
        self.shopTel        = [aDecoder decodeObjectForKey:@"shopTel"];
        self.shopMobile     = [aDecoder decodeObjectForKey:@"shopMobile"];
        self.shopAddress    = [aDecoder decodeObjectForKey:@"shopAddress"];
        self.shopProvinceID = [aDecoder decodeObjectForKey:@"shopProvinceID"];
        self.shopCityID     = [aDecoder decodeObjectForKey:@"shopCityID"];
        self.shopDistrictID = [aDecoder decodeObjectForKey:@"shopDistrictID"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID         forKey:@"userID"];
    [aCoder encodeObject:self.account        forKey:@"account"];
    [aCoder encodeObject:self.email          forKey:@"email"];
    [aCoder encodeObject:self.sex            forKey:@"sex"];
    [aCoder encodeObject:self.birthday       forKey:@"birthday"];
    [aCoder encodeObject:self.qq             forKey:@"qq"];
    [aCoder encodeObject:self.mobile         forKey:@"mobile"];
    [aCoder encodeObject:self.registerTime   forKey:@"registerTime"];
    [aCoder encodeObject:self.defaultCarID   forKey:@"defaultCarID"];
    [aCoder encodeObject:self.defaultCarName forKey:@"defaultCarName"];
    
    [aCoder encodeObject:self.shopType       forKey:@"shopType"];
    [aCoder encodeObject:self.shopID         forKey:@"shopID"];
    [aCoder encodeObject:self.shopStatus     forKey:@"shopStatus"];
    [aCoder encodeObject:self.shopName       forKey:@"shopName"];
    [aCoder encodeObject:self.shopEmail      forKey:@"shopEmail"];
    [aCoder encodeObject:self.shopTel        forKey:@"shopTel"];
    [aCoder encodeObject:self.shopMobile     forKey:@"shopMobile"];
    [aCoder encodeObject:self.shopAddress    forKey:@"shopAddress"];
    [aCoder encodeObject:self.shopProvinceID forKey:@"shopProvinceID"];
    [aCoder encodeObject:self.shopCityID     forKey:@"shopCityID"];
    [aCoder encodeObject:self.shopDistrictID forKey:@"shopDistrictID"];
}


@end
