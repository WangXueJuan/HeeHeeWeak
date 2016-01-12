//
//  GoodActivityViewController.m
//  HeeHeeWeak
//   精彩活动
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "GoodActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import "HWTools.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityDetailViewController.h"
@interface GoodActivityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>

{
  //定义请求的页码
    NSInteger _pageCount;
}
@property(nonatomic ,assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *acArray;


@end

@implementation GoodActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.title = @"精选活动";
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //启动刷新
    [self.tableView launchRefreshing];
    
}

#pragma mark -----------------------  UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.acArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodActivityModel *model = self.acArray[indexPath.row];
    goodCell.goodModel = model;
    return goodCell;

}

#pragma mark -----------------------  UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [storyBoard instantiateViewControllerWithIdentifier:@"activityDetailVC"];
    GoodActivityModel *model = self.acArray[indexPath.row];
    activityVC.activityId = model.activiId;
    [self.navigationController pushViewController:activityVC animated:YES];

}

#pragma mark ---------------------------- 懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 120;
       
    }
    return _tableView;
}


#pragma mark ------------------------- PullingRefreshDelegate
//tableView下拉刷新时调用
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
     //下拉刷新，加载数据
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];


}

//tableView上拉加载时调用
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    

}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowTime];
}

//加载数据调用此方法
- (void)loadData{
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld",kGoodActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            //下拉刷新的时候需要移除数组中的数据
            if (self.refreshing) {
                if (self.acArray.count > 0) {
                    [self.acArray removeLastObject];
                }
            }
            
            for (NSDictionary *dic in acDataArray) {
                GoodActivityModel *goodMod = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.acArray addObject:goodMod];
            }
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}


//懒加载数组
-(NSMutableArray *)acArray{
    if (_acArray == nil) {
        self.acArray = [NSMutableArray new];
    }
    return _acArray;

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
