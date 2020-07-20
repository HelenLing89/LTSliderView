//
//  LTSliderView.h
//  佳兆业城市广场
//
//  Created by 凌甜 on 2020/6/30.
//  Copyright © 2020 com.ATT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTSliderViewDelegate <NSObject>


- (void)LTSliderViewTouchIndex:(NSInteger)count;

@end

@interface LTSliderView : UIView

/**
 *  刷新显示-如果有自定义样式，需要调用此方法
 */
- (void)show;
/**
 *  设置显示的内容数组，不设置的话显示数字
 *
 */
@property (nonatomic,strong) NSArray *showArr;

/**
 *  设置数量
 *
 *  @param count 数量
 */
- (void)setLableCount:(int)count;

/**
 *  每个显示的Lable的宽度,默认33,(宽度不够会导致字体变小)
 *  这个是宽度
 */
@property CGFloat labelWidth;

/**
 *  每个显示的Lable的间距,默认33
 */
@property CGFloat labelMin;

/**
 *  未选中的Lable的高度，默认15
 */
@property CGFloat labelHeight;

/**
 *  未选中的Lable的高度，默认15
 */
@property CGFloat minWidth;




@property(nonatomic,weak) id <LTSliderViewDelegate> delegate;

- (void)scrollTo:(NSInteger)index;

@end

