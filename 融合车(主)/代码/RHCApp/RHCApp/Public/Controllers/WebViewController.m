//
//  WebViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/12.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (strong,nonatomic) UIWebView *mainWebView;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *html;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainWebView = [UIWebView new];
    [self.view addSubview:self.mainWebView];
    [self.mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset = 0;
    }];
    
    if (self.url.length) {
        NSURL *urld = [NSURL URLWithString:self.url];
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:urld]];
    }
    if (self.html.length) {
        [self.mainWebView loadHTMLString:self.html baseURL:nil];
    }
}

- (void)loadWebWithUrl:(NSString *)url{
    _url = url;
    NSURL *urld = [NSURL URLWithString:url];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:urld]];
}
- (void)loadWebWithHtml:(NSString *)html{
    _html = html;
    [self.mainWebView loadHTMLString:html baseURL:nil];
}


@end
