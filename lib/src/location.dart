import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'location_accuracy.dart';
import 'location_data.dart';
import 'location_auth_code.dart';

/// 定位
class Location {
  /// 通道名称
  static const MethodChannel _channel =
      const MethodChannel('baidu_location');

  /// 该通道下所有可用的方法名称
  final _checkPermision = 'checkPermision';
  final _setDesiredAccuracy = 'setDesiredAccuracy';
  final _requestLocationPermission = 'requestLocationPermission';
  final _requestLocationEnable = 'requestLocationEnable';
  final _requestCurrentLocation = 'requestCurrentLocation';

  /// 启动引擎
  /// 
  /// key：申请的有效key
  /// 返回值是鉴权结果状态码
  Future<LocationAuthCode> checkPermissionWithKey(String key) async {
    try {
      final int code = await _channel
        .invokeMethod(_checkPermision, {'key': key});
      debugPrint('code: $code');
      LocationAuthCode result;
      if (code == -1) {
        result = LocationAuthCode.unknown;
      }else if (code == 0) {
        result = LocationAuthCode.success;
      }else if (code == 1) {
        result = LocationAuthCode.networkFailed;
      }else {
        result = LocationAuthCode.failed;
      }
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  ///设定定位精度
  Future<bool> setDesiredAccuracy(
      {LocationAccuracy accuracy = LocationAccuracy.nearestTenMeters}) {
    return _channel
        .invokeMethod(_setDesiredAccuracy, {'distanceFilter': accuracy.index});
  }

  /// 请求权限。如果用户没有给予权限则返回false，如果没有进行过权限请求，会首先进行权限请求。
  Future<bool> requestLocationPermission() {
    return _channel.invokeMethod(_requestLocationPermission);
  }

  /// 请求定位服务能力，仅在android上使用。
  Future<bool> requestAndroidLocationServiceEnable() {
    if (Platform.isAndroid) {
      return _channel.invokeMethod(_requestLocationEnable);
    }
    return Future.value(true);
  }

  /// 请求当前位置
  Future<LocationData> requestCurrentLocation() {
    return _channel.invokeMethod(_requestCurrentLocation).then((result) => LocationData.fromMap(result));
  }

}