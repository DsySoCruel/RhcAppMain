//
//  HomeCollectionCellModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/6/26.
//

#import <Foundation/Foundation.h>

@interface HomeCollectionCellModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *imageName;
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
@end
