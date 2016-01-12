//
//  HotActivityTableViewCell.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "HotActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;


@end


@implementation HotActivityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kWidth, 150);
        
    }
    return self;
}


-(void)setHotModel:(HotActivityModel *)hotModel{
    
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.headImageView] placeholderImage:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
