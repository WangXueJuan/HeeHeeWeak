//
//  MainViewController.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据数组
@property(nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据数组
@property(nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据数组
@property(nonatomic, strong) NSMutableArray *themeArray;
//广告数据数组
@property(nonatomic, strong) NSMutableArray *adArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //left
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    //right
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchActivityAction:)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    //自定义tableView的头部
    [self configTableViewHeaderView];
    //请求网络数据
    [self requestModel];
    
}


#pragma mark --------------- 实现UITableViewDataSource代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.mainModel = array[indexPath.row];
    
    
    return mainCell;
    

}

#pragma mark --------------- 实现UITableViewDelegate代理方法

//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}

//自定义分区头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 160, 5, 320, 16)];
    if (section == 0) {
        UIImage *image = [UIImage imageNamed:@"home_recommed_ac"];
        sectionView.backgroundColor = [UIColor colorWithPatternImage:image];
    } else {
        UIImage *image = [UIImage imageNamed:@"home_recommd_rc"];
        sectionView.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    [view addSubview:sectionView];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;

}

#pragma mark ------------------------ Custom Method

- (void)selectCityAction:(UIBarButtonItem *)barBtn{

}

- (void)searchActivityAction:(UIBarButtonItem *)barBtn{

}

//自定义tableView的分区头部
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186)];
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.adArray.count, 186);
    //滑动时显示整张图片
    scrollView.pagingEnabled = YES;
    
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i]] placeholderImage:nil];
        [scrollView addSubview:imageView];
    }
    [tableViewHeaderView addSubview:scrollView];
    
    
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * i / 4, 186, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d",i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
    }
    
    //精选活动按钮
    UIButton *ActivityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ActivityBtn.frame = CGRectMake(0, 186 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2 ,343 - 186 -[UIScreen mainScreen].bounds.size.width / 4);
    [ActivityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
    [ActivityBtn addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:ActivityBtn];
    //热门专题按钮
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 186 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2 ,343 - 186 -[UIScreen mainScreen].bounds.size.width / 4);
    [themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
    [themeBtn addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:themeBtn];
    
    
    //tableView自身有一个区头和区尾，里面的每个分区也有一个分区头和分区尾
    self.tableView.tableHeaderView = tableViewHeaderView;
    
}

- (void)requestModel{
    NSString *str = [NSString stringWithFormat:@"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"];
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [sessionManger GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"downloadProgress = %lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求得到的数据
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            NSString *cityName = dic[@"cityname"];
           //推荐活动
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新tableView数据
            [self.tableView reloadData];
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                [self.adArray addObject:dic[@"url"]];
            }
            //拿到数据之后重新刷新tableView
            [self configTableViewHeaderView];
            //以请求回来的城市作为导航栏左侧按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            
        } else {
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
    

}

- (void)mainActivityButtonAction:(UIButton *)activityBtn{


}

- (void)goodActivityButtonAction:(UIButton *)activityBtn{

}

#pragma mark ------------------ LazyLoading

//懒加载初始化数组
-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

-(NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;

}

-(NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}

-(NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
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
