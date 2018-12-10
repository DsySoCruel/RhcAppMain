//
//  GuidePageView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/10.
//

#import "GuidePageView.h"

#define GuidePagePrefixName @"guidepage_"

@interface GuidePageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *doneButton;
//@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation GuidePageView

-(id)init{
    self = [super init];
    [self setupUI];
    [self setupLayout];
    return self;
}

-(void)setupUI{
    
    self.scrollView = [UIScrollView new];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setTitle:@"开启体验" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:RGB(0xffffff) forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = SFONT(17);
    self.doneButton.layer.cornerRadius = 20;
    self.doneButton.layer.borderWidth = 0.0;
    self.doneButton.layer.borderColor = RGB(0xffffff).CGColor;
    self.doneButton.backgroundColor = SMThemeColor;
    [self.doneButton addTarget:self action:@selector(domeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
//    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.skipButton setImage:IMAGECACHE(@"skipGuidPage") forState:UIControlStateNormal];
    
    [self addSubview:self.scrollView];
//    [self addSubview:self.skipButton];
    
//    WEAK_SELF
//    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//
//    }];
//    [[self.skipButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        STRONG_SELF
//        BLOCK_EXEC(self.doneBlock);
//        [[NSNotificationCenter defaultCenter] postNotificationName:FirstLoginSucceedNotification object:nil];
//        [self removeFromSuperview];
//    }];
}

- (void)domeButtonAction{
    if (self.doneBlock) {
        self.doneBlock();
    }
    [self removeFromSuperview];
}

-(void)setupLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

-(void)setPageNumbers:(NSInteger)pageNumbers{
    _pageNumbers = pageNumbers;
    [self.scrollView removeAllSubviews];
    
    for (int i=0; i<_pageNumbers; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%@%d",GuidePagePrefixName,i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        [self.scrollView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.scrollView.mas_height);
            make.left.offset(Screen_W*i);
            if (i == self.pageNumbers-1) {
                make.right.mas_equalTo(self.scrollView.mas_right);
                
            }
        }];
        if (i == pageNumbers-1) {
            imgView.userInteractionEnabled = YES;
            [imgView addSubview:self.doneButton];
            [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(125);
                make.height.offset(40);
                make.bottom.offset(SM_iPhoneX?-94:-Screen_H/750.0*60.0);
                make.centerX.mas_equalTo(imgView.mas_centerX);
            }];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CGFloat offSetX = scrollView.contentOffset.x;
//    NSInteger index = offSetX / Screen_W;
}
@end
