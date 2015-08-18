//
//  HttpClientUtils.h
//  TestHttpConnection
//
//  Created by wsliang on 15/4/27.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    HttpClientUrlBaseUrl = 0,
    HttpClientUrlSiteUrl,
    HttpClientUrlLogin,
    HttpClientUrlLogout,
    
    HttpClientUrlItemCreate,
    HttpClientUrlItemDelete,
    HttpClientUrlItemUpdate,
    HttpClientUrlItemSelect,
    HttpClientUrLItemPageList,
    
    
    HttpClientUrlListGuide,
    HttpClientUrlListInterest,
    HttpClientUrlListTopic,
    HttpClientUrlListArticle,
    HttpClientUrlListMessage,
    HttpClientUrlListUser,
    HttpClientUrlListComment,
    HttpClientUrlPageList,
    
    HttpClientUrlListGroup,
    HttpClientUrlListStatus,
    HttpClientUrlListConfig,
    
    HttpClientUrlCheckUserExist,
    HttpClientUrlAddUser,
    HttpClientUrlUpdateUser,
    HttpClientUrlUpdateUserPwd,
    HttpClientUrlUploadHeader,
    
    HttpClientUrlAddArticle,
    HttpClientUrlAddComment,
    HttpClientUrlDelComment,
    HttpClientUrlAddMessage,
    HttpClientUrlDelMessage,
    HttpClientUrlUpdateComment,
    HttpClientUrlAddFavoriteUser,
    HttpClientUrlDelFavoriteUser,
    
    
    
    
    
} HttpClientUrlType;


typedef enum : NSInteger {
    HttpItemStatusNormal = 0,
    HttpItemStatusNoPass = -1,
    HttpItemStatusLocked = -2,
    HttpItemStatusDelete = -3,
    HttpItemStatusTop = 1,
    HttpItemStatusSupport = 2,
    HttpItemStatusElite = 4,
    HttpItemStatusHot = 800
    
} HttpItemStatusType;
// 0正常,2推荐,4精华,8置顶,-1审核中,-2锁定,-3删除

@interface HttpClientUtils : NSObject
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *siteUrl;


-(NSString *)urlWithType:(HttpClientUrlType)theType;
-(NSString *)pathWithType:(HttpClientUrlType)theType;

-(NSString *)statusWithType:(HttpItemStatusType)theType;



@end
