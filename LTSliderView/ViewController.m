//
//  ViewController.m
//  LTSliderView
//
//  Created by 凌甜 on 2020/7/14.
//  Copyright © 2020 com.ATT. All rights reserved.
//

#import "ViewController.h"
#import "LTSliderView.h"
#define kW  1
#define kH 1
@interface ViewController ()<LTSliderViewDelegate>
@property(nonatomic,strong) LTSliderView *slideView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.slideView = [[LTSliderView alloc]initWithFrame:CGRectMake(0,100,
                                                                    self.view.bounds.size.width,
                                                                    79.6)];
        self.slideView.delegate = self;
        [self.view addSubview:self.slideView];
        //   以下为自定义显示的方法  设置数量
    
        [self.slideView setLableCount:12];
      //  self.slideView.showArr = @[@"海上系_1",@"海上系_2",@"海上系_3",@"海上系_4",@"海上系_5",@"海上系_6",@"海上系_1",@"海上系_2",@"海上系_3",@"海上系_4",@"海上系_5",@"海上系_6",@"海上系_1",@"海上系_2",@"海上系_3",@"海上系_4",@"海上系_5",@"海上系_6"];
    self.slideView.showArr = @[@"海上系_1",@"海上系_2",@"海上系_3",@"海上系_4",@"海上系_5",@"海上系_6",@"海上系_1",@"海上系_2",@"海上系_3",@"海上系_4",@"海上系_5",@"海上系_6"];
        [self.slideView show];
}

- (void)LTSliderViewTouchIndex:(NSInteger)count {
    NSLog(@"%ld",count);
}


@end
