
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/contacts.g.dart';

export 'src/contacts.g.dart' ;

enum Permisions { granted, denied, restricted, unknown, notDetermined }

class ContactPlus {
  ContactPlus(Contact contact): 
  id = contact.id,
  displayName = contact.displayName,
  isStarred = contact.isStarred,
  name = contact.name,
  thumbnail = contact.thumbnail,
  photo = contact.photo,
  phones = contact.phones._whereNotNull().toList(),
  emails = contact.emails._whereNotNull().toList(),
  addresses = contact.addresses._whereNotNull().toList(),
  organizations = contact.organizations._whereNotNull().toList(),
  websites = contact.websites._whereNotNull().toList(),
  socialMedias = contact.socialMedias._whereNotNull().toList(),
  events = contact.events._whereNotNull().toList(),
  notes = contact.notes._whereNotNull().toList(),
  accounts = contact.accounts._whereNotNull().toList(),
  groups = contact.groups._whereNotNull().toList();

  String id;
  String displayName;
  bool isStarred;
  Name? name;
  Uint8List? thumbnail;
  Uint8List? photo;
  List<Phone> phones;
  List<Email> emails;
  List<Address> addresses;
  List<Organization> organizations;
  List<Website> websites;
  List<SocialMedia> socialMedias;
  List<Event> events;
  List<Note> notes;
  List<Account> accounts;
  List<Group> groups;
}

class ContactsPluginError extends Error {
  final String message;
  ContactsPluginError(this.message);
  @override
  String toString() => message;
}
class MissingPlistUsageDescriptionError extends ContactsPluginError {
  MissingPlistUsageDescriptionError() : super("Missing plist usage description");
}
class FlutterContactsPlus {
  static final api = ContactsHostApi();
  Future<Permisions> checkPermission() async {
    final permission = await api.checkPermission();

    return switch (permission) {
       PermisionsApi.granted => Permisions.granted,
       PermisionsApi.denied => Permisions.denied,
       PermisionsApi.restricted => Permisions.restricted,
       PermisionsApi.notDetermined => Permisions.notDetermined,
       PermisionsApi.unknown => Permisions.unknown,
    };
  }
  Future<List<ContactPlus>> getContacts({
    bool withProperties = true,
    bool withThumbnail = false,
    bool withPhoto = false,
    bool withGroups = false,
    bool withAccounts = false,
    bool returnUnifiedContacts = false,
    bool includeNotesOnIos13AndAbove = false,
  }) => api.getContacts(ContactsRequest(
    withProperties: withProperties,
    withThumbnail: withThumbnail,
    withPhoto: withPhoto,
    withGroups: withGroups,
    withAccounts: withAccounts,
    returnUnifiedContacts: returnUnifiedContacts,
    includeNotesOnIos13AndAbove: includeNotesOnIos13AndAbove,
  )).then((value) => value._whereNotNull().map(ContactPlus.new).toList());
  Future<bool> requestPermission() => api.requestPermission().onError<PlatformException>((error, stackTrace) {
    if (error.code == "MISSING_PLIST_USAGE_DESCRIPTION") {
      if (kDebugMode) {
        print("Missing NSContactsUsageDescription key on Info.plist");
      }
      throw MissingPlistUsageDescriptionError();
    }
    throw error;
  });

  late final _eventChanneListenContacts = const EventChannel("dev.flutter.pigeon.com.dinastyonline.flutter_contacts_plus.ContactsHostApi.listenContacts");
  late final _stream = _eventChanneListenContacts.receiveBroadcastStream();

  Stream<bool> listent() {
    return _stream.map((event) => event as bool);
  }
}

extension IterableNullableExtension<T extends Object> on Iterable<T?> {
  /// The non-`null` elements of this `Iterable`.
  ///
  /// Returns an iterable which emits all the non-`null` elements
  /// of this iterable, in their original iteration order.
  ///
  /// For an `Iterable<X?>`, this method is equivalent to `.whereType<X>()`.
   Iterable<T> _whereNotNull() sync* {
    for (var element in this) {
      if (element != null) yield element;
    }
  }
}