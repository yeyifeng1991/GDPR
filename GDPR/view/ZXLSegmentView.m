//
//  ZXLSegmentView.m
//  GDPR
//
//  Created by zxl on 2017/12/26.
//  Copyright © 2017年 EM. All rights reserved.
//

#import "ZXLSegmentView.h"
#import "UIView+FRAME.h"
#import "COMMON.h"

#define kCanSliderLineWidth  (APPCONFIG_UI_SCREEN_FWIDTH - 15 *2)/self.segementTitleArray.count

@interface ZXLSegmentView()

@property (nonatomic, strong)NSArray *segementTitleArray;/**<按钮标题数组*/
@property (nonatomic, strong)NSMutableArray *segementButtonArray;/**<按钮数组 */
@property (nonatomic, strong)UIView *segementContainer;/**<按钮容器*/
@property (nonatomic, strong)UIView *canSliderLine; /**<底部可滑动的线*/
@property (nonatomic, strong)UIView *bottomLine; /**<底部分割线*/

@end

@implementation ZXLSegmentView

- (instancetype)initWithSegmentWithTitleArray:(NSArray *)segementTitleArray{
    self = [super init];
    if (self) {
        self.segementTitleArray = segementTitleArray;
        self.backgroundColor = [UIColor whiteColor];
        [self createSegments];
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    [self addSubview:self.segementContainer];
    //添加segement到view
    for (UIButton *button in self.segementButtonArray) {
        [self.segementContainer addSubview:button];
    }
    
    [self addSubview:self.bottomLine];
    [self addSubview:self.canSliderLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.segementContainer.top = 0;
    self.segementContainer.left = 15;
    self.segementContainer.width = self.width - 15*2;
    self.segementContainer.height = self.height;
    
    self.bottomLine.frame = CGRectMake(0, self.height-APPCONFIG_UNIT_LINE_WIDTH, self.width, APPCONFIG_UNIT_LINE_WIDTH);
    //每个子segment的宽度
    CGFloat segmentWith = (self.width-15*2) / self.segementTitleArray.count;
    for (int i=0; i<self.segementButtonArray.count; i++) {
        UIButton *button = (UIButton *)self.segementButtonArray[i];
        button.top = 0;
        button.left = i * segmentWith;
        button.width = segmentWith;
        button.height = 40;
    }
    //设置底部红色滑动线条的位置
    self.canSliderLine.bottom = self.bottomLine.top;
    self.canSliderLine.left = self.segementContainer.left;
    self.canSliderLine.width = segmentWith;
    self.canSliderLine.height = 2.0f;
}

- (void)createSegments
{
    self.segementButtonArray = [NSMutableArray array];
    for (int i=0; i<self.segementTitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button setTitle:self.segementTitleArray[i] forState:UIControlStateNormal];
        [button setTitle:self.segementTitleArray[i] forState:UIControlStateSelected];
        [button setTitleColor:RGB_HEX(0x666666) forState:UIControlStateNormal];
        [button setTitleColor:RGB_HEX(0xff4400) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (i==0) {
            button.selected = YES;
        }else
        {
            button.selected = NO;
        }
        button.tag = i;
        
        [button addTarget:self action:@selector(clickSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.segementButtonArray addObject:button];
    }
}
#pragma mark - 按钮的点击事件
- (void)clickSegmentButton:(UIButton *)segmentButton
{
    //按钮点击后
    [self selectSegmentButton:segmentButton];
    //回调给控制器
    if (self.clickSegmentButton) {
        self.clickSegmentButton(segmentButton.tag);
    }
}

- (void)selectSegmentButton:(UIButton *)segmentButton
{
    segmentButton.selected = YES;
    [self changeSelectedWithSelectedButton:segmentButton];
}

- (void)changeSelectedWithSelectedButton:(UIButton *)selectedButton
{
    for (UIButton *button in self.segementButtonArray) {
        if (![button isEqual:selectedButton]) {
            button.selected = NO;
        }
    }
    //设置可滑动线条的位置
    [self setCanSliderLinePosition];
}
#pragma mark - 设置可滑动的线条
- (void)setCanSliderLinePosition
{
    UIButton *button = [self selectedButton];
    [UIView animateWithDuration:0.3f animations:^{
        self.canSliderLine.left = 15+button.tag * kCanSliderLineWidth;
    }];
}

- (UIButton *)selectedButton
{
    NSInteger selectedIndex = [self selectedIndex];
    if (selectedIndex == -1 || self.segementButtonArray.count <= selectedIndex) {
        return nil;
    }
    return self.segementButtonArray[selectedIndex];
}

- (void)movieToCurrentSelectedSegment:(NSInteger)index
{
    UIButton *button = self.segementButtonArray[index];
    [self selectSegmentButton:button];
}

- (NSInteger)selectedIndex
{
    for(int i = 0; i < self.segementButtonArray.count; i++) {
        UIButton *button = (UIButton *)self.segementButtonArray[i];
        
        if (button.selected) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 懒加载
- (UIView *)segementContainer
{
    if (!_segementContainer) {
        _segementContainer = [[UIView alloc] init];
        _segementContainer.backgroundColor = [UIColor whiteColor];
    }
    return _segementContainer;
}

-(UIView *)canSliderLine
{
    if (!_canSliderLine) {
        _canSliderLine = [[UIView alloc] init];
//        _canSliderLine.backgroundColor = RGB_HEX(0xff4400);
        _canSliderLine.backgroundColor = [UIColor redColor];
    }
    return _canSliderLine;
}

-(UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
//        _bottomLine.backgroundColor = RGB_HEX(0xeeeeee);
        _bottomLine.backgroundColor = [UIColor yellowColor];
    }
    return _bottomLine;
}


@end
