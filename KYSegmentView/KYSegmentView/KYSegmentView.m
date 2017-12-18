//
//  KYBaseSegmentView.m
//  KYBaseSegmentView
//
//  Created by 康义 on 2017/12/15.
//  Copyright © 2017年 康义. All rights reserved.
//

#import "KYSegmentView.h"
#import "KYBaseSegmentView.h"
#import "UIView+ViewController.h"

#define MaxNums  10 //Max limit number,recommand below 10.
#define WIDTH     ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT    ([[UIScreen mainScreen] bounds].size.height)
//设置背景颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define More5LineWidth      WIDTH / 5.0

static NSString *const kObserverPage = @"currentPage";

@interface KYSegmentView()<NSCacheDelegate>
/**<
 *  自定义顶部栏视图，支持用户替代原有的固态标题样式。该属性是需要传入未选中(普通状态)时顶部样式，具体设置可参照Example中的方式(此自定义方式在NinaPagerStyleSlideBlock中并不适用)。
 *  Custom topTab views,you can set views as you wish.The property needs to your unselected(normal) views array,you can set it like Example's setting(This property doesn't support NinaPagerStyleSlideBlock mode).
 **/
@property (strong, nonatomic) NSArray *topTabViews;
/**<
 *  自定义顶部栏视图，支持用户替代原有的固态标题样式。该属性是需要传入选中时顶部样式，具体设置可参照Example中的方式(此自定义方式在NinaPagerStyleSlideBlock中并不适用)。
 *  Custom topTab views,you can set views as you wish.The property needs to your selected views array,you can set it like Example's setting(This property doesn't support NinaPagerStyleSlideBlock mode).
 **/
@property (strong, nonatomic) NSArray *selectedTopTabViews;
@property (nonatomic, strong) NSCache *limitControllerCache;
@property (nonatomic, strong) KYBaseSegmentView *kyBaseView;
@property (nonatomic, assign) BOOL hasSettingScrollEnabled;
@property (nonatomic, assign) BOOL hasSettingLinePer;
@property (nonatomic, strong) id currentObject;
@property (nonatomic, strong) id lastObject;
@end

@implementation KYSegmentView
{
    NSArray *titlesArray;
    NSArray *classArray;
    NSMutableArray *viewNumArray;
    NSMutableArray *vcsTagArray;
    NSMutableArray *vcsArray;
    BOOL viewAlloc[MaxNums];
    UIViewController *firstVC;
    BOOL pagerLoadWhole;
    BOOL ableLoadData;
}

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles WithObjects:(NSArray *)objects
{
    if (self = [super init]) {
        self.frame = frame;
        titlesArray = titles;
        classArray = objects;
    }
    return self;
}

#pragma mark - SetMethod

- (void)setNinaChosenPage:(NSInteger)ninaChosenPage {
    if (ninaChosenPage > titlesArray.count) {
        NSLog(@"You can't set chosen page greater than titles count!");
        return;
    }
    self.kyBaseView.scrollView.contentOffset = CGPointMake(WIDTH * (ninaChosenPage - 1) - 1, 0);
    self.kyBaseView.currentPage = ninaChosenPage - 1;
}

- (void)setSelectBottomLinePer:(CGFloat)selectBottomLinePer {
    _selectBottomLinePer = selectBottomLinePer;
    _hasSettingLinePer = YES;
}
- (void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    _hasSettingScrollEnabled = YES;
}

- (void)setTopTabScrollHidden:(BOOL)topTabScrollHidden {
    _topTabScrollHidden = topTabScrollHidden;
    self.kyBaseView.topTabHiddenEnable = _topTabScrollHidden;
}

#pragma mark - LazyLoad
- (KYBaseSegmentView *)kyBaseView {
    if (!_kyBaseView) {
        _kyBaseView = [[KYBaseSegmentView alloc] initWithFrame:self.bounds];
        [_kyBaseView addObserver:self forKeyPath:kObserverPage options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _kyBaseView;
}

#pragma mark - LayOutSubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_kyBaseView) {
        [self loadDataForView];
    }
}

#pragma mark - LoadData
- (void)loadDataForView {
    [self createPagerView:titlesArray WithObjects:classArray];
    self.kyBaseView.btnUnSelectColor = _unSelectTitleColor;
    self.kyBaseView.btnSelectColor = _selectTitleColor;
    self.kyBaseView.underlineBlockColor = _underlineColor;
    self.kyBaseView.topTabColor = _topTabBackGroundColor;
    CGFloat tabHeight = _topTabHeight > 25?_topTabHeight:40;
    self.kyBaseView.topHeight = tabHeight;
    self.kyBaseView.baseDefaultPage = 0;
    self.kyBaseView.topArray = _topTabViews;
    self.kyBaseView.changeTopArray = _selectedTopTabViews;
    self.kyBaseView.titleScale = _titleScale > 0?_titleScale:1.15;
    self.kyBaseView.titlesFont = _titleFont > 0?_titleFont:14;
    self.kyBaseView.topTabUnderLineHidden = _underLineHidden;
    self.kyBaseView.slideEnabled = _hasSettingScrollEnabled?_scrollEnabled:YES;
    self.kyBaseView.blockHeight = _sliderHeight > 0?_sliderHeight:tabHeight;
    self.kyBaseView.bottomLinePer = (_selectBottomLinePer > 0 && _selectBottomLinePer < 1 && _hasSettingLinePer)?_selectBottomLinePer:1;
    self.kyBaseView.autoFitTitleLine = NO;
    self.kyBaseView.bottomLineHeight = _selectBottomLineHeight > 0?_selectBottomLineHeight:2;
    self.kyBaseView.cornerRadiusRatio = _sliderCornerRadiusRatio > 0?_sliderCornerRadiusRatio:0;
    self.kyBaseView.titleArray = titlesArray;
    if (_nina_navigationBarHidden == YES) {
        self.viewController.automaticallyAdjustsScrollViewInsets = NO;
        self.kyBaseView.topTab.frame = CGRectMake(0, 20, WIDTH, tabHeight);
        self.kyBaseView.scrollView.frame = CGRectMake(0, tabHeight + 20, WIDTH, self.frame.size.height - tabHeight);
    }

    if (classArray.count > 0 && titlesArray.count > 0 && ableLoadData) {
        if (_loadWholePages) {
            for (NSInteger i = 0; i< classArray.count; i++) {
                [self loadWholeOrNotWithTag:i WithMode:1];
            }
        }else {
            [self loadWholeOrNotWithTag:0 WithMode:0];
        }
    }
    if (_loadWholePages) {
        for (NSInteger i = 0; i < vcsArray.count; i++) {
            [self.viewController addChildViewController:vcsArray[i]];
        }
    }else {
        if (firstVC != nil) {
            [self.viewController addChildViewController:firstVC];
        }
    }
    self.viewController.edgesForExtendedLayout = UIRectEdgeNone;
}


#pragma mark - Reload Data
- (void)reloadTopTabByTitles:(NSArray *)updatedTitles WithObjects:(NSArray *)updatedObjects {
    titlesArray = updatedTitles;
    classArray = updatedObjects;
    if (firstVC) {
        [firstVC.view removeFromSuperview];
        firstVC.view = nil;
        [firstVC removeFromParentViewController];
    }
    for (UIViewController *subVC in self.viewController.childViewControllers) {
        [subVC.view removeFromSuperview];
        subVC.view = nil;
        [subVC removeFromParentViewController];
    }
    if (!_loadWholePages) {
        for (NSInteger i = 0; i < classArray.count; i++) {
            viewAlloc[i] = NO;
        }
    }
    [self loadDataForView];
    [self.kyBaseView reloadTabItems:updatedTitles];
}

#pragma mark - NSCache
- (NSCache *)limitControllerCache {
    if (!_limitControllerCache) {
        _limitControllerCache = [NSCache new];
        _limitControllerCache.delegate = self;
    }
    /**< Set max of controller's number   **/
    _limitControllerCache.countLimit = 5;
    return _limitControllerCache;
}

#pragma mark - CreateView
- (void)createPagerView:(NSArray *)titles WithObjects:(NSArray *)objects {
    viewNumArray = [NSMutableArray array];
    vcsArray = [NSMutableArray array];
    vcsTagArray = [NSMutableArray array];
    if (titles.count > 0 && objects.count > 0) {
        [self addSubview:self.kyBaseView];
        //First ViewController present to the screen
        ableLoadData = YES;
    }else {
        NSLog(@"You should correct titlesArray or childVCs count!");
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.kyBaseView && [keyPath isEqualToString:kObserverPage]) {
        NSInteger page = [change[@"new"] integerValue];
        for (NSInteger i = 0; i < vcsTagArray.count; i++) {
            if ([vcsTagArray[i] isEqualToString:[NSString stringWithFormat:@"%i",[change[@"new"] intValue]]]) {
                self.lastObject = self.currentObject;
                self.currentObject = vcsArray[i];
                if ([vcsArray[i] isKindOfClass:[UIViewController class]]) {
                    [vcsArray[i] viewDidAppear:YES];
                }
            }
        }
        self.pageIndex = page;
        [self performSelector:@selector(currentPageAndObject) withObject:nil afterDelay:0.1];
        if (titlesArray.count > 5) {
            CGFloat topTabOffsetX = 0;
            if (page >= 2) {
                if (page <= titlesArray.count - 3) {
                    topTabOffsetX = (page - 2) * More5LineWidth;
                }
                else {
                    if (page == titlesArray.count - 2) {
                        topTabOffsetX = (page - 3) * More5LineWidth;
                    }else {
                        topTabOffsetX = (page - 4) * More5LineWidth;
                    }
                }
            }
            else {
                if (page == 1) {
                    topTabOffsetX = 0 * More5LineWidth;
                }else {
                    topTabOffsetX = page * More5LineWidth;
                }
            }
            [self.kyBaseView.topTab setContentOffset:CGPointMake(topTabOffsetX, 0) animated:YES];
        }
        if (!_loadWholePages) {
            for (NSInteger i = 0; i < titlesArray.count; i++) {
                if (page == i && i <= classArray.count - 1) {
                    if ([classArray[i] isKindOfClass:[NSString class]]) {
                        NSString *className = classArray[i];
                        Class class = NSClassFromString(className);
                        if ([class isSubclassOfClass:[UIViewController class]] && viewAlloc[i] == NO) {
                            UIViewController *ctrl = nil;
                            ctrl = class.new;
                            [self createOtherViewControllers:ctrl WithControllerTag:i];
                        }else if ([class isSubclassOfClass:[UIView class]]) {
                            UIView *singleView =class.new;
                            singleView.frame = CGRectMake(WIDTH * i, 0, WIDTH, self.frame.size.height - _topTabHeight);
                            [self.kyBaseView.scrollView addSubview:singleView];
                        }else if (!class) {
                            NSLog(@"Your Vc%li is not found in this project!",(long)i + 1);
                        }
                    }else {
                        if ([classArray[i] isKindOfClass:[UIViewController class]]) {
                            UIViewController *ctrl = classArray[i];
                            if (ctrl && viewAlloc[i] == NO) {
                                [self createOtherViewControllers:ctrl WithControllerTag:i];
                            }else if (!ctrl) {
                                NSLog(@"Your Vc%li is not found in this project!",(long)i + 1);
                            }
                        }else if ([classArray[i] isKindOfClass:[UIView class]]) {
                            UIView *singleView = classArray[i];
                            singleView.frame = CGRectMake(WIDTH * i, 0, WIDTH, self.frame.size.height - _topTabHeight);
                            [self.kyBaseView.scrollView addSubview:singleView];
                        }
                    }
                }else if (page == i && i > classArray.count - 1) {
                    NSLog(@"You are not set title%li 's controller.",(long)i + 1);
                }else {
                    /**<  The number of controllers max is 5.   **/
                    if (!_loadWholePages) {
                        if (vcsArray.count > 5) {
                            UIViewController *deallocVC = [vcsArray firstObject];
                            NSInteger deallocTag = [[vcsTagArray firstObject] integerValue];
                            if (![self.limitControllerCache objectForKey:@(deallocTag)]) {
                                [self.limitControllerCache setObject:deallocVC forKey:@(deallocTag)];
                            };
                            [deallocVC.view removeFromSuperview];
                            deallocVC.view = nil;
                            [deallocVC removeFromParentViewController];
                            deallocVC = nil;
                            [vcsArray removeObjectAtIndex:0];
                            viewAlloc[deallocTag] = NO;
                            [vcsTagArray removeObjectAtIndex:0];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    [self.kyBaseView removeObserver:self forKeyPath:kObserverPage context:nil];
}



#pragma mark - Private Method
/**
 *  Create first controller or views.
 *
 *  @param ctrl first controller.
 */
- (void)createFirstViewController:(UIViewController *)ctrl {
    firstVC = ctrl;
    self.lastObject = self.currentObject;
    self.currentObject = ctrl;
    ctrl.view.frame = CGRectMake(WIDTH * 0, 0, WIDTH, self.frame.size.height - _topTabHeight);
    [self.kyBaseView.scrollView addSubview:ctrl.view];
    /**<  Add new test cache   **/
    if (![self.limitControllerCache objectForKey:@(0)]) {
        [self.limitControllerCache setObject:ctrl forKey:@(0)];
    };
    [vcsArray addObject:ctrl];
    NSString *transString = [NSString stringWithFormat:@"%li",(long)0];
    [vcsTagArray addObject:transString];
    self.pageIndex = 1;
}

/**
 *  Create other controllers or views.
 *
 *  @param ctrl controllers.
 *  @param i    controller's tag.
 */
- (void)createOtherViewControllers:(UIViewController *)ctrl WithControllerTag:(NSInteger)i {
    [self.viewController addChildViewController:ctrl];
    self.lastObject = self.currentObject;
    self.currentObject = ctrl;
    [vcsArray addObject:ctrl];
    NSString *tagStr = @(i).stringValue;
    [vcsTagArray addObject:tagStr];
    ctrl.view.frame = CGRectMake(WIDTH * i, 0, WIDTH, self.frame.size.height - _topTabHeight);
    [self.kyBaseView.scrollView addSubview:ctrl.view];
    viewAlloc[i] = YES;
}

/**
 *  Load whole page or not.
 *
 *  @param ninaTag Viewcontroller or view tag.
 *  @param mode Load whole page mode.
 */
- (void)loadWholeOrNotWithTag:(NSInteger)ninaTag WithMode:(NSInteger)mode {
    if ([classArray[ninaTag] isKindOfClass:[NSString class]]) {
        NSString *className = classArray[ninaTag];
        Class class = NSClassFromString(className);
        if ([class isSubclassOfClass:[UIViewController class]]) {
            UIViewController *ctrl = class.new;
            if (mode == 0) {
                [self createFirstViewController:ctrl];
            }else {
                [self createOtherViewControllers:ctrl WithControllerTag:ninaTag];
            }
        }else if ([class isSubclassOfClass:[UIView class]]) {
            UIView *singleView =class.new;
            singleView.frame = CGRectMake(WIDTH * ninaTag, 0, WIDTH, self.frame.size.height - _topTabHeight);
            [self.kyBaseView.scrollView addSubview:singleView];
        }
    }else {
        if ([classArray[ninaTag] isKindOfClass:[UIViewController class]]) {
            UIViewController *ctrl = classArray[ninaTag];
            if (mode == 0) {
                [self createFirstViewController:ctrl];
            }else {
                [self createOtherViewControllers:ctrl WithControllerTag:ninaTag];
            }
        }else if ([classArray[ninaTag] isKindOfClass:[UIView class]]) {
            UIView *singleView = classArray[ninaTag];
            singleView.frame = CGRectMake(WIDTH * ninaTag, 0, WIDTH, self.frame.size.height - _topTabHeight);
            [self.kyBaseView.scrollView addSubview:singleView];
        }
    }
}

- (void)currentPageAndObject {
    if ([self.delegate respondsToSelector:@selector(CurrentPageIndex:currentObject:lastObject:)]) {
        [self.delegate CurrentPageIndex:self.pageIndex currentObject:self.currentObject lastObject:self.lastObject];
    }
}

@end
