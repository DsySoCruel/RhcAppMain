//
//  AccessoriesListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/2.
//

#import "BaseModel.h"

@interface AccessoriesListModel : BaseModel

@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *hid;
@property (nonatomic,strong) NSString *imgs;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *update_time;
@property (nonatomic,strong) NSString *collectionId;
@property (nonatomic,strong) NSString *inventory;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) NSString *commentCount;


@end
