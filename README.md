# KYSegmentView
![展示图](https://github.com/kangyiii/KYSegmentView/blob/master/%E5%B1%95%E7%A4%BAGif.gif)

###使用说明

```
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
_pagerView.delegate = self;
//对KYSegmentView做更多的自定义设置
}
return _pagerView;
}
//标题数组
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
//控制器数组
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
//代理方法
- (void)CurrentPageIndex:(NSInteger)currentPage currentObject:(id)currentObject lastObject:(id)lastObject{
//这里对每个具体的Controller做的操作
}
```
