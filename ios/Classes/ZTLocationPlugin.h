//
//  ZTLocationPlugin.h
//  Runner
//
//  Created by DuYangLu on 2019/8/9.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
// 百度定位插件

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTLocationPlugin : NSObject

+ (void)binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
