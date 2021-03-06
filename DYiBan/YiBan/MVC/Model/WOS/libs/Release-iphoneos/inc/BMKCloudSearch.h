/*
 *  BMKCloudSearch.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BMKCloudSearchInfo.h"
#import "BMKCloudPOIList.h"

@protocol BMKCloudSearchDelegate;
/// 云检索类型
enum BMKCloudSearchType
{
    BMK_NONE_SEARCH                 = 0,
    BMK_CLOUD_LOCAL_SEARCH          = 1,///<本地云检索
    BMK_CLOUD_NEARBY_SEARCH         = 2,///<周边云检索
    BMK_CLOUD_BOUND_SEARCH          = 3,///<区域云检索
    BMK_CLOUD_DETAIL_SEARCH         = 4///<POI详情
};

///云检索服务
@interface BMKCloudSearch : NSObject
/// 检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
@property (nonatomic, retain) id<BMKCloudSearchDelegate> delegate;
/**
 *本地云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)localSearchWithSearchInfo:(BMKCloudLocalSearchInfo *)searchInfo;
/**
 *周边云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)nearbySearchWithSearchInfo:(BMKCloudNearbySearchInfo *)searchInfo;
/**
 *矩形云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)boundSearchWithSearchInfo:(BMKCloudBoundSearchInfo *)searchInfo;

/**
 *详情云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiDetailResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)detailSearchWithSearchInfo:(BMKCloudDetailSearchInfo *)searchInfo;

@end

///云检索delegate，用于获取云检索结果
@protocol BMKCloudSearchDelegate<NSObject>
@optional
/**
 *返回云检索POI列表结果
 *@param poiResultList 云检索结果列表，成员类型为BMKCloudPOIList
 *@param type 返回结果类型： BMK_CLOUD_LOCAL_SEARCH,BMK_CLOUD_NEARBY_SEARCH,BMK_CLOUD_BOUND_SEARCH
 *@param error 错误号，@see BMKErrorCode
 */
- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error;

/**
 *返回云检索POI详情
 *@param poiDetailResult 类型为BMKCloudPOIInfo
 *@param type 返回结果类型： BMK_CLOUD_DETAIL_SEARCH
 *@param error 错误号，@see BMKErrorCode
 */
- (void)onGetCloudPoiDetailResult:(BMKCloudPOIInfo*)poiDetailResult searchType:(int)type errorCode:(int)error;
@end




