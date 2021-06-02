//
//  XZAlertActionConfig.m
//  XZAlertViewDemo
//
//  Created by ZF xie on 2021/6/2.
//

#import "XZAlertActionConfig.h"

@implementation XZAlertActionConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundStyle = XZActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = XZActionAlertViewTransitionStyleFade;
        self.closeStyle = XZActionAlertViewCloseStyleBottom;
        self.displayDuring = 0.4;
        self.disappearDuring = 0.3;
        self.closeBtnMargin = 20;
        self.allowTapBackgroundDismiss = NO;
        self.isShowCloseBtn = NO;
        self.bottomMargin = 0;
        self.closeSize = CGSizeMake(20, 20);
    }
    return self;
}

- (UIImage *)closeBtnImage {
    if (!_closeBtnImage) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XZAlertActionView" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        NSString *path = [bundle pathForResource:@"close_white" ofType:@"png"];
        _closeBtnImage = [UIImage imageWithContentsOfFile:path];
    }
    return _closeBtnImage;
}

@end
