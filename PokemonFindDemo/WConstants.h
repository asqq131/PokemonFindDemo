//
//  WConstantss.h
//  ZWScrollTableViewCtrlDemo
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#ifndef WConstantss_h
#define WConstantss_h

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#ifdef __OBJC__

//#import "AFHTTPRequest.h"
//#import "UIView+FixRatio.h"

#endif

#define _SHOW_DEBUG_LOG_
#ifdef _SHOW_DEBUG_LOG_
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#define kMainAPIDomain @""
#define kAppItunesId @""

#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kColorRGB(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#define kIsIOS9Later [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define kIsIOS8Later [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define kIsIOS7Later [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
//NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenSize [UIScreen mainScreen].applicationFrame.size

#define kIsIphone4s (kScreenSize.height == (480-20))
#define kIsIphone5 (kScreenSize.height == (568-20))

#define kFixRatioHeightByIphone6(H) (H / 647.0) * [UIScreen mainScreen].applicationFrame.size.height
#define kFixRatioWidthByIphone6(W) (W / 375.0) * [UIScreen mainScreen].applicationFrame.size.width

#define kNetworkConnectFailTip @"网络连接失败!"
#define kEmptyDataTip @"当前没有更多的数据!"
#define kServerRequestFailTip  @"服务器无响应"

// 图片路径
#define kResourceSrcName(file) [@"ResourceImages.bundle" stringByAppendingPathComponent:file]

// 通知
#define kNotificationNameByMenuSelected @"MenuSelectedNotification"

#endif /* WConstantss_h */
