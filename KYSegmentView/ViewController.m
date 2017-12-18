//
//  ViewController.m
//  KYSegmentView
//
//  Created by 康义 on 2017/12/14.
//  Copyright © 2017年 康义. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "KYSegmentView.h"

@interface ViewController ()
@property (nonatomic, strong) KYSegmentView *pagerView;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"KYSegmentView";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pagerView];
}
- (KYSegmentView *)pagerView {
    if (!_pagerView) {
        NSArray *titleArray = [self TitleArray];
        NSArray *vcsArray = [self VCsArray];
        CGRect pagerRect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        _pagerView = [[KYSegmentView alloc] initWithFrame:pagerRect WithTitles:titleArray WithObjects:vcsArray];
    }
    return _pagerView;
}
- (NSArray *)TitleArray {
    return @[
             @"全部",
             @"已付款",
             @"待发货",
             @"已发货",
             @"待评价",
             @"交易关闭"
             ];
}
- (NSArray *)VCsArray {
    return @[
             @"TestViewController",
             @"TestViewController",
             @"TestViewController",
             @"TestViewController",
             @"TestViewController",
             @"TestViewController"
             ];
}
@end
