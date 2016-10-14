//
//  AppDelegate.m
//  D3Auto
//
//  Created by zhongfang on 15/10/24.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "AppDelegate.h"

#import "Config.h"
#import "NetUser.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import "ControllerMainShop.h"
#import "ControllerMain4S.h"
#import "ControllerMainRepaire.h"
#import "ControllerMainArticle.h"
#import "ControllerMainMine.h"


#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    UIViewController*     pVCShop       = [[ControllerMainShop alloc] init];
    UIViewController*     pVC4S         = [[ControllerMain4S alloc] init];
    UIViewController*     pVCRepire     = [[ControllerMainRepaire alloc] init];
    UIViewController*     pVCArticle    = [[ControllerMainArticle alloc] init];
    UIViewController*     pVCMine       = [[ControllerMainMine alloc] init];
    
    UINavigationController* pNCShop     = [[UINavigationController alloc] initWithRootViewController:pVCShop];
    UINavigationController* pNC4S       = [[UINavigationController alloc] initWithRootViewController:pVC4S];
    UINavigationController* pNCRepire   = [[UINavigationController alloc] initWithRootViewController:pVCRepire];
    UINavigationController* pNCArticle  = [[UINavigationController alloc] initWithRootViewController:pVCArticle];
    UINavigationController* pNCMine     = [[UINavigationController alloc] initWithRootViewController:pVCMine];
    
    [pNCShop    setNavigationBarHidden:YES animated:YES];
    [pNC4S      setNavigationBarHidden:YES animated:YES];
    [pNCRepire  setNavigationBarHidden:YES animated:YES];
    [pNCArticle setNavigationBarHidden:YES animated:YES];
    [pNCMine    setNavigationBarHidden:NO animated:YES];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[pNCShop, pNC4S, pNCRepire, pNCArticle, pNCMine]];
    
    CGRect rTB = tabBarController.tabBar.frame;
    rTB.size.height = DEF_TABBAR_H;
    tabBarController.tabBar.frame = rTB;
    
    NSArray *tabBarItemImagesNor = @[@"bottom_btn_shop_nor", @"bottom_btn_4s_nor", @"bottom_btn_repaire_nor",@"bottom_btn_article_nor",@"bottom_btn_mine_nor"];
    NSArray *tabBarItemImagesSel = @[@"bottom_btn_shop_sel", @"bottom_btn_4s_sel", @"bottom_btn_repaire_sel",@"bottom_btn_article_sel",@"bottom_btn_mine_sel"];
    
    NSInteger index = 0;
    for ( RDVTabBarItem *item in [[tabBarController tabBar] items] )
    {
        UIImage *imgNor = [UIImage imageNamed:[tabBarItemImagesNor objectAtIndex:index]];
        UIImage *imgSel = [UIImage imageNamed:[tabBarItemImagesSel objectAtIndex:index]];
        
        [item setFinishedSelectedImage:imgSel withFinishedUnselectedImage:imgNor];

        //[item setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
        index++;
    }
    
    [self.window setRootViewController:tabBarController];
    
    // temp
    //[tabBarController setSelectedIndex:2];
    
    // initialize
    [[NetUser sharedInstance] reqSessionVerify];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NetUser sharedInstance] reqSessionVerify];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
