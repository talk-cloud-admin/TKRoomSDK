//
//  TKUtil.h
//  TKRoomSDK
//
//  Created by MAC-MiNi on 2018/7/13.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKUtils : NSObject

/**
 获取cpu核数
 */
+ (NSInteger)getCPUCores;

/**
 获取cpu类型
 */
+ (NSString *)getCPUType;

/**
 获取cpu使用率
 */
+ (NSString *)getCPUUsage;

/**
 获取总物理内存
 */
+ (unsigned long long)getTotalMemory;
/**
 获取当前App内存使用
 */
+ (uint64_t)getResidentMemory;


@end
