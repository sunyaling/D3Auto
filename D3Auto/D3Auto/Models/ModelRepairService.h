//
//  ModelRepairService.h
//  D3Auto
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelRepairService : NSObject

@property (nullable, nonatomic, copy) NSString* serviceID;

@property (nullable, nonatomic, copy) NSString* serviceName;

@property (nullable, nonatomic, copy) NSString* serviceImg;

@property (nonatomic) BOOL isChecked;

- (ModelRepairService* _Nonnull)initWithServiceID:(NSString* _Nonnull)serviceID andServiceName:(NSString* _Nonnull)serviceName serviceImg:(NSString* _Nonnull)serviceImg;

@end



/*
 *  服务（主分类）属性
 */

@interface ModelRepairServiceGroup : NSObject

@property (nullable, nonatomic, copy) NSString* serviceID;

@property (nullable, nonatomic, copy) NSString* serviceName;

@property (nullable, nonatomic, copy) NSString* serviceImg;

@property (nullable, nonatomic, strong) NSMutableArray* array;

- (ModelRepairServiceGroup* _Nonnull)initWithServiceID:(NSString* _Nonnull)serviceID andServiceName:(NSString* _Nonnull)serviceName serviceImg:(NSString* _Nonnull)serviceImg andArray:(NSArray* _Nullable)array;

@end