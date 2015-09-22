//
//  AppDelegate.h
//  微博
//
//  Created by hjd on 15/9/15.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *wbRefreshToken;

@end

