//
//  AppDelegate.m
//  微博
//
//  Created by hjd on 15/9/15.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "LoginController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    LoginController *loginController=[[LoginController alloc]init];
    self.window.rootViewController=loginController;

    [self.window makeKeyAndVisible];

    return YES;
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]){
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
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
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:[WBAuthorizeResponse class]]){
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        //通知
        NSNotification *notification =[NSNotification notificationWithName:kWBAuthorizeResponseNotification object:nil userInfo:@{@"wbtoken":self.wbtoken,@"wbCurrentUserID":self.wbCurrentUserID,@"wbRefreshToken":self.wbRefreshToken}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if ([response isKindOfClass:[WBPaymentResponse class]]){
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([response isKindOfClass:[WBSDKAppRecommendResponse class]]){
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - WBHttpRequestDelegate

-(void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@\n\n\n%@",request,response);
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
//    NSString *str=[NSString stringwith]
    NSLog(@"%@",data);
}

#pragma mark - Private Method
//微博登陆
-(void)bt_wbloginPressed{
    //隐藏键盘,键盘不隐藏bug
    [self.window endEditing:YES];
    
    [self registerAppToXinLangClient];
    
    //进去微博默认登陆页
    
    //获取用户信息
    [MBProgressHUD showMessage:@"正在登陆"];
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    queue.name=@"test1";
    NSDictionary *dic=@{@"access_token":kWBToken,
                        @"uid":kWBCurrentUserID
                        };
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dic queue:queue withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error){
        if (error) {
            NSLog(@"%@",error);
        }
        else{
            
            NSDictionary *mudic_user=@{@"screen_name":result[@"screen_name"]};
            
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            [userDefault setObject:mudic_user forKey:@"user"];
            
            //登陆成功进入主界面
            [self goToMain];
        }
    }];
}

//进去主界面
-(void)goToMain{
    TabBarController *tabBarController=[[TabBarController alloc]init];
    self.window.rootViewController=tabBarController;
    
    [MBProgressHUD hideHUD];
}

//向微博客户端程序注册第三方应用
-(void)registerAppToXinLangClient{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kXinLangWeiboAppKey];
}

@end
