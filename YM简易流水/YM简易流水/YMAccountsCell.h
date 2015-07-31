//
//  YMAccountsCell.h
//  YM简易流水
//
//  Created by Yeahming on 15/7/26.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMPersonalItem.h"

@interface YMAccountsCell : UITableViewCell
/** 数据模型 */
@property (nonatomic, strong) YMPersonalItem *personalItem;

@end
