//
//  YLDataConfiguration.h
//  YLAwesomePicker
//
//  Created by TK-001289 on 2017/6/15.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLAwesomeDataDelegate.h"

typedef NS_ENUM(NSInteger,YLDataConfigType) {
    YLDataConfigTypeUnKnow = 0,///< unknow the type
    YLDataConfigTypeAcademic,///< select academic
    YLDataConfigTypeProfessional,////< select professional
    YLDataConfigTypePoliticsStatus,////< select politics status
    YLDataConfigTypeIndustry,////< select Industry
    YLDataConfigTypeWorkYear,///< select work years
    YLDataConfigTypeStartTime,///< select start time
    YLDataConfigTypeEndTime,///< select end time
    YLDataConfigTypeNativePlace,///< Native place
    YLDataConfigTypeAddress,////< select province-city-region
    YLDataConfigTypeCountryCode,////< select country code
    //融合车使用
    YLDataConfigTypeChexiang,////车厢样式选择
    YLDataConfigTypeFengqi,////专属定制分期选择
    YLDataConfigTypeGender = 1000,///选择性别

};

@interface YLDataConfiguration : NSObject <YLAwesomeDataDelegate>
@property(nonatomic,copy)NSArray *selectedData;


/**
 You can use the default type, it will auto init the data.

 @param type YLDataConfigType
 @param selectedData The last selected data
 @return instance
 */
- (instancetype)initWithType:(YLDataConfigType)type selectedData:(NSArray *)selectedData;


- (instancetype)initWithType:(YLDataConfigType)type data:(NSArray *)data;

/**
 You can use this method to custom the select data.

 @param dataDic The select data like: @{@0:@[data0,data1...]}
 @param selectedData The last selected data
 @return instance
 */
- (instancetype)initWithData:(NSDictionary *)dataDic selectedData:(NSArray *)selectedData;


@end
//the data configuration center
