//
//  VTAlertActionView.m
//  VTAlertView
//
//  Created by 谢泽锋 on 2020/8/4.
//  Copyright © 2020年 谢泽锋. All rights reserved.
//

#import "XZAlertActionView.h"
#import "XZAlertPopUpManage.h"

@interface XZAlertActionBackgroundView : UIView
@property (nonatomic, assign) XZActionAlertViewBackgroundStyle style;

@end
@implementation XZAlertActionBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
    }
    return self;
}

- (void)setStyle:(XZActionAlertViewBackgroundStyle)style {
    _style = style;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case XZActionAlertViewBackgroundStyleGradient: {  // 渐变效果
            CGFloat height = self.frame.size.height;
            CGFloat width = self.frame.size.width;
            [[UIColor colorWithWhite:0 alpha:0.05] set];   // 背景透明度
            CGContextFillRect(context, [UIScreen mainScreen].bounds);
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            CGPoint center = CGPointMake(width / 2, height / 2);
            CGFloat radius = MIN(width, height);
            CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            break;
        }
        case XZActionAlertViewBackgroundStyleSolid: {
            [[UIColor.blackColor colorWithAlphaComponent:0.6] set];  // 背景透明度
            CGContextFillRect(context, [UIScreen mainScreen].bounds);
            break;
        }
    }
}

@end

@interface XZAlertActionView()<CAAnimationDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic) XZAlertActionBackgroundView *bgView;
@property (nonatomic, assign) BOOL visible;                    // 是否正在显示

@end

@implementation XZAlertActionView

+ (instancetype)actionAlertViewWithCustomView:(UIView *)customView style:(XZActionAlertViewTransitionStyle)style {
    return [[self alloc] initWithCustomView:customView style:style];
}

- (instancetype)initWithCustomView:(UIView *)customView style:(XZActionAlertViewTransitionStyle)style {
    if (self = [super init]) {
        self.customView = customView;
        self.transitionStyle = style;
        self.bgView.style = XZActionAlertViewBackgroundStyleSolid;
        _allowTapBackgroundDismiss = NO;
        self.displayDuring = 0.4;
        self.disappearDuring = 0.3;

    }
    return self;
}

+ (instancetype)actionAlertViewWithAnimationStyle:(XZActionAlertViewTransitionStyle)style {
    return [[self alloc] initWithAnimationStyle:style];
}

- (instancetype)initWithAnimationStyle:(XZActionAlertViewTransitionStyle)style {
    if (self = [super init]) {
        self.transitionStyle = style;
        _allowTapBackgroundDismiss = NO;
        self.bgView.style = XZActionAlertViewBackgroundStyleSolid;
        self.displayDuring = 0.4;
        self.disappearDuring = 0.3;

    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    }
    return self;
}



// 展示和消失
- (void)_dismiss {
    if (self.willDismissHandler) {
        self.willDismissHandler(self);
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewWillDismiss:)]) {
        [self.delegate actionAlertViewWillDismiss:self];
    }
    [self dismissCompletion:^{
    
        self.visible = NO;
        [[XZAlertPopUpManage sharedAlertPopUpManage] removeAlertAction:self];
        [XZAlertActionView setAnimating:NO];
        [XZAlertActionView setCurrentAlertView:nil];
        [self removeFromSuperview];
        [self teardown];
        
        if (self.didDismissHandler) {
            self.didDismissHandler(self);
        }else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidDismiss:)]) {
            [self.delegate actionAlertViewDidDismiss:self];
        }
        if ([XZAlertPopUpManage alertActionsCount] > 0 && [XZAlertPopUpManage sharedAlertPopUpManage].isShowNext) {
            XZAlertActionView *alertView = [XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.firstObject;
            [alertView show];
        }
    }];

}
- (void)dismiss {
    dispatch_main_async_safe(^{
        [self _dismiss];
    });
}

- (void)dismissCompletion:(void (^__nullable)(void))completion{
    
//    [[XZAlertPopUpManage sharedAlertPopUpManage] removeAlertAction:self];
//    if (completion) {
//        [self transitionOutCompletion:completion];
//    }else {
//        void (^dismissComplete)(void) = ^{
//
//            [XZAlertActionView setAnimating:NO];
//            [XZAlertActionView setCurrentAlertView:nil];
//            [self removeFromSuperview];
//            [self teardown];
//
//            if ([XZAlertPopUpManage alertActionsCount] > 0 && [XZAlertPopUpManage sharedAlertPopUpManage].isShowNext) {
//                XZAlertActionView *alertView = [XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.firstObject;
//                [alertView show];
//            }
//        };

    [self dismisXZackground];
    [self transitionOutCompletion:completion];
//    }
}

- (void)teardown {
    [self.bgView removeFromSuperview];
    [self.customView removeFromSuperview];
    self.customView = nil;
    self.bgView = nil;
    
}
- (void)show {
    dispatch_main_async_safe(^{
        [self _show];
    });
}
- (void)_show {
    //加锁
    @synchronized ([XZAlertPopUpManage sharedAlertPopUpManage]) {
        if (self.isVisible) { //是否正在展示
//            NSLog(@"弹窗还在展示中...........");
            return;
        }
        if (![[XZAlertPopUpManage sharedAlertPopUpManage].alertActionList containsObject:self]) {
            [[XZAlertPopUpManage sharedAlertPopUpManage] addAlertAction:self];
        }
//        NSLog(@"[XZAlertPopUpManage sharedAlertPopUpManage].priorityFollowingUnDisplay   %lu",(unsigned long)[XZAlertPopUpManage sharedAlertPopUpManage].priorityFollowingUnDisplay);
        //优先级过低不展示
        if ([XZAlertPopUpManage sharedAlertPopUpManage].priorityFollowingUnDisplay > self.displayPriority) {
            return;
        }
        if ([XZAlertActionView isAnimating]) { //当前已经有弹窗
//            NSLog(@"当前动画还===========未结束");
            return;
        }else {
            if (self.willShowHandler) {
                self.willShowHandler(self);
            } else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewWillShow:)]) {
                [self.delegate actionAlertViewWillShow:self];
            }
            self.visible = YES;
            [XZAlertActionView setAnimating:YES];
            [XZAlertActionView setCurrentAlertView:self];
            [self setUp];
            [self showBackground];
            [self transitionInCompletion:^{
                if (self.didShowHandler) {
                    self.didShowHandler(self);
                }else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidShow:)]) {
                    [self.delegate actionAlertViewDidShow:self];
                }
            }];
//            NSLog(@"弹窗展示%@===========成功",[self.customView class]);
        }
    }
}
- (BOOL)onDeviceOrientationDidChange{
    [self setNeedsLayout];
    return YES;
}

static BOOL __hd_animating;
+ (BOOL)isAnimating {
    return __hd_animating;
}

+ (void)setAnimating:(BOOL)animating {
    __hd_animating = animating;
}

static XZAlertActionView *__hd_current_view;
+ (XZAlertActionView *)currentAlertView {
    return __hd_current_view;
}

+ (void)setCurrentAlertView:(XZAlertActionView *)alertView {
    __hd_current_view = alertView;
}

- (void)setUp {
 
//    UIWindow* window = nil;
////    if (@available(iOS 13.0, *))
////    {
////        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
////        {
////            if (windowScene.activationState == UISceneActivationStateForegroundActive)
////            {
////                window = windowScene.windows.firstObject;
////                break;
////            }
////        }
////    }else{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        window = [UIApplication sharedApplication].keyWindow;
//#pragma clang diagnostic pop
////    }
    [self.showInView addSubview:self];
    
    if (self.showInView) {
        self.frame = self.showInView.bounds;
        self.bgView.frame = self.showInView.bounds;
    } else {
        self.frame = [UIScreen mainScreen].bounds;
        self.bgView.frame = [UIScreen mainScreen].bounds;
    }
    [self addSubview:self.bgView];
    // 如果包含自定义弹窗则
    NSAssert(self.customView, @"自定义弹窗视图不能为空");

    [self addSubview:self.customView];
    if (self.customView.frame.size.height) {
        self.customView.center = self.center;
    }else {
        if (self.transitionStyle == XZActionAlertViewTransitionStyleBottomEject) {
            
        }else {
            [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (self.showInView) {
//        self.frame = self.showInView.bounds;
//        self.bgView.frame = self.showInView.bounds;
//    } else {
//        self.frame = [UIScreen mainScreen].bounds;
//        self.bgView.frame = [UIScreen mainScreen].bounds;
//    }
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.customView.frame.size.height) {
        self.customView.center = self.center;
    }else {
        if (self.transitionStyle == XZActionAlertViewTransitionStyleBottomEject) {
            
        }else {
            [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
    }
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.showInView);
    }];
}

- (void)showBackground {
        dispatch_main_async_safe(^{
            self.bgView.frame = [UIScreen mainScreen].bounds;
            self.bgView.alpha = 0;
            [UIView animateWithDuration:self.displayDuring
                             animations:^{
                                 self.bgView.alpha = 1;
                             }];
        });
}

- (void)dismisXZackground {
    dispatch_main_async_safe(^{
        self.bgView.frame = [UIScreen mainScreen].bounds;
        [UIView animateWithDuration:self.disappearDuring
                         animations:^{
                             self.bgView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
        }];
    });
}

#pragma mark - Transitions
- (void)transitionInCompletion:(void (^)(void))completion {
    
    UIView *view = self.customView;
    switch (self.transitionStyle) {
        case XZActionAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = view.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            view.frame = rect;

            [UIView animateWithDuration:0.8 delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                view.frame = originalRect;
            } completion:^(BOOL finished) {
                execBlock(completion);
            }];
            
        } break;
            
        case XZActionAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = view.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            view.frame = rect;
            [UIView animateWithDuration:self.displayDuring
                             animations:^{
                                 view.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 !completion ?: completion();
                             }];
        } break;
            
        case XZActionAlertViewTransitionStyleFade: {
            view.alpha = 0;
            [UIView animateWithDuration:self.displayDuring
                             animations:^{
                                 view.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 !completion ?: completion();
                             }];
        } break;
            
        case XZActionAlertViewTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.3), @(0.8), @(1.2), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(0.8), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = self.displayDuring;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [view.layer addAnimation:animation forKey:@"bouce"];
        } break;
            
        case XZActionAlertViewTransitionStyleDropDown: {
            
            CGFloat y = self.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = self.displayDuring;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [view.layer addAnimation:animation forKey:@"dropdown"];
        } break;
            
        case XZActionAlertViewTransitionStyleBottomEject:
        {
            [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.customView.bounds.size.height) {
                    make.size.mas_equalTo(self.customView.bounds.size);
                }
                make.bottom.mas_equalTo(kScreenHeight/2);
                make.centerX.equalTo(self.bgView.mas_centerX);
            }];
            [self layoutIfNeeded];
            [UIView animateWithDuration:self.displayDuring animations:^{
                [self.customView  mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-kBottomSafeHeight);
                }];
                [self layoutIfNeeded];
            }];
        }
            break;
    }
}


- (void)transitionOutCompletion:(void (^)(void))completion {
    UIView *view = self.customView ;

    switch (self.transitionStyle) {
        case XZActionAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = view.frame;
            rect.origin.y = self.bounds.size.height;
                [UIView animateWithDuration:self.disappearDuring delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    view.frame = rect;
                } completion:^(BOOL finished) {
                    !completion ?: completion();
                }];
            
            
        } break;
            
        case XZActionAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = view.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:self.disappearDuring
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 view.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 !completion ?: completion();
                             }];
        } break;
            
        case XZActionAlertViewTransitionStyleFade: {
            [UIView animateWithDuration:self.disappearDuring
                             animations:^{
                                 view.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 !completion ?: completion();
                             }];
        } break;
            
        case XZActionAlertViewTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = self.disappearDuring;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [view.layer addAnimation:animation forKey:@"bounce"];
            
            view.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } break;
            
        case XZActionAlertViewTransitionStyleDropDown: {
            CGPoint point = view.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:self.disappearDuring
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 view.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 view.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 !completion ?: completion();
                             }];
        } break;
            
        case XZActionAlertViewTransitionStyleBottomEject:
        {

            [UIView animateWithDuration:self.disappearDuring animations:^{
                [self.customView  mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.customView.frame.size.height);
                    make.centerX.equalTo(self.mas_centerX);
                }];
                [self layoutIfNeeded];
            }completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        default:
        {
            if (completion) {
                completion();
            }
        }
            break;
    }
}

#pragma mark - CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void (^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

#pragma mark - event response
// 点击背景
- (void)tappedBackgroundView {
    
    if (self.didTappedBackgroundHandler) {
        self.didTappedBackgroundHandler(self);
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(actionAlertViewDidTappedBackGroundView:)]) {
        [self.delegate actionAlertViewDidTappedBackGroundView:self];
    }
    if (_allowTapBackgroundDismiss) {
        [self dismiss];
    }
}

- (void)setBackgroundStyle:(XZActionAlertViewBackgroundStyle)backgroundStyle {
    self.bgView.style = backgroundStyle;
}

- (XZAlertActionBackgroundView *)bgView {
    if (!_bgView) {
        _bgView = [[XZAlertActionBackgroundView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackgroundView)];
        recognizer.delegate = self;
        [_bgView addGestureRecognizer:recognizer];

    }
    return _bgView;
}

- (UIView *)showInView {
    if (!_showInView) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _showInView = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
        
    }
    return _showInView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"弹窗销毁====%@",[self.customView class]);
}

@end
