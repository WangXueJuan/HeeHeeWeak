//
//  ActivityDetailViewController.m
//  HeeHeeWeak
//  活动详情
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "ActivityDetailView.h"
@interface ActivityDetailViewController ()
{
    NSString *phoneNum;
}

@property (strong, nonatomic) IBOutlet ActivityDetailView *ActivityDetailView;





@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    
    //隐藏 tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    //打电话
    self.ActivityDetailView.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ActivityDetailView.phoneButton addTarget:self action:@selector(makePhoneCallButton:) forControlEvents:UIControlEventTouchUpInside];
    //地图
    self.ActivityDetailView.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ActivityDetailView.mapButton addTarget:self action:@selector(makeMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self showBackButton];
    //网络请求
    [self getModel];
}


#pragma mark ------------------- custom Method

//从网络请求数据
- (void)getModel{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [sessionManger GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetailList,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.ActivityDetailView.dataDic = successDic;
            //获取电话号码
            phoneNum = successDic[@"tel"];
           
            
        } else {
            
            
        
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    

}


//去地图页
- (void)makePhoneCallButton:(UIButton *)button{


}

//打电话
- (void)makeMapButton:(UIButton *)button{
    //程序外打电话。打完电话之后不返回当前应用程序
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tell://%@",phoneNum]]];
    
    //程序内打电话。打完电话之后返回当前应用程序
    
    UIWebView *cellPhoneWebView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tell://%@",phoneNum]]];
    [cellPhoneWebView loadRequest:request];
    [self.view addSubview:cellPhoneWebView];


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
