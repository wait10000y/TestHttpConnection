//
//  HttpConnection.m
//  chelady
//
//  Created by wsliang on 15/4/10.
//  Copyright (c) 2015年 www.chelady.com. All rights reserved.
//

#import "HttpConnection.h"

#import "CommProfile.h"
#import "MKNetworkKit.h"

@interface HttpConnection()

@property (nonatomic) MKNetworkEngine *httpEngine;

@end

@implementation HttpConnection
{
//    __block BOOL hasNetwork;
}

@synthesize httpEngine;
@synthesize timeoutInterval;
//@synthesize isConnected;

//+(instancetype)sharedObject
//{
//    static dispatch_once_t token;
//    static HttpConnection *staticObject;
//    dispatch_once(&token, ^{
//        staticObject = [HttpConnection new];
//    });
//    return staticObject;
//}


- (instancetype)init
{
    return [self initWithHostName:nil withPort:0 withPath:nil];
}

-(instancetype)initWithHostName:(NSString *)theHost withPort:(int)thePort withPath:(NSString*)thePath
{
    return [self initWithHostName:theHost withPort:thePort withPath:thePath withHeaderFields:@{@"x-client-identifier" : @"IOS"}];
}

-(instancetype)initWithHostName:(NSString *)theHost withPort:(int)thePort withPath:(NSString*)thePath withHeaderFields:(NSDictionary*)theFields
{
    self = [super init];
    if (self) {
        timeoutInterval = 16; // 默认 16s超时
        httpEngine = [[MKNetworkEngine alloc] initWithHostName:theHost portNumber:thePort apiPath:thePath customHeaderFields:theFields];
        httpEngine.reachabilityChangedHandler = ^(NetworkStatus status){
            //            hasNetwork = status != NotReachable;
        };
        [httpEngine useCache];
        _host = theHost;
        _port = thePort;
        _path = thePath;
        _headerFields = theFields;
        [httpEngine isReachable]; // 检查一次网络连接情况
    }
    return self;
}

-(NSString*)findUrlStringWithPath:(NSString*)thePath ssl:(BOOL)useSSL
{
    return [httpEngine defaultUrlString:thePath ssl:useSSL];
}

-(BOOL)isConnected
{
    return httpEngine.isReachable;
}

-(void)clearData
{
    [httpEngine cancelAllOperations];
    [httpEngine emptyCache];
    httpEngine = nil;
}

#pragma arguments

 // =================== base ===================

-(MKNetworkOperation *)operationWithPath:(NSString*)thePath params:(NSDictionary *)body httpMethod:(NSString *)method
{
    if ([self isConnected]) {
        MKNetworkOperation *tempOper = [httpEngine operationWithPath:thePath params:body httpMethod:method?:@"GET"];
        if (tempOper) {
            tempOper.timeoutInterval = timeoutInterval;
//            tempOper.freezable = YES;
            [httpEngine enqueueOperation:tempOper];
            return tempOper;
        }
    }
    return nil;
}

-(MKNetworkOperation *)operationWithUrl:(NSString*)theUrl params:(NSDictionary *)body httpMethod:(NSString *)method
{
    if ([self isConnected]) {
        MKNetworkOperation *tempOper = [httpEngine operationWithURLString:theUrl params:body httpMethod:method?:@"GET"];
        if (tempOper) {
            tempOper.timeoutInterval = timeoutInterval;
//            tempOper.freezable = YES;
            [httpEngine enqueueOperation:tempOper];
            return tempOper;
        }
    }
    return nil;
}

-(void)loadDefaultSiteData:(HttpCompleteBlock)theBlock
{
    // TODO: sendHeartbeat
    DLog(@"---- sendHeartbeat -----");
//    MKNetworkOperation *oper = [httpEngine operationWithURLString:[self findUrlStringWithPath:nil ssl:NO]];
    MKNetworkOperation *oper = [self operationWithPath:nil params:nil httpMethod:nil];
    if (oper) {
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                id data = [completedOperation responseJSON];
                theBlock(YES,data,nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                NSString *errStr = [error description];
                theBlock(NO,nil,errStr);
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }
    
}

// 返回的是 data 数据;
-(void)getDataWithUrl:(NSString*)theUrl withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    MKNetworkOperation *oper = [self operationWithUrl:theUrl params:theParams httpMethod:nil];
//    MKNetworkOperation *oper = [httpEngine operationWithURLString:theUrl params:theParams];
    if (oper) {
        if (theProgress) {
            [oper onDownloadProgressChanged:theProgress];
        }
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                theBlock(YES,[completedOperation responseData],nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                theBlock(NO,nil,[error localizedDescription]);
            }];
            [oper onNotModified:^{
                theBlock(NO,nil,@"304 错误");
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }
    
}

// 返回的是 data 数据;
-(void)getDataWithUrlPath:(NSString*)theUrlPath withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    MKNetworkOperation *oper = [self operationWithPath:theUrlPath params:theParams httpMethod:nil];
//    MKNetworkOperation *oper = [httpEngine operationWithPath:theUrlPath params:theParams];
    if (oper) {
        if (theProgress) {
            [oper onDownloadProgressChanged:theProgress];
        }
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                theBlock(YES,[completedOperation responseData],nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                theBlock(NO,nil,[error localizedDescription]);
            }];
            [oper onNotModified:^{
                theBlock(NO,nil,@"304 错误");
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }
    
}

/* 读取文件,保存在path指定的文件中,绝对地址 */
-(void)getStreamWithUrl:(NSString*)theUrl withStream:(NSOutputStream*)theStream progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    MKNetworkOperation *oper = [self operationWithUrl:theUrl params:nil httpMethod:nil];
//    MKNetworkOperation *oper = [httpEngine operationWithURLString:theUrl];
    if (oper) {
        if (theProgress) {
            [oper onDownloadProgressChanged:theProgress];
        }
        if (theStream) {
            [oper addDownloadStream:theStream];
        }
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                theBlock(YES,[completedOperation responseData],nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                theBlock(NO,[completedOperation responseData],[error localizedDescription]);
            }];
            [oper onNotModified:^{
                theBlock(NO,nil,@"304 错误");
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }
    
}

-(void)postWithUrl:(NSString*)theUrl withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
//    MKNetworkOperation *oper = [httpEngine operationWithURLString:theUrl params:theParams httpMethod:@"POST"];
    MKNetworkOperation *oper =  [self operationWithUrl:theUrl params:theParams httpMethod:@"POST"];
    if (oper) {
        if (theProgress) {
            [oper onUploadProgressChanged:theProgress];
        }
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                theBlock(YES,[completedOperation responseData],nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                theBlock(NO,[completedOperation responseData],[error localizedDescription]);
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }
    
}

-(void)postWithUrlPath:(NSString*)theUrlPath withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    MKNetworkOperation *oper = [self operationWithPath:theUrlPath params:theParams httpMethod:@"POST"];
//    MKNetworkOperation *oper = [httpEngine operationWithPath:theUrlPath params:theParams httpMethod:@"POST"];
    if (oper) {
        
        if (theProgress) {
            [oper onUploadProgressChanged:theProgress];
        }
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                theBlock(YES,[completedOperation responseData],nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                theBlock(NO,[completedOperation responseData],[error localizedDescription]);
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }
}

/* post 上传file文件*/
// paths: key:索引名称,value:文件地址或者地址数组,也可以是NSData数据;
/* post 传递file,data文件,paths 文件相对地址:key:文件索引名称;value:文件地址,多个时,是个文件地址数组;也可是上传 NSData数据; */
/*
 thePaths = @{@"test1":@"/user/testFile.exe",@"img[]":@[@"/user/img1.png",@"/user/img2.png",[NSData new]],@"other_data":[NSData new]};
 */
-(void)postFilesWithUrlPath:(NSString*)theUrlPath withFilePaths:(NSDictionary*)thePaths withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    MKNetworkOperation *oper = [self operationWithPath:theUrlPath params:theParams httpMethod:@"POST"];
//    MKNetworkOperation *oper = [httpEngine operationWithPath:theUrlPath params:theParams httpMethod:@"POST"];
    if (oper) {
        
        if (theProgress) {
            [oper onUploadProgressChanged:theProgress];
        }
        //    [oper addParams:theParams];
        [thePaths enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [oper addFile:obj forKey:key];
            }else if ([obj isKindOfClass:[NSArray class]]){
                for (NSString *tempPath in obj) {
                    if ([tempPath isKindOfClass:[NSData class]]) {
                        [oper addData:(NSData*)tempPath forKey:key];
                    }else{
                        [oper addFile:tempPath forKey:key];
                    }
                }
            }else if ([obj isKindOfClass:[NSData class]]){
                [oper addData:obj forKey:key];
            }
        }];
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                NSData *tData = [completedOperation responseData];
                theBlock(YES,tData,nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                NSData *tData = [completedOperation responseData];
                theBlock(NO,tData,error.domain);
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }

}

-(void)postFilesWithUrl:(NSString*)theUrl withFilePaths:(NSDictionary*)thePaths withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    MKNetworkOperation *oper = [self operationWithUrl:theUrl params:theParams httpMethod:@"POST"];
//    MKNetworkOperation *oper = [httpEngine operationWithURLString:theUrl params:theParams httpMethod:@"POST"];
    if (oper) {
        
        if (theProgress) {
            [oper onUploadProgressChanged:theProgress];
        }
        //    [oper addParams:theParams];
        [thePaths enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [oper addFile:obj forKey:key];
            }else if ([obj isKindOfClass:[NSArray class]]){
                for (NSString *tempPath in obj) {
                    if ([tempPath isKindOfClass:[NSData class]]) {
                        [oper addData:(NSData*)tempPath forKey:key];
                    }else{
                        [oper addFile:tempPath forKey:key];
                    }
                }
            }else if ([obj isKindOfClass:[NSData class]]){
                [oper addData:obj forKey:key];
            }
        }];
        if (theBlock) {
            [oper addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                NSData *tData = [completedOperation responseData];
                theBlock(YES,tData,nil);
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                NSData *tData = [completedOperation responseData];
                theBlock(NO,tData,error.domain);
            }];
        }
//        [httpEngine enqueueOperation:oper];
    }else{
        if (theBlock) {theBlock(NO,nil,@"网络连接错误");};
    }

}

 // =================== others ===================


/* 读取图片,绝对地址 */
-(void)imageWithUrl:(NSString*)theUrl progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    [self getDataWithUrl:theUrl withParams:nil progress:theProgress complete:^(BOOL resOK, id resData, NSString *resErr) {
        if (theBlock) {
            if (resOK) {
                UIImage *tImage = nil;
                if ([resData isKindOfClass:[NSData class]]) {
                    tImage = [UIImage imageWithData:resData];
                }else if ([resData isKindOfClass:[UIImage class]]){
                    tImage = resData;
                }
                
                if (tImage.size.width>0) {
                    theBlock(YES,tImage,nil);
                }else{
                    theBlock(NO,nil,@"不是有效的图片文件");
                }
            }else{
                theBlock(resOK,resData,resErr);
            }
        }
    }];
//    [httpEngine imageAtURL:[NSURL URLWithString:theUrl] completionHandler:^(UIImage *tImage, NSURL *url, BOOL isInCache) {
//        if (tImage.size.width>0) {
//            theBlock(YES,tImage,nil);
//        }else{
//            theBlock(NO,nil,@"图片文件已损坏");
//        }
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        theBlock(NO,nil,error.domain);
//    }];

}

/* 读取文件,保存在path指定的文件中,绝对地址 */
-(void)fileWithUrl:(NSString*)theUrl withFilePath:(NSString*)thePath progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    [self getStreamWithUrl:theUrl withStream:[NSOutputStream outputStreamToFileAtPath:thePath append:YES] progress:theProgress complete:theBlock];
}

-(void)jsonWithUrl:(NSString*)theUrl withParams:(NSDictionary*)theParams complete:(HttpCompleteBlock)theBlock
{
    [self getDataWithUrl:theUrl withParams:theParams progress:nil complete:^(BOOL resOK, id resData, NSString *resErr) {
        if (theBlock) {
            if (resOK) {
                theBlock(resOK,[self transDataToJson:resData],resErr);
            }else{
                theBlock(resOK,resData,resErr);
            }
        }
    }];
}

-(void)uploadWithUrl:(NSString*)theUrl withFilePaths:(NSDictionary*)thePaths withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    [self postFilesWithUrl:theUrl withFilePaths:thePaths withParams:theParams progress:theProgress complete:theBlock];
}

-(void)pageListWithUrl:(NSString*)theUrl withRange:(NSRange)theRange withParams:(NSDictionary*)theParams progress:(HttpProgressBlock)theProgress complete:(HttpCompleteBlock)theBlock
{
    
    [self getDataWithUrl:theUrl withParams:theParams progress:theProgress complete:^(BOOL resOK, id resData, NSString *resErr) {
        
    }];
//    if (![self isConnected] || !oper) {if (theBlock) {theBlock(NO,nil,@"网络连接错误");};return;}
    
    
}


-(NSData*)synDataWithUrl:(NSString *)theUrl withParams:(NSDictionary*)theParams withError:(NSString **)theErrStr
{
    if ([self isConnected]) {
        theUrl = [NSString stringWithFormat:@"%@%@%@",theUrl,([theUrl rangeOfString:@"?"].length == 1)?@"&":@"?",[theParams urlEncodedKeyValueString]];
        NSURLResponse *response = nil;
        NSError *error;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            *theErrStr = [error localizedDescription];
        }
        return data;
    }else{
        *theErrStr = @"网络连接错误";
    }
    return nil;
}







-(NSString*)transDataToString:(id)theData
{
    NSString *tData = theData;
    if ([theData isKindOfClass:[NSData class]]) {
        tData = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    }else if(![theData isKindOfClass:[NSString class]]){
        tData = [theData description];
    }
    return tData;
}

-(id)transDataToJson:(id)theData
{
    id jsonDict = theData;
    if ([theData isKindOfClass:[NSString class]]) {
        NSData *tData = [theData dataUsingEncoding:NSUTF8StringEncoding];
        if ([NSJSONSerialization isValidJSONObject:tData]) {
            jsonDict = [NSJSONSerialization JSONObjectWithData:tData options:NSJSONReadingAllowFragments error:nil];
        }
    }else if([theData isKindOfClass:[NSData class]]){
        jsonDict = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingAllowFragments error:nil];
//        if ([NSJSONSerialization isValidJSONObject:theData]) {
//        }else{
//            jsonDict = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
//        }
    }
    return jsonDict;
}


-(long)fileSizeForDir:(NSString*)path baseSize:(long)size
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir))
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath baseSize:size];
        }
    }
    return size;
}

@end
