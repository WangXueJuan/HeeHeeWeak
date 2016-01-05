//
//  MainViewController.h
//  HeeHeeWeak
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFURLSessionManager.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface MainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate>

@end
