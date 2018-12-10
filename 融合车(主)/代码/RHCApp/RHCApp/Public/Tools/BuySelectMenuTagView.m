//
//  BuySelectMenuTagView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/24.
//

#import "BuySelectMenuTagView.h"
static NSInteger const FontSize = 14;
static CGFloat const Padding = 10;            //button内边距
static CGFloat const ButtonPadding = 7.5;     //button内边距
static CGFloat const ButtonX = 0;
static CGFloat const ButtonY = 10;
static CGFloat const ButtonH = 35;            //button的高度

@interface BuySelectMenuTagView()
@end
@implementation BuySelectMenuTagView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)config:(NSArray *)itemArray{
    [self removeAllSubviews];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:itemArray.count];
    [tempArray addObjectsFromArray:itemArray];
    for (int i = 0; i < tempArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:SMTextColor forState:UIControlStateNormal];
        button.backgroundColor = SMViewBGColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSize weight:UIFontWeightLight];
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.layer.cornerRadius = 2;
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:tempArray[i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
    CGFloat buttonX = ButtonX;//记录上一个button的最大X 初始值
    CGFloat buttonY = ButtonY;//记录上一个button的最大Y 初始值
    
    //设置frame
    for (int j = 0; j < tempArray.count; j++) {
        //获取button
        UIButton *button = (UIButton *)[self viewWithTag:10000 + j];
        
        //由内容计算button宽度
        CGSize contentSize = [self contentSizeForPromiseWith:tempArray[j]];
        
        //如果剩余的距离不够的话 从新设置Y
        if ((Screen_W - buttonX) < (contentSize.width + 2*Padding + 2*ButtonPadding)||(contentSize.width + 2*Padding + 2*ButtonPadding) > Screen_W) {
            //如果是数组中的第一个对象的话Y值依然为0;
            if (j == 0) {
                buttonY = 10;
            }else{
                buttonY += ButtonH + Padding;
            }
            buttonX = 0;
        }
        
        if ((contentSize.width + 2*Padding + 2*ButtonPadding) > Screen_W) {
            
            
            button.frame = CGRectMake(Padding, buttonY, Screen_W - 2*Padding,ButtonH );
            //button.layer.cornerRadius = moreH*0.2;
            //            buttonY += (ButtonH + Padding);
        }else{
            button.frame = CGRectMake(Padding + buttonX, buttonY, contentSize.width + 2*ButtonPadding, ButtonH);
            //button.layer.cornerRadius = buttonH*0.2;
            //对X重新赋值
            buttonX = CGRectGetMaxX(button.frame);
        }
    }
    
}

- (void)buttonAction:(UIButton *)sender{
    //1.保存当前按钮应该的状态
    BOOL senderSelect = !sender.selected;
    //2.重置所有按钮
    NSArray *buttonArray = self.subviews;
    for (id obj in buttonArray) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            button.selected = NO;
            button.backgroundColor = SMViewBGColor;
        }
    }
    //3.赋值当前的状态给真实值
    sender.selected = senderSelect;
    //4.把选择的值传出
    if (senderSelect) {
        sender.backgroundColor = [UIColor redColor];
        if (self.selectBlock) {
            self.selectBlock(sender.titleLabel.text);
        }
    }else{
        sender.backgroundColor = SMViewBGColor;
        if (self.selectBlock) {
            self.selectBlock(@"");
        }
    }
}


+ (CGFloat)cellHeightWithArray:(NSArray *)tempArray {
    //计算总高度
    CGFloat buttonX = ButtonX;//记录上一个button的最大X 初始值
    CGFloat buttonY = ButtonY;//记录上一个button的最大Y 初始值
    
    //设置frame
    for (int z = 0; z < tempArray.count; z++) {
        //由内容计算button宽度
        CGSize contentSize = [tempArray[z] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]}];
        //如果剩余的距离不够的话 从新设置Y
        if ((Screen_W - buttonX) < (contentSize.width + 2*Padding + 2*ButtonPadding)) {
            
            if ((contentSize.width + 2*Padding + 2*ButtonPadding) > Screen_W) {
                if (z == 0) {
                    buttonY = 10;
                }else{
                    buttonY += ButtonH + Padding;
                }
                buttonX = 0;
            }else{
                //如果是数组中的第一个对象的话Y值依然为0;
                if (z == 0) {
                    buttonY = 10;
                }else{
                    buttonY += ButtonH + Padding;
                }
                buttonX = (Padding + contentSize.width + 2*ButtonPadding);
            }
        }else{
            buttonX += (Padding + contentSize.width + 2*ButtonPadding);
        }
    }
    return buttonY + ButtonH + Padding;
}

//单行计算宽度(传入字符串)
- (CGSize)contentSizeForPromiseWith:(NSString *)string{
    return [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]}];
}
//自适应高度
- (CGFloat)contentHeightWith:(NSString *)str width:(CGFloat)width{
    CGFloat height = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FontSize]} context:nil].size.height;
    return height;
}


@end
