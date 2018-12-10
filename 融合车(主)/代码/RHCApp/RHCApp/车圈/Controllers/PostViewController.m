//
//  PostViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "PostViewController.h"
#import "KemaoTextView.h"

#import "TZImagePickerController.h"
//#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "SDPhotoBrowser.h"
#import "DSYPhotoModel.h"

@interface PostViewController ()<UITextViewDelegate,UIScrollViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,SDPhotoBrowserDelegate>{
        
    BOOL _isSelectOriginalPhoto;
    
}
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) KemaoTextView *textView;
//添加照片
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;//调用相机用到
@property (nonatomic, strong) UICollectionView *collectionView;//展示照片
@property (nonatomic, assign) NSInteger maxCountTF;//设置允许选择最多相片

@property (nonatomic, assign) CGFloat itemWH;
@property (nonatomic, assign) CGFloat margin;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}
- (void)setupUI{
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitle:@"取消" forState:UIControlStateNormal];
    self.backButton.titleLabel.font = LPFFONT(15);
    [self.backButton setTitleColor:SMThemeColor forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backButton];
    
    self.titleL = [UILabel new];
    self.titleL.text = @"发布心情";
    self.titleL.font = BFONT(15);
    self.titleL.textColor = SMTextColor;
    [self.topView addSubview:self.titleL];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确认" forState:UIControlStateNormal];
    self.sureButton.backgroundColor = SMThemeColor;
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 3;
    self.sureButton.titleLabel.font = LPFFONT(13);
    [self.sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.topView addSubview:self.sureButton];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.topView addSubview:self.line];
    
    //设置发布内容区
    self.textView = [KemaoTextView new];
    self.textView.delegate = self;
    self.textView.alwaysBounceVertical = YES; // 垂直方向永远可以滚动(弹簧效果)
    self.textView.placeholder = @"说说此时的心情吧";
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
    
    //设置允许选择最多相片
    self.maxCountTF = 3;
    //3.设置相片资源
    self.selectedPhotos = [NSMutableArray array];
    [self configCollectionViewHere];


    
}
- (void)setupLayout{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset = 0;
        make.height.offset = 64 + SafeTopSpace;
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.bottom.offset = -10;
        make.width.offset = 45;
        make.height.offset = 20;
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.bottom.offset = -10;
        make.width.offset = 45;
        make.height.offset = 20;
    }];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.centerY.equalTo(self.backButton);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 1;
    }];
    
    //
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.width.offset = YXDScreenW - 20;;
        make.top.offset = 64 + 20;
        make.height.offset = 150;
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset = 20;
        make.left.right.offset = 0;
        make.height.offset = self.itemWH + 5;
    }];
    
}

- (void)sureButtonAction:(UIButton *)sender{
    if (![YXDUserInfoStore sharedInstance].loginStatus) {
        //弹出登录框
        [self presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
        return;
    }
    //判断内容
    [MBHUDHelper showLoadingHUDView:self.view withText:@"上传中"];
    //上传图片
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"title"] = @"测试标题";
    parames[@"content"] = self.textView.text.length ? self.textView.text : @"";
    parames[@"type"] = @"1";
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.selectedPhotos.count; i++) {
        DSYPhotoModel *model = self.selectedPhotos[i];
        YXDFormData *formData = [YXDFormData new];
        formData.data = UIImageJPEGRepresentation(model.photo, 0.3);
        formData.name = @"file";
        formData.filename = [NSString stringWithFormat:@"name%tu.jpg",i];
        formData.mimeType = @"image/jpeg";
        [tempArray addObject:formData];
    }

    WeakObj(self);
    [[NetWorkManager shareManager] postFileWithUrl:USER_AddPost parameters:parames formDataArray:tempArray succssed:^(id json) {
        [MBHUDHelper hideHUDView];
        if (json) {
            [MBHUDHelper showSuccess:@"发布成功"];
            if (Weakself.updateOrderBlock) {
                Weakself.updateOrderBlock();
            }
            //通知上层数据进行更新
           [Weakself dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        [MBHUDHelper hideHUDView];
    } uploadProgressBlock:^(float uploadProgress) {
        
    }];

    
    
    
}

- (void)backButtonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 设置图片模块
/****************设置展示选择照片的集合视图**************/
- (void)configCollectionViewHere{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.mj_w - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    //    layout.footerReferenceSize = CGSizeMake(0, _itemWH + _margin*2);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"footerID"];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.selectedPhotos.count < 3) {
        return self.selectedPhotos.count + 1;
    }
    
    return self.selectedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    
    if ((indexPath.item + 1) > self.selectedPhotos.count) {
        
        cell.imageView.image = IMAGECACHE(@"addpicture");
        cell.deleteBtn.hidden = YES;
        
    }else{
        
        cell.deleteBtn.hidden = NO;
        cell.photoModel = self.selectedPhotos[indexPath.item];
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteImageBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    //    ZLPhotoAssets *asset = self.assets[indexPath.item];
    //    if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
    //        cell.imageView.image = asset.thumbImage;
    //    }else if ([asset isKindOfClass:[NSString class]]){
    //        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"pc_circle_placeholder"]];
    //    }else if([asset isKindOfClass:[UIImage class]]){
    //        cell.imageView.image = (UIImage *)asset;
    //    }else if ([asset isKindOfClass:[ZLCamera class]]){
    //        cell.imageView.image = [asset thumbImage];
    //    }
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.selectedPhotos.count) {
        //打开照相机或者相册
        
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
        
        
    }else{
        
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.item;
        photoBrowser.imageCount = self.selectedPhotos.count;
        photoBrowser.sourceImagesContainerView = collectionView;
        [photoBrowser show];
    }
    
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    
    DSYPhotoModel *photoModel = self.selectedPhotos[index];
    
    if (photoModel.url.length) {
        
        TZTestCell *cell = (TZTestCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        return cell.imageView.image;
    }else{
        return photoModel.photo;
    }
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    DSYPhotoModel *photoModel = self.selectedPhotos[index];
    
    if (photoModel.url.length) {
        return [NSURL URLWithString:photoModel.url];
    }else{
        return nil;
    }
}




#pragma mark  ---拍照

- (void)openCamera{
    
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (iOS8Later) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                } else {
                    // Fallback on earlier versions
                }
            } else {
                
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"] options:@{} completionHandler:^(BOOL success) {
                    }];
                } else {
                    // Fallback on earlier versions
                }if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        
    } else { // 调用相机
        //1.判断图片数量是否可以打开照相机
        
        
        if (self.selectedPhotos.count >= self.maxCountTF) {
            [self presentAlertViewWith:@"提示" message:@"您最多只能选择3张照片"];
            return;
        }
        //2.设置为相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
            
            
        }
    }
    
    
}

#pragma mark ---选择照片
- (void)openLocalPhoto{
    
    //1设置：最大选择数（self.maxCountTF） ：每行照片显示数量 默认 3
    
    
    if (self.selectedPhotos.count >= self.maxCountTF) {
        [self presentAlertViewWith:@"提示" message:@"您最多只能选择3张照片"];
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(self.maxCountTF - self.selectedPhotos.count) columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    //是否上传原图
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    
    //______________________设置拍照按钮不在内部显示————————————————————————
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // 3. 设置是否可以选择视频/图片/原图
    //______________________设置是否可以选择视频/图片/原图————————————————————————
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.minImagesCount = 0;
    imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    //    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    //
    //    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark 资源库采集的两个方法

//1.创建拍照界面控制器
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

//1.摄像机镜头拍摄照片或者视频后 点击使用后调用
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (iOS8Later) {
                        
                        
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                
                            }];
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"] options:@{} completionHandler:^(BOOL success) {
                                
                            }];
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        
                    } else {
                        
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                                
                            }];
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
                
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        
                        NSMutableArray *numArray = [NSMutableArray arrayWithObjects:@1,@2,@3,nil];
                        
                        
                        //判断当前 pic 1 2 3 那个可用?
                        for (DSYPhotoModel *model in self.selectedPhotos) {
                            if (model.num == 1) {
                                //1.不可用
                                [numArray removeObject:@1];
                            }
                            if (model.num == 2) {
                                //2.不可用
                                [numArray removeObject:@2];
                            }
                            if (model.num == 3) {
                                //3.不可用
                                [numArray removeObject:@3];
                            }
                        }
                        DSYPhotoModel *model = [[DSYPhotoModel alloc] init];
                        model.photo = image;
                        model.asset = assetModel.asset;
                        model.num = [numArray.firstObject integerValue];
                        [self.selectedPhotos addObject:model];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.collectionView reloadData];
                        });
                    }];
                }];
            }
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - TZImagePickerControllerDelegate
// 2.选择图片后点击完成调用
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    //目标很明确，只管添加
    
    NSMutableArray *numArray = [NSMutableArray arrayWithObjects:@1,@2,@3,nil];
    
    for (int i = 0; i < photos.count; i++) {
        
        for (DSYPhotoModel *model in self.selectedPhotos) {
            if (model.num == 1) {
                //1.不可用
                [numArray removeObject:@1];
            }
            if (model.num == 2) {
                //2.不可用
                [numArray removeObject:@2];
            }
            if (model.num == 3) {
                //3.不可用
                [numArray removeObject:@3];
            }
        }
        
        DSYPhotoModel *model = [[DSYPhotoModel alloc] init];
        model.photo = photos[i];
        model.asset = assets[i];
        model.num = [numArray.firstObject integerValue];
        [self.selectedPhotos addObject:model];
    }
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    
}

//图库取消按钮方法 拍照界面取消方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Click Event
//点击图片删除按钮
- (void)deleteImageBtnClik:(UIButton *)sender {
    [self presentAlertViewWith:sender];
}

//各种警告框
- (void)presentAlertViewWith:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//删除图片和视频验证
- (void)presentAlertViewWith:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    WeakObj(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (sender) {
            [Weakself.selectedPhotos removeObjectAtIndex:sender.tag];
            [Weakself.collectionView reloadData];
        }
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}









@end
