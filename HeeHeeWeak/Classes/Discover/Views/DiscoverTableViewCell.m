//
//  DiscoverTableViewCell.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DiscoverTableViewCell    ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titlieLabel;



@end



@implementation DiscoverTableViewCell

-(void)setDiscoverModel:(DiscoverModel *)discoverModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:discoverModel.image] placeholderImage:nil];
    self.headImage.layer.cornerRadius = 30;
    self.headImage.clipsToBounds = YES;
    self.titlieLabel.text = discoverModel.title;

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
