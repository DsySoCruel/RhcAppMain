//
//  ServiceStationSelectViewCell.h
//  RHCApp
//
//  Created by daishaoyang on 2018/11/8.
//

#import <UIKit/UIKit.h>
@class ServiceStationViewCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface ServiceStationSelectViewCell : UITableViewCell

@property (nonatomic,strong) ServiceStationViewCellModel *model;

- (void)configModel:(ServiceStationViewCellModel *)model with:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
