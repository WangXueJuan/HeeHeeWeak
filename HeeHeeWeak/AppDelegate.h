//
//  AppDelegate.h
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    NSString *wbtoken;
    NSString *webCurrentUserID;
}
@property(nonatomic,strong) NSString *wbtoken;
@property(nonatomic, strong) NSString *webCurrentUserID;

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UITabBarController *tabBarVC;
@property (strong, nonatomic) NSString *wbRefreshToken;
@end

