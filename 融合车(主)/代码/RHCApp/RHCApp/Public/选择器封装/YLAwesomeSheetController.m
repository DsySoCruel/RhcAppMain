 //
//  YLResumeActionSheetController.m
//  YLLanJiQuan
//
//  Created by TK-001289 on 2017/6/15.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "YLAwesomeSheetController.h"
#import "YLAwesomeData.h"

#import "ProductSchemeListModel.h"


static CGFloat maxHeight = 260;
static CGFloat headerHeight = 50;
static CGFloat cellHeight = 37;

@interface YLAwesomeSheetController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,copy)NSArray *currentMonths;///< 当前年份可选的最大月份
@property(nonatomic,copy)NSArray *monthArray;///< 1~12月
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *ensureBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIPickerView *picker;

@property(nonatomic,assign)NSInteger selectRow;
@property(nonatomic,assign)NSInteger componentCount;///< the total component count
@property(nonatomic,strong)NSMutableArray *tmpSelectedData;///< contains the temp selectd data in each component
@end

@implementation YLAwesomeSheetController
- (instancetype)initWithTitle:(NSString *)title config:(id<YLAwesomeDataDelegate>)config callBack:(YLAwesomeSheetSelectCallBack)callBack
{
    if(self = [super init]){
        self.titleLabel.text = title;
        self.dataConfiguration = config;
        self.callBack = callBack;
    }
    return self;
}

- (instancetype)initDatePickerWithTitle:(NSString *)title callBack:(YLAwesomeSelectDateCallBack)callBack
{
    if(self = [super init]){
        self.titleLabel.text = title;
        self.dateCallBack = callBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
    [self.view addGestureRecognizer:tapGesture];
    [self.view addSubview:self.contentView];
    if(_dataConfiguration){
        [self fetchData];
    }
    [self showContentView];
}


- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_H, Screen_W, maxHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:self.titleLabel];
        [_contentView addSubview:self.cancelBtn];
        [_contentView addSubview:self.ensureBtn];
        if(_dataConfiguration){//picker view
            [_contentView addSubview:self.picker];
        }else{//date picker view
            [_contentView addSubview:self.datePicker];
        }
    }
    return _contentView;
}

- (UIButton *)cancelBtn
{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = PFFONT(17);
        UIColor *titleColor = SMParatextColor;
        [_cancelBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:titleColor forState:UIControlStateHighlighted];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.frame = CGRectMake(0, 0, 54, headerHeight);
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn
{
    if(!_ensureBtn){
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureBtn.titleLabel.font = PFFONT(17);
        [_ensureBtn setTitleColor:SMTextColor forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:SMTextColor forState:UIControlStateHighlighted];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
        _ensureBtn.frame = CGRectMake(Screen_W - 54, 0, 54, headerHeight);
    }
    return _ensureBtn;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = RGB(0xECEBEC);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(0, 0, Screen_W, headerHeight);
    }
    return _titleLabel;
}

- (UIPickerView *)picker
{
    if(!_picker)
    {
        _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, headerHeight, Screen_W, maxHeight - headerHeight)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
    }
    return _picker;
}

- (UIDatePicker *)datePicker
{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, headerHeight + 1, Screen_W, maxHeight - headerHeight - 1)];
        [_datePicker setDate:[NSDate date] animated:NO];
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker setValue:SMTextColor forKey:@"textColor"];
        NSDate *maxDate = [NSDate date];
        
        [_datePicker setMaximumDate:maxDate];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    return _datePicker;
}

- (void)fetchData
{
    _componentCount = [_dataConfiguration numberOfComponents];
    _tmpSelectedData = [NSMutableArray arrayWithCapacity:_componentCount];
    [self.picker reloadAllComponents];
    
    for(NSInteger i = 0; i < _componentCount; i++){
        YLAwesomeData *selectedData = [_dataConfiguration defaultSelectDataInComponent:i];
        if(!selectedData){
            NSArray *currentDatas = _dataConfiguration.dataSource[@(i)];
            if(currentDatas && currentDatas.count > 0){
                selectedData = currentDatas[0];
            }
        }
        
        if(selectedData){
            NSArray *array = _dataConfiguration.dataSource[@(i)];
            if(array){
                NSInteger row = [array indexOfObject:selectedData];
                if(row != NSNotFound){
                    [_picker selectRow:row inComponent:i animated:NO];
                    [self pickerView:_picker didSelectRow:row inComponent:i];
                }
            }
        }
    }
}


#pragma mark ---UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _componentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if(component < _componentCount){
        NSArray *array = _dataConfiguration.dataSource[@(component)];
        if(array){
            return array.count;
        }
    }
    return 0;
}

#pragma mark ---UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.bounds.size.width / _componentCount;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return cellHeight;
}

/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if(component < _componentCount){
        NSArray *array = _dataConfiguration.dataSource[@(component)];
        if(array && array.count > row){
            YLAwesomeData *data = array[row];
            title = data.name;
        }
    }
    return title;
}*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = RGB(0x000000);
        }
    }
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.font = PFFONT(17);
    if (row == self.selectRow) {
        genderLabel.textColor = SMTextColor;
    }else{
        genderLabel.textColor = SMParatextColor;
    }
    NSString *title;
    if(component < _componentCount){
        NSArray *array = _dataConfiguration.dataSource[@(component)];
        if(array && array.count > row){
            
            NSObject *data = array[row];
            if ([data isKindOfClass:[YLAwesomeData class]]) {
                YLAwesomeData *yData = (YLAwesomeData *)data;
                title = yData.name;
            }
            if ([data isKindOfClass:[ProductSchemeModel class]]) {

                ProductSchemeModel *cData = (ProductSchemeModel *)data;
                if (cData.down_payment_rate.length) {
                    title = cData.down_payment_rate;
                }
                if (cData.number_of_periods.length) {
                    title = cData.number_of_periods;
                }
            }
            if ([data isKindOfClass:[ProductSchemeListMCModel class]]) {
                ProductSchemeListMCModel *cData = (ProductSchemeListMCModel *)data;
                if (cData.monthly_coefficient.length) {
                    title = cData.monthly_coefficient;
                }
            }

        }
    }
    genderLabel.text = title;
    
    return genderLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectRow = row;
    [self.picker reloadComponent:0];
    if(component < _componentCount){
        //remember the select data
        NSArray *array = _dataConfiguration.dataSource[@(component)];
        if(array && array.count > row){
            YLAwesomeData *currentData = array[row];
            if(_tmpSelectedData.count > component){
                _tmpSelectedData[component] = currentData;
            }else{
                [_tmpSelectedData addObject:currentData];
            }
        }
        
        //ex: when select first component, the second to the last component data need refresh
        for(NSInteger nextCom = component + 1; nextCom < _componentCount; nextCom++){
            //reload data
            NSArray *nextArray = [_dataConfiguration dataInComponent:nextCom selectedComponent:component row:row];
            [pickerView reloadComponent:nextCom];
            if(nextArray.count > 0){
                NSInteger nextSelectRow = 0;
                //remember the select data
                YLAwesomeData *nextData = nextArray[nextSelectRow];
                if(_tmpSelectedData.count > nextCom){
                    _tmpSelectedData[nextCom] = nextData;
                }else{
                    [_tmpSelectedData addObject:nextData];
                }
                [pickerView selectRow:nextSelectRow inComponent:nextCom animated:NO];
            }else{
                if(_tmpSelectedData.count > nextCom){
                    //remove the last selected data
                    [_tmpSelectedData removeObjectsInRange:NSMakeRange(nextCom, _tmpSelectedData.count - nextCom)];
                }
            }
        }
    }
}

- (void)showContentView
{
    if(_contentView){
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.y = Screen_H - maxHeight - SafeBottomSpace;
            self.contentView.frame = frame;
        }];
    }
}

- (void)dismissContentView
{
    if(_contentView){
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.y = Screen_H;
            self.contentView.frame = frame;
        }completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }else{
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

- (void)showInController:(UIViewController *)controller
{
    if(controller && [controller isKindOfClass:[UIViewController class]]){
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.view];
        [controller addChildViewController:self];
    }
}

#pragma mark---other methods
- (void)cancel
{
    [_tmpSelectedData removeAllObjects];
    [self dismissContentView];
}

- (void)ensure
{
    if(_dataConfiguration){
        if(_callBack){
            if (_tmpSelectedData && _tmpSelectedData.count<1) {
                NSArray *array = _dataConfiguration.dataSource[@(0)];
                if(array && array.count > 0){
                    YLAwesomeData *firstData = array[0];
                    [_tmpSelectedData addObject:firstData];
                }
                _callBack(_tmpSelectedData);
            }
            else {
                _callBack(_tmpSelectedData);
            }
        }
    }else if(_dateCallBack){
        _dateCallBack(_datePicker.date);
    }
    [self dismissContentView];
}

@end
