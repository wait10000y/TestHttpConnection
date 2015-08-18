//
//  MKNetworkKit.h
//  MKNetworkKit
//
//  Created by Mugunth Kumar (@mugunthkumar) on 11/11/11.
//  Copyright (C) 2011-2020 by Steinlogic Consulting and Training Pte Ltd

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


/*
 MKNetworkKit 是一个使用十分方便，功能又十分强大、完整的iOS网络编程代码库。它只有两个类, 它的目标是使用像AFNetworking这么简单，而功能像ASIHTTPRequest(已经停止维护)那么强大。它除了拥有AFNetworking和ASIHTTPRequest所有功能以外，还有一些新特色，包括：
 
 源码：https://github.com/mugunthkumar/mknetworkkit
 how to use: http://blog.mugunthkumar.com/products/ios-framework-introducing-mknetworkkit/
 
 1、高度的轻量级，仅仅只有2个主类
 2、自主操作多个网络请求
 3、更加准确的显示网络活动指标
 4、自动设置网络速度，实现自动的2G、3G、wifi切换
 5、自动缓冲技术的完美应用，实现网络操作记忆功能，当你掉线了又上线后，会继续执行未完成的网络请求
 6、可以实现网络请求的暂停功能
 7、准确无误的成功执行一次网络请求，摒弃后台的多次请求浪费
 8、支持图片缓冲
 9、支持ARC机制
 10、在整个app中可以只用一个队列（queue），队列的大小可以自动调整
 
 MKNetworkKit的部署:
 下载地址: https://github.com/MugunthKumar/MKNetworkKit/
 将下载包中的 MKNetWorkKit 文件夹拖到你新建的工程中。添加：SystemConfiguration.framework，CFNetwork.framework，Security.framework和ImageIO.framework。
 
 注意:
 1. HostName不需要加”http://”, 程序会自动添加, 主机要指向一个目录, 不可以是一个具体文件, 如上类不可以是”www.***.net/json/conn.asp”
 2. 最新版的MKNetworkKit与目前网上介绍的版本不同, 方法也发生变化;
 
 */

#ifndef MKNetworkKit_MKNetworkKit_h
#define MKNetworkKit_MKNetworkKit_h

#ifndef __IPHONE_4_0
#error "MKNetworkKit uses features only available in iOS SDK 4.0 and later."
#endif

#if TARGET_OS_IPHONE
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
#define DO_GCD_RETAIN_RELEASE 0
#else
#define DO_GCD_RETAIN_RELEASE 1
#endif
#endif

#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
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
#define ALog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};
#endif

#import "MKNetworkKit/Categories/NSString+MKNetworkKitAdditions.h"
#import "MKNetworkKit/Categories/NSDictionary+RequestEncoding.h"
#import "MKNetworkKit/Categories/NSDate+RFC1123.h"
#import "MKNetworkKit/Categories/NSData+MKBase64.h"
#import "MKNetworkKit/Categories/UIImageView+MKNetworkKitAdditions.h"
#if TARGET_OS_IPHONE
#import "MKNetworkKit/Categories/UIAlertView+MKNetworkKitAdditions.h"
#elif TARGET_OS_MAC
//#import "MKNetworkKit/Categories/NSAlert+MKNetworkKitAdditions.h"
#endif

#import "MKNetworkKit/Reachability/Reachability.h"

#import "MKNetworkOperation.h"
#import "MKNetworkEngine.h"

#define kMKNetworkEngineOperationCountChanged @"kMKNetworkEngineOperationCountChanged"
#define MKNETWORKCACHE_DEFAULT_COST 10
#define MKNETWORKCACHE_DEFAULT_DIRECTORY @"MKNetworkKitCache"
#define kMKNetworkKitDefaultCacheDuration 60 // 1 minute
#define kMKNetworkKitDefaultImageHeadRequestDuration 3600*24*1 // 1 day (HEAD requests with eTag are sent only after expiry of this. Not that these are not RFC compliant, but needed for performance tuning)
#define kMKNetworkKitDefaultImageCacheDuration 3600*24*7 // 1 day

// if your server takes longer than 30 seconds to provide real data,
// you should hire a better server developer.
// on iOS (or any mobile device), 30 seconds is already considered high.

#define kMKNetworkKitRequestTimeOutInSeconds 30
#endif


