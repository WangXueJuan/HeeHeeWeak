//
//  MainViewController.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
    
}


#pragma mark --------------- 实现UITableViewDataSource代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    return mainCell;
    

}

#pragma mark --------------- 实现UITableViewDelegate代理方法

//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
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
