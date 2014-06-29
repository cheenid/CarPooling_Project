//
//  CPHttpRequest.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-22.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "CPHttpRequest.h"
#import <JSONKit.h>

@implementation CPHttpRequest
+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static CPHttpRequest *httpRequest = nil;
    dispatch_once(&pred, ^{ httpRequest = [[self alloc] init]; });
    return httpRequest;
}

#pragma mark -绑定百度云推送
/**
 * @method
 * @brief POST 绑定百度云推送，用户账号+channelID+osTYPE
 * @see {@url} /api/push/upload
 * @param  channelId 设备号
 * @param  ostype 操作系统类型：1.android; 2.iOS
 * @return
 */
- (void)requestBlindBaiduCloud:(NSString*)channelId
                        osType:(NSInteger)ostype
                       success:(void(^)(id responseObject))success
                      failture:(void(^)(NSError *error))failture
{
    NSNumber *osTypeNumber = [NSNumber numberWithInteger:ostype];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"channelId": channelId,@"osType":osTypeNumber};
    [manager POST:@"http://www.egoal.cn/sharecar/api/push/upload" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}



#pragma mark -积分兑换接口
/**
 * @method
 * @brief POST 获取我的积分总数
 * @see {@url} /api/score/spend
 * @param  productId 商品ID
 * @param  quantity 数量
 * @param  note 备注
 * @return
 */
- (void)requestTotalPoints:(NSString*)productId
                  quantity:(NSInteger)quantity
                      note:(NSString*)note
                   success:(void(^)(id responseObject))success
                  failture:(void(^)(NSError *error))failture
{
    NSNumber *quantityNumber = [NSNumber numberWithInteger:quantity];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"productId": productId,@"quantity":quantityNumber,@"note":note};
    [manager POST:@"http://www.egoal.cn/sharecar/api/score/spend" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -获取联系人接口，积分馈赠用
/*!
 * @method
 * @brief GET 获取我的联系人列表，分页获取
 * @see {@url} /api/friend/list/query
 * @param  page 第几页
 * @param  size 每页多少条
 * @return
 */
- (void)requestFriendlistWithPage:(NSInteger)page
                             size:(NSInteger)size
                          success:(void(^)(id responseObject))success
                         failture:(void(^)(NSError *error))failture
{
    NSNumber *pageNumber = [NSNumber numberWithInteger:page];
    NSNumber *sizeNumber = [NSNumber numberWithInteger:size];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"page":pageNumber,@"size":sizeNumber};
    [manager GET:@"http://www.egoal.cn/sharecar/api/friend/list/query" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -获取我的信息接口，包括：个人信息、认证信息、车辆信息
/**
 * @method
 * @brief 获取我的信息接口，包括：个人信息、认证信息、车辆信息
 * @see {@url} /api/profile/query
 * @return
 */
- (void)requestMyInfo:(void(^)(id responseObject))success
             failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.egoal.cn/sharecar/api/profile/query" parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -获取匹配的路线接口
/**
 * @method
 * @brief GET 获取匹配的路线接口
 * @see {@url} /api/route/pair
 * @param  routeId 要匹配的路线ID
 * @param  page 第几页
 * @param  size 每页多少条
 * @return
 */
- (void)requestMatchingRoute:(NSString*)routeId
                     success:(void(^)(id responseObject))success
                    failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"routeId": routeId};
    [manager GET:@"http://www.egoal.cn/sharecar/api/route/pair" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}

- (void)requestMatchingRoute:(NSString*)routeId
                        page:(NSInteger)page
                        size:(NSInteger)size
                     success:(void(^)(id responseObject))success
                    failture:(void(^)(NSError *error))failture
{
    NSNumber *pageNumber = [NSNumber numberWithInteger:page];
    NSNumber *sizeNumer = [NSNumber numberWithInteger:size];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"routeId": routeId,@"page":pageNumber,@"size":sizeNumer};
    [manager GET:@"http://www.egoal.cn/sharecar/api/route/pair" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -上传我的个人信息接口
/**
 * @method
 * @brief POST 上传我的个人信息，图片之类的，客户端调用七牛的接口上传 (Ok)
 * @see {@url} /api/profile/person/upload
 * @param  realname 姓名
 * @param  nickname  昵称
 * @param  birthday 生日
 * @param  gender  性别,  0 ,女性；1，男性
 * @param  headPhoto 头像URL，图片由客户端提交至七牛
 * @param  qq qq号
 * @return
 */
- (void)requestUploadMyInfo:(NSString*)realname
                   nickname:(NSString*)nickname
                   birthday:(NSString*)birthday
                     gender:(NSInteger)gender
                  headPhoto:(NSString*)headPhoto
                         qq:(NSString*)qq
                    success:(void(^)(id responseObject))success
                   failture:(void(^)(NSError *error))failture
{
    NSNumber *genderNumber = [NSNumber numberWithInteger:gender];
    NSDictionary *parameters = @{@"realname":realname,@"nickname":nickname,@"gender":genderNumber
                                 ,@"birthday":birthday,@"headPhoto":headPhoto,@"qq":qq};
    NSData *httpBody = [parameters JSONData];
    NSURL *url = [NSURL URLWithString:@"http://www.egoal.cn/sharecar/api/profile/person/upload"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:httpBody];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        DEBUG_METHOD(@"JSON: %@", responseObject);
         success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DEBUG_METHOD(@"Error: %@", error);
        failture(error);
    }];
    [operation start];
}


#pragma mark -获取我的订单列表，分页获取
/**
 * @method
 * @brief GET 获取我的订单列表，分页获取
 * @see {@url} /api/order/list/query
 * @param  page 第几页
 * @param  size 每页多少条
 * @return
 */
- (void)requestOrderList:(NSInteger)page
                    size:(NSInteger)size
                 success:(void(^)(id responseObject))success
                failture:(void(^)(NSError *error))failture
{
    NSNumber *pageNumber = [NSNumber numberWithInteger:page];
    NSNumber *sizeNumer = [NSNumber numberWithInteger:size];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"page":pageNumber,@"size":sizeNumer};
    [manager GET:@"http://www.egoal.cn/sharecar/api/order/list/query" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -获取我的订单详情
/*!
 * @method
 * @brief GET 获取我的订单详情
 * @see {@url} /api/order/detail/query
 * @param  orderID 订单ID
 * @return
 */
- (void)requestOrderDetail:(NSString*)orderID
                   success:(void(^)(id responseObject))success
                  failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id":orderID};
    [manager GET:@"http://www.egoal.cn/sharecar/api/order/detail/query" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}

#pragma mark -获取我的积分详情列表
/*!
 * @method
 * @brief GET 获取我的积分详情列表，包括历史的积分充值记录、接受的馈赠积分记录、馈赠他人积分的记录，按照时间逆序排列
 * @see {@url} /api/score/list/query
 * @param  page 第几页
 * @param  size 每页多少条
 * @return
 */
- (void)requestScoreList:(NSInteger)page
                    size:(NSInteger)size
                 success:(void(^)(id responseObject))success
                failture:(void(^)(NSError *error))failture
{
    NSNumber *pageNumber = [NSNumber numberWithInteger:page];
    NSNumber *sizeNumer = [NSNumber numberWithInteger:size];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"page":pageNumber,@"size":sizeNumer};
    [manager GET:@"http://www.egoal.cn/sharecar/api/score/list/query" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -修改拼车订单状态的接口
/*!
 * @method
 * @brief GET 修改拼车订单状态
 * @see {@url} /api/order/update
 * @param  orderID 订单ID
 * @param  status 订单状态值: 1. 司机发起邀请   2. 乘客发起邀请  3. 司机拒绝邀请 4.乘客拒绝邀请 5.司机接受邀请 6.乘客接受邀请 7.司机取消订单 8.乘客取消订单 9.订单完成
 * @return
 */
- (void)requestUpdateOrder:(NSString*)orderID
                    status:(NSInteger)status
                   success:(void(^)(id responseObject))success
                  failture:(void(^)(NSError *error))failture
{
    NSNumber *statusNumer = [NSNumber numberWithInteger:status];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id":orderID,@"status":statusNumer};
    [manager GET:@"http://www.egoal.cn/sharecar/api/order/update" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -获取可供兑换的商品列表，分页获取
/*!
 * @method
 * @brief GET 获取可供兑换的商品列表，分页获取
 * @see {@url} /api/score/gift/query/list
 * @param  page 第几页
 * @param  size 每页多少条
 * @return
 */
- (void)requestGiftList:(NSInteger)page
                   size:(NSInteger)size
                success:(void(^)(id responseObject))success
               failture:(void(^)(NSError *error))failture
{
    NSNumber *pageNumber = [NSNumber numberWithInteger:page];
    NSNumber *sizeNumer = [NSNumber numberWithInteger:size];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"page":pageNumber,@"size":sizeNumer};
    [manager GET:@"http://www.egoal.cn/sharecar/api/score/gift/query/list" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -创建拼车订单的接口
/*!
 * @method
 * @brief POST
 * @see {@url} /api/order/create
 * @param  driverId 司机ID
 * @param  driverRouteId 司机路线ID
 * @param  passengerId 乘客ID
 * @param  passengerRouteId 乘客路线ID
 * @param  comment 备注
 * @return
 */
- (void)requestCreateOrder:(NSString*)driverId
             driverRouteId:(NSString*)driverRouteId
               passengerId:(NSString*)passengerId
          passengerRouteId:(NSString*)passengerRouteId
                   comment:(NSString*)comment
                   success:(void(^)(id responseObject))success
                  failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"driverId": driverId,@"driverRouteId":driverRouteId,@"passengerId":passengerId};
    [manager POST:@"http://www.egoal.cn/sharecar/api/order/create" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}

#pragma mark -获取我的消息列表，分页获取
/*!
 * @method
 * @brief GET 获取我的消息列表，分页获取
 * @see {@url} /api/msg/list/query
 * @param  page 第几页
 * @param  size 每页多少条
 * @return
 */
- (void)requestMyMsgList:(NSInteger)page
                    size:(NSInteger)size
                 success:(void(^)(id responseObject))success
                failture:(void(^)(NSError *error))failture
{
    NSNumber *pageNumber = [NSNumber numberWithInteger:page];
    NSNumber *sizeNumer = [NSNumber numberWithInteger:size];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"page":pageNumber,@"size":sizeNumer};
    [manager GET:@"http://www.egoal.cn/sharecar/api/msg/list/query" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -上传我的爱车信息接口
/*!
 * @method
 * @brief POST 上传我的爱车信息
 * @see {@url} /api/profile/car/upload
 * @param  carType 车型型号
 * @param  carColors 颜色
 * @param  carNumber 车牌号码
 * @param  carSeats 座位数（5座、7座）
 * @return
 */
- (void)requestUploadCarProfile:(NSString*)carType
                      carColors:(NSString*)carColors
                      carNumber:(NSString*)carNumber
                       carSeats:(NSString*)carSeats
                        success:(void(^)(id responseObject))success
                       failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"carType": carType,@"carColors":carColors,@"carNumber":carNumber,@"carSeats":carSeats};
    [manager POST:@"http://www.egoal.cn/sharecar/api/profile/car/upload" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -行驶证认证接口
/*!
 * @method
 * @brief POST 上传我的爱车信息
 * @see {@url} /api/profile/carlicense/verify
 * @param  photo 行驶证图片，图片由客户端提交至七牛
 * @return
 */
- (void)requestUploadCarlicenseVerify:(NSString*)photo
                              success:(void(^)(id responseObject))success
                             failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"photo": photo};
    [manager POST:@"http://www.egoal.cn/sharecar/api/profile/carlicense/verify" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -驾驶证认证接口

/*!
 * @method
 * @brief POST 驾驶证认证接口
 * @see {@url} /api/profile/driverlicense/verify
 * @param  photo 驾照图片，图片由客户端提交至七牛
 * @return
 */
- (void)requestUploadDriverlicenseVerify:(NSString*)photo
                                 success:(void(^)(id responseObject))success
                                failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"photo": photo};
    [manager POST:@"http://www.egoal.cn/sharecar/api/profile/driverlicense/verify" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -身份认证接口
/*!
 * @method
 * @brief POST 身份认证接口
 * @see {@url} /api/profile/identity/verify
 * @param  frontPhoto 身份证正面照，图片由客户端提交至七牛
 * @param  backPhoto 身份证背面照，图片由客户端提交至七牛
 * @return
 */
- (void)requestVerifyIdentity:(NSString*)frontPhoto
                    backPhoto:(NSString*)backPhoto
                      success:(void(^)(id responseObject))success
                     failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"frontPhoto": frontPhoto,@"backPhoto":backPhoto};
    [manager POST:@"http://www.egoal.cn/sharecar/api/profile/identity/verify" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark - 真实头像认证接口
/*!
 * @method
 * @brief POST
 * @see {@url} /api/profile/photo/verify
 * @param  photo 真实头照，图片由客户端提交至七牛
 * @return
 */
- (void)requestVertifyPhoto:(NSString*)photo
                    success:(void(^)(id responseObject))success
                   failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"photo": photo};
    [manager POST:@"http://www.egoal.cn/sharecar/api/profile/photo/verify" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}

#pragma mark -请求七牛上传token
/**
 * @method
 * @brief GET 请求获取七牛上传token
 * @see {@url} /api/qiniu/uptoken
 * @return
 */
- (void)requestQiniuToken:(void(^)(id responseObject))success
                 failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager GET:@"http://www.egoal.cn/sharecar/api/qiniu/uptoken" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}

#pragma mark - 馈赠积分接口
/*!
 * @method
 * @brief POST 获取我的积分总数
 * @see {@url} /api/score/send
 * @param  contactId 联系人ID
 * @param  score 积分数
 * @return
 */
- (void)requestPresentScore:(NSString*)contactID
                      score:(NSString*)score
                    success:(void(^)(id responseObject))success
                   failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"contactId": contactID,@"score":score};
    [manager POST:@"http://www.egoal.cn/sharecar/api/score/send" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -获取我的积分总数
/*!
 * @method
 * @brief GET 获取我的积分总数
 * @see {@url} /api/score/total/query
 * @return
 */
- (void)requestTotalScore:(void(^)(id responseObject))success
                 failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://www.egoal.cn/sharecar/api/score/total/query" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -积分充值接口
/*!
 * @method
 * @brief POST 积分充值接口
 * @see {@url} /api/score/buy
 * @param  number 积分数
 * @return
 */
- (void)requestBuyScore:(NSInteger)number
                success:(void(^)(id responseObject))success
               failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSNumber *numNumber = [NSNumber numberWithInteger:number];
    NSDictionary *parameters = @{@"number":numNumber};
    [manager POST:@"http://www.egoal.cn/sharecar/api/score/buy" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}


#pragma mark -获取我的路线列表接口
/*!
 * @method
 * @brief GET 获取我的路线接口
 * @see {@url} /api/route/list
 * @return
 */
- (void)requestRouteList:(void(^)(id responseObject))success
                failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://www.egoal.cn/sharecar/api/route/list" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -发布路线接口
/*!
 * @method
 * @brief POST 用户发布新路线，服务端返回用户发布的路线ID
 * @see {@url} /api/route/create
 * @param personType 人员类型：1，司机；2，乘客
 * @param routeType 路线类型：1，长途；2，短途；3，上下班
 * @param nodes {NSDictionary} 节点列表，节点详情如下：
 * @param nodes {name:节点名称}
 * @param nodes {address:节点地址}
 * @param nodes {type:1,起点；2，终点；3，途经点}
 * @param nodes {latitude:经度}
 * @param nodes {longitude:纬度}
 * @param leaveTime 出发时间
 * @param leaveDate  出发日期 --- 可选，仅长途、短途有
 * @param backTime  可选，仅上下班有
 * @param repeat  JsonArray， [1,2,3,4,5,6,7],  分别代表 周一 ~ 周日； --- 可选，仅上下班有
 * @param seat 空位数，司机为可提供空位数；乘客为所需要空位数
 * @param note 备注
 * @return
 */
- (void)requestCreateRoute:(NSInteger)personType
                 routeType:(NSInteger)routeType
                      name:(NSString*)name
                   address:(NSString*)address
                      type:(NSInteger)type
                  latitude:(CGFloat)latitude
                 longitude:(CGFloat)longitude
                 leaveTime:(NSString*)leaveTime
                 leaveDate:(NSString*)leaveDate
                  backTime:(NSString*)backTime
                    repeat:(NSArray*)repeat
                      seat:(NSInteger)seat
                      note:(NSString*)note
                   success:(void(^)(id responseObject))success
                  failture:(void(^)(NSError *error))failture
{
    NSNumber *ptNumber = [NSNumber numberWithInteger:personType];
    NSNumber *rtNumber = [NSNumber numberWithInteger:routeType];
    
    NSNumber *ntNumber = [NSNumber numberWithInteger:type];
    NSNumber *latNumber = [NSNumber numberWithFloat:latitude];
    NSNumber *lotNumber = [NSNumber numberWithFloat:longitude];
    NSNumber *stNumber = [NSNumber numberWithInteger:seat];
    
    NSDictionary *nodes = @{@"name": name,@"address":address,@"type":ntNumber,
                            @"latitude":latNumber,@"longitude":lotNumber};
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:ptNumber forKey:@"personType"];
    [parameters setObject:rtNumber forKey:@"routeType"];
    [parameters setObject:nodes forKey:@"nodes"];
    [parameters setObject:leaveTime forKey:@"leaveTime"];
    [parameters setObject:repeat forKey:@"repeat"];
    [parameters setObject:stNumber forKey:@"seat"];
    [parameters setObject:note forKey:@"note"];
    
    if (leaveDate)
    {
        [parameters setObject:leaveDate forKey:@"leaveDate"];
    }
    
    if (backTime)
    {
        [parameters setObject:leaveDate forKey:@"backTime"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:@"http://www.egoal.cn/sharecar/api/route/create" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -自动登陆接口，通过手机号+密码
/*!
 * @method
 * @brief POST 客户端上传手机号+密码，服务端验证：
 * @see {@url} /api/login/password
 * @param  mobile 手机号码
 * @param  password 密码
 * @return
 */
- (void)requestAutoLogin:(NSString*)mobile
                password:(NSString*)password
                 success:(void(^)(id responseObject))success
                failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"mobile": mobile,@"password":password};
    [manager POST:@"http://www.egoal.cn/sharecar/api/login/password" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"JSON: %@", responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];

}


#pragma mark -注册&登陆接口，通过手机号+短信验证码
/*!
 * @method
 * @brief POST 客户端上传手机号+手机验证码，服务端验证
 * @see {@url} /api/login/sms
 * @param  mobile 手机号码
 * @param  code 短信验证码
 * @return
 */
- (void)requestLoginOrRegister:(NSString*)mobile
                          code:(NSString*)code
                       success:(void(^)(id responseObject))success
                      failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"mobile": mobile,@"code":code};
    DEBUG_METHOD(@"---parameters---%@",parameters);
    [manager POST:@"http://www.egoal.cn/sharecar/api/login/sms" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              DEBUG_METHOD(@"--%s---JSON: %@",__FUNCTION__, responseObject);
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DEBUG_METHOD(@"Error: %@", error);
              failture(error);
          }];
}


#pragma mark -获取手机验证码接口
/*!
 * @method
 * @brief GET 客户端上传手机号，服务端通过短信将验证码发送给手机：
 * @see {@url} /api/sms/code
 * @param  mobile 手机号码
 * @return
 */
- (void)requestSMS:(NSString*)mobile
           success:(void(^)(id responseObject))success
          failture:(void(^)(NSError *error))failture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"mobile":mobile};
    [manager GET:@"http://www.egoal.cn/sharecar/api/sms/code" parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             DEBUG_METHOD(@"JSON: %@", responseObject);
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             DEBUG_METHOD(@"Error: %@", error);
             failture(error);
         }];
}

@end
