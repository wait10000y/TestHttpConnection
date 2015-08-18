//
//  HttpConnection.h
//  chelady
//
//  Created by wsliang on 15/4/10.
//  Copyright (c) 2015年 www.chelady.com. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^HttpCompleteBlock)(BOOL resOK,id resData, NSString *resErr);
typedef void(^HttpProgressBlock)(double progress);

@interface HttpConnection : NSObject

@property (nonatomic) NSTimeInterval timeoutInterval; // 16 s
//@property (nonatomic) BOOL isEnableWWAN; // 3g时 是否使用网络 reachableOnWWAN

@property (nonatomic,readonly) BOOL isConnected;
@property (nonatomic,readonly) NSString *host;
@property (nonatomic,readonly) NSInteger port;
@property (nonatomic,readonly) NSString *path;
@property (nonatomic,readonly) NSDictionary *headerFields;


-(instancetype)init;
-(instancetype)initWithHostName:(NSString *)theHost withPort:(int)thePort withPath:(NSString*)thePath;
-(instancetype)initWithHostName:(NSString *)theHost withPort:(int)thePort withPath:(NSString*)thePath withHeaderFields:(NSDictionary*)theFields;

-(NSString*)findUrlStringWithPath:(NSString*)thePath ssl:(BOOL)useSSL;

-(void)loadDefaultSiteData:(HttpCompleteBlock)theBlock;
-(void)clearData;

-(void)getDataWithUrl:(NSString*)theUrl withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;
-(void)getStreamWithUrl:(NSString*)theUrl withStream:(NSOutputStream*)theStream progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;
-(void)postWithUrl:(NSString*)theUrl withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;
-(void)postFilesWithUrl:(NSString*)theUrl withFilePaths:(NSDictionary*)thePaths withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;


-(void)imageWithUrl:(NSString*)theUrl progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;
-(void)fileWithUrl:(NSString*)theUrl withFilePath:(NSString*)thePath progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;
-(void)jsonWithUrl:(NSString*)theUrl withParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock;
-(void)uploadWithUrl:(NSString*)theUrl withFilePaths:(NSDictionary*)thePaths withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;
-(void)pageListWithUrl:(NSString*)theUrl withRange:(NSRange)theRange withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock;

-(NSData*)synDataWithUrl:(NSString *)theUrl withParams:(NSDictionary*)theParams withError:(NSString **)theErrStr;


-(NSString*)transDataToString:(id)theData;
// 只转换NSString,NSData;
-(id)transDataToJson:(id)theData;
//计算文件夹下文件的总大小
-(long)fileSizeForDir:(NSString*)path baseSize:(long)size;

@end
