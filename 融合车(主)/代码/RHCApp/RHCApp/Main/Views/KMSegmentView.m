//
//  KMSegmentView.m
//  Scimall
//
//  Created by daishaoyang on 2017/7/3.
//  Copyright © 2017年 贾培军. All rights reserved.
//

#import "KMSegmentView.h"

@interface KMSegmentView ()
/** 当前选中的标题按钮 */
@property (nonatomic, weak) UIButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, weak) UIView *line;

@property (nonatomic ,assign) BOOL isNeedLiandong;

@end

@implementation KMSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    [self removeAllSubviews];
    
    // 添加标题
    NSUInteger count = titles.count;
    CGFloat titleButtonW = self.rcm_width / count;
    CGFloat titleButtonH = self.rcm_height;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.userInteractionEnabled = !self.isneedForbidClick;
        titleButton.tag = i;
        [titleButton setTitleColor:(self.unselectColor ? self.unselectColor : RGB(0x484578)) forState:UIControlStateNormal];
        [titleButton setTitleColor:RGB(0xFFC000) forState:UIControlStateSelected];
        titleButton.titleLabel.font = LPFFONT(self.segTitleFont ? self.segTitleFont : 18);
        
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
        
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
        //判断是否需要添加分隔线
        if (self.needSeparatorLine && i != count - 1) {
            UIView *sepapatorLine = [UIView new];
            sepapatorLine.backgroundColor = RGB(0x8E8CA7);
            sepapatorLine.frame = CGRectMake(titleButton.rcm_right, 0, 1, 15);
            sepapatorLine.rcm_centerY = titleButton.rcm_centerY;
            [self addSubview:sepapatorLine];
        }
    }
    
    // 按钮的选中颜色
    UIButton *firstTitleButton = self.subviews.firstObject;
    
    //底部黑色分隔线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.rcm_height - .5,self.rcm_width, .5 )];
    line.backgroundColor = RGB(0xFFC000);
    [self addSubview:line];
    line.hidden = YES;
    _line = line;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.rcm_height = self.blackLineHight ? self.blackLineHight : 2;
    indicatorView.rcm_y = self.blackLineToBottom ? self.rcm_height - self.blackLineToBottom:
    (self.rcm_height - indicatorView.rcm_height - 6.5);
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    self.indicatorView.hidden = self.needHideBottomLine;
    
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.rcm_width = self.blackLineWidth ? self.blackLineWidth : firstTitleButton.titleLabel.rcm_width;
    indicatorView.rcm_centerX = firstTitleButton.rcm_centerX;
    
    
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    firstTitleButton.titleLabel.font = BPFFONT(self.segTitleFont ? self.segTitleFont : 18);
    self.selectedTitleButton = firstTitleButton;
}


- (void)setNeedBlackLine:(BOOL)needBlackLine{
    _needBlackLine = needBlackLine;
    self.line.hidden = !needBlackLine;
}


#pragma mark - 监听点击
- (void)titleClick:(UIButton *)titleButton
{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        return;
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button == titleButton) {
                button.titleLabel.font = BPFFONT(self.segTitleFont ? self.segTitleFont : 18);
            }else{
                button.titleLabel.font = LPFFONT(self.segTitleFont ? self.segTitleFont : 18);
            }
        }
    }
    
    
    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.rcm_width = self.blackLineWidth ? self.blackLineWidth : titleButton.titleLabel.rcm_width;
        self.indicatorView.rcm_centerX = titleButton.rcm_centerX;
    }];
    
    // 让UIScrollView滚动到对应位置
    
    if (!self.isNeedLiandong) {
        if (self.didSelectedAtIndex) {
            self.didSelectedAtIndex(titleButton.tag);
        }
    }
  
}

- (void)changeSegmentedControlWithIndex:(NSInteger)index{
    UIButton *titleButton = self.subviews[index];
//    [self titleClick:titleButton];
    
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        return;
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button == titleButton) {
                button.titleLabel.font = BPFFONT(self.segTitleFont ? self.segTitleFont : 18);
            }else{
                button.titleLabel.font = LPFFONT(self.segTitleFont ? self.segTitleFont : 18);
            }
        }
    }    
    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.rcm_width = self.blackLineWidth ? self.blackLineWidth : titleButton.titleLabel.rcm_width;
        self.indicatorView.rcm_centerX = titleButton.rcm_centerX;
    }];
}


@end
