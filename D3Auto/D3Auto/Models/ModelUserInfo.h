//
//  ModelUserInfo.h
//  D3Auto
//
//  Created by zhongfang on 15/11/6.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ENUM_ACCOUNT_TYPE_NORMAL = 0,              // 普通用户
    ENUM_ACCOUNT_TYPE_4S,                      // 4S用户
    ENUM_ACCOUNT_TYPE_REPAIR                   // 汽修店铺
}
ENUM_ACCOUNT_TYPE;

typedef enum
{
    ENUM_ACCOUNT_STATUS_EXAMINING   =   0,      // 审核中
    ENUM_ACCOUNT_STATUS_PASSED      =   1,      // 通过审核
    ENUM_ACCOUNT_STATUS_FROZEN     =   2        // 冻结
    
}
ENUM_ACCOUNT_STATUS;

@interface ModelUserInfo : NSObject <NSCoding>


@property (nullable, nonatomic, copy) NSString* userID;
@property (nullable, nonatomic, copy) NSString* account;
@property (nullable, nonatomic, copy) NSString* email;
@property (nullable, nonatomic, copy) NSString* sex;
@property (nullable, nonatomic, copy) NSString* birthday;
@property (nullable, nonatomic, copy) NSString* qq;
@property (nullable, nonatomic, copy) NSString* mobile;
@property (nullable, nonatomic, copy) NSString* registerTime;
@property (nullable, nonatomic, copy) NSString* defaultCarID;
@property (nullable, nonatomic, copy) NSString* defaultCarName;

@property (nullable, nonatomic, copy) NSString* shopType;
@property (nullable, nonatomic, copy) NSString* shopID;
@property (nullable, nonatomic, copy) NSString* shopStatus;
@property (nullable, nonatomic, copy) NSString* shopName;
@property (nullable, nonatomic, copy) NSString* shopEmail;
@property (nullable, nonatomic, copy) NSString* shopTel;
@property (nullable, nonatomic, copy) NSString* shopMobile;
@property (nullable, nonatomic, copy) NSString* shopAddress;
@property (nullable, nonatomic, copy) NSString* shopProvinceID;
@property (nullable, nonatomic, copy) NSString* shopCityID;
@property (nullable, nonatomic, copy) NSString* shopDistrictID;

- (instancetype)initWithCoder:(NSCoder* _Nonnull)coder;
- (void)encodeWithCoder:(NSCoder* _Nonnull)coder;


@end
