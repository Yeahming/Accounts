//
//  YMDataStore.h
//  YM简易流水
//
//  Created by Yeahming on 15/7/26.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMPersonalItem.h"

@interface YMDataStore : NSObject
/** 取数据 */
+ (YMPersonalItem *)dataForKey:(NSString *)keyPath;

/** 存数据 */
+ (void)setData:(YMPersonalItem *)data forKey:(NSString *)keyPath;

@end
