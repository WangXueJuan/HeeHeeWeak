//
//  HWTools.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools

#pragma mark -------------- 时间转换相关的方法

+(NSString *)getDataFromString:(NSString *)timestamp{
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    return timeStr;

}

//获取系统当前时间
+ (NSDate *)getSystemNowTime{
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

#pragma mark -------------------- 根据文字最大显示宽高贺文字内容返回高度
+ (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}




@end
