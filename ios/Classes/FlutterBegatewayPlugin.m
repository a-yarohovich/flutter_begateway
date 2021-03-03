#import "FlutterBegatewayPlugin.h"
#if __has_include(<flutter_begateway/flutter_begateway-Swift.h>)
#import <flutter_begateway/flutter_begateway-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_begateway-Swift.h"
#endif

@implementation FlutterBegatewayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBegatewayPlugin registerWithRegistrar:registrar];
}
@end
