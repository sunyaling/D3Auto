//
//  ModelArticle.m
//  D3Auto
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ModelArticle.h"

@implementation ModelArticle

- (instancetype)init
{
    if ( self = [super init] )
    {
        self.articleID = 0;
        self.cateID = 0;
        self.thumb = @"";
        self.title = @"";
        self.abstract = @"";
        self.author = @"";
        self.keywords = @"";
        self.content = @"";
        self.isShow = 0;
        self.addTime = 0;
        self.sortOrder = 0;
        self.clickCount = 0;
        self.praiseCount = 0;
    }
    return self;
}

@end
