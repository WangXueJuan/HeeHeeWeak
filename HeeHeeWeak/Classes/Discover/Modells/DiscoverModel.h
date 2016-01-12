//
//  DiscoverModel.h
//  HeeHeeWeak
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *discoverId;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *title;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
