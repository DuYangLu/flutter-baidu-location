//
//  ZTLocation.h
//  Runner
//
//  Created by DuYangLu on 2019/8/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTLocation : NSObject
// 纬度
@property (nonatomic, assign) CLLocationDegrees latitude;
// 经度
@property (nonatomic, assign) CLLocationDegrees longitude;

///省份名字属性
@property(nonatomic, copy) NSString *province;

///城市名字属性
@property(nonatomic, copy) NSString *city;

///区名字属性
@property(nonatomic, copy) NSString *district;

///街道名字属性
@property(nonatomic, copy) NSString *street;

///街道号码属性
@property(nonatomic, copy) NSString *streetNumber;
@end

NS_ASSUME_NONNULL_END
