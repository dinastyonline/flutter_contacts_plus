import Contacts
import ContactsUI
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

extension FlutterError: @retroactive Error {}

extension NSPredicate: @unchecked @retroactive Sendable { }

extension FlutterPluginRegistrar {
    var commonMessenger: FlutterBinaryMessenger {
        
#if os(iOS)
        return messenger()
#elseif os(macOS)
    return messenger
#else
#error("Unsupported platform.")
#endif
    }
}


public class FlutterContactsPlusPlugin: NSObject, FlutterPlugin, ContactsHostApi {
    func checkPermission(completion: @escaping (Result<PermisionsApi, any Error>) -> Void) {
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
            
            switch authorizationStatus {
            case .authorized:
                completion(.success(.granted))
            case .denied:
                completion(.success(.denied))
            case .notDetermined:
                completion(.success(.notDetermined))
            case .restricted:
                completion(.success(.restricted))
            
            @unknown default:
                completion(.success(.unknown))
            }
        }

    }
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.commonMessenger
        let api : ContactsHostApi & NSObjectProtocol = FlutterContactsPlusPlugin.init()
        ContactsHostApiSetup.setUp(binaryMessenger: messenger, api: api)
        StreamApi.setUp(binaryMessenger: messenger, api: api)
    }
    
    func checkPlist() throws {
        let hasContactPermissions = Bundle.main.object(forInfoDictionaryKey: "NSContactsUsageDescription")
        if hasContactPermissions == nil {
            throw FlutterError(code: "MISSING_PLIST_USAGE_DESCRIPTION", message: nil, details: nil)
        }
    }
    func requestPermission(completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try self.checkPlist()
                CNContactStore().requestAccess(for: .contacts, completionHandler: { (granted, err) -> Void in
                    if let error = err {
                        completion(.failure(error))
                    } else {
                        completion(.success(granted))
                    }
                })
            } catch {
                completion(.failure(error))
            }
        }
        
    }
    
    func _fetchContacts(predicate: NSPredicate?, config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                let contacts = try ContactsService.select(
                    predicate: predicate,
                    config: config
                )
                completion(Result.success(contacts))
            } catch {
                completion(Result.failure(error))
            }
        }
    }
        func getContacts(config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
            _fetchContacts(predicate: nil, config: config, completion: completion)
        }
        func getContactsWithName(name: String, config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
            _fetchContacts(predicate: CNContact.predicateForContacts(matchingName: name), config: config, completion: completion)
        }
        
        func getContactsWithEmail(email: String, config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
            _fetchContacts(predicate: CNContact.predicateForContacts(matchingEmailAddress: email), config: config, completion: completion)
        }
        
        func getContactsWithPhone(phone: String, config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
            let predicate: NSPredicate?
            if #available(iOS 11, *) {
                predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phone))
            } else {
                predicate = nil
            }
            _fetchContacts(predicate: predicate, config: config, completion: completion)
        }
        
        func getContactsWithIds(ids: [String], config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
            _fetchContacts(predicate: CNContact.predicateForContacts(withIdentifiers: ids), config: config, completion: completion)
        }
        
        func getContactsInGroup(groupId: String, config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
            _fetchContacts(predicate: CNContact.predicateForContactsInGroup(withIdentifier: groupId), config: config, completion: completion)
        }
        
        func getContactsInContainer(containerId: String, config: ContactsRequest, completion: @escaping (Result<[Contact], Error>) -> Void) {
            _fetchContacts(predicate: CNContact.predicateForContactsInContainer(withIdentifier: containerId), config: config, completion: completion)
        }
    }
