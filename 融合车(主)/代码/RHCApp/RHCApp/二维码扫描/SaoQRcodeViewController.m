//
//  SaoQRcodeViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/23.
//

#import "SaoQRcodeViewController.h"
#import "SGQRCode.h"
//#import "EditPersionalInfoViewController.h"
//#import "ScannerRequest.h"
//#import "ReleaseManager.h"
//#import "DataCompleteRequest.h"
//#import "SaoSecondViewController.h"

@interface SaoQRcodeViewController ()<SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;

@property (nonatomic, strong) UILabel *labelOne;
//@property (nonatomic, strong) ScannerRequest *request;

@end

@implementation SaoQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    [self setupUI];
}

- (void)setupUI{
    
    UIImage *normalImage = [UIImage imageNamed:@"backIcon"];
    UIImage *highlightImage = [UIImage imageNamed:@"backIcon"];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, normalImage.size.width+30, normalImage.size.height+20)];
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton setImage:highlightImage forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.labelOne = [UILabel new];
    self.labelOne.textColor = [UIColor whiteColor];
    self.labelOne.textAlignment = NSTextAlignmentCenter;
    self.labelOne.numberOfLines = 2;
    self.labelOne.font = LPFFONT(17);
    self.labelOne.text = @"将二维码放入框内\n即可自动扫描";
    [self saoButtonAction];
}

- (void)backButtonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLine";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleDefault;
        _scanningView.cornerLocation = CornerLoactionInside;
        _scanningView.cornerColor = SMThemeColor;
        _scanningView.cornerWidth = 4;
        _scanningView.backgroundAlpha = 0.5;
    }
    return _scanningView;
}

//打开扫码摄像头进行扫码
- (void)saoButtonAction{
    //判断摄像头
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2、创建摄像设备输入流
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (deviceInput == nil) {
        [MBHUDHelper showError:@"请前往设置允许使用摄像头"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    [self.scanningView addTimer];
    [self.manager startRunning];
    [self.view addSubview:self.scanningView];
    [self setupQRCodeScanning];
    [self updataUI];
    
    //判断身份认证情况
    //    [[ReleaseManager sharedReleaseManager] dataCompletedType:ReleaseTypeArticle completeBlock:^(BOOL isCompleted, BOOL isSend) {
    //        if (!isCompleted) {
    //            KMAlertView *alerController = [[KMAlertView alloc] initWithTitle:@"请完善您的职业信息" message:@"在您进行企业工作者认证时，需要完善您的职业信息，请在”编辑个人信息“中添加”就职单位和职位“。" cancelButtonTitle:@"取消" otherButtonTitle:@"去完善"];
    //            [alerController show];
    //            alerController.cancelBlock = ^{};
    //            alerController.otherBlock = ^{
    //                //"去完善" -> "个人资料编辑"页
    //                EditPersionalInfoViewController *vc = [EditPersionalInfoViewController new];
    //                [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
    //            };
    //            return;
    //        } else {
    //
    //        }
    //    }];
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
    } else {
    }
}
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *url = [obj stringValue];
        if ([url isHttpLink]) {
            //发布文章或会议
//            NSMutableDictionary *dic =[url getURLParameters];
//            BLOCK_EXEC(self.releaseContentBlock,dic[@"QRToken"]);
//            [self dismissViewControllerAnimated:NO completion:nil];
            if (self.releaseContentBlock) {
                self.releaseContentBlock(url);
            }
            [self dismissViewControllerAnimated:NO completion:nil];

        } else if([url containsString:@"BEGIN:VCARD"]) {
            //扫码二维码名片
//            BLOCK_EXEC(self.getCardMessageBlock,url);
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [MBHUDHelper showError:@"无法识别信息"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:nil];
            });
        }
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}
- (void)dealloc {
    [self removeScanningView];
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}
//界面更新布局(开始扫码）
- (void)updataUI{
    [self.view addSubview:self.labelOne];
    [self.labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(100);
        make.centerX.offset = 0;
    }];
}
//界面恢复布局（结束扫码）
- (void)endUpdataUI{
    //    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.view).offset(-20);
    //    }];
    //    self.imageView.hidden = NO;
    //    self.saoButton.hidden = NO;
    //    self.labelOne.textColor = SMTextColor;
    //    self.labelThree.textColor = SMTextColor;
}


//打开扫码摄像头进行扫码
- (void)saoButtonAction:(NSString *)url{
    
    //    NSMutableDictionary *dic =[self getURLParameters:url];
    //    NSLog(@"%@",dic);
    //    SaoSecondViewController *vc = [SaoSecondViewController new];
    //    vc.lgToken = dic[@"QRToken"];
    //    BLOCK_EXEC(self.releaseContentBlock,dic[@"QRToken"]);
    //    [self dismissViewControllerAnimated:NO completion:nil];
    
    
    //    [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
    //    [self.navigationController pushViewController:vc animated:YES];
    //获取数据进行返回
    //    [self.request stopRequest];
    //    self.request = [ScannerRequest new];
    //    self.request.lgToken =
    //    if (self.postType == PostContentForArticle) {
    //        self.request.type = @"1";
    //    }
    //    if (self.postType == PostContentForMeeting) {
    //        self.request.type = @"2";
    //    }
    //    [self startLoading];
    //    WEAK_SELF
    //    [self.request startRequestWithRetClass:[HTTPBaseRequestItem class] andCompleteBlock:^(id  _Nullable retItem, NSError * _Nullable error, BOOL isMock) {
    //        STRONG_SELF
    //        [self stopLoading];
    //        [self.scanningView removeTimer];
    //        [self.scanningView removeFromSuperview];
    //        self.scanningView = nil;
    //        [self endUpdataUI];
    //        if(error){
    //            [self showToast:error.localizedDescription];
    //            return;
    //        }
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }];
}

@end
