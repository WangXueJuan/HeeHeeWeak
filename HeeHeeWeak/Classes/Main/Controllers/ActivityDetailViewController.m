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
#import "ActivityDetailView.h"
@interface ActivityDetailViewController ()


@property (strong, nonatomic) IBOutlet ActivityDetailView *ActivityDetailView;





@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.ActivityDetailView.dataDic = successDic;
            
        } else {
            
            
        
        }
        
        
        
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
