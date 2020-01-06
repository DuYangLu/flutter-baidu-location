# baidu_location
定位插件，提供基于百度定位sdk的定位能力。

## 准备工作
* 在[百度地图开放平台](http://lbsyun.baidu.com)申请应用key。
* 在原生应用中向系统申请定位能力。如下图在iOS应用使用的时候申请定位能力。
![lEOqC6.jpg](https://s2.ax1x.com/2019/12/27/lEOqC6.jpg)

## 添加依赖
工程的yaml文件中添加以下依赖.

```
dependencies:
  baidu_location:
    git:
      url: https://github.com/DuYangLu/flutter-baidu-location
```

## 使用

### 百度鉴权
```
_location = Location();
_location.checkPermissionWithKey(‘¥key’).then((code) {
      debugPrint('百度鉴权 code: $code');
    }).catchError((error) {
      debugPrint('百度鉴权失败 error: $error');
    });
```

### 获取定位权限
```
final granted = await _location.requestLocationPermission();
```

### 获取定位服务能力
仅在android上需要

```
final locationServiceEnable =
            await _location.requestAndroidLocationServiceEnable()
```

### 设定定位精确度

```
_location.setDesiredAccuracy(accuracy: LocationAccuracy.best);
```

### 获取当前位置

```
final LocationData data = await _location.requestCurrentLocation();
```