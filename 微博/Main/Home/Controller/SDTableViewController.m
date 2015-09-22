//
//  SDTableViewController.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */


#import "SDTableViewController.h"
#import "SDRefresh.h"
#import "TitleButton.h"
#import "PopMenu.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ToolBar.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

#define kLogoHeight 35.f
#define kBottomToolHeight   40.f

@interface SDTableViewController () <SDRefreshViewAnimationDelegate,ToolBarDelegate>
{
    BOOL isFooterRefreshing;
}

@property(nonatomic,weak) TitleButton *titleButton;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;

@property(nonatomic,retain) NSMutableArray  *listData;
@property(nonatomic) NSUInteger page;

@end

@implementation SDTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//        self.title = @"上拉和下拉刷新";
//        self.tableView.rowHeight = 60.0f;
//        self.tableView.separatorColor = [UIColor whiteColor];
//         模拟数据
        self.page=1;
        isFooterRefreshing=NO;
        self.listData=[[NSMutableArray alloc]init];
//        self.tableView.backgroundColor=Color(221, 221, 221,1);
        self.tableView.backgroundColor=kHomeBg;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupHeaderAndFooter];
}

-(void)setupHeaderAndFooter{
    [self setupHeader];
    [self setupFooter];
}

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    refreshHeader.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    _refreshHeader = refreshHeader;
    
//    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        [self refreshData];
    };
    
    // 动画view
    UIImageView *animationView = [[UIImageView alloc] init];
    animationView.frame = CGRectMake(30, 45, 40, 40);
    animationView.image = [UIImage imageNamed:@"staticDeliveryStaff"];
    [refreshHeader addSubview:animationView];
    _animationView = animationView;
    
    NSArray *images = @[[UIImage imageNamed:@"deliveryStaff0"],
                        [UIImage imageNamed:@"deliveryStaff1"],
                        [UIImage imageNamed:@"deliveryStaff2"],
                        [UIImage imageNamed:@"deliveryStaff3"]
                        ];
    _animationView.animationImages = images;
    
    
    UIImageView *boxView = [[UIImageView alloc] init];
    boxView.frame = CGRectMake(150, 10, 15, 8);
    boxView.image = [UIImage imageNamed:@"box"];
    [refreshHeader addSubview:boxView];
    _boxView = boxView;
    
    UILabel *label= [[UILabel alloc] init];
    label.text = @"下拉加载最新数据";
    label.frame = CGRectMake((self.view.bounds.size.width - 200) * 0.5, 5, 200, 20);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [refreshHeader addSubview:label];
    _label = label;
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    self.page++;
    isFooterRefreshing=YES;
    [self refreshData];
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
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic_user=[userDefault objectForKey:@"user"];
    [self.titleButton setTitle:dic_user[@"screen_name"] forState:UIControlStateNormal];
}

-(void)refreshData{
    
    NSDictionary *dic=@{@"access_token":kWBToken,
                        @"uid":kWBCurrentUserID,
                        @"page":[NSString stringWithFormat:@"%lu",(unsigned long)self.page]
                        };
    
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" httpMethod:@"GET" params:dic queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error){
        __weak SDRefreshHeaderView *weakRefreshHeader = _refreshHeader;
        if (error) {
            NSLog(@"%@",error);
            [weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
        }
        else{
//            NSLog(@"%@",result);
            
            if (!isFooterRefreshing) {
                self.listData=[result[@"statuses"] mutableCopy];
                
                [self.tableView reloadData];
                [weakRefreshHeader endRefreshing];
            }
            else{
                [self.listData addObjectsFromArray:result[@"statuses"]];
                [self.tableView reloadData];
                [self.refreshFooter endRefreshing];
                isFooterRefreshing=NO;
            }
        }
    }];
}

#pragma mark - SDRefreshView Animation Delegate

- (void)refreshView:(SDRefreshView *)refreshView didBecomeNormalStateWithMovingProgress:(CGFloat)progress
{
    refreshView.hidden = NO;
    if (progress == 0) {
        _animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _boxView.hidden = NO;
        _label.text = @"下拉加载最新数据";
        [_animationView stopAnimating];
    }
    
    self.animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(progress * 10, -20 * progress), CGAffineTransformMakeScale(progress, progress));
    self.boxView.transform = CGAffineTransformMakeTranslation(- progress * 85, progress * 35);
    
}

- (void)refreshView:(SDRefreshView *)refreshView didBecomeRefreshingStateWithMovingProgress:(CGFloat)progress
{
    _label.text = @"客官别急，正在加载数据...";
    [UIView animateWithDuration:1.5 animations:^{
        self.animationView.transform = CGAffineTransformMakeTranslation(200, -20);
    }];
}

- (void)refreshView:(SDRefreshView *)refreshView didBecomeWillRefreshStateWithMovingProgress:(CGFloat)progress
{
    _boxView.hidden = YES;
    _label.text = @"放开我，我才帮你加载数据";
    _animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(10, -20), CGAffineTransformMakeScale(1, 1));
    [_animationView startAnimating];
}

#pragma mark - Tableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"homeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    
    [cell.contentView removeAllSubviews];
    NSDictionary *dic=self.listData[indexPath.row];
    
    UIView *view_back=[[UIView alloc]initWithFrame:CGRectMake(0, kMargin, self.tableView.width, 0)];
    view_back.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:view_back];
    
    UIView *view_header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
    view_header.backgroundColor=[UIColor whiteColor];
    [view_back addSubview:view_header];
    NSDictionary *dic_user=dic[@"user"];
    //头像
    UIImageView *iv_logo=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin, kMargin, kLogoHeight, kLogoHeight)];
    [iv_logo sd_setImageWithURL:[NSURL URLWithString:dic_user[@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    [view_header addSubview:iv_logo];
    //昵称
    UILabel *lb_name=[[UILabel alloc]init];
    lb_name.text=dic_user[@"screen_name"];
    lb_name.textColor=[UIColor redColor];
    lb_name.font=[UIFont systemFontOfSize:kDetailFontSize];
    CGSize size_name=[Helper getContentActualSize:lb_name.text WithFont:lb_name.font];
    lb_name.frame=CGRectMake(iv_logo.right+kMargin, iv_logo.top,size_name.width, size_name.height);
    [view_header addSubview:lb_name];
    //时间
    UILabel *lb_time=[[UILabel alloc]init];
    NSString *str_time=[Helper resolveSinaWeiboDate:dic[@"created_at"]];
    lb_time.text=str_time;
    lb_time.textColor=CommonColor;
    lb_time.font=[UIFont systemFontOfSize:kSmallFontSize];
    CGSize size_time=[Helper getContentActualSize:lb_time.text WithFont:lb_time.font];
    lb_time.frame=CGRectMake(lb_name.left, lb_name.bottom,size_time.width, size_time.height);
    [view_header addSubview:lb_time];
    UILabel *lb_source=[[UILabel alloc]init];
    lb_source.text=[NSString stringWithFormat:@"来自 %@",[self parseHTML:dic[@"source"]]];
    lb_source.textColor=kWordsDetailColor;
    lb_source.font=[UIFont systemFontOfSize:kSmallFontSize];
    CGSize size_source=[Helper getContentActualSize:lb_source.text WithFont:lb_source.font];
    lb_source.frame=CGRectMake(lb_time.right+5, lb_time.top,size_source.width, size_source.height);
    [view_header addSubview:lb_source];
    view_header.height+=(kMargin+iv_logo.height);
    
    UIView *view_middle=[[UIView alloc]initWithFrame:CGRectMake(0, view_header.bottom, self.tableView.width, kMargin)];
    view_middle.backgroundColor=[UIColor whiteColor];
    [view_back addSubview:view_middle];
    //文字
    UILabel *lb_text=[[UILabel alloc]init];
    if(dic[@"text"]){
        lb_text.text=dic[@"text"];
        lb_text.textColor=kWordsColor;
        lb_text.font=[UIFont systemFontOfSize:kDefaultFontSize];
        lb_text.numberOfLines=0;
        CGSize size_text=dic[@"text"]?[Helper getContentActualSize:lb_text.text withWidth:view_middle.width-2*kMargin WithFont:lb_text.font]:(CGSizeZero);
        lb_text.frame=CGRectMake(kMargin, kMargin,size_text.width, size_text.height);
        [view_middle addSubview:lb_text];
//        lb_text.backgroundColor=[UIColor greenColor];
    }
    view_middle.height+=lb_text.height;
    //配图
    if ([dic[@"pic_ids"] count]>1) {
        //多图
//        NSLog(@"多图：%@",dic[@"pic_ids"]);
        
        for (int i=0; i<[dic[@"pic_ids"] count]; i++) {
            UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin+(i%3)*(kPicThumbnail+kPicMargin), kMargin+(i/3)*(kPicThumbnail+kPicMargin), kPicThumbnail, kPicThumbnail)];
            NSString *str_url=[NSString stringWithFormat:@"%@/%@",dic[@"thumbnail_pic"],dic[@"pic_ids"][i]];
            [iv_pic sd_setImageWithURL:[NSURL URLWithString:str_url]];
            [view_middle addSubview:iv_pic];
        }
        NSUInteger count_pic=[dic[@"pic_ids"] count];
        view_middle.height+=(kMargin+ceil(count_pic/3.0)*(kPicThumbnail+kPicMargin));
    }
    else{
        if (dic[@"bmiddle_pic"]) {
            //单图
//            NSLog(@"单图：%@",dic[@"bmiddle_pic"]);
            UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin,kMargin+lb_text.bottom, kPicBmiddle, kPicBmiddle)];
            [iv_pic sd_setImageWithURL:[NSURL URLWithString:dic[@"bmiddle_pic"]]];
            [view_middle addSubview:iv_pic];
            view_middle.height+=(kMargin+iv_pic.height);
        }
    }
    //转发微博
    if (dic[@"retweeted_status"]) {
        NSDictionary *dic_retweeted_status=dic[@"retweeted_status"];
        
        UIView *view_retweet=[[UIView alloc]initWithFrame:CGRectMake(0, lb_text.bottom+kMargin, self.view.width, 0)];
        view_retweet.backgroundColor=kHomeBg;
        [view_middle addSubview:view_retweet];
        //文字
        NSString *str_screen_name=dic_retweeted_status[@"user"][@"screen_name"];
        NSString *str_text=dic_retweeted_status[@"text"];
        NSString *str_textNew=[NSString stringWithFormat:@"@%@:%@",str_screen_name,str_text];
        UILabel *lb_text=[[UILabel alloc]init];
        NSMutableAttributedString *muattStr=[[NSMutableAttributedString alloc]initWithString:str_textNew];
        [muattStr setAttributes:@{NSForegroundColorAttributeName:[UIColor cyanColor],NSFontAttributeName:[UIFont systemFontOfSize:kDefaultFontSize]} range:NSMakeRange(0,str_screen_name.length+2)];
        [muattStr setAttributes:@{NSForegroundColorAttributeName:kWordsDetailColor,NSFontAttributeName:[UIFont systemFontOfSize:kDefaultFontSize]} range:NSMakeRange(str_screen_name.length+2,str_text.length)];
        lb_text.attributedText=muattStr;
//        lb_text.text=str_text;
//        lb_text.textColor=kWordsDetailColor;
        lb_text.numberOfLines=0;
        lb_text.font=[UIFont systemFontOfSize:kDefaultFontSize];
        CGSize size_text=[Helper getContentActualSize:lb_text.text withWidth:view_retweet.width-2*kMargin WithFont:[UIFont systemFontOfSize:kDefaultFontSize]];
        lb_text.frame=CGRectMake(kMargin, kMargin,size_text.width, size_text.height);
        [view_retweet addSubview:lb_text];
//        lb_text.backgroundColor=[UIColor greenColor];
        
        view_retweet.height+=(kMargin+lb_text.height);
        
        
        if ([dic_retweeted_status[@"pic_urls"] count]>1) {
            //多图
//            NSLog(@"转发多图：%@",dic_retweeted_status[@"pic_urls"]);
            for (int i=0; i<[dic_retweeted_status[@"pic_urls"] count]; i++) {
                UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin+(i%3)*(kPicThumbnail+kPicMargin), lb_text.bottom+kMargin+(i/3)*(kPicThumbnail+kPicMargin), kPicThumbnail, kPicThumbnail)];
                NSString *str_url=[NSString stringWithFormat:@"%@",dic_retweeted_status[@"pic_urls"][i][@"thumbnail_pic"]];
                [iv_pic sd_setImageWithURL:[NSURL URLWithString:str_url]];
                [view_retweet addSubview:iv_pic];
            }
            NSUInteger count_pic=[dic_retweeted_status[@"pic_urls"] count];
//            NSLog(@"%lu===rows:%f",(unsigned long)count_pic,ceil(count_pic/3.0));
            view_retweet.height+=(kMargin+ceil(count_pic/3.0)*(kPicThumbnail+kPicMargin));
        }
        else{
            if (dic_retweeted_status[@"bmiddle_pic"]) {
                //单图
//                NSLog(@"转发单图：%@",dic_retweeted_status[@"bmiddle_pic"]);
                UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin, lb_text.bottom+kMargin, kPicBmiddle, kPicBmiddle)];
                [iv_pic sd_setImageWithURL:[NSURL URLWithString:dic_retweeted_status[@"bmiddle_pic"]]];
                [view_retweet addSubview:iv_pic];
                view_retweet.height+=(kMargin+iv_pic.height);
            }
        }
        view_retweet.height+=kMargin;
        view_middle.height+=view_retweet.height;
//        view_retweet.backgroundColor=[UIColor redColor];
    }
//    UITableView
//    view_middle.height+=kMargin;
    UIView *view_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, view_middle.bottom+kMargin, self.view.width, kBottomToolHeight)];
    view_bottom.backgroundColor=[UIColor whiteColor];
    [view_back addSubview:view_bottom];
    ToolBar *toolBar=[[ToolBar alloc]initWithFrame:CGRectMake(0, 0, view_bottom.width, view_bottom.height) delegate:self];
    toolBar.dic_status=dic;
    [view_bottom addSubview:toolBar];
    
    view_back.height=(view_header.height+view_middle.height+view_bottom.height);
    
//    view_back.height=[self heightForWeibo:dic];
    
//    view_back.backgroundColor=[UIColor yellowColor];
//    view_header.backgroundColor=[UIColor greenColor];
//    view_middle.backgroundColor=[UIColor blueColor];
//    view_bottom.backgroundColor=[UIColor purpleColor];
    
    return cell;
}

-(NSString*)parseHTML:(NSString*)html{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        NSLog(@"parseHTML Error: %@", error);
        return @"null";
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *inputNode=[bodyNode findChildTag:@"a"];
    NSString *str_content=inputNode.contents;
    
    return str_content;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell间隔
    CGFloat height=kMargin;
    NSDictionary *dic=self.listData[indexPath.row];
    height+=[self heightForWeibo:dic];
    
    return height;
}

-(CGFloat)heightForWeibo:(NSDictionary *)dic{
    //头像、昵称、时间
    CGFloat height_row=(kMargin+kLogoHeight);
    //文字
    if (dic[@"text"]) {
        height_row+=(kMargin+[Helper getContentActualSize:dic[@"text"] withWidth:self.view.width-2*kMargin WithFont:[UIFont systemFontOfSize:kDefaultFontSize]].height);
    }
    
    if([dic[@"pic_ids"] count]>1){
        //多图
        NSUInteger count_pic=[dic[@"pic_ids"] count];
        height_row+=(kMargin+ceil(count_pic/3.0)*(kPicThumbnail+kPicMargin));
    }
    else{
        if (dic[@"bmiddle_pic"]) {
            //单图
            height_row+=(kMargin+kPicBmiddle);
        }
    }
    //转发微博
    if(dic[@"retweeted_status"]){
        NSDictionary *dic_retweeted_status=dic[@"retweeted_status"];
        //文字
        NSString *str_text=[NSString stringWithFormat:@"@%@:%@",dic_retweeted_status[@"user"][@"screen_name"],dic_retweeted_status[@"text"]];
        height_row+=(kMargin+[Helper getContentActualSize:str_text withWidth:self.view.width-2*kMargin WithFont:[UIFont systemFontOfSize:kDefaultFontSize]].height);
        
        if([dic_retweeted_status[@"pic_urls"] count]>1){
            //多图
            NSUInteger count_pic=[dic_retweeted_status[@"pic_urls"] count];
            height_row+=(kMargin+ceil(count_pic/3.0)*(kPicThumbnail+kPicMargin));
        }
        else{
            if (dic_retweeted_status[@"bmiddle_pic"]) {
                //单图
                height_row+=(kMargin+kPicBmiddle);
            }
        }
        height_row+=kMargin;
    }
    
    //转发、评论、赞
    height_row+=(kMargin+kBottomToolHeight);
    
    return height_row;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - ToolBarDelegate
-(void)toolBar:(ToolBar *)toobar buttonIndex:(NSUInteger)index{
    if (index==0) {
        NSLog(@"0");
    }
    else if (index==1){
        NSLog(@"1");
    }
    else if (index==2){
        int count_like=[toobar.bt_like.titleLabel.text intValue];
        if (toobar.bt_like.selected) {
            count_like--;
        }
        else if (!toobar.bt_like.selected){
            count_like++;
        }
        [toobar.bt_like setTitle:[NSString stringWithFormat:@"%i",count_like] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            toobar.bt_like.selected=!toobar.bt_like.selected;
        }];
        NSLog(@"2");
    }
}

@end

 /**
 // normal状态执行的操作
 refreshHeader.normalStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
 refreshView.hidden = NO;
 if (progress == 0) {
 _animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
 _boxView.hidden = NO;
 _label.text = @"下拉加载最新数据";
 [_animationView stopAnimating];
 }
 
 self.animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(progress * 10, -20 * progress), CGAffineTransformMakeScale(progress, progress));
 self.boxView.transform = CGAffineTransformMakeTranslation(- progress * 85, progress * 35);
 };
 
 // willRefresh状态执行的操作
 refreshHeader.willRefreshStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
 _boxView.hidden = YES;
 _label.text = @"放开我，我才帮你加载数据";
 _animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(10, -20), CGAffineTransformMakeScale(1, 1));
 NSArray *images = @[[UIImage imageNamed:@"deliveryStaff0"],
 [UIImage imageNamed:@"deliveryStaff1"],
 [UIImage imageNamed:@"deliveryStaff2"],
 [UIImage imageNamed:@"deliveryStaff3"]
 ];
 _animationView.animationImages = images;
 [_animationView startAnimating];
 };
 
 // refreshing状态执行的操作
 refreshHeader.refreshingStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
 _label.text = @"客官别急，正在加载数据...";
 [UIView animateWithDuration:1.5 animations:^{
 self.animationView.transform = CGAffineTransformMakeTranslation(200, -20);
 }];
 };
 */


