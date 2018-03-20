//
//  ZXLMainContainController.m
//  GDPR
//
//  Created by zxl on 2017/12/26.
//  Copyright © 2017年 EM. All rights reserved.
//

#import "ZXLMainContainController.h"
#import "Masonry.h"
#import "COMMON.h"
#import "ZXLSegmentView.h"
#import "ZXLMainControllerHelper.h"
#import "ZXLMainController.h"

@interface ZXLMainContainController ()<UIScrollViewDelegate>

@property (nonatomic, strong)ZXLSegmentView *segment;

@property (nonatomic, strong)ZXLMainControllerHelper *helper;

@property (nonatomic, strong)UIScrollView *ctrlContanier;/**<控制器容器*/

@end

@implementation ZXLMainContainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViews];//创建页面
    [self makeConstaints];// 约束
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //只有这个方法中拿到了ctrlContanier的frame后才能去设置当前的控制器
    [self scrollViewDidEndScrollingAnimation:self.ctrlContanier];
}

-(void)setUpViews
{
    self.navigationItem.title = @"资讯";
    [self.view addSubview:self.segment];
    [self.view addSubview:self.ctrlContanier];
    [self createChildCtrls];
}
#pragma mark - 添加子视图控制器
- (void)createChildCtrls
{
    //添加子控制器
    for (int i=0; i<self.helper.segmentTitleArray.count; i++) {
        ZXLMainController *childCtrl = [[ZXLMainController alloc] initWithChildViewType:i];
        [self addChildViewController:childCtrl];
    }
}

-(void)makeConstaints
{
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(ZXLNavigationBarAdapterContentInsetTop);
        make.size.mas_equalTo(CGSizeMake(APPCONFIG_UI_SCREEN_FWIDTH, 40));
    }];
    [self.ctrlContanier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.segment.mas_bottom);
    }];
    self.ctrlContanier.contentSize = CGSizeMake(self.childViewControllers.count*APPCONFIG_UI_SCREEN_FWIDTH, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    //设置optionalNewsSegment滚动到控制器对应的位置
    [self.segment movieToCurrentSelectedSegment:index];
    //容错处理
    if (index<0) return;
    // 取出需要显示的控制器
    ZXLMainController *willShowVC = self.childViewControllers[index];
    // 如果当前位置已经显示过了，就直接返回
    if ([willShowVC isViewLoaded]) return;
    // 添加控制器的view到scrollView中;
    willShowVC.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVC.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


#pragma mark - 懒加载顶部的滑动按钮
- (ZXLSegmentView *)segment
{
    if (!_segment) {
        _segment = [[ZXLSegmentView alloc] initWithSegmentWithTitleArray:self.helper.segmentTitleArray];
        __weak typeof(self)weakSelf = self;
        _segment.clickSegmentButton = ^(NSInteger index) {
            //点击segment回调
            // 让底部的内容scrollView滚动到对应位置
            CGPoint offset = weakSelf.ctrlContanier.contentOffset;
            offset.x = index * weakSelf.ctrlContanier.frame.size.width;//移动距离
            [weakSelf.ctrlContanier setContentOffset:offset animated:YES];
        };
    }
    return _segment;
}

- (ZXLMainControllerHelper *)helper
{
    if (!_helper) {
        _helper = [[ZXLMainControllerHelper alloc] init];
    }
    return _helper;
}

#pragma mark - 添加scrollview
-(UIScrollView *)ctrlContanier
{
    if (!_ctrlContanier) {
        _ctrlContanier = [[UIScrollView alloc] init];
        _ctrlContanier.scrollsToTop = NO;
        _ctrlContanier.showsVerticalScrollIndicator = NO;
        _ctrlContanier.showsHorizontalScrollIndicator = NO;
        _ctrlContanier.pagingEnabled = YES;
        _ctrlContanier.delegate = self;
    }
    return _ctrlContanier;
}


@end
