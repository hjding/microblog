//
//  TabBar.h
//  微博
//
//  Created by hjd on 15/9/15.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;

@protocol TabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(TabBar *)tabBar;

@end


@interface TabBar : UITabBar

@property (nonatomic , weak) id<TabBarDelegate> tabBarDelegate;

@end
