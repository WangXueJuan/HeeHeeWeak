//
//  ActivityDetailView.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HWTools.h"
@interface ActivityDetailView ()
{
    //保存上一次图片的底部的高度
    CGFloat _previonsImageBottom;
    //保存最后一次label底部的高度
    CGFloat _lastLabelBottom;

}


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *activityAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;


@end

@implementation ActivityDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 1000);

}


//在set方法中赋值
-(void)setDataDic:(NSDictionary *)dataDic{
    //活动图片
    NSArray *urls = dataDic[@"urls"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    //活动标题
    self.activityTitle.text = dataDic[@"title"];
    //活动起止时间
    NSString *startTime = [HWTools getDataFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWTools getDataFromString:dataDic[@"new_end_date"]];
    self.activityTimeLabel.text = [NSString stringWithFormat:@"正在进行:%@ - %@",startTime,endTime];
    //活动受欢迎度
    self.favoriteLabel.text = [NSString stringWithFormat:@"%@人已喜欢",dataDic[@"fav"]];
    //活动价格
    self.priceLabel.text = dataDic[@"pricedesc"];
    //活动地址
    self.activityAdressLabel.text = dataDic[@"address"];
    //活动联系方式
    self.phoneNumberLabel.text = dataDic[@"tel"];

    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];

}

//获取活动信息详情到页面
- (void)drawContentWithArray:(NSArray *)contentArray{
    for (NSDictionary *dic in contentArray) {
        //获取每一段活动信息的文本高度
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:15.0];
        CGFloat y;
        if (_previonsImageBottom > 500) {
            //当第一个活动详情显示，label先从保留的图片底部的坐标开始
            y = 500 + _previonsImageBottom - 500;
        }else{
            //当第二个开始时，要加上上面控件的高度
            y = 500 + _previonsImageBottom;
        }
        NSString *title = dic[@"title"];
         //如果标题存在,标题高度应该是上次图片的高度的底部高度
        if (title !=nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, kWidth- 10, height)];
        label.text = dic[@"description"];
        label.font = [UIFont systemFontOfSize:15.0];
        label.numberOfLines = 0;
        [self.mainScrollView addSubview:label];
        //保留最后一个label的高度，+64是下边tableBar的高度
        _lastLabelBottom = label.bottom + 10 + 64;
      
        NSArray *urlArray = dic[@"urls"];
        //当某一段落没有图片的时候，上次图片的高度用上次label的高度+10
        if (urlArray == nil) {
            _previonsImageBottom = label.bottom + 10;
        }else{
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlArray) {
                 CGFloat imagY;
                if (urlArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) {  //有title的算上title的30像素
                            imagY = _previonsImageBottom + label.height + 30 + 5;
                        } else{
                            imagY = _previonsImageBottom + label.height + 5;
                        }
                    } else {
                        imagY = lastImgbottom + 10;
                    
                    }
                } else{
                 //单张图片
                    imagY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, imagY, kWidth - 10, (kWidth - 10) / width * imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                 [self.mainScrollView addSubview:imageView];
                //每一次都保留图片底部的高度
                _previonsImageBottom = imageView.bottom + 5;
                if (urlArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
                
            }
        }
    }
    //给mainScrollView重新赋值它的高度
    self.mainScrollView.contentSize = CGSizeMake(kWidth, _lastLabelBottom + 20);
}

@end
