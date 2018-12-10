//
//  RHCURL.h
//  RHCApp
//
//  Created by daishaoyang on 2018/7/15.
//

#ifndef RHCURL_h
#define RHCURL_h

#define RHCMainPath @"http://106.15.103.137/zycartrade-app"

/******************************登录注册**********************************/

//发送验证码
#define USER_SendCodeURL [NSString stringWithFormat:@"%@/auth/getVerifyCode",RHCMainPath]
//登录
#define USER_login [NSString stringWithFormat:@"%@/auth/loginNew",RHCMainPath]
//退出
#define USER_logout [NSString stringWithFormat:@"%@/auth/logout",RHCMainPath]

/******************************通用**********************************/
//获取客服电话
#define USER_ServiceTel [NSString stringWithFormat:@"%@/serviceTel/phone",RHCMainPath]
//消息
#define USER_GetfirstNewsList [NSString stringWithFormat:@"%@/news/getfirstNewsList",RHCMainPath]
//消息详情
#define USER_GetNewsList [NSString stringWithFormat:@"%@/news/getNewsList",RHCMainPath]

//轮播图
#define USER_BannerList [NSString stringWithFormat:@"%@/banner/list",RHCMainPath]
//收藏
#define USER_CollectionAdd [NSString stringWithFormat:@"%@/collection/add",RHCMainPath]
//删除收藏
#define USER_CollectionDelete [NSString stringWithFormat:@"%@/collection/delete",RHCMainPath]
//收藏列表
#define USER_CollectionList [NSString stringWithFormat:@"%@/collection/list",RHCMainPath]
//商品详情
#define USER_ProductDetail [NSString stringWithFormat:@"%@/product/detail",RHCMainPath]
//商品详情默认分期方案
#define USER_SchemeList [NSString stringWithFormat:@"%@/product/schemeList",RHCMainPath]
//商品详情自由分期方案 获取首付比例
#define USER_FindProductSchemeDPList [NSString stringWithFormat:@"%@/order/findProductSchemeDPList",RHCMainPath]
//商品详情自由分期方案 获取期数
#define USER_FindProductSchemeNPList [NSString stringWithFormat:@"%@/order/findProductSchemeNPList",RHCMainPath]
//汽配详情
#define USER_AccessoriesDetail [NSString stringWithFormat:@"%@/accessories/detail",RHCMainPath]


/******************************首页**********************************/

//首页数据 集合实现
#define USER_GetCommonHome [NSString stringWithFormat:@"%@/auth/getCommonHome",RHCMainPath]

//首页数据 1.秒杀区 2.所有商品列表
#define USER_ProductList [NSString stringWithFormat:@"%@/product/list",RHCMainPath]
//首页数据 2.车圈与发现
#define USER_PostAndinformationlist [NSString stringWithFormat:@"%@/information/postAndinformationlist",RHCMainPath]
//首页二级:秒杀列表
#define USER_ActivityList [NSString stringWithFormat:@"%@/product/activityList",RHCMainPath]
//首页二级:汽配列表
#define USER_AccessoriesList [NSString stringWithFormat:@"%@/accessories/list",RHCMainPath]
//首页二级:汽配类型列表
#define USER_AccessoriesTypelist [NSString stringWithFormat:@"%@/accessories/typeList",RHCMainPath]
//首页二级:汽车品牌
#define USER_listBrand [NSString stringWithFormat:@"%@/brand/listBrand",RHCMainPath]


/******************************发现**********************************/
//发现列表
#define USER_InformationList [NSString stringWithFormat:@"%@/information/list",RHCMainPath]
//发现详情
#define USER_InformationDetail [NSString stringWithFormat:@"%@/information/detail",RHCMainPath]
//靠谱
#define USER_updatePraiseNumber [NSString stringWithFormat:@"%@/information/updatePraiseNumber",RHCMainPath]
//没用
#define USER_updateStepOnNumber [NSString stringWithFormat:@"%@/information/updateStepOnNumber",RHCMainPath]

/******************************车圈**********************************/
//车圈帖子列表
#define USER_PostList [NSString stringWithFormat:@"%@/post/list",RHCMainPath]
//帖子详情列表
#define USER_Postdetail [NSString stringWithFormat:@"%@/post/detail",RHCMainPath]
//帖子评论列表
#define USER_CommentList [NSString stringWithFormat:@"%@/post/commentList",RHCMainPath]
//发布评论
#define USER_AddComment [NSString stringWithFormat:@"%@/post/addComment",RHCMainPath]
//发布帖子
#define USER_AddPost [NSString stringWithFormat:@"%@/post/addPost",RHCMainPath]
//车圈主页
#define USER_Mylist [NSString stringWithFormat:@"%@/post/mylist",RHCMainPath]



/******************************订单**********************************/
//汽车订单列表
#define USER_ProductOrderList [NSString stringWithFormat:@"%@/order/productOrderList",RHCMainPath]
//汽车订单详情
#define USER_ProductOrderDetail [NSString stringWithFormat:@"%@/order/productOrderDetail",RHCMainPath]
//催促审核
#define USER_AddOrderUrge [NSString stringWithFormat:@"%@/order/addOrderUrge",RHCMainPath]
//车厢订单列表
#define USER_CarriageOrderList [NSString stringWithFormat:@"%@/order/carriageOrderList",RHCMainPath]
//车厢订单详情
#define USER_CarriageOrderDetail [NSString stringWithFormat:@"%@/order/carriageOrderDetail",RHCMainPath]

//配件订单列表
#define USER_OrderList [NSString stringWithFormat:@"%@/order/orderList",RHCMainPath]
//配件订单详情
#define USER_OrderDetail [NSString stringWithFormat:@"%@/order/orderDetail",RHCMainPath]

/******************************购买和购物车**********************************/
//查看配件购物车列表
#define USER_ProductCarList [NSString stringWithFormat:@"%@/order/carList",RHCMainPath]
//添加配件到购物车
#define USER_ProductAddCar [NSString stringWithFormat:@"%@/order/addCar",RHCMainPath]
//更改数量
#define USER_ProductUpdateCarItemNumber [NSString stringWithFormat:@"%@/order/updateCarItemNumber",RHCMainPath]
//删除购物车内容
#define USER_ProductDeleteCarItem [NSString stringWithFormat:@"%@/order/deleteCarItem",RHCMainPath]

//添加购车订单
#define USER_AddProductOrder [NSString stringWithFormat:@"%@/order/addProductOrder",RHCMainPath]


//添加车厢订单
#define USER_AddCarriageOrder [NSString stringWithFormat:@"%@/order/addCarriageOrder",RHCMainPath]

//添加配件订单
#define USER_SettleAccounts [NSString stringWithFormat:@"%@/order/settleAccounts",RHCMainPath]


//添加专属定制
#define USER_AddPrivateCustomization [NSString stringWithFormat:@"%@/privateCustomization/add",RHCMainPath]

//支付前获取订单基本信息
#define USER_GetOrderPayData [NSString stringWithFormat:@"%@/order/getOrderPayData",RHCMainPath]

//支付前获取订单加密信息
#define USER_Pay [NSString stringWithFormat:@"%@/pay/pay",RHCMainPath]
/******************************我的**********************************/
//编辑个人图像
#define USER_UpdateHeadimg [NSString stringWithFormat:@"%@/auth/updateHeadimg",RHCMainPath]
//编辑个人资料
#define USER_UpdateUserInfo [NSString stringWithFormat:@"%@/auth/updateUserInfo",RHCMainPath]
//服务网点
#define USER_ScreentoneList [NSString stringWithFormat:@"%@/screentone/list",RHCMainPath]
//意见反馈
#define USER_FeedbackAdd [NSString stringWithFormat:@"%@/feedback/add",RHCMainPath]

//我的收货地址
#define USER_myaddress [NSString stringWithFormat:@"%@/address/list",RHCMainPath]
//新增收货地址
#define USER_addAddress [NSString stringWithFormat:@"%@/address/add",RHCMainPath]
//修改地址
#define USER_updateAddress [NSString stringWithFormat:@"%@/address/update",RHCMainPath]
//获取城市
#define USER_AreaList [NSString stringWithFormat:@"%@/screentone/areaList",RHCMainPath]
//添加收货地址选取的城市 三级联动
#define USER_AreaDataParam [NSString stringWithFormat:@"%@/tools/areaDataParam",RHCMainPath]
//常见问题
#define USER_FaqList [NSString stringWithFormat:@"%@/faq/list",RHCMainPath]

/******************************我的**********************************/
//获取热门搜索
#define USER_GetHotsearchListlist [NSString stringWithFormat:@"%@/search/getHotsearchListlist",RHCMainPath]
//进行搜索
#define USER_SearchList [NSString stringWithFormat:@"%@/search/list",RHCMainPath]

//搜索为空
#define USER_AddSubmitData [NSString stringWithFormat:@"%@/order/addSubmitData",RHCMainPath]



#endif /* RHCURL_h */
