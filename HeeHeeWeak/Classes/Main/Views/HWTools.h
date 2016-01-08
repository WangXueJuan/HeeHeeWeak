//
//  HWTools.h
//  HeeHeeWeak
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HWTools : NSObject

#pragma mark -------------- 时间转换相关的方法
//通过时间戳转换时间
+(NSString *)getDataFromString:(NSString *)timestamp;

//获取系统当前时间
+ (NSDate *)getSystemNowTime;

#pragma mark -------------------- 根据文字最大显示宽高贺文字内容返回高度
+ (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font;

@end
