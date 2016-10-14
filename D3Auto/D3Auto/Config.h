//
//  Config.h
//  D3Auto
//
//  Created by zhongfang on 15/10/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#ifndef Config_h
#define Config_h

/*#ifdef DEBUG
    #define     DEF_SERVER_URL      @"http://www.zhangxinli.com.cn/disanqiche/app_server"                           // 服务器URL
    #define     DEF_SHOP_URL        @"http://www.zhangxinli.com.cn/disanqiche/shop/"                                // 商城URL
    #define     DEF_URL_HELP        @"http://www.zhangxinli.com.cn/disanqiche/app_server/other/help/help.html"      // 帮助URL
    #define     DEF_URL_ABOUT       @"http://www.zhangxinli.com.cn/disanqiche/app_server/other/about/about.html"    // 关于URL
#else*/
    #define     DEF_SERVER_URL      @"http://www.disanqiche.com/app_server/"                                        // 服务器URL
    #define     DEF_SHOP_URL        @"http://www.disanqiche.com/shop/"                                              // 商城URL
    //#define     DEF_SHOP_URL        @"http://www.disanqiche.com/app_server/other/shop/temp.html"                    // 商城URL
    #define     DEF_URL_HELP        @"http://www.disanqiche.com/app_server/other/help/help.html"                    // 帮助URL
    #define     DEF_URL_ABOUT       @"http://www.disanqiche.com/app_server/other/about/about.html"                  // 关于URL
//#endif


#define     DEF_COLOR_BG        [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]           // root view 底色

#define     DEF_COLOR_LINE      [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.9]           // seperation line

#define     DEF_COLOR_LGTBLUE   [UIColor colorWithRed:135.0/255 green:206.0/255 blue:235.0/255 alpha:0.9]           // light blue

#define     DEF_COLOR_LGTRED    [UIColor colorWithRed:240.0/255 green:69.0/255 blue:0.0/255 alpha:0.9]              // light red



#define     DEF_TABBAR_H        45                                                                                  // 底边栏的高

#define     DEF_STATUSBAR_H     [UIApplication sharedApplication].statusBarFrame.size.height                        // 顶部状态栏高

#define     DEF_TAG_BASE_NUM    1000                                                                                // 按钮tag基值（因tag无法从0开始）

#define     DEF_LOC_DISTANCE    300.0                                                                               // 定位启动范围（米）

#define     DEF_MAX_UPLOAD_SHOP 5                                                                                   // 商店上传照片张数上限

#define     DEF_BCAST_CMT_INTER 10800                                                                               // 广播消息提交时间间隔 3*60*60
#define     DEF_BCAST_REF_INTER 3600                                                                                // 广播消息更新时间间隔 1*60*60



#define     DEF_KEY_USER_INFO   @"user_info"
#define     DEF_KEY_IS_LOGIN    @"is_login"
#define     DEF_KEY_SESSION_ID  @"session_id"
#define     DEF_KEY_USER_ID     @"user_id"

#define     DEF_KEY_CITY_NAME   @"city_name"
#define     DEF_KEY_LONGITUDE   @"longitude"                                                                        // 经度
#define     DEF_KEY_LATITUDE    @"latitude"                                                                         // 纬度

#define     DEF_KEY_BCCMT_TIME  @"last_time_broadcast_commit"                                                       // 广播消息 上次提交时间
#define     DEF_KEY_BCREF_TIME  @"last_time_broadcast_refresh"                                                      // 广播消息 上次刷新时间


#endif /* Config_h */
