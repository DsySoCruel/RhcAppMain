//
//  YLDataConfiguration.m
//  YLAwesomePicker
//
//  Created by TK-001289 on 2017/6/15.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLDataConfiguration.h"
#import "YLAwesomeData.h"

//#import "DistrictDataRequest.h"
//#import "GetIndustryListRequest.h"

@interface YLDataConfiguration ()
@property(nonatomic,copy,readwrite)NSDictionary *dataSource;///< ex: @{@0:@[data0,data1...]}
@property(nonatomic,assign)YLDataConfigType type;
@property(nonatomic,copy)NSArray *allMonths;///< 12~1
@property(nonatomic,copy)NSArray *currentMonths;///< currentMonth ~ 1

@end

@implementation YLDataConfiguration
- (instancetype)initWithType:(YLDataConfigType)type selectedData:(NSArray *)selectedData
{
    if(self = [super init]){
        self.type = type;
        [self getDefaultDataWithType:type data:selectedData];
        self.selectedData = selectedData;
    }
    return self;
}

- (instancetype)initWithType:(YLDataConfigType)type data:(NSArray *)data
{
    if(self = [super init]){
        self.type = type;
        [self getDefaultDataWithType:type data:data];
    }
    return self;
}


- (instancetype)initWithData:(NSDictionary *)dataDic selectedData:(NSArray *)selectedData
{
    if(self = [super init]){
        self.dataSource = dataDic;
        self.selectedData = selectedData;
    }
    return self;
}

- (void)getDefaultDataWithType:(YLDataConfigType)type data:(NSArray *)data
{
    switch (type) {
        case YLDataConfigTypeFengqi:{
            YLAwesomeData *data0 = [[YLAwesomeData alloc]initWithId:1 name:@"固定分期"];
            YLAwesomeData *data1 = [[YLAwesomeData alloc]initWithId:2 name:@"自由分期"];
            YLAwesomeData *data2 = [[YLAwesomeData alloc]initWithId:3 name:@"全款"];
            self.dataSource = @{@0:@[data0,data1,data2]};
        }
            break;

        case YLDataConfigTypeChexiang:{//车厢样式选择
            YLAwesomeData *data0 = [[YLAwesomeData alloc]initWithId:1 name:@"平板式"];
            YLAwesomeData *data1 = [[YLAwesomeData alloc]initWithId:2 name:@"栏板式"];
            YLAwesomeData *data2 = [[YLAwesomeData alloc]initWithId:3 name:@"箱式"];
            self.dataSource = @{@0:@[data0,data1,data2]};
        }
            break;
            
        case YLDataConfigTypeGender:{
            YLAwesomeData *data0 = [[YLAwesomeData alloc]initWithId:0 name:@"男"];
            YLAwesomeData *data1 = [[YLAwesomeData alloc]initWithId:1 name:@"女"];
            self.dataSource = @{@0:@[data0,data1]};
        }
            break;
        case YLDataConfigTypeAcademic:{
            NSArray *names = @[@"专科",@"本科",@"硕士",@"博士",@"博士后",@"其他"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:names.count];
            for(NSInteger i = 0; i < names.count; i++){
                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:i name:names[i]];
                [array addObject:data];
            }
            self.dataSource = @{@0:array};
        }
            break;
        case YLDataConfigTypeProfessional:{
            NSArray *names = @[@"正高级",@"副高级",@"中级",@"初级",@"技术"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:names.count];
            for(NSInteger i = 0; i < names.count; i++){
                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:i name:names[i]];
                [array addObject:data];
            }
            self.dataSource = @{@0:array};
        }
            break;
        case YLDataConfigTypePoliticsStatus:{
            NSArray *names = @[@"党员",@"团员",@"群众",@"其他党派",@"无党派人士"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:names.count];
            for(NSInteger i = 0; i < names.count; i++){
                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:i name:names[i]];
                [array addObject:data];
            }
            self.dataSource = @{@0:array};
        }
            break;
//        case YLDataConfigTypeIndustry:{
//            NSMutableArray *array = [NSMutableArray arrayWithCapacity:data.count];
//            for(GetIndustryListModel *model in data){
//                YLAwesomeData *d = [[YLAwesomeData alloc]initWithId:model.itemId.integerValue name:model.detail];
//                [array addObject:d];
//            }
//            self.dataSource = @{@0:array};
//        }
//            break;
        case YLDataConfigTypeWorkYear:{
            NSArray *names = @[@"应届毕业生",@"1~3年",@"3~5年",@"5~10年",@"10年以上"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:names.count];
            for(NSInteger i = 0; i < names.count; i++){
                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:i name:names[i]];
                [array addObject:data];
            }
            self.dataSource = @{@0:array};
        }
            break;
        case YLDataConfigTypeStartTime:{
            NSDateComponents *dateComponents = [self currentDateComponents];
            NSInteger year = dateComponents.year;
            NSInteger month = dateComponents.month;
            
            NSMutableArray *years = [NSMutableArray array];
            for(NSInteger i = year; i >= 1970; i--){
                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:i name:[NSString stringWithFormat:@"%li年",(long)i]];
                [years addObject:data];
            }
            NSMutableArray *months = [NSMutableArray arrayWithCapacity:12];
            NSMutableArray *currentMonths = [NSMutableArray arrayWithCapacity:month];
            for(NSInteger j = 12; j > 0; j--){
                NSString *monthFormat = [NSString stringWithFormat:@"%li月",(long)j];
                if (j < 10) {
                    monthFormat = [NSString stringWithFormat:@"0%li月",(long)j];
                }
                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:j name:monthFormat];
                [months addObject:data];
                if(j <= month){
                    [currentMonths addObject:data];
                }
            }
            self.allMonths = months;
            self.currentMonths = currentMonths;
            self.dataSource = @{@0:years,@1:months};
        }
            break;
        case YLDataConfigTypeEndTime:{
            NSDateComponents *dateComponents = [self currentDateComponents];
            NSInteger year = dateComponents.year;
            NSInteger month = dateComponents.month;
            
            NSMutableArray *years = [NSMutableArray array];
            [years addObject:[[YLAwesomeData alloc]initWithId:0 name:@"至今"]];
            for(NSInteger i = year; i >= 1970; i--){
                YLAwesomeData *data = [[YLAwesomeData alloc] initWithId:i name:[NSString stringWithFormat:@"%li年",(long)i]];
                [years addObject:data];
            }
            NSMutableArray *months = [NSMutableArray arrayWithCapacity:12];
            NSMutableArray *currentMonths = [NSMutableArray arrayWithCapacity:month];
            for(NSInteger j = 12; j > 0; j--){
                NSString *monthFormat = [NSString stringWithFormat:@"%li月",(long)j];
                if (j < 10) {
                    monthFormat = [NSString stringWithFormat:@"0%li月",(long)j];
                }
                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:j name:monthFormat];
                [months addObject:data];
                if(j <= month){
                    [currentMonths addObject:data];
                }
            }
            self.allMonths = months;
            self.currentMonths = currentMonths;
            self.dataSource = @{@0:years,@1:months};
        }
            break;
//        case YLDataConfigTypeNativePlace:{
//            NSMutableArray *array = [NSMutableArray arrayWithCapacity:data.count];
//            for (ProvinceObject *obj in data) {
//                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:obj.pid.integerValue name:obj.name];
//                [array addObject:data];
//            }
//            self.dataSource = @{@0:array};
//        }
//            break;
//        case YLDataConfigTypeAddress:{
//            NSMutableArray *provinces = [NSMutableArray arrayWithCapacity:data.count];
//            for (ProvinceObject *obj in data) {
//                YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:obj.pid.integerValue name:obj.name];
//                data.city = obj.city;
//                [provinces addObject:data];
//            }
//
//            NSArray *citys = [NSArray array];
//            if (provinces.count > 0) {
//                YLAwesomeData *data = provinces[0];
//                citys = [self currentCitys:data];
//            }
//            self.dataSource = @{@0:provinces,@1:citys};
//
//        }
//            break;
            
        case YLDataConfigTypeCountryCode:{
            
        }
            break;
        case YLDataConfigTypeUnKnow:
        default:
            break;
    }
}

//- (NSArray *)currentCitys:(YLAwesomeData *)curModel{
//    NSMutableArray *citys = [NSMutableArray array];
//    for (CityObject *city in curModel.city) {
//        YLAwesomeData *data = [[YLAwesomeData alloc]initWithId:city.cid.integerValue name:city.name];
//        [citys addObject:data];
//    }
//    return citys;
//}

- (NSDateComponents *)currentDateComponents
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:now];
    return dateComponents;
}



#pragma mark---YLAwesomeDataDelegate
- (NSInteger)numberOfComponents
{
    return _dataSource.allKeys.count;
}

- (YLAwesomeData *)defaultSelectDataInComponent:(NSInteger)component
{
    if(_selectedData.count > component){
        return _selectedData[component];
    }
    return nil;
}

- (NSArray *)dataInComponent:(NSInteger)component
{
    if([_dataSource.allKeys containsObject:@(component)]){
        return _dataSource[@(component)];
    }
    return @[];
}

- (void)updateDataSourceWithIndex:(NSInteger)index data:(NSArray *)data
{
    if(data){
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource];
        tmpDic[@(index)] = data;
        self.dataSource = tmpDic;
    }
}

- (NSArray *)dataInComponent:(NSInteger)nComponent selectedComponent:(NSInteger)sComponent row:(NSInteger)row
{
    if(_type == YLDataConfigTypeStartTime){
        if(sComponent == 0){
            if(row == 0){
                [self updateDataSourceWithIndex:1 data:self.currentMonths];
                return self.currentMonths;
            }else{
                [self updateDataSourceWithIndex:1 data:self.allMonths];
                return self.allMonths;
            }
        }
    }else if (_type == YLDataConfigTypeEndTime){
        if(sComponent == 0){
            if(row == 0){
                [self updateDataSourceWithIndex:1 data:@[]];
                return @[];
            }else if(row == 1){
                [self updateDataSourceWithIndex:1 data:self.currentMonths];
                return self.currentMonths;
            }else{
                [self updateDataSourceWithIndex:1 data:self.allMonths];
                return self.allMonths;
            }
        }
    }
//    else if(_type == YLDataConfigTypeAddress){
//        if(sComponent == 0){//select province,then refresh citys and areas
//            NSArray *provinces = self.dataSource[@0];
//            if(provinces && provinces.count > row){
//                YLAwesomeData *currentProvince = provinces[row];
//                NSArray *citys = [self currentCitys:currentProvince];
//                if(nComponent == 1){
//                    [self updateDataSourceWithIndex:1 data:citys];
//                    return citys;
//                }
//            }
//            return @[];
//        }
//    }
    else if (nComponent < _dataSource.allKeys.count){
        NSArray *data = _dataSource[@(nComponent)];
        [self updateDataSourceWithIndex:nComponent data:data];
        return data;
    }
    return @[];
}

@end
