import 'package:flutter/material.dart';

import 'package:baidu_location/baidu_location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location _location;

  @override
  void initState() {
    super.initState();

    _location = Location();

    // 百度鉴权
    _location.checkPermissionWithKey('taIHANot3s0EN2KSNocsQFep972lvmkn').then((code) {
      debugPrint('百度鉴权 code: $code');
    }).catchError((error) {
      debugPrint('百度鉴权失败 error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: _requestCurrentLocation,
                child: Text('requestLocation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestCurrentLocation() async {
    try {
      // 获取定位权限
      final granted = await _location.requestLocationPermission();
      if (granted) {
        /// 判断是否获取到了android定位服务能力
        final locationServiceEnable =
            await _location.requestAndroidLocationServiceEnable();
        if (locationServiceEnable) {
          final LocationData data = await _location.requestCurrentLocation();
          debugPrint('data: ${data.toJson()}');
          return;
        }
        debugPrint('请开启GPS定位');
      }else {
        debugPrint('获取定位权限失败');
      }
    } catch (e) {
      debugPrint('e: $e');
    }

  }

  


}
