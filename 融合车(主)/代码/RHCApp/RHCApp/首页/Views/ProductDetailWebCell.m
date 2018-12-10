//
//  ProductDetailWebCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/12.
//

#import "ProductDetailWebCell.h"

@interface ProductDetailWebCell()
@property (nonatomic,strong) UIWebView   *mainWebView;
@end


@implementation ProductDetailWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    _mainWebView = [[UIWebView alloc] init ];
    _mainWebView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_mainWebView];
//    _mainWebView.delegate = self;
//    [(UIScrollView *)[[_mainWebView subviews] objectAtIndex:0] setScrollEnabled:NO];

}

- (void)setupLayout{
    [_mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset = 0;
    }];
}
- (void)loadHeml:(NSString *)url{
    [_mainWebView loadHTMLString:url baseURL:nil];
}
@end
