#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint baidu_location.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'baidu_location'
  s.version          = '0.0.1'
  s.summary          = '百度定位插件'
  s.description      = '定位功能的插件：使用百度定位'
  
  s.homepage         = 'https://github.com/DuYangLu/flutter-baidu-location'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'example.com' => '2365178852@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  s.dependency 'BMKLocationKit'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
