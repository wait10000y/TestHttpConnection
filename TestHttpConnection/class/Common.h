//
//  Common.h
//  chelady
//
//  Created by wsliang on 15/4/1.
//  Copyright (c) 2015年 www.chelady.com. All rights reserved.
//

#ifndef chelady_Common_h
#define chelady_Common_h



//#ifdef TIFLOG_LEVEL_ON
//#define TifLogCommon(___modlevel_, ___modname_, ___loglevel_, ...) do { if (___modlevel_ >= (___loglevel_)) NSLog(___modname_ @"<" #___loglevel_ @"> " __VA_ARGS__); } while(0)
//#else
//#define TifLogCommon(...) {}
//#endif


#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"[%s %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"Error %@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

// ALog always displays output regardless of the DEBUG setting
#ifndef ALog
#define ALog(fmt, ...) {NSLog((@"[%s %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};
#endif


#endif






/*
 
 文章列表页;
 文章详情页;
 评论列表;
 添加评论,回复评论页;
 分享功能;
 第三方登录;
 
 圈子-话题 列表界面;
 话题详情界面(描述,新文章列表);
 发现列表界面(热门活动,只是课堂,精华内容,车女郎达人);
 热门活动页面;
 知识课堂界面(文章列表界面);
 精华内容(文章列表界面);
 车女郎达人(人物列表界面);
 
 我首页(头像,昵称,说明;文章,关注,消息,设置 table列表);
 (话题,文章,会员,tab列表)收藏列表;
 消息(列表发件箱,收件箱 table列表);
 信息列表(table列表);
 回复消息界面(对话模式);
 (我的文章,我的评论 tab列表)我的文章(申请精华功能),评论界面;
 账户安全界面(手机号,手机验证码 table列表);
 修改密码界面(原密码,新密码,重复密码 table列表);
 
 我的详情界面(头像,昵称,签名,手机号码,邮箱,qq号,真是姓名,性别,生日,地区 table列表);
 地区列表界面(二级菜单);
 头像修改界面,昵称修改界面,其他修改界面;
 设置界面(账户安全,清除图片缓存,意见反馈,检测新版本,关于车女郎,退出登录);
 意见反馈界面...
 搜索界面(section 会员,话题,文章 分类);
 发表文章界面(标题,正文,视频,图片);
 
 会员详情界面(头像,名称,粉丝,文章,关注;文章列表);
 注册界面(手机,昵称,密码,手机验证码);
 登录界面(手机/邮箱地址,密码)(忘记密码,第三方登录);
 忘记密码界面(手机号,手机验证码;新密码,重复密码);
 
 
 
 
 
 */















