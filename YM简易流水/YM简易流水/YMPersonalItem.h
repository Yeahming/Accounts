//
//  YMPersonalItem.h
//  YM简易流水
//
//  Created by Yeahming on 15/7/26.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum:NSInteger{
    YMPersonalItemTypeIncome,// 收入
    YMPersonalItemTypeExpend,// 支出
} YMPersonalItemType;


@interface YMPersonalItem : NSObject

/** 记录类型 */
@property (nonatomic, assign) YMPersonalItemType  itemType;

/** 收入 */
@property (nonatomic, copy) NSString *income;

/** 支出 */
@property (nonatomic, copy) NSString *expend;

/** 日期 */
@property (nonatomic, copy) NSString *date;

/** 备注 */
@property (nonatomic, copy) NSString *remark;


@end
