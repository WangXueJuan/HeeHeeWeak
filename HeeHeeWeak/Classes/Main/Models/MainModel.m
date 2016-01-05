//
//  MainModel.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
//初始化这个方法
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.type = dict[@"type"];
        if ([self.type integerValue] == RecommendTypeActivity) {
            //如果是推荐活动
            self.address = dict[@"address"];
            self.counts = dict[@"counts"];
            self.startTime = dict[@"startTime"];
            self.endTime = dict[@"endTime"];
            self.price = dict[@"price"];
            self.lng = [dict[@"lng"] floatValue];
            self.lat = [dict[@"lat"] floatValue];
        } else {
            //推荐专题
            self.activityDescription = dict[@"description"];
        
        }
        self.title = dict[@"title"];
        self.activityId = dict[@"id"];
        self.image_big = dict[@"image_big"];
       
       
    }
    return self;
    
}


@end
