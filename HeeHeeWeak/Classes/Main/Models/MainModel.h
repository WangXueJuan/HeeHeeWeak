//
//  MainModel.h
//  HeeHeeWeak
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    RecommendTypeActivity = 1,    //推荐活动
    RecommendTypeTheme            //推荐专题

} RecommendType;

@interface MainModel : NSObject
//首页大图
@property(nonatomic, copy) NSString *image_big;
//标题
@property(nonatomic, copy) NSString *title;
//价格
@property(nonatomic, copy) NSString *price;
//经纬度
@property(nonatomic, assign) CGFloat lat;
@property(nonatomic, assign) CGFloat lng;
//地址
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
@property(nonatomic, copy) NSString *counts;
@property(nonatomic, copy) NSString *activityId;
@property(nonatomic, copy) NSString *type;
//描述
@property(nonatomic, copy) NSString *activityDescription;

//添加一个方法，把主页传来的字典转换成model数据
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
