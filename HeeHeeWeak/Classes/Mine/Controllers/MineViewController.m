//
//  MineViewController.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "ProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "SharView.h"
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *headImageButton;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) UILabel *nameLabel;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.imageArray = @[@"btn_order_wait", @"btn_recommend", @"ac_details_recommed_img", @"btn_share_selected", @"home"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存",@"用户反馈",@"给我评分",@"分享给好友",@"当前版本1.0", nil ];
    
   
    
    [self setupTableViewHeaderView];
}

//每次当页面将要重写出现的时候重新计算图片缓存大小
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次当页面将要重写出现的时候重新计算图片缓存大小
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.02f)M",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indePath] withRowAnimation:UITableViewRowAnimationFade];

}

-(UIButton *)headImageButton{
    if (_headImageButton == nil) {
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.frame = CGRectMake(20, 20, 120, 120);
        [self.headImageButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
        self.headImageButton.backgroundColor = [UIColor whiteColor];
        [self.headImageButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.headImageButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        self.headImageButton.layer.cornerRadius = 60;
        self.headImageButton.clipsToBounds = YES;
    }
    return _headImageButton;
    
}

//点击头像上的登陆注册按钮
- (void)loginAction:(UIButton *)btn{
    
    
}


#pragma mark ------------------------ UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}


#pragma mark ------------------------ UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            //清除缓存
            [self clearImage];
            [ProgressHUD showSuccess:@"已为您清楚完毕!"];
        }
            break;
        case 1:{
            //发送邮件
            [self sendEmail];
            
        }
            break;
        case 2:{
            //评分
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
            break;
        case 3:{
            //分享
            [self share];
            
        }
            break;
        case 4:{
            [ProgressHUD show:@"正在为您检测..."];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
    
        }
            break;
            
        default:
            break;
    }


}

//清理图片缓存
- (void)clearImage{

    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearDisk];
    [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indePath] withRowAnimation:UITableViewRowAnimationFade];
    

}

//发送邮件
- (void)sendEmail{
    Class mailClass = NSClassFromString(@" MFMailComposeViewController");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            //初始化发送邮件类对象
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"用户反馈"];
            //设置收件人
            NSArray *reciverArray = [NSArray arrayWithObjects:@"1216747227@qq.com", nil];
            [picker setToRecipients:reciverArray];
            //设置发送内容
            NSString *textEmail = @"请留下您宝贵的意见:";
            [picker setMessageBody:textEmail isHTML:NO];
            //推出视图
            [self presentViewController:picker animated:YES completion:nil];

        } else {
            WXJLog(@"未配置邮箱账号");
        }
    } else {
        WXJLog(@"当前设备不能发送");
    }
    
}

//检查更新
- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"恭喜您，当前已是最新版本"];
}

//邮件发送完成调用的方法
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled: //取消
            WXJLog(@"MFMailComposeResultCancelled - 取消");
            break;
        case MFMailComposeResultFailed: //尝试保存或发送邮件失败
            WXJLog(@"MFMailComposeResultCancelled - 失败");
            break;
        case MFMailComposeResultSaved: //保存
            WXJLog(@"MFMailComposeResultCancelled - 保存");
            break;
        case MFMailComposeResultSent: //发送成功
            WXJLog(@"MFMailComposeResultCancelled - 发送成功");
            break;
        default:
            break;
    }


}

//调用分享
- (void)share{
    SharView *shareView = [[SharView alloc] init];
    [self.view addSubview:shareView];
}



#pragma mark -------------------------------- 自定义方法
- (void)setupTableViewHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    headView.backgroundColor = MainColor;
    [headView addSubview:self.headImageButton];
    [headView addSubview:self.nameLabel];
    self.tableView.tableHeaderView = headView;
}


#pragma mark------------------------------ 懒加载

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 110) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
    }
    return _tableView;
}


-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 45, kWidth - 200, 60)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.text = @" 欢迎来到  嘻嘻乐周末!";
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:21.0];
        
    }
    return _nameLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
