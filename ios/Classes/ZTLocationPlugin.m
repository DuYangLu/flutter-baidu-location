//
//  ZTLocationPlugin.m
//  Runner
//
//  Created by DuYangLu on 2019/8/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "ZTLocationPlugin.h"
#import "ZTLocationManager.h"
#import "ZTLocation.h"
#import <CoreLocation/CoreLocation.h>

// 方法通道名称
static NSString *const LOCATION_METHOD_CHANNEL_NAME = @"baidu_location";

@implementation ZTLocationPlugin

+ (void)binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    // 注册插件
    FlutterMethodChannel* methodChannel = [FlutterMethodChannel
                                           methodChannelWithName:LOCATION_METHOD_CHANNEL_NAME
                                           binaryMessenger:messenger];
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        // 响应插件中的方法
        [self handleMethodCall:call result:result];
    }];
}

+ (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    NSString *method = call.method;

    if ([method isEqualToString:@"checkPermision"]) {
        [[ZTLocationManager shared] checkPermissionWithKey:arguments[@"key"] completion:^(BMKLocationAuthErrorCode code) {
            result(@(code));
        }];
    }else if ([method isEqualToString:@"setDesiredAccuracy"]) {
        NSDictionary *dictionary = @{
                                     @"0" : @(kCLLocationAccuracyBestForNavigation),
                                     @"1" : @(kCLLocationAccuracyBest),
                                     @"2" : @(kCLLocationAccuracyNearestTenMeters),
                                     @"3" : @(kCLLocationAccuracyHundredMeters),
                                     @"4" : @(kCLLocationAccuracyKilometer),
                                     @"5" : @(kCLLocationAccuracyThreeKilometers)
                                     };
        [[ZTLocationManager shared] setDesiredAccuracy:[dictionary[arguments[@"distanceFilter"]] doubleValue]];
        result(@(1));
    }else if ([method isEqualToString:@"requestLocationPermission"]) {
        [[ZTLocationManager shared] requestPermission:^(BOOL authored) {
            result(@(authored));
        }];
    }else if ([method isEqualToString:@"requestCurrentLocation"]) {
        [[ZTLocationManager shared] requestCurrentLocation:^(ZTLocation * _Nullable location, NSString * _Nullable errorMessage) {
            if (errorMessage != nil && location == nil) {
                result([FlutterError errorWithCode:@"101" message:errorMessage details:errorMessage]);
                return ;
            }
            NSDictionary *info = @{
                                   @"latitude": @(location.latitude),
                                   @"longitude": @(location.longitude),
                                   @"province": location.province == nil ? @"" : location.province,

                                   @"city": location.city == nil ? @"" : location.city,
                                   @"district": location.district == nil ? @"" : location.district,
                                   @"street": location.street == nil ? @"" : location.street,
                                   @"streetNumber": location.streetNumber == nil ? @"" : location.streetNumber
                                   };
            result(info);
        }];
    } else {
        result([FlutterError errorWithCode:@"101" message:@"not found" details:@"方法未实现"]);
    }
}

@end
