//
//  OrganizationTagsView.m
//  Scimall
//
//  Created by daishaoyang on 2018/6/20.
//  Copyright © 2018年 贾培军. All rights reserved.
//

#import "OrganizationTagsView.h"
#import "YXDButton.h"
static NSInteger const FontSize = 14;
static CGFloat const Padding = 10;            //button内边距
static CGFloat const ButtonPadding = 7.5;     //button内边距
static CGFloat const ButtonX = 0;
static CGFloat const ButtonY = 10;
static CGFloat const ButtonH = 35;            //button的高度
static CGFloat const AddW = 15;//因为加图片而额外添加嗯宽度

@interface OrganizationTagsView()
@end

@implementation OrganizationTagsView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)config:(NSArray *)itemArray{
    [self removeAllSubviews];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:itemArray];
    [tempArray addObject:@"重置"];
    for (int i = 0; i < tempArray.count; i++) {
        YXDButton *button = [YXDButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:SMTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSize weight:UIFontWeightLight];
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.tag = 10000 + i;
        
        [button setTitle:tempArray[i] forState:UIControlStateNormal];
        [button setTitleColor:SMTextColor forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        if ((i+1) == tempArray.count) {
            button.backgroundColor = [UIColor clearColor];
            button.status = MoreStyleStatusNormal;
            button.padding = 5;
            [button setImage:IMAGECACHE(@"qichezuosuojieguo_02") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(deleteAllTags:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button.backgroundColor = [UIColor whiteColor];
            [button setImage:IMAGECACHE(@"qichezuosuojieguo_01") forState:UIControlStateNormal];
            button.status = MoreStyleStatusCenter;
            button.padding = 5;
            [button addTarget:self action:@selector(deleteSelectTags:) forControlEvents:UIControlEventTouchUpInside];
        }
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
        if ((Screen_W - buttonX) < (contentSize.width + AddW + 2*Padding + 2*ButtonPadding)||(contentSize.width + AddW + 2*Padding + 2*ButtonPadding) > Screen_W) {
            //如果是数组中的第一个对象的话Y值依然为0;
            if (j == 0) {
                buttonY = 10;
            }else{
                buttonY += ButtonH + Padding;
            }
            buttonX = 0;
        }
        
        if ((contentSize.width + AddW + 2*Padding + 2*ButtonPadding) > Screen_W) {
            
            
            button.frame = CGRectMake(Padding, buttonY, Screen_W - 2*Padding,ButtonH );
            //button.layer.cornerRadius = moreH*0.2;
//            buttonY += (ButtonH + Padding);
        }else{
            button.frame = CGRectMake(Padding + buttonX, buttonY, contentSize.width + 2*ButtonPadding + AddW, ButtonH);
            //button.layer.cornerRadius = buttonH*0.2;
            //对X重新赋值
            buttonX = CGRectGetMaxX(button.frame);
        }
    }
    
}


+ (CGFloat)cellHeightWithArray:(NSArray *)tempArray {
    
    NSMutableArray *itemArray = [NSMutableArray array];
    [itemArray addObjectsFromArray:tempArray];
    [itemArray addObject:@"重置"];
    //计算总高度
    CGFloat buttonX = ButtonX;//记录上一个button的最大X 初始值
    CGFloat buttonY = ButtonY;//记录上一个button的最大Y 初始值
    
    //设置frame
    for (int z = 0; z < itemArray.count; z++) {
        //由内容计算button宽度
        CGSize contentSize = [itemArray[z] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]}];
        //如果剩余的距离不够的话 从新设置Y
        if ((Screen_W - buttonX) < (contentSize.width + AddW + 2*Padding + 2*ButtonPadding)) {
            
            if ((contentSize.width + AddW + 2*Padding + 2*ButtonPadding) > Screen_W) {
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
                buttonX = (Padding + contentSize.width + AddW + 2*ButtonPadding);
            }
        }else{
            buttonX += (Padding + contentSize.width + AddW + 2*ButtonPadding);
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



- (void)deleteSelectTags:(UIButton *)sender{
    if (self.deleteTagsBlock) {
        self.deleteTagsBlock(sender.titleLabel.text);
    }
}

- (void)deleteAllTags:(UIButton *)sender{
    if (self.deleteAllBlock) {
        self.deleteAllBlock();
    }
}
@end
