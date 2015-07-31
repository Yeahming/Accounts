//
//  YMGestureUnlockViewController.m
//  YM简易流水
//
//  Created by Yeahming on 15/7/29.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import "YMGestureUnlockViewController.h"
#import "YMGestureView.h"
#import "YMGestureAbleView.h"

@interface YMGestureUnlockViewController ()

@end

@implementation YMGestureUnlockViewController
- (void)loadView
{
    self.view = [[YMGestureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 常见解锁界面
    YMGestureAbleView *gestureView = [[YMGestureAbleView alloc] init];
    // 设置frame
    CGFloat gestureViewX = 0;
    CGFloat gestureViewY = (self.view.bounds.size.height - self.view.bounds.size.width)*0.5;
    CGFloat gestureViewWH = self.view.bounds.size.width;
    gestureView.frame = CGRectMake(gestureViewX, gestureViewY, gestureViewWH, gestureViewWH);
    [self.view addSubview:gestureView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
