//
//  ZTLocationManager.m
//  Runner
//
//  Created by DuYangLu on 2019/8/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "ZTLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ZTLocation.h"


@interface ZTLocationManager () <CLLocationManagerDelegate, BMKLocationAuthDelegate>

// 百度定位管理类
@property (nonatomic, strong) BMKLocationManager *locationManager;
// 系统定位管理类
@property (nonatomic, strong) CLLocationManager *sLocationManager;

// 启动引擎回调
@property (nonatomic, copy) ZTLocationCheckPermissionCompletion kCheckBaiduCompletion;

// 请求定位回调
@property (nonatomic, copy) ZTPermissionRequestCompletionBlock kPermissionCompletion;

// 逆地理编码回调表（key是经纬度拼接）
@property (nonatomic, strong) NSMutableDictionary *kReverseGeoCodInfo;
@end

@implementation ZTLocationManager

// MARK: - Public methods

// 单例
+ (instancetype)shared {
    static ZTLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZTLocationManager alloc] init];
    });
    return manager;

}

/// 启动引擎
/// @param key 申请的有效key
/// @param completion 回调是否鉴权成功
- (void)checkPermissionWithKey: (NSString *)key
                    completion: (ZTLocationCheckPermissionCompletion)completion {
    _kCheckBaiduCompletion = completion;
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key authDelegate:self];
}

// 设置设定定位精度
- (void)setDesiredAccuracy:(CLLocationAccuracy)accracy {
    _locationManager.desiredAccuracy = accracy;
}

// 请求定位权限
- (void)requestPermission:(ZTPermissionRequestCompletionBlock)completion {
    /// 已经有权限
    if ([self authored]) {
        completion(YES);
        return;
    }

    /// 还没有请求过权限
    if ([self notDeterminded]) {
        self.kPermissionCompletion = completion;
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil) {
            self.sLocationManager.delegate = self;
            [self.sLocationManager requestWhenInUseAuthorization];
        }else if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil) {
            self.sLocationManager.delegate = self;
            [self.sLocationManager requestAlwaysAuthorization];
        }else {
            [NSException raise:NSInternalInconsistencyException format:@"To use location in iOS8 and above you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file"];
        }
        return;
    }

    /// 没有权限
    completion(NO);
}

// 请求当前位置
- (void)requestCurrentLocation:(ZTLocatingCompletionBlock)completion {
    if (![self authored]) {
        completion(nil, @"没有权限");
        return;
    }
    if ([self notDeterminded]) {
        completion(nil, @"请先调用requestPermission:函数获取权限");
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error != nil) {
            completion(nil, error.localizedDescription);
            return ;
        }

        //
        ZTLocation *ztlocation = [[ZTLocation alloc] init];
        ztlocation.latitude = location.location.coordinate.latitude;
        ztlocation.longitude = location.location.coordinate.longitude;

        ztlocation.province = [weakSelf invalidCheck:location.rgcData.province];
        ztlocation.city = [weakSelf invalidCheck:location.rgcData.city];
        ztlocation.district = [weakSelf invalidCheck:location.rgcData.district];
        ztlocation.street = [weakSelf invalidCheck:location.rgcData.street];
        ztlocation.streetNumber = [weakSelf invalidCheck:location.rgcData.streetNumber];

        completion(ztlocation, nil);
    }];
}

- (NSString *)invalidCheck:(NSString *)str {
    if (str != nil) {
        return str;
    }
    return @"";
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        // The user denied authorization
        NSLog(@"User denied permissions");

        if (self.kPermissionCompletion) {
            self.kPermissionCompletion(NO);
        }
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse
             || status == kCLAuthorizationStatusAuthorizedAlways) {
        if (self.kPermissionCompletion) {
            self.kPermissionCompletion(YES);
        }
        NSLog(@"User granted permissions");
    }
}

#pragma mark - BMKLocationAuthDelegate

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    if (self.kCheckBaiduCompletion) {
        self.kCheckBaiduCompletion(iError);
    }
}

// MARK: - Private methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.locationTimeout = 10;
        _locationManager.reGeocodeTimeout = 10;

        _sLocationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

// 已经认证
- (BOOL)authored {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return  status == kCLAuthorizationStatusAuthorizedWhenInUse
    || status == kCLAuthorizationStatusAuthorizedAlways;
}

// 未处理
- (BOOL)notDeterminded {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return  status == kCLAuthorizationStatusNotDetermined;
}

// 经纬度拼接的key
- (NSString *)keyWithLocation:(CLLocationCoordinate2D)location {
    NSString *key = [NSString stringWithFormat:@"%f-%f", location.latitude, location.longitude];
    return key;
}

#pragma mark - Lazy methods

- (NSMutableDictionary *)kReverseGeoCodInfo {
    if (!_kReverseGeoCodInfo) {
        _kReverseGeoCodInfo = [[NSMutableDictionary alloc] init];
    }
    return _kReverseGeoCodInfo;
}

@end
