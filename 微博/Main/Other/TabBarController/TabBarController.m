//
//  TabBarController.m
//  微博
//
//  Created by hjd on 15/9/15.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"	
#import "HomeController.h"
#import "MessageController.h"
#import "FoundController.h"
#import "MeController.h"
#import "TabBar.h"
#import "SDTableViewController.h"

@interface TabBarController ()<TabBarDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAllChildControllers];
    
    [self addCustomTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addAllChildControllers{
//    HomeController *homeController=[[HomeController alloc]init];
    SDTableViewController *homeController=[[SDTableViewController alloc]init];
    [self addOneChildVc:homeController title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    MessageController *messageController=[[MessageController alloc]init];
    [self addOneChildVc:messageController title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    FoundController *foundController=[[FoundController alloc]init];
    [self addOneChildVc:foundController title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    MeController *meController=[[MeController alloc]init];
    [self addOneChildVc:meController title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

-(void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {

    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (IOS7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;

    NavigationController *navigationController=[[NavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:navigationController];
}

- (void)addCustomTabBar {
    //创建自定义tabbar
    TabBar *customTabBar = [[TabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    //更换系统自带的tabbar
    [self setValue:customTabBar forKey:@"tabBar"];
}

+ (void)initialize{
    //设置底部tabbar的主题样式
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CommonColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}

#pragma mark - DSTabBarDelegate
- (void)tabBarDidClickedPlusButton:(TabBar *)tabBar{
    NSLog(@"+");
    [MBProgressHUD showSuccess:@"发表成功"];
}

@end
