//
//  StatusCellTableViewCell.h
//  微博
//
//  Created by hjd on 15/9/21.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusCell : UITableViewCell

@property(nonatomic,retain) NSDictionary *status;
@property(nonatomic,assign) CGFloat rowheight;

@end
