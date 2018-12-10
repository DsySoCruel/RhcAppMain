//
//  EditMessageViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/19.
//

#import "EditMessageViewController.h"
#import <AFNetworking.h>
#import "MineViewCell.h"
#import "EditHeadCell.h"
#import "ChangeNameController.h"
#import "YLAwesomeData.h"
#import "YLDataConfiguration.h"
#import "YLAwesomeSheetController.h"

static NSString *kMineViewCell = @"MineViewCell";
static NSString *kEditHeadCell = @"EditHeadCell";

@interface EditMessageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation EditMessageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.view.backgroundColor = SMViewBGColor;
    [self setupData];
    [self setupUI];
    [self setupLayout];
}

- (void)setupData{
    self.dataArray = @[@"图像",@"昵称",@"性别"];
}


#pragma mark UI
-(void)setupUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SMViewBGColor;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:kMineViewCell];
    [self.tableView registerClass:[EditHeadCell class] forCellReuseIdentifier:kEditHeadCell];
    [self.view addSubview:self.tableView];
}

-(void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset = 0;
        make.top.offset = 20;
    }];
}


#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        EditHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kEditHeadCell];
        [cell configWithTitle:self.dataArray[indexPath.row] andSubstitle:[YXDUserInfoStore sharedInstance].userModel.headimg];
        return cell;
    }else if (indexPath.row == 1){
        MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineViewCell forIndexPath:indexPath];
        [cell configWithTitle:self.dataArray[indexPath.row] andSubstitle:[YXDUserInfoStore sharedInstance].userModel.nickname];
        return  cell;
    }else{
        MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineViewCell forIndexPath:indexPath];
        [cell configWithTitle:self.dataArray[indexPath.row] andSubstitle: [[YXDUserInfoStore sharedInstance].userModel.sex integerValue] == 0 ? @"男" : @"女" ];
        return  cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 10;
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = SMViewBGColor;
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self iconChange];
    }
    if (indexPath.row == 1) {
        ChangeNameController *vc = [ChangeNameController new];
        [self.navigationController pushViewController:vc animated:YES];
        WeakObj(self);
        vc.block = ^{
            [Weakself.tableView reloadData];
        };
    }
    if (indexPath.row == 2) {
        YLDataConfiguration *config = [[YLDataConfiguration alloc] initWithType:YLDataConfigTypeGender selectedData:@[]];
        WeakObj(self)
        [[[YLAwesomeSheetController alloc] initWithTitle:nil
                                                  config:config
                                                callBack:^(NSArray *selectedData) {
                                                    
                                                    YLAwesomeData *data = [selectedData firstObject];
                                                    [Weakself saveWith:[NSString stringWithFormat:@"%ld",data.objId] ];
                                                }] showInController:self];

    }
}

- (void)saveWith:(NSString *)str{
    
    //1.发送网络请求
    //1.1发送成功后 修改本地保存的 数据
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"sex"] = str;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_UpdateUserInfo parameters:parames successed:^(id json) {
        if (json) {
            YXDUserInfoModel *account = [YXDUserInfoStore sharedInstance].userModel;
            account.sex = str;
            NSString *jsonstr = [account toJSONString];
            [[NSUserDefaults standardUserDefaults]setValue:jsonstr forKey:@"userInfoKey"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyUI" object:self];
            [Weakself.tableView reloadData];
        }
    } failure:^(NSError *error) {
    }];
}
//-(void)showOptionMenu{
//
//    if (IS_IOS8) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要清除缓存吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self clearCatch];
//        }];
//        [alert addAction:cancelAction];
//        [alert addAction:clearAction];
//        [self.navigationController presentViewController:alert animated:YES completion:nil];
//    }
//}

#pragma mark -更新图像信息

//修改图片操作
- (void)iconChange{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从本地相册上传图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openLocalPhoto];
    }]];
    // 由于它是一个控制器 直接modal出来就好了
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)openCamera{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //判断相机是否存在
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到摄像头" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//如果有相机，则设置图片选取器的类型为相机
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)openLocalPhoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//设置为图片库
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    YXDUserInfoModel *account = [YXDUserInfoStore sharedInstance].userModel;
    NSString *jsonstr = [account toJSONString];
    NSLog(@"-----------%@",jsonstr);
    
    UIImage *editedImage = info[@"UIImagePickerControllerOriginalImage"];
    [MBHUDHelper showLoadingHUDView:self.view withText:@"上传中"];
    //上传图片
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    YXDFormData *formData = [YXDFormData new];
    formData.data = UIImageJPEGRepresentation(editedImage, 0.3);
    formData.name = @"file";
    formData.filename = @"name.jpg";
    formData.mimeType = @"image/jpeg";
    WeakObj(self);
    [[NetWorkManager shareManager] postFileWithUrl:USER_UpdateHeadimg parameters:parames formDataArray:@[formData] succssed:^(id json) {
        [MBHUDHelper hideHUDView];
        if (json) {
            [MBHUDHelper showSuccess:@"图片修改成功"];
            //如果返回地址 修改本地存储的地址哦
            
            YXDUserInfoModel *account = [YXDUserInfoStore sharedInstance].userModel;
            account.headimg = json[@"headimg"];
            NSString *jsonstr = [account toJSONString];
            [[NSUserDefaults standardUserDefaults]setValue:jsonstr forKey:@"userInfoKey"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyUI" object:nil];
            [Weakself.tableView reloadData];
            //通知上层数据进行更新
        }

    } failure:^(NSError *error) {
        [MBHUDHelper hideHUDView];

    } uploadProgressBlock:^(float uploadProgress) {

    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
