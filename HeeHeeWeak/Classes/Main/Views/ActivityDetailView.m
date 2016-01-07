//
//  ActivityDetailView.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityDetailView ()
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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityTitle.text = dataDic[@"title"];
//    self.activityTitle.text =
    self.favoriteLabel.text = [NSString stringWithFormat:@"%@人已喜欢",dataDic[@"fav"]];
    self.priceLabel.text = dataDic[@"pricedesc"];
    self.activityAdressLabel.text = dataDic[@"address"];
    self.phoneNumberLabel.text = dataDic[@"tel"];


}


@end
