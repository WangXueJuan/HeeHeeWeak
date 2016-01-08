//
//  ThemeViewController.m
//  HeeHeeWeak
//  活动专题
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ThemeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityThemView.h"
@interface ThemeViewController ()
@property(nonatomic, strong) ActivityThemView *themeView;
@end

@implementation ThemeViewController

-(void)loadView{
    [super loadView];
    
    //隐藏 tabBar
    self.tabBarController.tabBar.hidden = YES;
    self.themeView = [[ActivityThemView alloc] initWithFrame:self.view.frame];
    self.view = self.themeView;
    //请求网络数据
    [self getDataModel];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIViewController
    //加上自定义的返回 按钮
    [self showBackButton];
    
    
}

#pragma mark ---------------------- Custom Method

-(void)getDataModel{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManger GET:[NSString stringWithFormat:@"%@&id=%@",kActivityTheme,self.themeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            self.themeView.dataDic = dic[@"success"];
            //导航栏标题
            self.navigationItem.title = dic[@"success"][@"title"];
        } else {
        
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXJLog(@"error = %@",error);
        
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
