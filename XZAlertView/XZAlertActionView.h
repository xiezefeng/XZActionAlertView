//
//  VTAlertActionView.h
//  VTAlertView
//
//  Created by 谢泽锋 on 2020/8/4.
//  Copyright © 2020年 谢泽锋. All rights reserved.
//
#import "XZAlertActionHeader.h"
#import <UIKit/UIKit.h>
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
@property (nonatomic, assign) XZActionAlertViewBackgroundStyle backgroundStyle;  // 背景效果
@property (nonatomic, assign) XZActionAlertViewTransitionStyle transitionStyle;  //转场类型
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) XZDisplayPriority displayPriority;   ///<显示优先级 默认0
@property (nonatomic, assign) float displayDuring;   ///<出现时间长度
@property (nonatomic, assign) float disappearDuring;   ///<消失时间长度

@property (nonatomic, assign, getter=isVisible,readonly) BOOL visible;                    // 是否正在显示
@property (nonatomic, assign) BOOL allowTapBackgroundDismiss;                    //点击背景是否隐藏
@property (nonatomic, strong) UIView *showInView;///<展示所在视图容器 默认是window上




@property (weak, nonatomic) id<XZActionAlertViewDelegate> delegate;

/** 以下回调优先级高于代理 */
@property (nonatomic, copy) XZActionAlertViewHandler willShowHandler;
@property (nonatomic, copy) XZActionAlertViewHandler didShowHandler;
@property (nonatomic, copy) XZActionAlertViewHandler willDismissHandler;
@property (nonatomic, copy) XZActionAlertViewHandler didDismissHandler;
@property (nonatomic, copy) XZActionAlertViewHandler didTappedBackgroundHandler;



+ (instancetype)actionAlertViewWithCustomView:(UIView *)customView style:(XZActionAlertViewTransitionStyle)style;

- (instancetype)initWithCustomView:(UIView *)customView style:(XZActionAlertViewTransitionStyle)style;

+ (instancetype)actionAlertViewWithAnimationStyle:(XZActionAlertViewTransitionStyle)style;

- (instancetype)initWithAnimationStyle:(XZActionAlertViewTransitionStyle)style;

// 展示和消失
- (void)dismiss;
- (void)show;



@end

