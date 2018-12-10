//
//  ChangeNameController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/20.
//

#import "ChangeNameController.h"

@interface ChangeNameController ()
@property(nonatomic,weak)UITextField *nameTextFild;

@end

@implementation ChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    self.view.backgroundColor = SMViewBGColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    UITextField *nameTextFild = [UITextField new];
    nameTextFild.placeholder = @"请输入修改的昵称";
    nameTextFild.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTextFild];
    _nameTextFild = nameTextFild;
    
    [self.nameTextFild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 64 + 40;
        make.left.offset = 20;
        make.right.offset = -20;
        make.height.offset = 40;
    }];
        
    [UIView animateWithDuration:0.25 animations:^{
        [nameTextFild becomeFirstResponder];
    }];
    
}

- (void)cancle{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)save{
    
    //1.发送网络请求
    //1.1发送成功后 修改本地保存的 数据
    
    
    if (self.nameTextFild.text.length > 0 && self.nameTextFild.text.length < 12) {
    
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
        parames[@"name"] = self.nameTextFild.text;
        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_UpdateUserInfo parameters:parames successed:^(id json) {
            if (json) {
                YXDUserInfoModel *account = [YXDUserInfoStore sharedInstance].userModel;
                account.nickname = Weakself.nameTextFild.text;
                NSString *jsonstr = [account toJSONString];
                [[NSUserDefaults standardUserDefaults]setValue:jsonstr forKey:@"userInfoKey"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyUI" object:self];
                if (Weakself.block) {
                    Weakself.block();
                }
                [Weakself.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
        }];
    }else{
        [MBHUDHelper showError:@"昵称格式不对"];
    }
}
@end
