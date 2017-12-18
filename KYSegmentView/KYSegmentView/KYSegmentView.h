//
//  KYBaseSegmentView.m
//  KYBaseSegmentView
//
//  Created by 康义 on 2017/12/15.
//  Copyright © 2017年 康义. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSegmentViewDelegate <NSObject>
@optional
/**
 *  通过此代理方法您可以获取到当前页码、当前对象及上一个对象进而对相关的控制器进行操作。
 */
- (void)CurrentPageIndex:(NSInteger)currentPage currentObject:(id)currentObject lastObject:(id)lastObject;
@end

@interface KYSegmentView : UIView
/** NinaPagerView代理 */
@property (weak, nonatomic) id<KYSegmentViewDelegate>delegate;

/** 上方标题选中时颜色，默认颜色为黑色 */
@property (strong, nonatomic) UIColor *selectTitleColor;

/** 上方标题未选中时颜色，默认颜色为灰色 */
@property (strong, nonatomic) UIColor *unSelectTitleColor;

/** 在下划线模式下的下划线的颜色 */
@property (strong, nonatomic) UIColor *underlineColor;

/** 上方topTab背景颜色，默认颜色为白色 */
@property (strong, nonatomic) UIColor *topTabBackGroundColor;

/**<
 *  所在的控制器index或点击上方button的index。
 *  Current controller's or view's index and click button's index.
 **/
@property (assign, nonatomic) NSInteger pageIndex;

/**
 *  上方TopTab的高度值，如果不设置默认值为40，请设置值大于25。
 *  TopTab height,default height is 40,please set it above 25.
 */
@property (assign, nonatomic) CGFloat topTabHeight;
/**
 *  上方标题的字体大小设置，默认为14。
 *  Title font in TopTab,default font is 14.
 */
@property (assign, nonatomic) CGFloat titleFont;
/**
 *  您可以设置titleSize这个属性来设置标题的缩放比例(相对于原比例标题)。同时，在加入了顶部自定义视图之后，您可以通过设置此属性来对选中的view整体进行缩放，推荐您设置的范围在1~1.5之间，如果不设置此属性，默认的缩放比例为1.15。(需要注意的是，此属性不适用于NinaPagerStyleSlideBlock样式)
 *  You can set titleSize for title animation(compare to origin title).Meanwhile,after adding custom topTab,you also can set the property to the topTab view which selected.Command range between 1 and 1.5.If don't set this,default scale is 1.15.(TitleScale is not working on NinaPagerStyleSlideBlock)
 */
@property (assign, nonatomic) CGFloat titleScale;
/**<
 *  您可以对此参数进行设置来改变下划线的长度，此参数代表的是选中的整体部分的占比，默认为1，您可以对此进行设置，但推荐您尽量不要设置在0.5以下(此参数设置在两种样式中均可使用)。
 *  You can set this parameter to change the length of bottomline,the percent of selected button,default is 1.Recommand to set it above 0.5.
 **/
@property (assign, nonatomic) CGFloat selectBottomLinePer;
/**<
 *  您可以对此参数进行设置来改变下划线的高度，默认为2，若超过3，则默认为3。
 *  You can set this to change bottomline's height,default is 2,max height is 3.
 **/
@property (assign, nonatomic) CGFloat selectBottomLineHeight;
/**<
 *  NinaPagerStyleSlideBlock模式下的滑块高度。
 *  SliderBlock's height in NinaPagerStyleSlideBlock.
 **/
@property (assign, nonatomic) CGFloat sliderHeight;
/**<
 *  滑块的layer.cornerRadius属性，默认的计算公式是(滑块高度 / SlideBlockCornerRadius)，若您想要自定义调整，请修改此参数，如果不想要圆角，请设置此参数为0。
 *  Sliderblock's layer.cornerRadius,it equals to sliderHeight / SlideBlockCornerRadius,if you don't want cornerRadius,please set this to 0.
 **/
@property (assign, nonatomic) CGFloat sliderCornerRadiusRatio;
/**<
 *  是否隐藏了导航栏，您的导航栏如果隐藏或者没有，需要将此属性设置为YES。
 *  Hide NavigationBar or not,if you wanna set this to YES,you must hide your NavigationBar first.
 **/
@property (assign, nonatomic) BOOL nina_navigationBarHidden;
/**<
 *  是否一次性加载全部页面或控制器，默认为否。
 *  Load whole viewcontrollers or views,default is NO.
 **/
@property (assign, nonatomic) BOOL loadWholePages;
/**<
 *  上方TopTab下面的总览线是否隐藏，默认为不隐藏。
 *  Hide the topTab's underline(not the select underline) or not,default is NO.
 **/
@property (assign, nonatomic) BOOL underLineHidden;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (assign, nonatomic) BOOL topTabScrollHidden;

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles WithObjects:(NSArray *)objects;
@end
