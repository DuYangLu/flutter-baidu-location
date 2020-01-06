#import "BaiduLocationPlugin.h"
#import "ZTLocationPlugin.h"

@implementation BaiduLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    [ZTLocationPlugin binaryMessenger:registrar.messenger];
}
@end
