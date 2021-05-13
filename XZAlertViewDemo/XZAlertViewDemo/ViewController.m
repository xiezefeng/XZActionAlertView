//
//  ViewController.m
//  XZAlertViewDemo
//
//  Created by ZF xie on 2021/5/13.
//

#import "ViewController.h"
#import "XZAlertActionView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;///<<#des#>
@property (nonatomic, strong) NSArray *allTititleArray;///<<#des#>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.tableView];
    self.allTititleArray = @[
    
        @"中间弹出",
        @"底部弹出",
    ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTititleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.allTititleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
            redView.backgroundColor = UIColor.redColor;
            XZAlertActionView *alert = [[XZAlertActionView alloc] initWithCustomView:redView style:XZActionAlertViewTransitionStyleBottomEject];
            alert.allowTapBackgroundDismiss = YES;
            [alert show];
        }
            break;
        case 1: {
            UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
            redView.backgroundColor = UIColor.redColor;
            XZAlertActionView *alert = [[XZAlertActionView alloc] initWithCustomView:redView style:XZActionAlertViewTransitionStyleDropDown];
            alert.allowTapBackgroundDismiss = YES;
            alert.showInView = self.tableView;
            [alert show];
        }
            break;
        default:
            break;
    }
}

@end
