//
//  XZAlertPopUpManage.h
//  XZAlertView
//
//  Created by ZF xie on 2020/11/9.
//
#import "XZAlertActionHeader.h"
#import <Foundation/Foundation.h>


@class XZAlertActionView;

NS_ASSUME_NONNULL_BEGIN

@interface XZAlertPopUpManage : NSObject

@property (nonatomic, strong) NSMutableArray <XZAlertActionView *> *alertActionList;///<弹窗队列

@property (nonatomic, assign) XZDisplayPriority priorityFollowingUnDisplay;   ///<优先级以下不展示

@property (nonatomic, assign) BOOL isShowNext;   ///<前一个弹窗结束是否继续展示下一个弹窗

@property (nonatomic, readonly ) XZAlertActionView *currentAlertActionView;///<<#des#>


/// 实例化
+ (instancetype)sharedAlertPopUpManage;

/// 添加弹窗
- (void)addAlertAction:(XZAlertActionView *)action;

/// 移除弹窗
- (void)removeAlertAction:(XZAlertActionView *)action;

/// 添加弹窗数组
- (void)addAlertActions:(NSArray *)actions;

/// 展示弹窗
- (void)showAlertActions;

/// 弹窗数量
+ (NSInteger)alertActionsCount;

/// 移除优先级displayPriority之下的弹窗
+ (void)removablePopupView:(XZDisplayPriority)displayPriority;

@end

NS_ASSUME_NONNULL_END
