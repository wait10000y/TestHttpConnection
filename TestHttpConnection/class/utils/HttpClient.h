//
//  HttpClient.h
//  TestHttpConnection
//
//  Created by wsliang on 15/4/27.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClientUtils.h"
#import "HttpConnection.h"

#define HttpConnectionHeartbeatTimeInterval (10*60) // 心跳时间间隔

//@class HttpConnection;
@interface HttpClient : NSObject

@property (nonatomic,readonly) BOOL isReachable;
@property (nonatomic,readonly) BOOL isLogin;
@property (nonatomic,readonly) NSString *siteUrl;
@property (nonatomic,readonly) NSString *baseUrl;
@property (nonatomic,readonly) NSMutableDictionary *cacheDict;
@property (nonatomic,readonly) HttpConnection *connection;


+(instancetype)sharedObject;

-(void)connectToServer:(HttpCompleteBlock)theBlock;
-(void)disConnect:(HttpCompleteBlock)theBlock;


-(void)listGuidePaths:(HttpCompleteBlock)theBlock;
// user_name=12300&user_pwd=12300
-(void)userLoginWithName:(NSString*)theName withPwd:(NSString*)thePwd complete:(HttpCompleteBlock)theBlock;

-(void)listInterestWithComplete:(HttpCompleteBlock)theBlock;

-(void)listTopicWithRange:(NSRange)theRange withParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock;


-(void)listArticleWithRange:(NSRange)theRange withParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock;

-(void)listUserWithRange:(NSRange)theRange withParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock;

-(void)listMessageWithRange:(NSRange)theRange withParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock;

-(void)getArticleWithUid:(NSString*)theUid complete:(HttpCompleteBlock)theBlock;

// /item/select/article?uid=fe141a2000d26041ee5e3418934a344b
-(void)getItemWithName:(NSString*)tehName withUid:(NSString*)theUid complete:(HttpCompleteBlock)theBlock;
// /item/delete/article?uid=
-(void)deleteItemWithName:(NSString*)tehName withUid:(NSString*)theUid complete:(HttpCompleteBlock)theBlock;
// /item/update/article?uid=
-(void)updateItemWithName:(NSString*)tehName witParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock;
// /item/create/article 
-(void)addItemWithName:(NSString*)tehName witParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock;


@end
