//
//  OrderMakeViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/18.
//

#import "BaseViewController.h"
#import "MyAddressModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface OrderMakeViewController : BaseViewController
@property (nonatomic,strong) NSMutableArray *selectGoodsArray;
@property (nonatomic,strong) MyAddressModel *addressModel;
@property (nonatomic,strong) NSMutableAttributedString *titleString;

@end

NS_ASSUME_NONNULL_END
