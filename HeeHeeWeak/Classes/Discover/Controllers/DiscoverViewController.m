//
//  DiscoverViewController.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "HWTools.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "DiscoverModel.h"
#import "ActivityDetailViewController.h"
@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *likeArray;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //只有下拉刷新
    [self.tableView setHeaderOnly:YES];
    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];
    //网路请求
    [self getRequestData];
}

- (void)getRequestData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"正在加载中..."];
    [manger GET:kDiscoverList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSMutableArray *array = [NSMutableArray new];
            array = successDic[@"like"];
            for (NSDictionary *dict in array) {
                DiscoverModel *model = [[DiscoverModel alloc] initWithDictionary:dict];
                [self.likeArray addObject:model];
               
            }
            
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];


}


#pragma mark ------------------------------ UITableViewDelegate
//选中方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [storyBoard instantiateViewControllerWithIdentifier:@"activityDetailVC"];
    DiscoverModel *model = self.likeArray[indexPath.row];
    activityVC.activityId = model.discoverId;
    [self.navigationController pushViewController:activityVC animated:YES];
    
}

#pragma mark ------------------------------ UITableViewDataSource
//返回分区行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.likeArray.count;
}

//重用机制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DiscoverModel *model = self.likeArray[indexPath.row];
    cell.discoverModel = model;

    return cell;

}

#pragma mark-------------------------------------- 懒加载

-(PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(5, 5, kWidth - 10, kHeight - 120) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 130;
        
    }
    return _tableView;

}

-(NSMutableArray *)likeArray{
    if (!_likeArray) {
        self.likeArray = [NSMutableArray new];
    }
    return _likeArray;
}

#pragma mark ------------------------- PullingRefreshTableViewDelegate

//下拉刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(getRequestData) withObject:nil afterDelay:1.0];

}

-(NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowTime];
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    
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
