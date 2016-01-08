//
//  GoodActivityModel.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "GoodActivityModel.h"

@implementation GoodActivityModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.image = dic[@"image"];
        self.address = dic[@"address"];
        self.age = dic[@"age"];
        self.counts = dic[@"counts"];
        self.price  =dic[@"price"];
        self.activiId = dic[@"id"];
        self.type = dic[@"type"];
    }
    return self;
}

@end
