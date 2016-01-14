//
//  HotActivityViewController.m
//  HeeHeeWeak
//  热门专题
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "HotActivityViewController.h"
#import "HotActivityModel.h"
#import "PullingRefreshTableView.h"
#import "HotActivityTableViewCell.h"
#import "HWTools.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ThemeViewController.h"
#import "ActivityThemView.h"

@interface HotActivityViewController ()<UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    //定义网页请求的页码
    NSInteger _pageCount;

}

@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tabelView;
@property(nonatomic, strong) NSMutableArray *listArray;
@property(nonatomic, strong) NSMutableArray *acArray;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门专题";
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tabelView];
    [self showBackButton];
    //注册cell
    [self.tabelView registerNib:[UINib nibWithNibName:@"HotActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    //启动自动刷新
    [self.tabelView launchRefreshing];
    
}

#pragma mark -------------------- UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotActivityTableViewCell *hotCell = [self.tabelView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HotActivityModel *model = self.listArray[indexPath.row];
    hotCell.hotModel = model;
    return hotCell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.listArray.count;
}

#pragma mark --------------------------- UITableViewDelegate



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotActivityModel *hotModel = self.listArray[indexPath.row];
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    themeVC.themeId = hotModel.hotActivityId;
    [self.navigationController pushViewController:themeVC animated:YES];

}

#pragma mark --------------------------- UITableViewDelegate

//下拉刷新时调用
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];

}

//上拉加载时调用
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];

}


//懒加载
-(PullingRefreshTableView *)tabelView{
    if (_tabelView == nil) {
        self.tabelView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(5, 5, kWidth - 10, kHeight - 50) pullingDelegate:self];
        self.tabelView.rowHeight = 160;
        self.tabelView.dataSource = self;
        self.tabelView.delegate  =self;
       
    }
    return  _tabelView;
}

-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

//网路请求数据
-(void)loadData{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld",kHotActivityThem,(long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *aArray = successDic[@"rcData"];
            //下拉刷新的时候需要移除数组中的数据
            if (self.refreshing) {
                if (self.acArray.count > 0) {
                    [self.acArray removeLastObject];
                }
            }
            
            for (NSDictionary *dic in aArray) {
                HotActivityModel *hoModel = [[HotActivityModel alloc] initWithDictionary:dic];
                
                [self.listArray addObject:hoModel];
            }
            
        }
        //完成加载
        [self.tabelView tableViewDidFinishedLoading];
        self.tabelView.reachedTheEnd = NO;
        [self.tabelView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXJLog(@"error = %@",error);
    }];



}

//刷新完成时间
-(NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowTime];
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tabelView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tabelView tableViewDidEndDragging:scrollView];
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
