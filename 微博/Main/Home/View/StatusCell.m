////
////  StatusCellTableViewCell.m
////  微博
////
////  Created by hjd on 15/9/21.
////  Copyright (c) 2015年 hjd. All rights reserved.
////
//
//#import "StatusCell.h"
//#import "UIImageView+WebCache.h"
//
//@implementation StatusCell
//
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
////        [self initSubviews];
//    }
//    return self;
//}
//
//-(void)setStatus:(NSDictionary *)status{
//    
////    UIView *view_back=[[UIView alloc]initWithFrame:CGRectMake(0, kMargin, self.width, 0)];
////    view_back.backgroundColor=[UIColor whiteColor];
////    [self.contentView addSubview:view_back];
////    
////    UIView *view_header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
////    view_header.backgroundColor=[UIColor whiteColor];
////    [view_back addSubview:view_header];
////    NSDictionary *dic_user=dic[@"user"];
////    //头像
////    UIImageView *iv_logo=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin, kMargin, kLogoHeight, kLogoHeight)];
////    [iv_logo sd_setImageWithURL:[NSURL URLWithString:dic_user[@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
////    [view_header addSubview:iv_logo];
////    //昵称
////    UILabel *lb_name=[[UILabel alloc]init];
////    lb_name.text=dic_user[@"screen_name"];
////    lb_name.textColor=[UIColor redColor];
////    lb_name.font=[UIFont systemFontOfSize:kDetailFontSize];
////    CGSize size_name=[Helper getContentActualSize:lb_name.text WithFont:lb_name.font];
////    lb_name.frame=CGRectMake(iv_logo.right+kMargin, iv_logo.top,size_name.width, size_name.height);
////    [view_header addSubview:lb_name];
////    //时间
////    UILabel *lb_time=[[UILabel alloc]init];
////    lb_time.text=dic_user[@"created_at"];
////    lb_time.textColor=CommonColor;
////    lb_time.font=[UIFont systemFontOfSize:kSmallFontSize];
////    CGSize size_time=[Helper getContentActualSize:lb_time.text WithFont:lb_time.font];
////    lb_time.frame=CGRectMake(lb_name.left, lb_name.bottom,size_time.width, size_time.height);
////    [view_header addSubview:lb_time];
////    UILabel *lb_source=[[UILabel alloc]init];
////    lb_source.text=[NSString stringWithFormat:@"来自 %@",dic[@"source"]];
////    lb_source.textColor=kWordsDetailColor;
////    lb_source.font=[UIFont systemFontOfSize:kSmallFontSize];
////    CGSize size_source=[Helper getContentActualSize:lb_source.text WithFont:lb_source.font];
////    lb_source.frame=CGRectMake(lb_time.right, lb_time.top,size_source.width, size_source.height);
////    [view_header addSubview:lb_source];
////    view_header.height+=(kMargin+kLogoHeight);
////    
////    UIView *view_middle=[[UIView alloc]initWithFrame:CGRectMake(0, view_header.bottom, self.tableView.width, kMargin)];
////    view_middle.backgroundColor=[UIColor whiteColor];
////    [view_back addSubview:view_middle];
////    //文字
////    UILabel *lb_text=[[UILabel alloc]init];
////    if(dic[@"text"]){
////        lb_text.text=dic[@"text"];
////        lb_text.textColor=kWordsColor;
////        lb_text.font=[UIFont systemFontOfSize:kDefaultFontSize];
////        lb_text.numberOfLines=0;
////        CGSize size_text=dic[@"text"]?[Helper getContentActualSize:lb_text.text withWidth:view_middle.width-2*kMargin WithFont:lb_text.font]:(CGSizeZero);
////        lb_text.frame=CGRectMake(kMargin, kMargin,size_text.width, size_text.height);
////        [view_middle addSubview:lb_text];
////        lb_text.backgroundColor=[UIColor greenColor];
////    }
////    view_middle.height+=lb_text.height;
////    //配图
////    if ([dic[@"pic_ids"] count]>1) {
////        //多图
////        NSLog(@"多图：%@",dic[@"pic_ids"]);
////        
////        for (int i=0; i<[dic[@"pic_ids"] count]; i++) {
////            UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin+(i%3)*(kPicThumbnail+kPicMargin), kMargin+(i/3)*(kPicThumbnail+kPicMargin), kPicThumbnail, kPicThumbnail)];
////            NSString *str_url=[NSString stringWithFormat:@"%@/%@",dic[@"thumbnail_pic"],dic[@"pic_ids"][i]];
////            [iv_pic sd_setImageWithURL:[NSURL URLWithString:str_url]];
////            [view_middle addSubview:iv_pic];
////        }
////        NSUInteger count_pic=[dic[@"pic_ids"] count];
////        view_middle.height+=(kMargin+ceil(count_pic/3.0)*(kPicThumbnail+kPicMargin));
////    }
////    else{
////        if (dic[@"bmiddle_pic"]) {
////            //单图
////            NSLog(@"单图：%@",dic[@"bmiddle_pic"]);
////            UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin,kMargin+lb_text.bottom, kPicBmiddle, kPicBmiddle)];
////            [iv_pic sd_setImageWithURL:[NSURL URLWithString:dic[@"bmiddle_pic"]]];
////            [view_middle addSubview:iv_pic];
////            view_middle.height+=(kMargin+iv_pic.height);
////        }
////    }
////    //转发微博
////    if (dic[@"retweeted_status"]) {
////        NSDictionary *dic_retweeted_status=dic[@"retweeted_status"];
////        
////        UIView *view_retweet=[[UIView alloc]initWithFrame:CGRectMake(0, lb_text.bottom, self.view.width, 0)];
////        view_retweet.backgroundColor=kHomeBg;
////        [view_middle addSubview:view_retweet];
////        //文字
////        NSString *str_text=[NSString stringWithFormat:@"@%@:%@",dic_retweeted_status[@"user"][@"screen_name"],dic_retweeted_status[@"text"]];
////        UILabel *lb_text=[[UILabel alloc]init];
////        //        NSMutableAttributedString *muattStr=[[NSMutableAttributedString alloc]initWithString:str_text];
////        //                [muattStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:kDefaultFontSize]} range:NSMakeRange(0, [dic_retweeted_status[@"user"][@"screen_name"] length])];
////        //                [muattStr setAttributes:@{NSForegroundColorAttributeName:kWordsDetailColor,NSFontAttributeName:[UIFont systemFontOfSize:kDefaultFontSize]} range:NSMakeRange([dic_retweeted_status[@"user"][@"screen_name"] length]-1, [dic_retweeted_status[@"text"] length]+1)];
////        //        lb_text.attributedText=muattStr;
////        lb_text.text=str_text;
////        lb_text.numberOfLines=0;
////        lb_text.font=[UIFont systemFontOfSize:kDefaultFontSize];
////        CGSize size_text=[Helper getContentActualSize:lb_text.text withWidth:view_retweet.width-2*kMargin WithFont:[UIFont systemFontOfSize:kDefaultFontSize]];
////        lb_text.frame=CGRectMake(kMargin, kMargin,size_text.width, size_text.height);
////        [view_retweet addSubview:lb_text];
////        lb_text.backgroundColor=[UIColor greenColor];
////        
////        view_retweet.height+=(kMargin+lb_text.height);
////        
////        
////        if ([dic_retweeted_status[@"pic_urls"] count]>1) {
////            //多图
////            NSLog(@"转发多图：%@",dic_retweeted_status[@"pic_urls"]);
////            for (int i=0; i<[dic_retweeted_status[@"pic_urls"] count]; i++) {
////                UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin+(i%3)*(kPicThumbnail+kPicMargin), lb_text.bottom+kMargin+(i/3)*(kPicThumbnail+kPicMargin), kPicThumbnail, kPicThumbnail)];
////                NSString *str_url=[NSString stringWithFormat:@"%@",dic_retweeted_status[@"pic_urls"][i][@"thumbnail_pic"]];
////                [iv_pic sd_setImageWithURL:[NSURL URLWithString:str_url]];
////                [view_retweet addSubview:iv_pic];
////            }
////            NSUInteger count_pic=[dic_retweeted_status[@"pic_urls"] count];
////            NSLog(@"%lu===rows:%f",(unsigned long)count_pic,ceil(count_pic/3.0));
////            view_retweet.height+=(kMargin+ceil(count_pic/3.0)*(kPicThumbnail+kPicMargin)+kMargin);
////        }
////        else{
////            if (dic_retweeted_status[@"bmiddle_pic"]) {
////                //单图
////                NSLog(@"转发单图：%@",dic_retweeted_status[@"bmiddle_pic"]);
////                UIImageView *iv_pic=[[UIImageView alloc]initWithFrame:CGRectMake(kMargin, lb_text.bottom+kMargin, kPicBmiddle, kPicBmiddle)];
////                [iv_pic sd_setImageWithURL:[NSURL URLWithString:dic_retweeted_status[@"bmiddle_pic"]]];
////                [view_retweet addSubview:iv_pic];
////                view_retweet.height+=(kMargin+iv_pic.height);
////            }
////        }
////        view_middle.height+=+view_retweet.height;
////        view_retweet.backgroundColor=[UIColor redColor];
////    }
////    
////    view_middle.height+=kMargin;
////    
////    UIView *view_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, view_middle.bottom, self.view.width, 0)];
////    view_bottom.backgroundColor=[UIColor whiteColor];
////    [view_back addSubview:view_bottom];
////    UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 2)];
////    line_bottom.backgroundColor=[UIColor blackColor];
////    [view_bottom addSubview:line_bottom];
////    view_bottom.height=kBottomToolHeight;
////    
////    
////    
////    //    view_back.height=(view_header.height+view_middle.height+view_bottom.height);
////    view_back.height=[self heightForWeibo:dic];
////    
////    view_back.backgroundColor=[UIColor yellowColor];
////    view_header.backgroundColor=[UIColor greenColor];
////    view_middle.backgroundColor=[UIColor blueColor];
////    view_bottom.backgroundColor=[UIColor purpleColor];
//}
//
//-(CGFloat)height{
//    
//}
//
//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//@end
