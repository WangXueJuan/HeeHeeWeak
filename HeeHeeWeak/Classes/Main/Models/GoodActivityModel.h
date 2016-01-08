//
//  GoodActivityModel.h
//  HeeHeeWeak
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodActivityModel : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *age;
@property(nonatomic, strong) NSString *counts;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *activiId;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *type;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
