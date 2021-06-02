//
//  VTAlertActionView.h
//  VTAlertView
//
//  Created by 谢泽锋 on 2020/8/4.
//  Copyright © 2020年 谢泽锋. All rights reserved.
//
#import "XZAlertActionHeader.h"
#import <UIKit/UIKit.h>
#import "XZAlertActionConfig.h"
@class XZAlertActionView;

@protocol XZActionAlertViewDelegate <NSObject>

@optional
/** 以下代理优先级低于 block 回调 */

/** 即将出现 */
- (void)actionAlertViewWillShow:(XZAlertActionView *)alertView;
/** 已经出现 */
- (void)actionAlertViewDidShow:(XZAlertActionView *)alertView;
/** 即将消失 */
- (void)actionAlertViewWillDismiss:(XZAlertActionView *)alertView;
/** 已经消失 */
- (void)actionAlertViewDidDismiss:(XZAlertActionView *)alertView;
/** 点击了背景 */
- (void)actionAlertViewDidTappedBackGroundView:(XZAlertActionView *)alertView;

@end


typedef void (^XZActionAlertViewHandler)(XZAlertActionView *alertView);


@interface XZAlertActionView : UIView

@property (nonatomic, assign) NSInteger displayPriority;   ///<显示优先级 默认0
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIView *showInView;///<展示所在视图容器 默认是window上
@property (nonatomic, assign, getter=isVisible,readonly) BOOL visible;                    // 是否正在显示
@property (nonatomic, strong) XZAlertActionConfig *config;///<配置


/** 以下回调优先级高于代理 */
@property (nonatomic, copy) XZActionAlertViewHandler willShowHandler;
@property (nonatomic, copy) XZActionAlertViewHandler didShowHandler;
@property (nonatomic, copy) XZActionAlertViewHandler willDismissHandler;
@property (nonatomic, copy) XZActionAlertViewHandler didDismissHandler;
@property (nonatomic, copy) XZActionAlertViewHandler didTappedBackgroundHandler;

@property (weak, nonatomic) id<XZActionAlertViewDelegate> delegate;

+ (instancetype)actionAlertViewWithCustomView:(UIView *)customView config:(XZAlertActionConfig *)config;

+ (instancetype)actionAlertViewWithCustomView:(UIView *)customView style:(XZActionAlertViewTransitionStyle)style;

- (instancetype)initWithCustomView:(UIView *)customView style:(XZActionAlertViewTransitionStyle)style;

+ (instancetype)actionAlertViewWithAnimationStyle:(XZActionAlertViewTransitionStyle)style;

- (instancetype)initWithAnimationStyle:(XZActionAlertViewTransitionStyle)style;

// 展示和消失
- (void)dismiss;
- (void)show;



@end

