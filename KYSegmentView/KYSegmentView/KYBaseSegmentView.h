//
//  KYBaseSegmentView.h
//  KYBaseSegmentView
//
//  Created by 康义 on 2017/12/15.
//  Copyright © 2017年 康义. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYBaseSegmentView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView; /**<  滑动视图   **/
@property (assign, nonatomic) NSInteger currentPage; /**<  页码   **/
@property (strong, nonatomic) UIScrollView *topTab; /**<  顶部tab   **/
@property (strong, nonatomic) NSArray *titleArray; /**<  标题   **/
@property (strong, nonatomic) NSArray *topArray; /**<  未选中时顶部自定义视图   **/
@property (strong, nonatomic) NSArray *changeTopArray; /**<  选中时顶部自定义视图   **/
@property (assign, nonatomic) CGFloat titleScale; /**< 标题缩放比例 **/
@property (assign, nonatomic) NSInteger baseDefaultPage; /**< 设置默认加载的界面 **/
@property (assign, nonatomic) CGFloat blockHeight; /**< 滑块高度 **/
@property (assign, nonatomic) CGFloat bottomLinePer; /**< 下划线占比 **/
@property (assign, nonatomic) CGFloat bottomLineHeight; /**< 下划线高度 **/
@property (assign, nonatomic) CGFloat cornerRadiusRatio; /**< 滑块圆角 **/
@property (assign, nonatomic) CGFloat titlesFont; /**< 标题字体大小 **/
@property (assign, nonatomic) CGFloat topHeight; /**< TopTab高度 **/
@property (assign, nonatomic) BOOL topTabUnderLineHidden; /**< 是否显示下方的下划线 **/
@property (assign, nonatomic) BOOL slideEnabled; /**< 允许下方左右滑动 **/
@property (assign, nonatomic) BOOL autoFitTitleLine; /**< 下划线是否自适应标题宽度 **/
@property (assign, nonatomic) BOOL topTabHiddenEnable; /**< 是否允许下方滑动时候隐藏上方的toptab **/
@property (strong, nonatomic) UIColor *btnUnSelectColor; /**< 未选中的标题颜色 **/
@property (strong, nonatomic) UIColor *btnSelectColor; /**< 选中的标题颜色 **/
@property (strong, nonatomic) UIColor *underlineBlockColor; /**< 下划线或滑块颜色 **/
@property (strong, nonatomic) UIColor *topTabColor; /**< topTab背景颜色 **/

/**
 *  Reload toptab titles
 *
 @param newTitles new titles
 */
- (void)reloadTabItems:(NSArray *)newTitles;

@end
