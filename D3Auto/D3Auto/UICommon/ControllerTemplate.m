//
//  ControllerTemplate.m
//  D3Auto
//
//  Created by zhongfang on 15/10/29.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerTemplate.h"

#include "Net4S.h"

@interface ControllerTemplate ()

@end

@implementation ControllerTemplate

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData
{
    
}
- (void)initUI
{

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



#pragma -mark View4SRootDelegate
- (void)onClickedBannerURL:(NSString* _Nonnull)url
{
    
}

#pragma -mark Net Notify
- (void)update:(NSArray*)arry
{
    
}

#pragma -mark NetWork
- (void)reqData
{
    [[Net4S sharedInstance] req4SBanner:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [self update:success[@"data"]];
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
