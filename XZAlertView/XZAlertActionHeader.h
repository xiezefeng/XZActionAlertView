//
//  XZAlertActionHeader.h
//  HRZ
//
//  Created by ZF xie on 2020/11/10.
//  Copyright © 2020 hrz. All rights reserved.
//

#ifndef XZAlertActionHeader_h
#define XZAlertActionHeader_h
#import <Masonry/Masonry.h>

/// 显示优先级
typedef NS_ENUM(NSUInteger, XZDisplayPriority) {
    XZDisplayPriorityDefault = 0, // 默认 可以移除弹窗
    XZDisplayPriorityWordCommand, //口令
    XZDisplayPriorityForcedNoRemove = 100 , //大于不可移除弹窗
    XZDisplayPriorityAgreement, //协议
    XZDisplayPriorityForceUpdate, //强制更新
};

/** 动画效果 */
typedef NS_ENUM(NSInteger, XZActionAlertViewTransitionStyle) {
    XZActionAlertViewTransitionStyleBounce       = 1 << 1,               ///< 反弹缩放
    XZActionAlertViewTransitionStyleFade        = 1 << 2,              ///< 透明度变化
    XZActionAlertViewTransitionStyleDropDown     = 1 << 3,             ///< 物理动画下落
    XZActionAlertViewTransitionStyleSlideFromTop = 1 << 4,         ///< 顶部滑出
    XZActionAlertViewTransitionStyleSlideFromBottom = 1 << 5,      ///< 底部滑出
    XZActionAlertViewTransitionStyleBottomEject = 1 << 6,  ///< 底部弹出底部展示
};

/** 背景效果 */
typedef NS_ENUM(NSInteger, XZActionAlertViewBackgroundStyle) {
    XZActionAlertViewBackgroundStyleSolid = 1 << 1,  ///< 半透明 默认
    XZActionAlertViewBackgroundStyleGradient = 1 << 2,   ///< 渐变半透明
};

#define execBlock(b, ...) if (b != nil) {b(__VA_ARGS__);}
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
        block();\
    } else {\
        dispatch_async(queue, block);\
    }
#endif
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

#define kIs_iphone ([[UIDevice currentDevice].model isEqual:@"iPhone"])

#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))

#endif /* XZAlertActionHeader_h */
