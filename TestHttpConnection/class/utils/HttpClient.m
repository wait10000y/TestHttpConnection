//
//  HttpClient.m
//  TestHttpConnection
//
//  Created by wsliang on 15/4/27.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "HttpClient.h"

#import "CommProfile.h"
#import "HttpConnection.h"

@interface HttpClient()

@property (nonatomic) NSTimer *keepaliveTimer;

@end

@implementation HttpClient
{
    HttpConnection *mConnection;
    NSString *mBaseUrl;
    NSString *mSiteUrl;
    HttpClientUtils *mUtils;
}

//@synthesize connection;
@synthesize baseUrl = mBaseUrl;
@synthesize siteUrl = mSiteUrl;
@synthesize connection = mConnection;


+(instancetype)sharedObject
{
    static dispatch_once_t token;
    static HttpClient *staticObject;
    dispatch_once(&token, ^{
        staticObject = [HttpClient new];
    });
    return staticObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // TODO: 配置
//        CommProfile *profile = [CommProfile shareObject];
//        mConnection = [[HttpConnection alloc] initWithHostName:profile.server_host withPort:profile.server_port withPath:profile.server_domain];
        mConnection = [[HttpConnection alloc] initWithHostName:@"www.wangshiliang.com.cn" withPort:0 withPath:@"chelady"];
//      mConnection.timeoutInterval = 16;
        mUtils = [HttpClientUtils new];
        mUtils.baseUrl = [mConnection findUrlStringWithPath:nil ssl:NO];
        mUtils.siteUrl = [mConnection findUrlStringWithPath:@"index.php" ssl:NO];
        
        _cacheDict = [NSMutableDictionary new];
    }
    return self;
}

-(void)connectToServer:(HttpCompleteBlock)theBlock
{
    [mConnection loadDefaultSiteData:^(BOOL resOK, id resData, NSString *resErr) {
        if (resOK) {
            mUtils.baseUrl = [resData objectForKey:@"base_url"];
            mUtils.siteUrl = [resData objectForKey:@"site_url"];
        }
        theBlock(resOK,resData,resErr);
    }];
}

-(void)disConnect:(HttpCompleteBlock)theBlock
{
    [self stopHeartbeat];
    [mConnection clearData];
    mSiteUrl = nil;
    mBaseUrl = nil;
    _cacheDict = nil;
    theBlock(YES,@"已断开连接",nil);
}

-(BOOL)isReachable
{
    return mConnection.isConnected;
}

-(void)stopHeartbeat
{
    if (self.keepaliveTimer) {
        if ([self.keepaliveTimer isValid]) {
            [self.keepaliveTimer invalidate];
        }
        self.keepaliveTimer = nil;
    }
}

-(void)startKeepLoginHeartbeat
{
    [self stopHeartbeat];
    self.keepaliveTimer = [NSTimer timerWithTimeInterval:HttpConnectionHeartbeatTimeInterval target:self selector:@selector(sendHeartbeat) userInfo:nil repeats:YES];
    //    self.keepaliveTimer = [NSTimer scheduledTimerWithTimeInterval:theTimeInterval target:self selector:@selector(connectToServer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.keepaliveTimer forMode:NSRunLoopCommonModes];
    //    [self.keepaliveTimer fire];
}

-(void)sendHeartbeat
{
    // TODO: 更新在线时间
    [mConnection loadDefaultSiteData:nil];
}

// =================== api ===================

-(void)listGuidePaths:(HttpCompleteBlock)theBlock
{
    NSString *guideUrl = [mUtils urlWithType:HttpClientUrlListGuide];
    [mConnection jsonWithUrl:guideUrl withParams:nil complete:^(BOOL resOK, NSDictionary *resData, NSString *resErr) {
        if ([resData isKindOfClass:[NSDictionary class]]) {
            if (((NSNumber*)[resData valueForKey:@"ret"]).boolValue) {
                NSArray *temp = [resData valueForKey:@"data"];
                temp = [temp sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                    return [obj1 compare:obj2];
                }];
                theBlock(resOK,temp,resErr);
                return;
            }
        }
        resErr = @"数据格式错误";
        theBlock(NO,nil,resErr);
    }];
    
    //    NSArray *guideList = @[
    //                           [NSString stringWithFormat:@"%@%@",guideUrl,@"0.jpg"],
    //                           [NSString stringWithFormat:@"%@%@",guideUrl,@"1.jpg"],
    //                           [NSString stringWithFormat:@"%@%@",guideUrl,@"2.jpg"],
    //                           [NSString stringWithFormat:@"%@%@",guideUrl,@"3.jpg"],
    //                           [NSString stringWithFormat:@"%@%@",guideUrl,@"4.jpg"],
    //                           [NSString stringWithFormat:@"%@%@",guideUrl,@"5.jpg"]
    //                           ];
    
    //    theBlock(YES,guideList,nil);
}

// user_name=12300&user_pwd=12300
-(void)userLoginWithName:(NSString*)theName withPwd:(NSString*)thePwd complete:(HttpCompleteBlock)theBlock
{
    if (!theName.length>0 || !thePwd.length>0) {
        theBlock(NO,nil,@"用户名,密码填写错误");
        return;
    }
    NSString *url = [mUtils urlWithType:HttpClientUrlLogin];
    NSDictionary *theParams = @{@"user_name":theName,@"user_pwd":thePwd};
    [mConnection postWithUrl:url withParams:theParams progress:nil complete:^(BOOL resOK, id resData, NSString *resErr) {
        if (resOK) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self startKeepLoginHeartbeat];
            }];
//            [self performSelectorInBackground:@selector(startKeepLoginHeartbeat) withObject:nil];
            
        }
        theBlock(resOK,[mConnection transDataToJson:resData],resErr);
    }];
}

-(void)listInterestWithComplete:(HttpCompleteBlock)theBlock
{
    NSString *url = [mUtils urlWithType:HttpClientUrlListInterest];
    
    [mConnection jsonWithUrl:url withParams:@{@"status":@"0"} complete:^(BOOL resOK, NSDictionary *resData, NSString *resErr) {
        if (resOK) {
            NSArray *list = [resData objectForKey:@"data"];
            theBlock(resOK,list,resErr);
            return ;
        }
        theBlock(resOK,resData,resErr);
    }];
    
}

-(void)listTopicWithRange:(NSRange)theRange withParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock
{
    NSString *url = [mUtils urlWithType:HttpClientUrlListTopic];
    
    [mConnection getDataWithUrl:url withParams:@{@"status":@"0"} progress:nil complete:^(BOOL resOK, NSDictionary *resData, NSString *resErr) {
        if (resOK) {
            NSArray *list = [resData objectForKey:@"data"];
            theBlock(resOK,list,resErr);
            return ;
        }
        theBlock(resOK,resData,resErr);
    }];
}




@end
