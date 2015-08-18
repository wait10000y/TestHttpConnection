//
//  PSProfile.h
//  PaaS
//
//  Created by shiliang.wang on 14-1-17.
//  Copyright (c) 2014年 xor-media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommProfile : NSObject
@property (nonatomic,readonly) NSUserDefaults *uData;

@property (nonatomic) NSString *server_host;
@property (nonatomic) int server_port;
@property (nonatomic) NSString *server_domain;

@property (nonatomic) NSString *user_pwd;
@property (nonatomic) NSString *user_name;
@property (nonatomic) BOOL auto_login;


// ---- 公共数据区 ----

@property (nonatomic) BOOL isLogin;
@property (nonatomic) id loginUser;




+(CommProfile*)shareObject;

/**
 修改属性值的时候需要调用下面的方法
 */
-(void)setStringValue:(NSString *)theVaule forKey:(NSString*)theKey;
-(void)setIntegerValue:(NSInteger)theVaule forKey:(NSString *)theKey;
-(void)setBoolValue:(BOOL)theVaule forKey:(NSString *)theKey;
  // get stringValue
-(NSString *)stringValueForKey:(NSString *)theKey;
-(BOOL)boolValueForKey:(NSString*)theKey;
-(NSInteger)integerValueForKey:(NSString*)theKey;

/*----- base -------*/

-(void)synchronizeData;

-(void)setObject:(id)theObj forKey:(NSString*)theKey;

-(void)registerDefaults:(NSDictionary*)theVKs;

-(id)objectValueForKey:(NSString*)theKey;

@end
