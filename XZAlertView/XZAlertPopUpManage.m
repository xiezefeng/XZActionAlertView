//
//  XZAlertPopUpManage.m
//  XZAlertView
//
//  Created by ZF xie on 2020/11/9.
//

#import "XZAlertPopUpManage.h"
#import "XZAlertActionView.h"

@interface XZAlertPopUpManage()
@property (nonatomic, strong ) XZAlertActionView *currentAlertActionView;///<<#des#>

@end

@implementation XZAlertPopUpManage
static XZAlertPopUpManage *_alertPopUpManage = nil;

+ (instancetype)sharedAlertPopUpManage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _alertPopUpManage = [[super allocWithZone:NULL] init];
        _alertPopUpManage.alertActionList = [NSMutableArray array];
        _alertPopUpManage.isShowNext = YES;
    });
    return _alertPopUpManage;
}

- (void)setPriorityFollowingUnDisplay:(NSInteger)priorityFollowingUnDisplay {
    [self willChangeValueForKey:@"priorityFollowingUnDisplay"];
    _priorityFollowingUnDisplay = priorityFollowingUnDisplay;
    [self didChangeValueForKey:@"priorityFollowingUnDisplay"];
    [self showAlertActions];

}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedAlertPopUpManage];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [XZAlertPopUpManage sharedAlertPopUpManage];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [XZAlertPopUpManage sharedAlertPopUpManage];
}

- (void)addAlertAction:(XZAlertActionView *)action {

    for (int i = 0; i < self.alertActionList.count; i++) {
        XZAlertActionView *alert = self.alertActionList[i];
        if (alert.displayPriority > action.displayPriority) {
            [self.alertActionList insertObject:action atIndex:i];
            return;
        }
    }
    //当数组没有数据或者displayPriority级别没有高于数组中的弹窗时
    [self.alertActionList addObject:action];

   
}
- (void)removeAlertAction:(XZAlertActionView *)action {
    NSAssert([self.alertActionList containsObject:action], @"队列中不包含此弹窗");
//    NSLog(@"removeAlertAction移除前===============%lu",(unsigned long)[XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.count);
    [self.alertActionList removeObject:action];
//    NSLog(@"removeAlertAction移除后===============%lu",(unsigned long)[XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.count);

}

- (void)addAlertActions:(NSArray *)actions {
    NSAssert(!actions, @"弹窗数组不能为空");
    [self.alertActionList addObjectsFromArray:actions];
    [self.alertActionList sortUsingComparator:^NSComparisonResult(XZAlertActionView * _Nonnull obj1, XZAlertActionView *   _Nonnull obj2) {
        return obj1.displayPriority < obj2.displayPriority;
    }];
}

- (void)showAlertActions {
    if (self.alertActionList.count > 0) {
        XZAlertActionView *actionView = self.alertActionList.firstObject;
        if (actionView.displayPriority < self.priorityFollowingUnDisplay) {
            NSLog(@"优先级过低不展示");
            return;
        }
        [actionView show];
        self.currentAlertActionView = actionView;
    }else {
        self.currentAlertActionView = nil;
    }
}

+ (NSInteger)alertActionsCount {
    return [XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.count;
}

+ (void)removablePopupView:(NSInteger)displayPriority {
    XZAlertActionView *currentAlertActionView = nil;
//    NSLog(@"移除前===============%lu",(unsigned long)[XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.count);
    for (NSInteger i = [XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.count - 1; i >= 0; i--) {
        XZAlertActionView *obj = [XZAlertPopUpManage sharedAlertPopUpManage].alertActionList[i];
        if (obj.displayPriority < displayPriority) {
            if (obj.isVisible) {
                currentAlertActionView = obj;
            }else {
                [[XZAlertPopUpManage sharedAlertPopUpManage] removeAlertAction:obj];
            }
        }
    }
    if (currentAlertActionView) {
        [currentAlertActionView dismiss];
    }else {
        [[XZAlertPopUpManage sharedAlertPopUpManage] showAlertActions];
    }
//    NSLog(@"移除后===============%lu",(unsigned long)[XZAlertPopUpManage sharedAlertPopUpManage].alertActionList.count);
//    [XZAlertPopUpManage sharedAlertPopUpManage].isShowNext = YES;
    
}
@end
