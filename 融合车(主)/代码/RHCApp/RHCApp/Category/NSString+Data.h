//
//  NSString+Data.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/22.
//

#import <Foundation/Foundation.h>


/**
 * 1 1分钟 >=  time             格式：刚刚
 * 2 1分钟 <= time < 60分钟 格式：1~60分钟前
 * 3 1小时 <= time < 4小时  格式：1~3小时前
 * 3 4小时 <= time < 今天   格式：hh:ss
 * 4 昨日 = time           格式：昨日 hh:ss
 * 5 2天 <= time           格式：MM月dd日
 * 6 不同年                格式：yyyy年MM月dd日
 */

@interface NSString (Data)
/**
 * 时间戳 根据规则 转换为 时间差 （此规则只适应于本应用）
 */
-(NSString*)timeTypeFromNow;

/**
 * 时间戳  转换为 nsdate
 */

-(NSDate *)timeStampToDate;

- (NSString *)timeStampToDateSecondStr;
/**
 * 时间戳 根据formatterString格式 转换为 时间字符串
 */
-(NSString *)timeStampToStringWithFormatterString:(NSString *)formatterString;

/**
 * NSDate 按照dateFormatterString的格式 转换为 NSString
 */
+(NSString *)stringFromDate:(NSDate *)date dateFormatterString:(NSString *)dateFormatterString;

- (NSString *)timeStampToDateStr;

/**
 时间字符串转时间戳
 
 @param formatTime 时间字符串
 @param format 转换格式
 @return 返回时间戳
 */
+(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

/**
 比较时间是否过期（给定的时间戳和当前的时间对比）
 
 @param upToNowTime 比较的截至时间
 @return 返回Bool  YES : 过期 NO  : m没有过期
 */
+(BOOL )isOverTime:(NSString *)upToNowTime;

@end
