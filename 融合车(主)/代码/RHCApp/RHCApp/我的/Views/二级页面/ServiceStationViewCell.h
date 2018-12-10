//
//  ServiceStationViewCell.h
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import <UIKit/UIKit.h>
@class ServiceStationViewCellModel;

@interface ServiceStationViewCell : UITableViewCell

@property (nonatomic,strong) ServiceStationViewCellModel *model;

- (void)configModel:(ServiceStationViewCellModel *)model with:(NSIndexPath *)indexPath;

@end
