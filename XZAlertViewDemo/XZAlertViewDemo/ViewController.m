//
//  ViewController.m
//  XZAlertViewDemo
//
//  Created by ZF xie on 2021/5/13.
//

#import "ViewController.h"
#import "XZAlertActionView.h"
#import "CustomView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;///<<#des#>
@property (nonatomic, strong) NSArray *allTititleArray;///<<#des#>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *backgroundStyleSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewTypeSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *showInViewSeg;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ViewController


- (IBAction)show:(id)sender {
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    redView.backgroundColor = UIColor.redColor;
    NSInteger type = 1 << (self.segView.selectedSegmentIndex + 1);
    XZAlertActionView *alert = [[XZAlertActionView alloc] initWithCustomView:redView style:type];
    alert.allowTapBackgroundDismiss = YES;
    alert.backgroundStyle = 1 << (self.backgroundStyleSeg.selectedSegmentIndex + 1);
    if (self.viewTypeSeg.selectedSegmentIndex == 0) {
        alert.showInView = self.tableView;

    }else {
        CustomView *ctView = [[CustomView alloc] init];
        
        ctView.backgroundColor = UIColor.whiteColor;
        ctView.detailLB.text= @"实力对抗肌肤拉开大煞风景阿克琉斯觉得反馈啦见识到风口浪尖阿斯科利的风景阿克琉斯大家反馈啦及时的反馈啦就是快乐的风景阿克琉斯大家反馈啦绝世独立封口机阿斯科利的飞机啊";
        alert.customView = ctView;
        
    }
    if (self.showInViewSeg.selectedSegmentIndex == 0) {
        alert.showInView = self.bottomView;
    }
    
    [alert show];

}


@end
