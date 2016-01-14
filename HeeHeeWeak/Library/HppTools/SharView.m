//
//  SharView.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "SharView.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"

@interface SharView ()
@property(nonatomic, strong) UIView *sharView;
@property(nonatomic, strong) UIView *blackView;

@end


@implementation SharView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
        
    }
    return self;

}

//显示的四个按钮 和 label
- (void)configView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.blackView.alpha = 0.0;
    self.blackView.backgroundColor = [UIColor blackColor];
    [window addSubview:self.blackView];
    
    self.sharView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 200, kWidth, 200)];
    self.sharView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.sharView];
    //新浪微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(15, 10, 100, 80);
    [weiboBtn setImage:[UIImage imageNamed:@"sina_weibo"] forState:UIControlStateNormal];
    weiboBtn.tag = 1;
    [weiboBtn addTarget:self action:@selector(sharBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sharView addSubview:weiboBtn];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 100, 30)];
    label1.text = @"新浪微博";
    label1.textAlignment = NSTextAlignmentCenter;
    [self.sharView addSubview:label1];
    //朋友圈
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(130, 10, 100, 80);
    [friendBtn setImage:[UIImage imageNamed:@"py_normal-1"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(sharBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    friendBtn.tag = 2;
    [self.sharView addSubview:friendBtn];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 80, 100, 30)];
    label2.text = @"朋友圈";
    label2.textAlignment = NSTextAlignmentCenter;
    [self.sharView addSubview:label2];
    //微信
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(245, 10, 100, 80);
    [weixinBtn setImage:[UIImage imageNamed:@"icon_pay_weixin"] forState:UIControlStateNormal];
    weixinBtn.tag = 3;
    [weixinBtn addTarget:self action:@selector(sharBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sharView addSubview:weixinBtn];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(245, 80, 100, 30)];
    label3.text = @"微 信";
    label3.textAlignment = NSTextAlignmentCenter;
    [self.sharView addSubview:label3];
    //remove
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(50, 135, 270, 40);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    removeBtn.backgroundColor = [UIColor cyanColor];
    [removeBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sharView addSubview:removeBtn];
    
    /*
     animateWithDuration:1.0 animations:^ 默认会禁止手势，触摸，可以通过options来打开用户交互
     */
    [UIView animateWithDuration:1.0 animations:^{
        self.blackView.alpha = 0.8;
        self.sharView.frame = CGRectMake(0, kHeight - 200, kWidth, 200);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.blackView.alpha = 0.8;
        }];
    }];
    



}

//点击取消按钮，移除这个视图
- (void)cancelAction{
    [UIView animateWithDuration:1.0 animations:^{
        self.blackView.alpha = 0.0;
        self.sharView.alpha = 0.0;
    }];
    [self.sharView removeAllSubviews];
    [self.blackView removeAllSubviews];
    
}

//点击 朋友圈 微信 新浪微博 分享按钮
- (void)sharBtnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1:{
            //新浪微博分享
            AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            WBAuthorizeRequest *authRequest =[WBAuthorizeRequest request];
            authRequest.redirectURI = kRedirectURL;
            authRequest.scope = @"all";
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
            [WeiboSDK sendRequest:request];
            
            [self.blackView removeFromSuperview];
            [self.sharView removeFromSuperview];
            
            
        }
            break;
        case 2:{
            //朋友圈分享
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.text = @"周末去哪嗨？和我一起下载“嘻嘻乐周末”吧，这是一款集 旅游，美食，亲子活动为一体的软件，让你的周末大声嗨起来!!!嘻嘻🌹🌹🌺";
            req.bText = YES;
            //发送场景为 微信朋友圈，默认为 会话窗口
            req.scene = WXSceneTimeline;
            [WXApi sendReq:req];
            
            
        }
            break;
        case 3:{
            //微信分享给朋友
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.text = @"周末去哪嗨？和我一起下载“嘻嘻乐周末”吧，这是一款集 旅游，美食，亲子活动为一体的软件，让你的周末大声嗨起来!!!嘿嘿嘿嘿嘿嘿🌺";
            req.bText = YES;
            req.scene = WXSceneSession;
            [WXApi sendReq:req];
            
            
        }
            break;
    }
}

- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = NSLocalizedString(@"这个应用太好玩了，在这里吃的开心，玩的高兴，让您的周末和家人共享天伦之乐，快去下载和我一起玩吧!", nil);
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shar" ofType:@".png"]];
    message.imageObject = image;
    
    return message;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
