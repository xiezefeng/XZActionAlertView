//
//  XZAlertActionConfig.h
//  XZAlertViewDemo
//
//  Created by ZF xie on 2021/6/2.
//

#import "XZAlertActionHeader.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XZAlertActionConfig : NSObject
@property (nonatomic, assign) XZActionAlertViewBackgroundStyle backgroundStyle;  // 背景效果
@property (nonatomic, assign) XZActionAlertViewTransitionStyle transitionStyle;  //转场类型
@property (nonatomic, assign) float displayDuring;   ///<出现时间长度
@property (nonatomic, assign) float disappearDuring;   ///<消失时间长度
@property (nonatomic, strong) UIImage *closeBtnImage;///<关闭按钮图片
@property (nonatomic, assign) CGFloat closeBtnMargin;   ///<关闭按钮距离容器距离 X Y
@property (nonatomic, assign) BOOL allowTapBackgroundDismiss; ///点击背景是否隐藏
@property (nonatomic, assign) BOOL isShowCloseBtn;   ///<添加关闭按钮 默认不展示
@property (nonatomic, assign) CGFloat bottomMargin;   ///<底部间距 默认0
@property (nonatomic, assign) CGSize closeSize;   ///<关闭按钮大小
@property (nonatomic, assign) XZActionAlertViewCloseStyle closeStyle;   ///<关闭按钮颜色

@end

NS_ASSUME_NONNULL_END
