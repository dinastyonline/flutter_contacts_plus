#ifndef FLUTTER_PLUGIN_FLUTTER_CONTACTS_PLUS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_CONTACTS_PLUS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_contacts_plus {

class FlutterContactsPlusPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterContactsPlusPlugin();

  virtual ~FlutterContactsPlusPlugin();

  // Disallow copy and assign.
  FlutterContactsPlusPlugin(const FlutterContactsPlusPlugin&) = delete;
  FlutterContactsPlusPlugin& operator=(const FlutterContactsPlusPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_contacts_plus

#endif  // FLUTTER_PLUGIN_FLUTTER_CONTACTS_PLUS_PLUGIN_H_
