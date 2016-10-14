//
//  MyWebViewController.h
//  D3Auto
//
//  Created by zhongfang on 15/11/4.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ViewController.h"

@interface MyWebViewController : ViewController

@property (nonatomic) BOOL hideNavigationBar;


- (MyWebViewController* _Nonnull)initWithUrl:(NSString* _Nullable)url;

- (void)loadHTMLString:(NSString* _Nonnull)string;

@end

