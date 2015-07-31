//
//  YMAddRecordViewController.h
//  YM简易流水
//
//  Created by Yeahming on 15/7/28.
//  Copyright © 2015年 Yeahming. All rights reserved.
//
/** 代理协议 */
@class YMPersonalItem;
@protocol YMAddRecordViewControllerDelegate <NSObject>

@optional
- (void)saveBtnClicked:(UIButton *)button andContents:(YMPersonalItem *)item;
@end

#import <UIKit/UIKit.h>

@interface YMAddRecordViewController : UIViewController
/** 代理属性 */
@property (nonatomic, weak) id<YMAddRecordViewControllerDelegate>  delegate;

@end
