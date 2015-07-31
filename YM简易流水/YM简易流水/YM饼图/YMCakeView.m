//
//  YMCakeView.m
//  饼图
//
//  Created by Yeahming on 15/7/12.
//  Copyright (c) 2015年 Yeahming. All rights reserved.
//

#import "YMCakeView.h"

@implementation YMCakeView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
static CGFloat starAngle = -M_PI_2;
static CGFloat endAngle = 0;
- (void)drawRect:(CGRect)rect {
    // 上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 路径
    CGPoint center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    CGFloat radius = MIN(self.bounds.size.width*0.5, self.bounds.size.height*0.5)-2;
    // 一次性画self.dataArray.count 个扇形
    for (NSNumber *number in self.dataArray) {
        // 扇形的角度
        CGFloat angle = (number.intValue)/100.0*M_PI*2;
        endAngle = starAngle + angle;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:starAngle endAngle:endAngle clockwise:YES];
        [path addLineToPoint:center];
        // 添加和设置
        CGContextAddPath(context, path.CGPath);
        [[self randomColor] set];
        
        // 渲染
        CGContextFillPath(context);
        starAngle = endAngle;
    }
    
}

/**
 *  产生一个随机颜色
 */
- (UIColor *)randomColor
{
    CGFloat red = arc4random_uniform(256)/255.0;
    CGFloat green = arc4random_uniform(256)/255.0;
    CGFloat blue = arc4random_uniform(256)/255.0;
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return randomColor;
}
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self setNeedsDisplay];
}
@end
