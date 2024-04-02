//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<blue_thermal_printer/BlueThermalPrinterPlugin.h>)
#import <blue_thermal_printer/BlueThermalPrinterPlugin.h>
#else
@import blue_thermal_printer;
#endif

#if __has_include(<charset_converter/CharsetConverterPlugin.h>)
#import <charset_converter/CharsetConverterPlugin.h>
#else
@import charset_converter;
#endif

#if __has_include(<flutter_blue_plus/FlutterBluePlusPlugin.h>)
#import <flutter_blue_plus/FlutterBluePlusPlugin.h>
#else
@import flutter_blue_plus;
#endif

#if __has_include(<image_picker_ios/FLTImagePickerPlugin.h>)
#import <image_picker_ios/FLTImagePickerPlugin.h>
#else
@import image_picker_ios;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [BlueThermalPrinterPlugin registerWithRegistrar:[registry registrarForPlugin:@"BlueThermalPrinterPlugin"]];
  [CharsetConverterPlugin registerWithRegistrar:[registry registrarForPlugin:@"CharsetConverterPlugin"]];
  [FlutterBluePlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBluePlusPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
}

@end
