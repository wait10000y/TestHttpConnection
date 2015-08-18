//
//  HttpClientUtils.m
//  TestHttpConnection
//
//  Created by wsliang on 15/4/27.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "HttpClientUtils.h"

@implementation HttpClientUtils
@synthesize baseUrl;
@synthesize siteUrl;

-(NSString *)pathWithType:(HttpClientUrlType)theType
{
    NSString *tempPath = @"";
    switch (theType) {
        case HttpClientUrlBaseUrl:
        {
//            tempPath = @"";
        } break;
        case HttpClientUrlSiteUrl:
        {
//            tempPath = @"";
        } break;
        case HttpClientUrlLogin:
        {
            tempPath = @"/login/login";
        } break;
        case HttpClientUrlLogout:
        {
            tempPath = @"/login/logout";
        } break;
            
            
        case HttpClientUrLItemPageList:
        {
            tempPath = @"/page/item_list/article/0/20";
        } break;
            
        case HttpClientUrlItemSelect:
        {
            tempPath = @"/item/select/article";
        } break;
        case HttpClientUrlItemDelete:
        {
            tempPath = @"/item/delete/article";
        } break;
        case HttpClientUrlItemUpdate:
        {
            tempPath = @"/item/update/article";
        } break;
        case HttpClientUrlItemCreate:
        {
            tempPath = @"/item/create/article";
        } break;
            
            
        case HttpClientUrlListGuide:
        {
            tempPath = @"/System_config/guide_list";
        } break;
        case HttpClientUrlListInterest:
        {
            tempPath = @"/topic/interest_list";
        } break;
        case HttpClientUrlListTopic:
        {
            tempPath = @"/topic/topic_list/interest_uid/20/0";
        } break;
        case HttpClientUrlListArticle:
        {
            tempPath = @"/System_config/guide_list";
        } break;
        case HttpClientUrlListMessage:
        {
            tempPath = @"/message/message_list/sender/20/0";
        } break;
        case HttpClientUrlListUser:
        {
            tempPath = @"/System_config/guide_list";
        } break;
        case HttpClientUrlListComment:
        {
            tempPath = @"/System_config/guide_list";
        } break;
            
            
        case HttpClientUrlListGroup:
        {
            tempPath = @"/System_config/guide_list";
        } break;
        case HttpClientUrlListStatus:
        {
            tempPath = @"/System_config/guide_list";
        } break;
        case HttpClientUrlListConfig:
        {
            tempPath = @"/System_config/guide_list";
        } break;
            
            
            
        case HttpClientUrlCheckUserExist:
        {
            // mobile,email,account,name_nick
            tempPath = @"/user/check_user_exist";
        } break;
        case HttpClientUrlAddUser:
        {
            tempPath = @"/user/add_user";
        } break;
        case HttpClientUrlUploadHeader:
        {
            tempPath = @"/user/update_logo";
        } break;
        case HttpClientUrlUpdateUser:
        {
            tempPath = @"/user/update";
        } break;
        case HttpClientUrlUpdateUserPwd:
        {
            tempPath = @"/user/update_pwd";
        } break;

        case HttpClientUrlAddArticle:
        {
            // interest_uid,topic_uid; 内容列表; 内容参数:title,tags,description,content
            tempPath = @"/article/article_add";
        } break;
        case HttpClientUrlAddComment:
        {
            tempPath = @"/comment/comment_add";
        } break;
        case HttpClientUrlAddFavoriteUser:
        {
            // ?item_uid=12300&item_name=wsliang
            tempPath = @"/favorite/favorite_add/user";
        } break;
        case HttpClientUrlAddMessage:
        {
            tempPath = @"/message/send_message";
        } break;
        case HttpClientUrlUpdateComment:
        {
            tempPath = @"/comment/comment_update";
        } break;
        
        case HttpClientUrlDelComment:
        {
            tempPath = @"/comment/comment_del?uid=12300";
        } break;
        case HttpClientUrlDelMessage:
        {
            tempPath = @"/System_config/guide_list";
        } break;
        case HttpClientUrlDelFavoriteUser:
        {
            tempPath = @"/favorite/favorite_del/user?uid=1230";
        } break;
        case HttpClientUrlPageList:
        {
            tempPath = @"/System_config/guide_list";
        } break;

            // /user/send_mobile_message?mobile=15618518520
            
            // /user/check_mobile_code/4391

//            /verification_image
//            get 校验图片验证码(返回1表示成功,0表示失败)
//            /verification_image/check_code/d22n
            
            
            
//            item/select/article
            
            
        default:
//            tempPath = @"";
            break;
    }
    return tempPath;
}

-(NSString*)siteUrlWithPath:(NSString*)thePath
{
    if (thePath.length>0) {
        NSString *formatStr = [thePath hasPrefix:@"/"]?@"%@%@":@"%@/%@";
        return [NSString stringWithFormat:formatStr,siteUrl,thePath];
    }
    return siteUrl;
}

//-(NSString*)baseUrlWithPath:(NSString*)thePath
//{
//    if (thePath.length>0) {
//        NSString *formatStr = [thePath hasPrefix:@"/"]?@"%@%@":@"%@/%@";
//        return [NSString stringWithFormat:formatStr,baseUrl,thePath];
//    }
//    return siteUrl;
//}

-(NSString *)urlWithType:(HttpClientUrlType)theType
{
    return [self siteUrlWithPath:[self pathWithType:theType]];
}


-(NSString *)statusWithType:(HttpItemStatusType)theType
{
    return [NSString stringWithFormat:@"%ld",theType];
}

@end
