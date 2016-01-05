//
//  MainTableViewCell.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainTableViewCell ()
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
//活动名字
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;


@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

//在model的set方法赋值
-(void)setMainModel:(MainModel *)mainModel{
      [self.activityImage sd_setImageWithURL:[NSURL URLWithString:mainModel.image_big] placeholderImage:nil];//网上获取图片
    self.activityNameLabel.text = mainModel.title;
    self.activityPriceLabel.text = mainModel.price;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
