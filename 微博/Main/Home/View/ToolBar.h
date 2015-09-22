//
//  ToolBar.h
//  微博
//
//  Created by hjd on 15/9/22.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarDelegate;

@interface ToolBar : UIView

@property(nonatomic,assign) id<ToolBarDelegate> toolBarDelegate;

@property(nonatomic,retain) UIButton    *bt_retweet;
@property(nonatomic,retain) UIButton    *bt_comment;
@property(nonatomic,retain) UIButton    *bt_like;

@property(nonatomic,retain) NSDictionary    *dic_status;

-(id)initWithFrame:(CGRect)frame delegate:(id<ToolBarDelegate>)toolBarDelegate;

@end



@protocol ToolBarDelegate <NSObject>

@optional
-(void)toolBar:(ToolBar *)toobar buttonIndex:(NSUInteger)index;

@end