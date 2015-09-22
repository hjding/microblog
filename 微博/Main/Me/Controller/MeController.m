//
//  MeController.m
//  微博
//
//  Created by hjd on 15/9/15.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#import "MeController.h"

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
}

- (void)setupNavigationItem {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
}

#pragma mark - Target 
-(void)setting{
    
}

@end
