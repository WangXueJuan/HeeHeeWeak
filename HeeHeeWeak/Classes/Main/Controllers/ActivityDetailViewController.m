//
//  ActivityDetailViewController.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"活动详情";
    
    [self showBackButton];
    //网络请求
    [self getModel];
}


#pragma mark ------------------- custom Method

- (void)getModel{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [sessionManger GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetailList,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//      [MBProgressHUD hideHUDForView:self.view animated:YES];
        WXJLog(@"downloadProgress = %@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        WXJLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];        WXJLog(@"error = %@",error);
    }];
    

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
