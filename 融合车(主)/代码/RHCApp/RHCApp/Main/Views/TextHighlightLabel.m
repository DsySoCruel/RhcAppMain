//
//  TextHighlightLabel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "TextHighlightLabel.h"

@interface TextHighlightLabel()

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,assign) BOOL isYidui;
@property (nonatomic,assign) NSInteger startNum;
@property (nonatomic,assign) NSInteger endNum;

@end

@implementation TextHighlightLabel

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)setAttributedTextAuto:(NSString *)text withHighFont:(UIFont *)font{
    self.isYidui = NO;
    [self.array removeAllObjects];
    text = [text stringByReplacingOccurrencesOfString:@"复\""withString:@"复\" @"];
    [self searchRange:[NSMutableString stringWithFormat:@"%@",text]];
    text = [text stringByReplacingOccurrencesOfString:@"\""withString:@""];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:text];
    for (NSValue *value in self.array) {
        NSRange keyRange = [value rangeValue];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:keyRange];
        [attributeString addAttribute:NSFontAttributeName value:font range:keyRange];
    }
    self.attributedText = attributeString;
}

//**************
-(void)searchRange:(NSMutableString *)sourceString
{
    NSRange tmpRange = [sourceString rangeOfString:@"\""];//获取当前搜索到的第一个
    if(tmpRange.location!=NSNotFound)//有值的话需要继续搜索
    {
        self.isYidui = !self.isYidui;
        
        if (self.isYidui) {//开始
            self.startNum = tmpRange.location;//获取开始的标记位置
            //干掉开始标记
            [sourceString deleteCharactersInRange:tmpRange];
            
            [self searchRange:sourceString];
            
        }else{//结束
            self.endNum = tmpRange.location;//获取结束标记位置
            //干掉结束标记
            [sourceString deleteCharactersInRange:tmpRange];
            
            //生成改变range
            NSValue *value = [NSValue valueWithRange:NSMakeRange(self.startNum, self.endNum - self.startNum)];
            [self.array addObject:value];
            
            [self searchRange:sourceString];
        }
        
        //        NSValue *value = [NSValue valueWithRange:NSMakeRange(tmpRange.location + startIndex, tmpRange.length)];
        //        [storeArray addObject:value];
        //        sourceString = [sourceString substringFromIndex:tmpRange.location+tmpRange.length];//截取字符串（保留后边的）
        //        startIndex = tmpRange.location + tmpRange.length + startIndex;
        //        [self searchRange:sourceString withStoreArray:storeArray andStartIndex:startIndex];
    }
}


@end
