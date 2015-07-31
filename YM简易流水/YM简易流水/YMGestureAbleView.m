//
//  YMGestureAbleView.m
//  YM简易流水
//
//  Created by Yeahming on 15/7/29.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

/** 总列数 */
static const int YMTotalCols = 3;
/** 总按钮个数 */
static const CGFloat YMTotalCounts = 9;
/** 每个按钮的尺寸 */
static const CGFloat YMBtnWH = 74;
/** 间距 */
static const CGFloat YMPaddiing = 38;

/** 解锁密码 */
static NSString *const YMPassWord = @"03752";

#import "YMGestureAbleView.h"
#import "YMAccountsBookController.h"

@interface YMGestureAbleView()

/** 路径 */
@property (nonatomic, strong) UIBezierPath *path;
/** 路径终点 */
@property (nonatomic, assign) CGPoint  endPoint;
/** 已触发按钮数组 */
@property (nonatomic, strong) NSMutableArray *selectedBtns;
/** 上一个被点击的按钮 */
@property (nonatomic, weak) UIButton  *lastTouchedBtn;

@end
@implementation YMGestureAbleView

// 重写初始化方法，添加子控件
- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加按钮
        for (int i = 0; i < YMTotalCounts; i++) {
            self.backgroundColor = [UIColor clearColor];
            UIButton *clockBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            // 添加tag便于解锁
            clockBtn.tag = i;
            
            // 监听按钮
            [clockBtn addTarget:self action:@selector(btnTouched:) forControlEvents:(UIControlEventTouchDown)];
            
            // 设置图片
            [clockBtn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:(UIControlStateNormal)];
            [clockBtn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:(UIControlStateSelected)];
            [self addSubview:clockBtn];
        }
    }
    return self;
}

// 按钮被点击时调用
- (void)btnTouched:(UIButton *)btn
{
    //取消上一个被点击的选中状态
    self.lastTouchedBtn.selected = NO;
    
    // 设置为选中状态
    btn.selected = YES;
    
    // 添加到数组
    [self.selectedBtns addObject:btn];
    
    // 记住此次点击的按钮
    self.lastTouchedBtn = btn;
}

// 监听手势移动
- (void)touchesMoved:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event
{
    [self.path removeAllPoints];
    [self setNeedsDisplay];
    // 获取当前手势
    UITouch *touch = [touches anyObject];
    // 获取当前手势
    CGPoint currentPoint = [touch locationInView:self];
    
    for (UIButton *btn in self.subviews) {
        // 转换坐标系
        CGPoint btnPoint = [self convertPoint:currentPoint toView:btn];
        // 如果在某个按钮上则添加到数组中
        
        if ([btn pointInside:btnPoint withEvent:event]) {
            btn.selected = YES;
            if (![self.selectedBtns containsObject:btn]) {
                [self.selectedBtns addObject:btn];
                self.lastTouchedBtn = btn;
            }
        }
    }
    self.endPoint = currentPoint;
    [self setNeedsDisplay];
    }

// 不让按钮截取事件处理
- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    
    // 获取当前手势
    CGPoint currentPoint = point;
    
    for (UIButton *btn in self.subviews) {
        // 转换坐标系
        CGPoint btnPoint = [self convertPoint:currentPoint toView:btn];
        // 如果在某个按钮上则添加到数组中
        
        if ([btn pointInside:btnPoint withEvent:event]) {
            return self;
        }
    }
    return  [super hitTest:point withEvent:event];
}
- (void)touchesEnded:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event
{
    // 记录用户解锁密码// 正确密码 03752
    NSMutableString *passWord = [NSMutableString string];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 把数组中的按钮全部取消选中状态
            for (UIButton *selectedBtn in self.selectedBtns) {
                selectedBtn.selected = NO;
                [passWord appendString:[NSString stringWithFormat:@"%ld",selectedBtn.tag]];
            }
            
            // 清空数组
            [self.selectedBtns removeAllObjects];
            
            // 重绘
            [self.path removeAllPoints];
            [self setNeedsDisplay];
            // 判断密码是够正确
            if ([passWord isEqualToString:YMPassWord]) {
                // 加载主界面
                self.window.rootViewController = [[YMAccountsBookController alloc] init];
            }
    });
    
}

- (void)drawRect:(CGRect)rect {
    
    // 将数组的按钮都连接起来
    for (int i = 0; i < self.selectedBtns.count; i++) {
        UIButton *startBtn = self.selectedBtns[i];
        if (i == 0) {
            
            [self.path moveToPoint:startBtn.center];
        }
        else
        {
            [self.path addLineToPoint:startBtn.center];
        }
    }
    [self.path addLineToPoint:self.endPoint];

    [[UIColor whiteColor] set];
    [self.path stroke];
}

// 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置子控件位置
    CGFloat btnWH = YMBtnWH;
    for (int i = 0; i < YMTotalCounts; i++) {
        //
        // 取出button
        UIButton *btn = self.subviews[i];
        // 计算frame
        int row = i/YMTotalCols;
        int col = i%YMTotalCols;
        CGFloat btnX = YMPaddiing + (YMPaddiing + btnWH)*col;
        CGFloat btnY = YMPaddiing + (YMPaddiing + btnWH)*row;
        btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    }
}

// 已触发按钮数组懒加载
- (NSMutableArray *)selectedBtns
{
    if (_selectedBtns == nil) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}

// 路径懒加载
- (UIBezierPath *)path
{
    if (_path == nil) {
        _path = [UIBezierPath bezierPath];
        _path.lineWidth = 20;
        _path.lineJoinStyle = kCGLineCapRound;
    }
    
    return _path;
}

@end
