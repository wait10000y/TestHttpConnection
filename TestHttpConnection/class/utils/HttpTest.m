//
//  HttpTest.m
//  chelady
//
//  Created by wsliang on 15/4/17.
//  Copyright (c) 2015年 www.chelady.com. All rights reserved.
//

#import "HttpTest.h"

#import "Common.h"
#import "HttpConnection.h"
//#import "ArticleModel.h"
#import "TMCache.h"

@implementation HttpTest


-(void)testActions:(int)theType
{
//    [self testCache];
//    [self testHttpConnect];
//    [self testPageList];
//    [self testSynHttp];
//    return;
//    
//    NSString *nowTitle = @"unknow status";
//    switch (theType) {
//        case 0:
//            [self testHttpConnect];
//            nowTitle = @"testHttpLogin";
//            break;
//        case 1:
//            [self testHttpLogin];
//            nowTitle = @"testGetImage";
//            break;
//        case 2:
//            [self testGetImage];
//            nowTitle = @"testDownloadFile";
//            break;
//        case 3:
//            [self testDownloadFile];
//            nowTitle = @"testJsonData";
//            break;
//        case 4:
//            [self testJsonData];
//            nowTitle = @"testUploadData";
//            break;
//        case 5:
//            [self testUploadData];
//            nowTitle = @"testUploadFile";
//            break;
//        case 6:
//            [self testUploadFile];
//            nowTitle = @"testHttpLogout";
//            break;
//        case 7:
//            [self testHttpLogout];
//            nowTitle = @"testHttpDisConnect";
//            break;
//        case 8:
//            [self testHttpDisConnect];
//            nowTitle = @"testHttpConnect";
//        default:
//            break;
//    }

    
}


//-(void)loadArticle
//{
//    NSDictionary *jsonDict = @{@"uid":@"uid1",
//                               @"title":@"测试标题",
//                               @"create_user_uid":@"user_uid1",
//                               @"create_time":@"2015-04-12 12:24:30"
//                               };
//    ArticleModel *aModel = [[ArticleModel alloc] initWithDictionary:jsonDict error:nil];
//    
//    DLog(@"----article:%@ -------",aModel);
//}


// ====================== test =========================
-(void)addMainQueueBlock:(void(^)(void))theBlock forKey:(NSString *)queueKey
{
    static NSMutableDictionary *tempQueueDict = nil;
    @synchronized(self){
        if (!tempQueueDict) {
            tempQueueDict = [NSMutableDictionary new];
        }
        
        NSOperation *tempOpera = [NSBlockOperation blockOperationWithBlock:^{
            theBlock();
            @synchronized(tempQueueDict){
                NSMutableArray *blocks = [tempQueueDict objectForKey:queueKey];
                if (blocks.count>0) {
                    id tBlock = [blocks lastObject];
                    [blocks removeAllObjects];
                    [[NSOperationQueue mainQueue] addOperation:tBlock];
                }
            }
        }];
        
        NSMutableArray *operas = [tempQueueDict objectForKey:queueKey];
        if (!operas) {
            operas = [NSMutableArray new];
            [tempQueueDict setObject:operas forKey:queueKey];
        }
        
        @synchronized(tempQueueDict){
            NSOperationQueue* oq = [NSOperationQueue mainQueue];
            BOOL noOpera = YES;
            if (oq.operationCount>0){
                for (NSOperation *tempOP in [oq operations]) {
                    if ([operas containsObject:tempOP]) {
                        noOpera = NO;
                        break;
                    }
                }
            }
            if (noOpera) {
                [operas removeAllObjects];
                [[NSOperationQueue mainQueue] addOperation:tempOpera];
            }else{
                [operas addObject:tempOpera];
            }
        }
    }
    
}

-(void)testCache
{
    NSString* fileUrl = @"http://static.blog.csdn.net/skin/dark1/images/body_bg.jpg";
    NSURL *url = [NSURL URLWithString:fileUrl];
    [[TMCache sharedCache] objectForKey:[url absoluteString]
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      if (object) {
                                          NSLog(@"------ load image from cache ------");
                                          //                                          [self setImageOnMainThread:(UIImage *)object];
                                          return;
                                      }
                                      
                                      NSLog(@"cache miss, requesting %@", url);
                                      
                                      NSURLResponse *response = nil;
                                      NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                      NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                                      
                                      UIImage *image = [[UIImage alloc] initWithData:data scale:[[UIScreen mainScreen] scale]];
                                      //                                      [self setImageOnMainThread:image];
                                      NSLog(@"------ load image from server ------");
                                      [[TMCache sharedCache] setObject:image forKey:[url absoluteString]];
                                  }];
}

//-(void)testSynHttp
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        HttpConnection *hc = [HttpConnection sharedObject];
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",hc.siteUrl,@"/welcome/data"];
//        NSString *errStr;
//        NSData *reData = [hc synDataWithUrl:urlString withParams:@{@"t1":@"t1Value",@"t2":@"t2value"} withError:&errStr];
//        if (errStr) {
//            NSLog(@"----- testSynHttp error:%@ -----",errStr);
//        }
//        NSLog(@"----- testSynHttp data:%@ -----",[[NSString alloc] initWithData:reData encoding:NSUTF8StringEncoding]);
//    });
//    
//}
//
//-(void)testPageList
//{
//    NSRange tempRange = NSMakeRange(1, 2);
//    HttpConnection *hc = [HttpConnection sharedObject];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@/%lu/%lu",hc.siteUrl,@"/page/item_list/article",tempRange.location,tempRange.length];
//    NSDictionary *dataParams = @{@"user_name":@"12300",@"user_pwd":@"12300"};
//    [hc jsonWithUrl:urlString withParams:dataParams complete:^(BOOL resOK, id resData, NSString *resErr) {
//        NSLog(@"---- testJsonData: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[hc transDataToJson:resData]);
//    }];
//    
//}
//
//-(void)testGetImage
//{
//    NSString* fileUrl = @"http://static.blog.csdn.net/skin/dark1/images/body_bg.jpg";
//    HttpConnection *hc = [HttpConnection sharedObject];
//    [hc imageWithUrl:fileUrl progress:^(double progress) {
//        NSLog(@"----- testGetImage: %.2f ------",progress);
//    } complete:^(BOOL resOK, UIImage *resData, NSString *resErr) {
//        if (resOK) {
//            NSLog(@"---- testGetImage: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,NSStringFromCGSize([resData size]));
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                UIImageView *iView = [[UIImageView alloc] initWithImage:resData];
//                iView.contentMode = UIViewContentModeScaleAspectFit;
//                iView.clipsToBounds = YES;
//                iView.frame = CGRectMake(10, 40, 200, 180);
////                iView.center = self.view.center;
////                [self.view addSubview:iView];
//            }];
//        }else{
//            NSLog(@"---- testGetImage: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[hc transDataToString:resData]);
//        }
//    }];
//}
//
//-(void)testDownloadFile
//{
//    NSString* fileUrl = @"http://static.blog.csdn.net/skin/dark1/images/body_bg.jpg";
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths lastObject];
//    NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:@"/download"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if (![fm fileExistsAtPath:tempPath isDirectory:nil]) {
//        [fm createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    NSString *tempFilePath = [tempPath stringByAppendingPathComponent:@"test.file"];
//    
//    HttpConnection *hc = [HttpConnection sharedObject];
//    [hc fileWithUrl:fileUrl withFilePath:tempFilePath progress:^(double progress) {
//        NSLog(@"----- testDownloadFile: %.2f ------",progress);
//    } complete:^(BOOL resOK, id resData, NSString *resErr) {
//        NSLog(@"---- testDownloadFile: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[hc transDataToString:resData]);
//    }];
//}
//
//-(void)testJsonData
//{
//    
//    HttpConnection *hc = [HttpConnection sharedObject];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",hc.siteUrl,@"/welcome/data"];
//    NSDictionary *dataParams = @{@"user_name":@"12300",@"user_pwd":@"12300"};
//    [hc jsonWithUrl:urlString withParams:dataParams complete:^(BOOL resOK, id resData, NSString *resErr) {
//        NSLog(@"---- testJsonData: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[hc transDataToJson:resData]);
//    }];
//    
//}
//
//-(void)testUploadData
//{
//    HttpConnection *hc = [HttpConnection sharedObject];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",hc.siteUrl,@"/welcome/data"];
//    NSDictionary *dataParams = @{@"user_name":@"12300",@"user_pwd":@"12300"};
//    NSDictionary *files = @{@"testData":[urlString dataUsingEncoding:NSUTF8StringEncoding],@"testStr":@"test str value"};
//    
//    [hc postFilesWithUrl:urlString withFilePaths:files withParams:dataParams progress:nil complete:^(BOOL resOK, id resData, NSString *resErr) {
//        NSLog(@"---- testUploadData: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[hc transDataToJson:resData]);
//    }];
//    
//}
//
//-(void)testUploadFile
//{
//    HttpConnection *hc = [HttpConnection sharedObject];
//    
//    NSDictionary *fileParams = @{@"uid":@"12300"};
//    NSString *tempFilePath =[[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
//    NSString *tempFilePath2 =[[NSBundle mainBundle] pathForResource:@"4" ofType:@"png"];
//    NSDictionary *files = @{@"images[]":@[tempFilePath,tempFilePath2,tempFilePath,[[NSData alloc] initWithContentsOfFile:tempFilePath2]]};
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",hc.siteUrl,@"/System_config/upload_guides"];
//    
//    [hc postFilesWithUrl:urlString withFilePaths:files withParams:fileParams progress:^(double progress) {
//        NSLog(@"----- testUploadFile: %.2f ------",progress);
//    } complete:^(BOOL resOK, id resData, NSString *resErr) {
//        NSLog(@"---- testUploadFile: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[[hc transDataToJson:resData] valueForKey:@"message"]);
//    }];
//    
//}
//
//// post
//-(void)testHttpLogin
//{
//    HttpConnection *hc = [HttpConnection sharedObject];
//    if (hc.isConnected) {
//        NSDictionary *dataParams = @{@"user_name":@"12300",@"user_pwd":@"12300"};
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",hc.siteUrl,@"/login/login"];
//        [hc postWithUrl:urlString withParams:dataParams progress:nil complete:^(BOOL resOK, id resData, NSString *resErr) {
//            NSLog(@"---- testHttpLogin: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[[hc transDataToJson:resData] valueForKey:@"message"]);
//        }];
//    }else{
//        NSLog(@"--- testHttpLogin : http连接未开启 ---");
//    }
//    
//}
//
//-(void)testHttpConnect
//{
//    HttpConnection *hc = [HttpConnection sharedObject];
//    [hc connectToServer:^(BOOL resOK, id resData, NSString *resErr) {
//        DLog(@"---- HttpConnect: %d ,resdata:%@, error:%@ ----",resOK,[hc transDataToString:resData],resErr);
//    }];
//}
//
//-(void)testHttpLogout
//{
//    HttpConnection *hc = [HttpConnection sharedObject];
//    if (hc.isConnected) {
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",hc.siteUrl,@"/login/logout"];
//        [hc postWithUrl:urlString withParams:nil progress:nil complete:^(BOOL resOK, id resData, NSString *resErr) {
//            NSLog(@"---- testHttpLogout: resOK:%d,resErr:%@,data:%@ ---",resOK,resErr,[hc transDataToString:resData]);
//        }];
//    }else{
//        NSLog(@"--- testHttpLogout : http连接未开启 ---");
//    }
//}
//
//-(void)testHttpDisConnect
//{
//    HttpConnection *hc = [HttpConnection sharedObject];
//    [hc disConnect:^(BOOL resOK, id resData, NSString *resErr) {
//        DLog(@"---- HttpDisConnect: %d ,resdata:%@, error:%@ ----",resOK,[hc transDataToString:resData],resErr);
//    }];
//}


@end
