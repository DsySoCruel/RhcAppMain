//
//  NSString+Extension.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

#pragma mark -- 根据时间戳返回到现在的类别
- (NSString *)timeTyeBuytimeTnterval;

#pragma mark -- 返回日期到现在的时间类别 (使用NSString + Data）类别中的方法
- (NSString *)timeFromNow;

#pragma mark -- 返回字符串所占尺寸
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

#pragma mark -- 正则匹配用户密码6-18位数字和字母组合
+(BOOL)checkPassword:(NSString*)password;

#pragma mark -  M5D加密
- (NSString *)md5String;

#pragma mark -  json转换
+(id )getObjectFromJsonString:(NSString *)jsonString;
+(NSString *)getJsonStringFromObject:(id)object;

#pragma mark -  NSDate互转NSString
+(NSDate *)NSStringToDate:(NSString *)dateString;
+(NSDate *)NSStringToDate:(NSString *)dateString withFormat:(NSString *)formatestr;
+(NSString *)NSDateToString:(NSDate *)dateFromString withFormat:(NSString *)formatestr;

#pragma mark -  判断字符串是否为空,为空的话返回 “” （一般用于保存字典时）
+(NSString *)IsNotNull:(NSString*)string;
+(BOOL)isBlankString:(id)string;//方法1
+(BOOL)isBlankFromNetString:(id)string;//方法2 用于网络请求


#pragma mark - 如何通过一个整型的变量来控制数值保留的小数点位数。以往我们通类似@"%.2f"来指定保留2位小数位，现在我想通过一个变量来控制保留的位数
+(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace;


#pragma mark - 使用subString去除float后面无效的0
+(NSString *)changeFloatWithString:(NSString *)stringFloat;

#pragma mark - 去除float后面无效的0
+(NSString *)changeFloatWithFloat:(CGFloat)floatValue;


#pragma mark -  手机号码验证
+ (BOOL) isMobileNumber:(NSString *)mobileNum;

#pragma mark -  阿里云压缩图片
+(NSURL*)UrlWithStringForImage:(NSString*)string;
+(NSString*)removeYaSuoAttribute:(NSString*)string;

#pragma mark - 字符串类型判断
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;

#pragma mark -  计算内容文本的高度方法
+ (CGFloat)HeightForText:(NSString *)text withSizeOfLabelFont:(CGFloat)font withWidthOfContent:(CGFloat)contentWidth;

#pragma mark -  计算字符串长度
+ (CGFloat)WidthForString:(NSString *)text withSizeOfFont:(CGFloat)font;


#pragma mark -  计算两个时间相差多少秒

+(NSInteger)getSecondsWithBeginDate:(NSString*)currentDateString  AndEndDate:(NSString*)tomDateString;

#pragma mark - 根据出生日期获取年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;

#pragma mark - 根据经纬度计算两个位置之间的距离
+(double)distanceBetweenOrderBylat1:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2;

#pragma mark - 根据传入的数值字符串甄别返回 **万
- (NSString *)priceWithWan;

// 是否为http链接
- (BOOL)isHttpLink;

// 是否为有效字符串
- (BOOL)isValidString;

/**
 扫一扫得到的url参数 转字典
 @return 字典
 */
- (NSMutableDictionary *)getURLParameters;

/**
 扫一扫得到的名片参数 转字典
 @return 字典
 */
- (NSMutableDictionary *)getCardParameters;


/**
 * 计算文本的宽度：CGSizeMake(0, 传入显示的最大高度);
 * 计算文本的高度：CGSizeMake(传入显示的最大宽度, 0);
 */
+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font text:(NSString *)text;


@end
