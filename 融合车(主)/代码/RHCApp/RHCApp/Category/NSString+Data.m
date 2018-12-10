//
//  NSString+Data.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/22.
//

#import "NSString+Data.h"

@implementation NSString (Data)

-(NSString*)timeTypeFromNow{
    //    NSDate *localDate = [self timeStampToDate];
    //
    //    NSDate *nowDate = [NSDate date];
    //    NSDate *beforeDate = localDate;
    //
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //    NSDateComponents *compts = [calendar components:unitFlags fromDate:beforeDate toDate:nowDate options:0];
    
    //    NSTimeInterval time = fabs([beforeDate timeIntervalSinceDate:nowDate]); //date1是前一个时间(早)，date2是后一个时间(晚)
    //    CGFloat timeInterval = time/60.0/60.0;//小时为单位
    //    NSString *returnString = @"";
    //    if (timeInterval<=1) {
    //        //规则1
    //        returnString = [NSString stringWithFormat:@"%ld分钟前",(long)compts.minute];
    //        if ((long)compts.minute==0) {
    //                returnString = @"刚刚";
    //        }
    //    }
    //    else if(timeInterval > 1 && timeInterval <= 24){
    //        //规则2
    //        returnString = [NSString stringWithFormat:@"%ld小时前",(long)compts.hour];
    //    }
    ////    else if(timeInterval > 4 && timeInterval <= 24){
    ////        //规则3
    ////        returnString = [self stringFromDate:beforeDate dateFormatterString:@"HH:mm"];
    ////    }
    //    else if(timeInterval > 24 && timeInterval <= 48){
    //        //规则4
    //        NSString *result = [self stringFromDate:beforeDate dateFormatterString:@"HH:mm"];
    //        returnString = [NSString stringWithFormat:@"昨日 %@",result];
    //    }
    //    else{
    //        //compts.hour > 48
    //        if (compts.year && compts.year >= 1) {
    //            //规则6 不同年
    //            returnString = [self stringFromDate:beforeDate dateFormatterString:@"YYYY年MM月dd日"];
    //        }else{
    //            //规则5 同年
    //            returnString = [self stringFromDate:beforeDate dateFormatterString:@"MM月dd日"];
    //        }
    //    }
    //
    //    return returnString;
    
    NSDate *originalData = [self timeStampToDate];
    NSString *result;
    //今年
    if ([self isThisYear]) {
        // 今天
        if ([self isToday]) {
            NSTimeInterval  timeInterval = [[self timeStampToDate] timeIntervalSinceNow];
            timeInterval = fabs(timeInterval);
            long temp = 0;
            // time <= 1分钟
            if (timeInterval < 60) {
                result = [NSString stringWithFormat:@"刚刚"];
            }
            // 1分钟 <= time < 60分钟
            else if (timeInterval < 60*60*1) {
                temp = timeInterval/60;
                result = [NSString stringWithFormat:@"%ld分钟前",temp];
            }
            // 1小时 <= time < 4小时
            else if (timeInterval < 60*60*4) {
                temp = timeInterval/(60*60);
                result = [NSString stringWithFormat:@"%ld小时前",temp];
            }
            // > 4小时
            else{
                result = [self stringFromDate:originalData dateFormatterString:@"HH:mm"];
            }
        }
        //昨日
        else if ([self isYesterday]){
            NSString *returnString = [self stringFromDate:originalData dateFormatterString:@"HH:mm"];
            result = [NSString stringWithFormat:@"昨日 %@",returnString];
        }
        // >= 两天
        else{
            result = [self stringFromDate:originalData dateFormatterString:@"MM.dd"];
        }
        
    }
    //不同年
    else{
        result = [self stringFromDate:originalData dateFormatterString:@"YYYY.MM.dd"];
    }
    return result;
}

//时间戳->时间
-(NSDate *)timeStampToDate{
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]/1000.0];
    return sourceDate;
}

-(NSString *)timeStampToStringWithFormatterString:(NSString *)formatterString{
    NSDate *date = [self timeStampToDate];
    NSString *timeStr = [self stringFromDate:date dateFormatterString:formatterString];
    return timeStr;
}

//8小时时间差
- (NSDate *)getLocalDateFromatUniversalTime:(NSDate *)UTCDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:UTCDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:UTCDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为当前时区时间
    NSDate* localDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:UTCDate];
    return localDate;
}

- (NSString *)timeStampToDateStr{
    NSDate *date = [self timeStampToDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSString *nowtimeStr = [formatter stringFromDate:date];
    return nowtimeStr;
}

- (NSString *)timeStampToDateSecondStr{
    NSDate *date = [self timeStampToDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm aa"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSString *nowtimeStr = [formatter stringFromDate:date];
    return nowtimeStr;
}

//NSDate 按照dateFormatterString的格式 转换为 NSString
-(NSString *)stringFromDate:(NSDate *)date dateFormatterString:(NSString *)dateFormatterString{
    NSString *timeString = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormatterString];
    timeString = [formatter stringFromDate:date];
    return timeString;
}

//NSDate 按照dateFormatterString的格式 转换为 NSString
+(NSString *)stringFromDate:(NSDate *)date dateFormatterString:(NSString *)dateFormatterString{
    NSString *timeString = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormatterString];
    timeString = [formatter stringFromDate:date];
    return timeString;
}

+(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSString *timeStamp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] stringValue];
    
    return timeStamp;
    
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 1.获得当前时间的年月日
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:nowDate];
    
    // 2.获得self的年月日
    NSDate *selfDate = [self timeStampToDate];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:selfDate];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:nowDate];
    
    NSDate *selfDate = [self timeStampToDate];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:selfDate];
    
    // 获得nowDate和selfDate的差距
    return labs(selfCmps.day - nowCmps.day) == 1;
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:nowDate];
    
    // 2.获得self的年月日
    NSDate *selfDate = [self timeStampToDate];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:selfDate];
    
    return nowCmps.year == selfCmps.year;
}

/**
 比较时间是否过期（给定的时间戳和当前的时间对比）
 
 @param upToNowTime 比较的截至时间
 @return 返回Bool  YES : 过期 NO  : 没有过期
 */
+(BOOL)isOverTime:(NSString *)upToNowTime{
    if ([upToNowTime isEqualToString:@"0"]) {//没有时间限制
        return NO;
    }
    NSTimeInterval time = [upToNowTime doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate= [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //1.生成最后时间格式字符串
    NSString *endDateStr = [dateFormatter stringFromDate: detailDate];
    //2.获取时间格式字符串
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *dt1 = [dateFormatter dateFromString:endDateStr];
    NSDate *dt2 = [dateFormatter dateFromString:currentDateStr];
    NSComparisonResult result = [dt1 compare:dt2];
    if (result == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}
@end
