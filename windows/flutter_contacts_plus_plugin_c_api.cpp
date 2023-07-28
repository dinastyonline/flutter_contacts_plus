#include "include/flutter_contacts_plus/flutter_contacts_plus_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_contacts_plus_plugin.h"

void FlutterContactsPlusPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_contacts_plus::FlutterContactsPlusPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
