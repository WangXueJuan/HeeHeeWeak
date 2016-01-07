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
#import "PrefixHeader.pch"
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClassifyViewController.h"
#import "GoodActivityViewController.h"
#import "HotActivityViewController.h"

@interface MainViewController ()<UIScrollViewDelegate>
{
    int timerCount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据数组
@property(nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据数组
@property(nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据数组
@property(nonatomic, strong) NSMutableArray *themeArray;
//广告数据数组
@property(nonatomic, strong) NSMutableArray *adArray;
//定时器
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UIButton *activityBtn;
@property(nonatomic, strong) UIButton *themeBtn;
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
    //启动定时器
    [self startTimer];
    
    
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
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 160, 5, 320, 16)];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         ActivityDetailViewController *actiDetailVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"activityDetailVC"];
        //活动id
        MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
        actiDetailVC.activityId = mainModel.activityId;
        [self.navigationController pushViewController:actiDetailVC animated:YES];
    } else {
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
    
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;

}

#pragma mark ------------------------ Custom Method

- (void)selectCityAction:(UIBarButtonItem *)barBtn{
    //初始化一个selectCity
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController presentViewController:selectCityVC animated:YES completion:nil];
    

}

- (void)searchActivityAction:(UIBarButtonItem *)barBtn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];

}

//自定义tableView的分区头部
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 343)];
    //按钮4个
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth * i / 4, 186, kWidth / 4, kWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d",i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
    }
    
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        //创建按钮
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 10 + i;
        [touchBtn addTarget:self action:@selector(touchAdversiment:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:touchBtn];
        
    }

    [tableViewHeaderView addSubview:self.scrollView];
    self.pageControl.numberOfPages = self.adArray.count;
    [tableViewHeaderView addSubview:self.pageControl];
    [tableViewHeaderView addSubview:self.activityBtn];
    [tableViewHeaderView addSubview:self.themeBtn];
    //tableView自身有一个区头和区尾，里面的每个分区也有一个分区头和分区尾
    self.tableView.tableHeaderView = tableViewHeaderView;
    
}

//请求网络数据
- (void)requestModel{
    //kMainDataList 被定义到头文件里面的接口，引入到了 预编译文件
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [sessionManger GET:kMainDataList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        WXJLog(@"downloadProgress = %lld",downloadProgress.totalUnitCount);
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
                NSDictionary *dict = @{@"url":dic[@"url"],@"type": dic[@"type"],@"id":dic[@"id"]};
                [self.adArray addObject:dict];
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

//分类列表
- (void)mainActivityButtonAction:(UIButton *)activityBtn{
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc] init];
    [self.navigationController pushViewController:classifyVC animated:YES];

}

//精选活动
- (void)goodActivityButtonAction:(UIButton *)activityBtn{
    GoodActivityViewController *godVC = [[GoodActivityViewController alloc] init];
    [self.navigationController pushViewController:godVC animated:YES];

}

//热门专题
- (void)hotActivityButtonAction:(UIButton *)btn{
    HotActivityViewController *hotVC = [[HotActivityViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];


}

//广告图片点击方法
- (void)touchAdversiment:(UIButton *)adBtn{
    //从数组中取出字典数据中的 type 类型
    NSString *type = self.adArray[adBtn.tag - 10][@"type"];
    if ([type integerValue] == 1) {
        UIStoryboard *mainStorboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityDetailViewController *actiDetailVC = [mainStorboard instantiateViewControllerWithIdentifier:@"activityDetailVC"];
        
        //活动id
        actiDetailVC.activityId = self.adArray[adBtn.tag - 10][@"id"];
        
        [self.navigationController pushViewController:actiDetailVC animated:YES];
    } else{
    
        HotActivityViewController *hotActivityVC = [[HotActivityViewController alloc] init];
        [self.navigationController pushViewController:hotActivityVC animated:YES];
    }
    
   

}

// scrollView懒加载
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
        self.scrollView.contentSize = CGSizeMake(kWidth * self.adArray.count, 186);
        //滑动时显示整张图片
        self.scrollView.pagingEnabled = YES;
        //不显示水平方向的滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
    }
    
    return _scrollView;

}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        //设置小圆点和定时器，让scrollView实现定时滑动
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 150, kWidth, 30)];
        //小圆点个数
        self.pageControl.numberOfPages = self.adArray.count;
        //选中颜色未青色
        self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

//精选活动按钮
- (UIButton *)activityBtn{
    if (_activityBtn == nil) {
        //精选活动按钮
        self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.activityBtn.frame = CGRectMake(0, 186 + kWidth / 4, kWidth / 2 ,343 - 186 -kWidth / 4);
        [self.activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
        [self.activityBtn addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return  _activityBtn;
}

//热门专题按钮
- (UIButton *)themeBtn{
    if (_themeBtn == nil) {
        //热门专题按钮
        self.themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.themeBtn.frame = CGRectMake(kWidth / 2, 186 + [UIScreen mainScreen].bounds.size.width / 4, kWidth / 2 ,343 - 186 - kWidth / 4);
        [self.themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
        [self.themeBtn addTarget:self action:@selector(hotActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _themeBtn;
}

#pragma mark ------------------ 首页轮播图
- (void)startTimer{
    
    if (self.timer != nil) {
        return;
    }
   self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(rollAnimationAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//每2秒执行一次，自动轮播
- (void)rollAnimationAction:(NSTimer *)timer{
    //把pageController当前页 + 1
    NSInteger rollPage = (self.pageControl.currentPage + 1) % self.adArray.count;
    self.pageControl.currentPage = rollPage;
    //计算scrollView应该滚动的x轴的坐标
    CGFloat offsetX = self.pageControl.currentPage * kWidth;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

/*
 当手动去滑动scrollView的时候，定时器依然在计算时间，可能我们刚刚滑动到下一页，，定时器时间又刚好触发，导致在当前页面停留不够2秒。
 解决方案：
 在scrollView开始移动的时候结束定时器,在scrollView移动完毕的时候，再启动定时器
 */

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    [self.timer invalidate]; // 停止定时器后并置为 0 ，才能保证定时器正常那个运行
    self.timer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer isValid];

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


#pragma mark ---------------  UIPageControl的方法实现

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //1.获取scrollView页面宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //2.获取scrollView停止是的偏移量
    //contentOffset 是当前scrollView距离原点偏移的位置
    CGPoint offset = self.scrollView.contentOffset;
    //3.通过偏移量和页面宽度计算当前页数
    NSInteger pageNumber = offset.x / pageWidth;
    self.pageControl.currentPage = pageNumber;


}

- (void)pageSelectAction:(UIPageControl *)page{
    //获取当前页面
    NSInteger pageNum = page.currentPage;
    //获取scrollView页面宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //让scrollView滚动到第几页
    self.scrollView.contentOffset = CGPointMake(pageNum * pageWidth, 0);

    
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
