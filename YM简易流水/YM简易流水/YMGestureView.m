//
//  YMGestureView.m
//  YM简易流水
//
//  Created by Yeahming on 15/7/29.
//  Copyright © 2015年 Yeahming. All rights reserved.
//
#define totalCols 
#import "YMGestureView.h"

@implementation YMGestureView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIImage *bgImage  = [UIImage imageNamed:@"Home_refresh_bg"];
    [bgImage drawInRect:rect];
}

@end
