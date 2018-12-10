//
//  PGYPopMenu.m
//  Pugongying
//
//  Created by app on 16/3/15.
//  Copyright © 2016年 新乡市蒲公英网络技术有限公司. All rights reserved.
//

#import "PGYPopMenu.h"
#define  LeftView 10.0f
#define  TopToView 10.0f


@interface PGYPopMenu()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy) NSArray *selectData;
@property (nonatomic,copy) void(^action)(NSInteger index);
@property (nonatomic,copy) NSArray * imagesData;

@end
PGYPopMenu * backgroundView;
UITableView * tableView;


@implementation PGYPopMenu


- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PGYPopMenu hiden];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    
    backgroundView = [[PGYPopMenu alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.imagesData = images ;
    backgroundView.selectData = selectData;
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.1];
    [win addSubview:backgroundView];
    
    // TAB
    tableView = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60 , 65 -  20.0 * selectData.count , frame.size.width , 40 * selectData.count) style:0];
    tableView.dataSource = backgroundView;
    //    tableView.transform =  CGAffineTransformMakeScale(0.5, 0.5);
    tableView.delegate = backgroundView;
//    tableView.layer.cornerRadius = 10.0f;
    tableView.scrollEnabled = NO;
    // 定点
    tableView.layer.anchorPoint = CGPointMake(1.0, 0);
    tableView.transform =CGAffineTransformMakeScale(0.0001, 0.0001);
    
    tableView.rowHeight = 40;
    
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    //    tableView.layer.anchorPoint = CGPointMake(100, 64);
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        //        tableView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 70, frame.size.width, 40 * selectData.count);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.5;
            tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }];
    }
}
+ (void)tapBackgroundClick
{
    [PGYPopMenu hiden];
}
+ (void)hiden
{
    if (backgroundView != nil) {
        
        [UIView animateWithDuration:0.3 animations:^{
            //            UIWindow * win = [[[UIApplication sharedApplication] windows] firstObject];
            //            tableView.frame = CGRectMake(win.bounds.size.width - 35 , 64, 0, 0);
            tableView.transform = CGAffineTransformMakeScale(0.000001, 0.0001);
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [tableView removeFromSuperview];
            tableView = nil;
            backgroundView = nil;
        }];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"PellTableViewSelectIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.imageView.image = [UIImage imageNamed:self.imagesData[indexPath.row]];
    cell.textLabel.text = _selectData[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.action) {
        self.action(indexPath.row);
    }
    [PGYPopMenu hiden];
}

//#pragma mark 绘制三角形
//- (void)drawRect:(CGRect)rect
//
//{
//    
//    
//    //    [colors[serie] setFill];
//    // 设置背景色
//    [[UIColor whiteColor] set];
//    //拿到当前视图准备好的画板
//    
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    
//    //利用path进行绘制三角形
//    
//    CGContextBeginPath(context);//标记
//    CGFloat location = [UIScreen mainScreen].bounds.size.width;
//    CGContextMoveToPoint(context,
//                         location -  LeftView - 10, 70);//设置起点
//    
//    CGContextAddLineToPoint(context,
//                            location - 2*LeftView - 10 ,  60);
//    
//    CGContextAddLineToPoint(context,
//                            location - TopToView * 3 - 10, 70);
//    
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    
//    [[UIColor whiteColor] setFill];  //设置填充色
//    
//    [[UIColor whiteColor] setStroke]; //设置边框颜色
//    
//    CGContextDrawPath(context,
//                      kCGPathFillStroke);//绘制路径path
//    
//    //    [self setNeedsDisplay];
//    
//    
//
//}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

@end
