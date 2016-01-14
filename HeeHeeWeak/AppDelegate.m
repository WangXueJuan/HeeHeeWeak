//
//  AppDelegate.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "WeiboSDK.h"
#import "WBHttpRequest+WeiboShare.h"
#import "WBHttpRequest+WeiboToken.h"
@interface AppDelegate ()<WeiboSDKDelegate,WBHttpRequestDelegate>

@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize webCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    //UITableBarController
    self.tabBarVC = [[UITabBarController alloc] init];
    //创建被tabBarC管理的视图控制器
    //主页
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainStoryboard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic.png"];
    //设置tabBar选中图片模式，按照图片原始状态显示
    UIImage *mainSelectedImage = [UIImage imageNamed:@"ft_home_selected_ic.png"];
    mainNav.tabBarItem.selectedImage = [mainSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //调整tabBar图片显示的位置（顺序为：上，左，下，右）
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //发现
    UIStoryboard *discoverStorboard = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverStorboard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic.png"];
    
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //设置tabBar选中的图片模式，按照图片原始状态显示
    UIImage *discoverSelectedImage = [UIImage imageNamed:@"ft_found_selected_ic.png"];
    discoverNav.tabBarItem.selectedImage = [discoverSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //我的
    UIStoryboard *mineStorboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *mineNav = mineStorboard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_selected_ic.png"];
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //设置选中图片
    UIImage *mineSelectImage = [UIImage imageNamed:@"ft_person_selected_ic.png"];
    mineNav.tabBarItem.selectedImage = [mineSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //添加被管理的视图
    self.tabBarVC.viewControllers = @[mainNav,discoverNav,mineNav];
    //设置tabBar导航栏的颜色
    self.tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    
    
    self.window.rootViewController = self.tabBarVC;
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#define mark -------------------- shar weibo
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    return [WeiboSDK handleOpenURL:url delegate:self];
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{

}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"恭喜您，分享成功!", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.webCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"认真结果"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.webCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        [alert show];
    }
}

//返回请求加载的结果
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    NSString *title = nil;
    UIAlertView *alert = nil;
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@",result] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}

//请求失败
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    NSString *title = nil;
    UIAlertView *alert = nil;
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
