//
//  HotActivityModel.h
//  HeeHeeWeak
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotActivityModel : NSObject
//热门专题的属性
@property(nonatomic, strong) NSString *headImageView;
@property(nonatomic, strong) NSString *hotActivityId;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
