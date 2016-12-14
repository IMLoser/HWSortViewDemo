//
//  ViewController.m
//  HWSortViewDemo
//
//  Created by 曹航玮 on 2016/12/11.
//  Copyright © 2016年 曹航玮. All rights reserved.
//

#import "ViewController.h"
#import "HWSortView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * titlesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 19; i++) {
        [titlesArray addObject:[NSString stringWithFormat:@"IMLoser-%02zd",i + 1]];
    }
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    HWSortView * sortView = [HWSortView sortViewWithTitlesArray:titlesArray];
    sortView.columnCount = 3;
    sortView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:sortView];

}

- (BOOL)prefersStatusBarHidden { return YES; }

@end
