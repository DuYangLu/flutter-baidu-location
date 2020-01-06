
/// 定位数据
class LocationData {
  /// 纬度
  double latitude;

  /// 经度
  double longitude;

  ///省份名字属性
  String province;

  ///城市名字属性
  String city;

  ///区名字属性
  String district;

  /// 乡镇
  String town;

  ///街道名字
  String street;

  ///街道号码
  String streetNumber;

  /// 地址名称
  String addresss;

  LocationData(
      {this.latitude,
      this.longitude,
      this.province,
      this.city,
      this.district,
      this.street,
      this.streetNumber,
      this.addresss});

  factory LocationData.fromMap(Map<dynamic, dynamic> dataMap) {
    return LocationData(
        latitude: dataMap['latitude'] ?? 0,
        longitude: dataMap['longitude'] ?? 0,
        province: dataMap['province'] ?? '',
        city: dataMap['city'] ?? '',
        district: dataMap['district'] ?? '',
        street: dataMap['street'] ?? '',
        streetNumber: dataMap['streetNumber'] ?? '',
        addresss: dataMap['addresss'] ?? '');
  }

  Map<String, Object> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'province': province,
      'city': city,
      'district': district,
      'town': town,
      'street': street,
      'streetNumber': streetNumber,
      'addresss': addresss,
    };
  }
}