//
//  HotActivityModel.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "HotActivityModel.h"

@implementation HotActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.headImageView = dic[@"img"];
        self.hotActivityId = dic[@"id"];
    }
    return self;
}


@end
