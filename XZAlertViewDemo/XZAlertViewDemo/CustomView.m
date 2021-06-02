//
//  CustomView.m
//  XZAlertViewDemo
//
//  Created by ZF xie on 2021/5/13.
//

#import "CustomView.h"
#import <Masonry/Masonry.h>
@implementation CustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.detailLB = [[UILabel alloc] init];
        self.detailLB.textAlignment = NSTextAlignmentCenter;
        self.detailLB.numberOfLines = 0;
        [self addSubview:self.detailLB];
        [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            make.width.mas_equalTo(300);
        }];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.dism();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
