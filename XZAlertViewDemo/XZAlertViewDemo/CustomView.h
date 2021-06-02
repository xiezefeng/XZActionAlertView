//
//  CustomView.h
//  XZAlertViewDemo
//
//  Created by ZF xie on 2021/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomView : UIView
@property (nonatomic, strong) UILabel *detailLB;///<
@property (nonatomic, copy) void(^dism)(void);
@end

NS_ASSUME_NONNULL_END
