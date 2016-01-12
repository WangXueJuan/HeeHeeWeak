//
//  DiscoverModel.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.discoverId = dict[@"id"];
        self.type = dict[@"type"];
    }
    return self;
}


@end
