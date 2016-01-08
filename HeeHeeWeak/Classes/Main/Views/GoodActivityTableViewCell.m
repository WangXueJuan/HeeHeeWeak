//
//  GoodActivityTableViewCell.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ageImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UIButton *loveButton;

@end


@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.frame = CGRectMake(0, 0, kWidth, 90);
}

//在set方法中赋值
-(void)setGoodModel:(GoodActivityModel *)goodModel{
    self.ageLabel.text = goodModel.age;
    self.activityPriceLabel.text = goodModel.price;
    self.activityTitleLabel.text = goodModel.title;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
//    [self.loveButton setTitle:goodModel.counts forState:UIControlStateNormal];
  


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
