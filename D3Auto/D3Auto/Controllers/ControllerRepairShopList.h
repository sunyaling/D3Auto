//
//  ControllerRepairShopList.h
//  D3Auto
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControllerRepairShopList : UIViewController

typedef enum
{
    ENUM_SHOP_LIST_SOS,
    ENUM_SHOP_LIST_NEARBY,
    ENUM_SHOP_LIST_SERVICE
}
ENUM_SHOP_LIST_MODE;

- (instancetype)initWithMode:(ENUM_SHOP_LIST_MODE)mode;

- (instancetype)initWithMode:(ENUM_SHOP_LIST_MODE)mode andServiceID:(NSString*)serviceID;

@end
