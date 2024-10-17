//
//  StreamsApi.swift
//  flutter_contacts_plus
//
//  Created by David Londono on 2/08/23.
//
import Contacts
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

public class StreamHandler: NSObject, FlutterStreamHandler {
    
    var listent: (_ arguments: Any?, _ events: @escaping FlutterEventSink) -> FlutterError?
    var cancel: (_ arguments: Any?) -> FlutterError?

    init(listent: @escaping (_: Any?, _: @escaping FlutterEventSink) -> FlutterError?, cancel: @escaping (_: Any?) -> FlutterError?) {
        self.listent = listent
        self.cancel = cancel
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        return listent(arguments, events)
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return cancel(arguments)
    }
    
    
}


class StreamApi {
    static func setUp(binaryMessenger: FlutterBinaryMessenger, api: ContactsHostApi?) {
        let notificationCenter = NotificationCenter.default
        
        let listenContactsChannel = FlutterEventChannel(name: "dev.flutter.pigeon.com.dinastyonline.flutter_contacts_plus.ContactsHostApi.listenContacts", binaryMessenger: binaryMessenger)
        
        var token: NSObjectProtocol?
        listenContactsChannel.setStreamHandler(
            StreamHandler(listent: { (arguments,  events: @escaping FlutterEventSink) in
                token = notificationCenter.addObserver(
                    forName: NSNotification.Name.CNContactStoreDidChange,
                    object: nil,
                    queue: nil,
                    using: { _ in events(true) }
                )
                return nil
            }, cancel: { arguments in
                if let token =  token {
                    notificationCenter.removeObserver(token)
                }
                return nil
            }))
    }
}
