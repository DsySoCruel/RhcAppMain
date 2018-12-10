//
//  DSYPhotoModel.h
//  ParentsApp
//
//  Created by Mac book on 16/10/14.
//  Copyright © 2016年 WangShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSYPhotoModel : NSObject


@property (nonatomic, assign) NSInteger num;//那个字段的照片

//@property (nonatomic, copy) NSString *photoIdentifier;//图片唯一标识

//@property (nonatomic, assign) DSYVideoModelType type;


//本机
@property (nonatomic, strong) UIImage *photo;//缩略图(本机)

@property (nonatomic, strong) id asset;//本地资源

//网络
@property (nonatomic, copy) NSString *url;//存放本机地址或者网络URL


@end
