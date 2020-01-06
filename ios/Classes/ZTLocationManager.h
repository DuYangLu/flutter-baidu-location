//
//  ZTLocationManager.h
//  Runner
//
//  Created by DuYangLu on 2019/8/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>

@class ZTLocation;

typedef void (^ZTPermissionRequestCompletionBlock)(BOOL authored);

typedef void (^ZTLocatingCompletionBlock)(ZTLocation * _Nullable location, NSString * _Nullable errorMessage);

typedef void (^ZTLocationCheckPermissionCompletion)(BMKLocationAuthErrorCode code);

NS_ASSUME_NONNULL_BEGIN

@interface ZTLocationManager : NSObject

// 单例
+ (instancetype)shared;

/// 启动引擎
/// @param key 申请的有效key
/// @param completion 回调是否鉴权成功
- (void)checkPermissionWithKey: (NSString *)key
                    completion: (ZTLocationCheckPermissionCompletion) completion;

// 设置定位精度
- (void)setDesiredAccuracy:(CLLocationAccuracy)accracy;

// 请求定位权限
- (void)requestPermission:(ZTPermissionRequestCompletionBlock)completion;

// 请求当前位置
- (void)requestCurrentLocation:(ZTLocatingCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
