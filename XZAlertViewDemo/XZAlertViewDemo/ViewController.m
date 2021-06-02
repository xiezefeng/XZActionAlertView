//
//  ViewController.m
//  XZAlertViewDemo
//
//  Created by ZF xie on 2021/5/13.
//

#import "ViewController.h"
#import "XZAlertActionView.h"
#import "CustomView.h"
@interface ViewController ()
@property (nonatomic, strong) UITableView *tableView;///<<#des#>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *backgroundStyleSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewTypeSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *showInViewSeg;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ViewController


- (IBAction)show:(id)sender {
    XZAlertActionConfig *config = [[XZAlertActionConfig alloc] init];
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    redView.backgroundColor = UIColor.redColor;
    config.transitionStyle = 1 << (self.segView.selectedSegmentIndex + 1);
    config.allowTapBackgroundDismiss = YES;
    config.backgroundStyle = 1 << (self.backgroundStyleSeg.selectedSegmentIndex + 1);
    config.isShowCloseBtn = YES;
    config.closeStyle = XZActionAlertViewCloseStyleRightTop;
    XZAlertActionView *alert = [XZAlertActionView actionAlertViewWithCustomView:redView config:config];
    if (self.viewTypeSeg.selectedSegmentIndex == 0) {
        alert.showInView = self.tableView;

    }else {
        CustomView *ctView = [[CustomView alloc] init];
        ctView.backgroundColor = UIColor.whiteColor;
        ctView.detailLB.text= @"实力对抗肌肤拉开大煞风景阿克琉斯觉得反馈啦见识到风口浪尖阿斯科利的风景阿克琉斯大家反馈啦及时的反馈啦就是快乐的风景阿克琉斯大家反馈啦绝世独立封口机阿斯科利的飞机啊";
        alert.customView = ctView;
        ctView.dism = ^{
            [alert dismiss];
        };
        
    }
    if (self.showInViewSeg.selectedSegmentIndex == 1) {
        alert.showInView = self.bottomView;
    }
    [alert show];

}



@end
