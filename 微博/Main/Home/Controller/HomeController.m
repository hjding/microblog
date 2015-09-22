//
//  ViewController.m
//  微博
//
//  Created by hjd on 15/9/15.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import "HomeController.h"
#import "TitleButton.h"
#import "PopMenu.h"
#import "AppDelegate.h"

@interface HomeController ()

@property(nonatomic,weak)       TitleButton         *titleButton;

@property(nonatomic,retain)     UITableView         *listView;
@property(nonatomic,retain)     NSMutableArray      *listData;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
//    [self get_public_timeline];
}

- (void)setupNavigationItem {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"navigationbar_friendsearch" highBackgroudImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"navigationbar_pop" highBackgroudImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    [self setupCenterTitle];
}

- (void)setupCenterTitle{
    
    //创建导航中间标题按钮
    TitleButton *titleButton = [[TitleButton alloc] init];
    titleButton.height = NavigationItemOfTitleViewHeight;
    
    //设置文字
    [titleButton setTitle:@"首页" forState:UIControlStateNormal];
    //设置图标
    UIImage *mainImage = [[UIImage imageWithName:@"main_badge"] scaleImageWithSize:CGSizeMake(10, 10)];
    
    [titleButton setImage:mainImage forState:UIControlStateNormal];
    //设置背景
    [titleButton setBackgroundImage:[UIImage resizableImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    //监听点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    self.titleButton = titleButton;
    
    [self setupUserInfo];
    
}

/**
 *  点击标题点击
 */
- (void)titleClick:(UIButton *)titleButton{
    // 弹出菜单
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    PopMenu *menu = [[PopMenu alloc] initWithContentView:button];
    menu.arrowPosition = PopMenuArrowPositionCenter;
    [menu showInRect:CGRectMake((self.view.frame.size.width-217)/2.0,CGRectGetMaxY([self.navigationController navigationBar].frame)-PopMenuMarginTop, 217, 400)];
}

- (void)pop{
    NSLog(@"--扫一扫--");
}

- (void)friendsearch{
//    NSLog(@"--好友搜索--");
    
    //获取用户信息
    [self setupUserInfo];
}

-(void)setupUserInfo{
//#ifndef kWBToken
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = kRedirectURI;
//    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    [WeiboSDK sendRequest:request];
////
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:kWBAuthorizeResponseNotification object:nil];
//#else
//    [self get_public_timeline];
//#endif
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic_user=[userDefault objectForKey:@"user"];
    [self.titleButton setTitle:dic_user[@"screen_name"] forState:UIControlStateNormal];
    
    
    
}

-(void)tongzhi:(NSNotification *)notification{
    [self get_public_timeline];
//#define kWBToken                            notification.userInfo[@"wbtoken"]
//#define kWBRefreshToken                     notification.userInfo[@"wbRefreshToken"]
//#define kWBCurrentUserID                    notification.userInfo[@"wbCurrentUserID"]
}

-(void)get_public_timeline{
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    queue.name=@"test2";
    NSDictionary *dic=@{@"access_token":kWBToken,
                        @"uid":kWBCurrentUserID
                        };
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" httpMethod:@"GET" params:dic queue:queue withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
        else{
            NSLog(@"%@",result);
//            self.listData=[[NSMutableArray alloc]initWithArray:<#(NSArray *)#>];
//            [self.listView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
