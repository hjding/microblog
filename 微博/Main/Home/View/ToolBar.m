//
//  ToolBar.m
//  微博
//
//  Created by hjd on 15/9/22.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import "ToolBar.h"

@implementation ToolBar

-(id)initWithFrame:(CGRect)frame delegate:(id<ToolBarDelegate>)toolBarDelegate{
    self=[super initWithFrame:frame];
    if (self) {
//        self.frame=frame;
        _toolBarDelegate=toolBarDelegate;
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews{
    UIView *line_top=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    line_top.backgroundColor=kHomeBg;
    [self addSubview:line_top];
    
    CGFloat width_button=(self.frame.size.width-2)/3.0;
    CGFloat height_button=(self.frame.size.height-2);
    self.bt_retweet=[self buttonWithPNG:@"timeline_icon_retweet"];
    self.bt_retweet.tag=0;
    self.bt_retweet.frame=CGRectMake(0, line_top.bottom, width_button, height_button);
    [self addSubview:self.bt_retweet];
    
    UIView *line_1=[[UIView alloc]initWithFrame:CGRectMake(self.bt_retweet.right, height_button/4.0, 1, height_button/2.0)];
    line_1.backgroundColor=kHomeBg;
    [self addSubview:line_1];
    
    self.bt_comment=[self buttonWithPNG:@"timeline_icon_comment"];
    self.bt_comment.tag=1;
    self.bt_comment.frame=CGRectMake(line_1.right, self.bt_retweet.top, width_button, height_button);
    [self addSubview:self.bt_comment];
    
    UIView *line_2=[[UIView alloc]initWithFrame:CGRectMake(self.bt_comment.right, line_1.top, line_1.width, line_1.height)];
    line_2.backgroundColor=line_1.backgroundColor;
    [self addSubview:line_2];
    
    self.bt_like=[self buttonWithPNG:@"timeline_icon_unlike"];
    self.bt_like.tag=2;
    self.bt_like.frame=CGRectMake(line_2.right, self.bt_retweet.top, width_button, height_button);
    [self.bt_like setImage:[UIImage imageWithName:@"timeline_icon_like"] forState:UIControlStateSelected];
    [self addSubview:self.bt_like];
    
//    self.bt_like.backgroundColor=[UIColor greenColor];
//    self.bt_retweet.backgroundColor=[UIColor redColor];
//    self.bt_comment.backgroundColor=[UIColor blueColor];
    
    UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    line_bottom.backgroundColor=kHomeBg;
    [self addSubview:line_bottom];
    
}

-(UIButton *)buttonWithPNG:(NSString *)png {
    
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:[UIImage imageWithName:png] forState:UIControlStateNormal];
    [bt setTitleColor:kWordsDetailColor forState:UIControlStateNormal];
    bt.titleLabel.font=[UIFont systemFontOfSize:kDetailFontSize];
    [bt addTarget:self action:@selector(btPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return bt;
}

-(void)setDic_status:(NSDictionary *)dic_status{
    
    
    [self.bt_retweet setTitle:[NSString stringWithFormat:@"%@",dic_status[@"reposts_count"]] forState:UIControlStateNormal];
    [self.bt_comment setTitle:[NSString stringWithFormat:@"%@",dic_status[@"comments_count"]] forState:UIControlStateNormal];
    [self.bt_like setTitle:[NSString stringWithFormat:@"%@",dic_status[@"attitudes_count"]]forState:UIControlStateNormal];
}

-(void)btPressed:(UIButton *)bt{
    
    if ([self.toolBarDelegate respondsToSelector:@selector(toolBar:buttonIndex:)]) {
        [self.toolBarDelegate toolBar:self buttonIndex:bt.tag];
    }
    
//    if (bt==self.bt_retweet) {
//        if ([self.toolBarDelegate respondsToSelector:@selector(toolBar:buttonIndex:)]) {
//            [self.toolBarDelegate toolBar:self buttonIndex:bt.tag];
//        }
//    }
//    else if (bt==self.bt_comment){
//        
//    }
//    else if (bt==self.bt_like){
//        
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

