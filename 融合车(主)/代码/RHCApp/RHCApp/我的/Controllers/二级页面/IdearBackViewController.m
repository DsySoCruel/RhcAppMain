//
//  IdearBackViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import "IdearBackViewController.h"
#import "KemaoTextView.h"

@interface IdearBackViewController ()
<UITextViewDelegate>

@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) KemaoTextView *textView;
@property (nonatomic, assign) NSInteger maxNumber;//最大输入数量 默认为200
@property (nonatomic, strong) UILabel  *numberLabel;
@property (nonatomic, strong) UIButton *senderButton;

@end

@implementation IdearBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = SMViewBGColor;
    self.maxNumber = 200;
    
    
    self.textBgView = [UIView new];
    self.textBgView.backgroundColor = [UIColor whiteColor];
    self.textBgView.layer.cornerRadius = 5;
    [self.view addSubview:self.textBgView];
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.left.offset = 15;
        make.top.offset = 15 + 64 + SafeTopSpace;
        make.height.offset = 190;
    }];
    
    self.textView = [KemaoTextView new];
    self.textView.font = PFFONT(14);
    self.textView.textColor = SMTextColor;
    self.textView.placeholderColor = SMParatextColor;
    self.textView.delegate = self;
    self.textView.placeholder = @"哪点用的不舒服？告诉我们，精美礼品等期望我们进步的您!";
    [self.textBgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.right.offset = -5;
        make.top.offset = 0;
        make.bottom.offset = -30;
    }];
    
    
    self.numberLabel = [UILabel new];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    self.numberLabel.font = LPFFONT(14);
    [self.textBgView addSubview:self.numberLabel];
    NSInteger currentLenth = 0;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)currentLenth,(long)self.maxNumber];
    self.numberLabel.textColor = RGB(0x8E8CA7);
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = -10;
        make.bottom.offset = 0;
    }];
    
    self.senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.senderButton setTitle:@"提交赢大奖" forState:UIControlStateNormal];
    self.senderButton.layer.cornerRadius = 25;
    self.senderButton.backgroundColor = RGB(0xFA4708);
    [self.view addSubview:self.senderButton];
    [self.senderButton addTarget:self action:@selector(senderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.height.offset = 50;
        make.top.equalTo(self.textBgView.mas_bottom).offset = 50;
    }];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    //这个判断相当于是textfield中的点击return的代理方法
    //    if ([text isEqualToString:@"\n"]) {
    //        [textView resignFirstResponder];
    //        return NO;
    //    }
    
    if (text.length > self.maxNumber - textView.text.length) {
        //只保留能保留的
        textView.text = [NSString stringWithFormat:@"%@%@",textView.text,[text substringToIndex:self.maxNumber - textView.text.length]];
        [MBHUDHelper showWarningWithText:[NSString stringWithFormat:@"不能超过%ld个字哦",(long)self.maxNumber]];
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)self.maxNumber];
        return NO;
    }
    
    if (range.location < textView.text.length) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length - 1 + text.length, (long)self.maxNumber];
        
    }else{
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length + text.length, (long)self.maxNumber];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)senderButtonAction:(UIButton *)sender{
        
    [self.view endEditing:YES];
    if (!self.textView.text.length) {
        [MBHUDHelper showError:@"请写下您想说的话"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"content"] = self.textView.text;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_FeedbackAdd parameters:dic successed:^(id json) {
        if (json) {
            [MBHUDHelper showSuccess:@"意见反馈成功"];
            [Weakself.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {

    }];
}



@end
