//
//  ClassifyViewController.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ClassifyViewController.h"
#import "GoodActivityTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "HWTools.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityDetailViewController.h"
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"

@interface ClassifyViewController ()<UITableViewDelegate, UITableViewDataSource, PullingRefreshTableViewDelegate>
{
//定义请求的页码
    NSInteger _pageCount;
}
@property(nonatomic, assign) BOOL refreshing;   //是否刷新
@property(nonatomic, strong) PullingRefreshTableView *tableView; //显示数据
@property(nonatomic, strong) NSMutableArray *showDataArray;  //显示数据的数组
@property(nonatomic, strong) NSMutableArray *showArray;      //演出剧目
@property(nonatomic, strong) NSMutableArray *touristArray;   //景点场馆
@property(nonatomic, strong) NSMutableArray *studyArray;     //学习益智
@property(nonatomic, strong) NSMutableArray *familyArray;    //亲子旅游
@property(nonatomic, strong) VOSegmentedControl *segMentControl;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton];
    self.title = @"分类列表";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segMentControl];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _pageCount = 1;
    
    //导航栏右侧标题
    UIBarButtonItem *rightBar1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_list"] style:UIBarButtonItemStylePlain target:self action:@selector(shaiXuanBtn:)];
    rightBar1.tintColor = [UIColor whiteColor];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    searchBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[rightBar1,searchBtn];
    
    [self getShowRequest];
    [self getTouristRequest];
    [self getStudyRequest];
    [self getFamilyRequest];
    
    [self chooseRequest];
    

}

//在页面将要消失的时候去掉所有的圈圈
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ProgressHUD dismiss];
}
#define mark --------------------------------------------- 网络请求方法

// typeid = 6 演出剧目
- (void)getShowRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"加载中，请稍后..."];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,(long)_pageCount,@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDaArray = successDic[@"acData"];
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in acDaArray) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dic];
                
                [self.showArray addObject:goodModel];
            }
            
        } else {
            
            
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXJLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    

  
}

- (void)getTouristRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // typeid = 23 景点场馆
    [ProgressHUD show:@"加载中，请稍后..."];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,(long)_pageCount,@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDaArray = successDic[@"acData"];
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in acDaArray) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dic];
                
                [self.touristArray addObject:goodModel];
            }
            
        } else {
            
            
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXJLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    


}

// typeid = 22 学习益智
- (void)getStudyRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"加载中，请稍后..."];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,(long)_pageCount,@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WXJLog(@"downloadProgress = %@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDaArray = successDic[@"acData"];
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in acDaArray) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dic];
                
                [self.studyArray addObject:goodModel];
            }
            
        } else {
            
            
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXJLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    


}

   // typeid = 21  亲子旅游
- (void)getFamilyRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"加载中，请稍后..."];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassifyList,(long)_pageCount,@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WXJLog(@"downloadProgress = %@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDaArray = successDic[@"acData"];
            //下拉刷新删除原来的数据
            if (self.refreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in acDaArray) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dic];
                
                [self.familyArray addObject:goodModel];
            }
            
        } else {
            
            
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        //根据上一页选择的按钮，确定显示第几页数据
        [self showPreviousSelectButton];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXJLog(@"error = %@",error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    


}

//网络选择方法
- (void)chooseRequest{
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTourisPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudyRequest];
            break;
        case ClassifyListTypeFamilyTravel:
            [self getFamilyRequest];
            break;
            
        default:
            break;
    }
}

//根据上一页选择的按钮，确定选择具体的第几页的数据
- (void)showPreviousSelectButton{
    //下拉刷新删除原来的数据
    if (self.refreshing) {
        if (self.showDataArray > 0) {
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTourisPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
    
}


//导航栏按钮实现方法
- (void)shaiXuanBtn:(UIBarButtonItem *)btn{

}

- (void)searchBtn:(UIBarButtonItem *)btn{

}

#pragma mark ---------------------------------- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [storyBoard instantiateViewControllerWithIdentifier:@"activityDetailVC"];
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    activityVC.activityId = model.activiId;
    [self.navigationController pushViewController:activityVC animated:YES];

}

#pragma mark --------------------------------- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *ActorCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ActorCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    ActorCell.goodModel = model;
    
    return ActorCell;
}



#pragma mark -------------------------------- PullingRefreshTableView

//下拉刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
    
}

//上拉加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}

//获取当前时间
-(NSDate *)pullingTableViewLoadingFinishedDate{
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


#define kMark ------------------------------------------------  懒加载

//懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 50) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource  =self;
        self.tableView.rowHeight = 120;
        
    }
    return _tableView;
    
}

-(VOSegmentedControl *)segMentControl{
    if (!_segMentControl) {
        self.segMentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"}]];
        self.segMentControl.contentStyle = VOContentStyleTextAlone;
        self.segMentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segMentControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segMentControl.selectedBackgroundColor = self.segMentControl.backgroundColor;
        self.segMentControl.allowNoSelection = NO;
        self.segMentControl.frame = CGRectMake(0, 0, kWidth, 50);
        self.segMentControl.indicatorThickness = 4;
        self.segMentControl.selectedSegmentIndex = self.classifyListType - 1;
        [self.view addSubview:self.segMentControl];
        //点击返回的是哪个按钮
        [self.segMentControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
                                                                                                                        
    }
    return _segMentControl;
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
    self.classifyListType = segmentCtrl.selectedSegmentIndex + 1;
    [self chooseRequest];
}


-(NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

-(NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

-(NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;

}

-(NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;

}

-(NSMutableArray *)familyArray{
    if (!_familyArray) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
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
