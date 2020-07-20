//
//  LTSliderView.m
//  佳兆业城市广场
//
//  Created by 凌甜 on 2020/6/30.
//  Copyright © 2020 com.ATT. All rights reserved.
//

#define kViewWidth(v)            v.frame.size.width
#define kViewHeight(v)           v.frame.size.height
#define kViewX(v)                v.frame.origin.x
#define kViewY(v)                v.frame.origin.y
#define kViewMaxX(v)             (v.frame.origin.x + v.frame.size.width)
#define kViewMaxY(v)             (v.frame.origin.y + v.frame.size.height)
#define kW  1
#define kH 1

#import "LTSliderView.h"
#import "UIView+SunExtension.h"

@interface LTSliderView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *baseScrollView;
@property (nonatomic,strong) NSMutableArray *SlideLabArr;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic, weak) NSTimer *timer;
@property int allcount;
@property int lastCount;
@end
@implementation LTSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.labelWidth = 100.5;
        self.labelMin = 20;
        self.labelHeight = 79.6;
        self.minWidth = 60;
        self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
       // self.baseScrollView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.baseScrollView];
        self.baseScrollView.delegate = self;
        self.baseScrollView.showsVerticalScrollIndicator = NO;
        self.baseScrollView.showsHorizontalScrollIndicator = NO;
        self.baseScrollView.scrollEnabled = YES;
        self.clipsToBounds = YES;
        self.lastCount  = 0;
    }
    return self;
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    UIView *subView = tap.view;
    [self scrollTo:subView.tag];
    
   
//    CGPoint point = [tap locationInView:self.baseScrollView];
//    CGFloat labDiff = point.x - (self.labelWidth*0.5 *kW / 2);
//    int index = labDiff / (self.labelWidth*0.5 *kW / 2);
//    [self scrollTo:index];
}

- (void)scrollTo:(NSInteger)index {
    NSInteger centerIndex = self.allcount/2;
    NSInteger newIndex = index - self.currentIndex +centerIndex;
    if (newIndex >= self.allcount) { newIndex = index - self.allcount;}
    if (newIndex < 0) {
        newIndex = newIndex+self.allcount;
    }
   // NSLog(@"%ld,%ld,%ld",newIndex, index,self.currentIndex);
    [self.baseScrollView setContentOffset:CGPointMake(newIndex * (self.labelWidth+self.labelMin), 0)
                       animated:YES];
    if ([_delegate respondsToSelector:@selector(LTSliderViewTouchIndex:)]) {
        [_delegate LTSliderViewTouchIndex:index];
    }
}

- (void)setLableCount:(int)count
{
    self.allcount = count;
}

- (void)show {
     self.currentIndex = 0;
    if (self.SlideLabArr.count > 0) {
        for (UIView *subView in self.SlideLabArr) {
            [subView removeFromSuperview];
        }
        [self.SlideLabArr removeAllObjects];
    }
    if (!self.SlideLabArr) {
        self.SlideLabArr = [NSMutableArray array];
    }
    //设置baseScrollView的尺寸: 宽: label宽+间距
    self.baseScrollView.frame = CGRectMake(0,
                                           0,(self.labelWidth+self.labelMin),self.k_Height);
    self.baseScrollView.k_centerX = self.k_Width/2;
    if (self.allcount > 0) {
        for (int i = 0; i < self.allcount; i++) {
            UIView *subView = [[UIView alloc] initWithFrame:CGRectZero];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(didTap:)];
            [subView addGestureRecognizer:tap];
            subView.tag = i;
            subView.backgroundColor = [UIColor purpleColor];
            //imageV.contentMode = uivew;
            if (i == 0) {
                subView.frame = CGRectMake(0,0,(self.labelWidth+self.labelMin),self.k_Height);
            }else {
                UIView *lastView = self.SlideLabArr[i-1];
                subView.frame = CGRectMake (kViewMaxX(lastView),0,
                                           (self.labelWidth+self.labelMin),self.k_Height);
            }
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.minWidth,self.minWidth/self.labelWidth *self.labelHeight)];
            [subView addSubview:imageV];
            imageV.center = CGPointMake(self.baseScrollView.k_Width/2, self.k_Height/2);
            imageV.image = [UIImage imageNamed:self.showArr[i]];
            [self.baseScrollView addSubview:subView];
            [self.SlideLabArr addObject:subView];
        }
        UIView *lastView = self.SlideLabArr[self.SlideLabArr.count - 1];
        self.baseScrollView.contentSize = CGSizeMake(kViewMaxX(lastView), 0);
         NSInteger centerIndex = self.allcount/2;
        UIView *centerView = self.SlideLabArr[centerIndex];
       [self.baseScrollView setContentOffset:CGPointMake(kViewMaxX(centerView), 0) animated:YES];
        self.baseScrollView.pagingEnabled = YES;
        self.baseScrollView.clipsToBounds = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    int count = (offset)/(self.labelWidth+self.labelMin);
    UIView *subView = self.SlideLabArr[self.SlideLabArr.count - 1];
    if (offset <= kViewMaxX(subView) + 1) {
        if (self.lastCount != count) {
                   self.lastCount = count;
               }
        CGFloat countOffset = offset - count * (self.labelWidth+self.labelMin);
        CGFloat offsetRait  = 1;
        if (countOffset != 0) {
            offsetRait = 1-countOffset / (self.labelWidth+self.labelMin);
        }
        UIView *showView = nil;
        if (count >= 0 && count < self.SlideLabArr.count - 1) {
                showView = self.SlideLabArr[count];
            }
        if (showView) {
            CGFloat width = self.minWidth +(self.labelWidth - self.minWidth) * offsetRait;
            UIImageView *imageV = showView.subviews[0];
            imageV.k_size = CGSizeMake(width,width/self.labelWidth*self.labelHeight);
            imageV.center = CGPointMake(self.baseScrollView.k_Width/2, self.k_Height/2);
        }
        if (count < self.SlideLabArr.count-1) {
        UIView*nextImageV = self.SlideLabArr[count+1];
        if (nextImageV) {
            CGFloat width = self.minWidth + (self.labelWidth - self.minWidth) * (1 - offsetRait);
            UIImageView *imageV = nextImageV.subviews[0];
            imageV.k_size = CGSizeMake(width,width/self.labelWidth*self.labelHeight);
             imageV.center = CGPointMake(self.baseScrollView.k_Width/2, self.k_Height/2);
        }
    }
        if (count > 0) {
            UIView *lastView = self.SlideLabArr[count-1];
            CGFloat width = self.minWidth;
            UIImageView *imageV = lastView.subviews[0];
            imageV.k_size = CGSizeMake(width,width/self.labelWidth*self.labelHeight);
             imageV.center = CGPointMake(self.baseScrollView.k_Width/2, self.k_Height/2);
                }
        if (count<self.SlideLabArr.count-2) {
            UIView *next2View = self.SlideLabArr[count+2];
            CGFloat width = self.minWidth;
            UIImageView *imageV = next2View.subviews[0];
            imageV.k_size = CGSizeMake(width,width/self.labelWidth*self.labelHeight);
             imageV.center = CGPointMake(self.baseScrollView.k_Width/2, self.k_Height/2);
            }
        for (int i=0; i < self.SlideLabArr.count; i++) {
                if ((i != count) && (i != count + 1) && (i != count - 1) && (i != count + 2)) {
                    UIView *lab = self.SlideLabArr[i];
                    CGFloat width = self.minWidth;
                    UIImageView *imageV = lab.subviews[0];
                    imageV.k_size = CGSizeMake(width,width/self.labelWidth*self.labelHeight);
                    imageV.center = CGPointMake(self.baseScrollView.k_Width/2, self.k_Height/2);
                }
            }
        }
    // 找出最中间的那个图片控件
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.baseScrollView.subviews.count; i++) {
        UIView *subView = self.baseScrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(subView.frame.origin.x - scrollView.contentOffset.x);
        if (distance < minDistance) {
            minDistance = distance;
            page = subView.tag;
        }
    }
    self.currentIndex = page;
}



#pragma mark - 内容更新
- (void)updateContent
{
    //NSLog(@"updateContent------%ld",self.currentIndex);
    // 设置图片
    NSInteger centerIndex = self.allcount/2;
    for (int i = 0; i<self.baseScrollView.subviews.count; i++) {
        UIView *subView = self.baseScrollView.subviews[i];
        NSInteger index = self.currentIndex;
        
        if (i < centerIndex) {
            index = index - (centerIndex -i);
        }
        if(i> centerIndex) {
             index = index +(i-centerIndex);
        }
        if (index < 0) {
            index = self.allcount+index;
        } else if (index >= self.showArr.count) {
            index = index-self.showArr.count;
        }
        subView.tag = index;
        UIImageView *imageV = subView.subviews[0];
        
       imageV.image = [UIImage imageNamed:self.showArr[index]];
    }

    // 设置偏移量在中间
    self.baseScrollView.contentOffset = CGPointMake(self.baseScrollView.frame.size.width *centerIndex, 0);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   // [self setCenterContentOffset:scrollView];
    [self updateContent];
     if ([_delegate respondsToSelector:@selector(LTSliderViewTouchIndex:)]) {
         [_delegate LTSliderViewTouchIndex:self.currentIndex];
     }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}

//滑动的时候停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  //  [self stopTimer];
}

//停止滑动之后开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//   [self startTimer];
}


#pragma mark - 定时器处理
- (void)startTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)next {
    NSInteger nextIndex = self.allcount/2+1;
        [self.baseScrollView setContentOffset:CGPointMake(nextIndex * self.baseScrollView.frame.size.width, 0) animated:YES];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self])
    {
        for (UIView *subview in self.baseScrollView.subviews)
        {
            CGPoint offset = CGPointMake(point.x - self.baseScrollView.frame.origin.x +
                                         self.baseScrollView.contentOffset.x -
                                         subview.frame.origin.x,
                                         
                                         point.y - self.baseScrollView.frame.origin.y +
                                         self.baseScrollView.contentOffset.y -
                                         subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event]))
            {
                return view;
            }
        }
        return self.baseScrollView;
    }
    return view;
}



@end
