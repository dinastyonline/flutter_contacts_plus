import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/contacts.g.dart',
    dartOptions: DartOptions(),
    cppOptions: CppOptions(namespace: 'pigeon_example'),
    cppHeaderOut: 'windows/include/contacts.g.h',
    cppSourceOut: 'windows/include/contacts.g.cpp',
    kotlinOut:
        'android/src/main/kotlin/com/dinastyonline/flutter_contacts_plus/Contacts.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.dinastyonline.flutter_contacts_plus'
    ),
    swiftOut: 'apple/Classes/Contacts.g.swift',
    swiftOptions: SwiftOptions(),
    // copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'com.dinastyonline.flutter_contacts_plus',
  ),
)
class Name {
  Name({
    required this.first,
    required this.last,
    required this.middle,
    required this.prefix,
    required this.suffix,
    required this.nickname,
    required this.firstPhonetic,
    required this.lastPhonetic,
    required this.middlePhonetic,
  });
  String first;
  String last;
  String middle;
  String prefix;
  String suffix;
  String nickname;
  String firstPhonetic;
  String lastPhonetic;
  String middlePhonetic;
}

class Phone {
  Phone({
    required this.number,
    required this.normalizedNumber,
    required this.label,
    required this.customLabel,
    required this.isPrimary,
  });
  String number;
  String normalizedNumber;
  // one of: assistant, callback, car, companyMain, faxHome, faxOther, faxWork, home,
  // iPhone, isdn, main, mms, mobile, pager, radio, school, telex, ttyTtd, work,
  // workMobile, workPager, other, custom
  String label;
  String customLabel;
  // not supported on iOS
  bool isPrimary;
}

class Email {
  Email({
    required this.address,
    required this.label,
    required this.customLabel,
    required this.isPrimary,
  });
  String address;
  String label;
  String customLabel;
  bool isPrimary;
}

class Address {
  Address({
    required this.address,
    required this.label,
    required this.customLabel,
    required this.street,
    required this.pobox,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isoCountry,
    required this.subAdminArea,
    required this.subLocality,
  });
  String address;
  String label;
  String customLabel;
  String street;
  String pobox;
  String neighborhood;
  String city;
  String state;
  String postalCode;
  String country;
  String isoCountry;
  String subAdminArea;
  String subLocality;
}

class Organization {
  Organization({
    required this.company,
    required this.title,
    required this.department,
    required this.jobDescription,
    required this.symbol,
    required this.phoneticName,
    required this.officeLocation,
  });
  String company;
  String title;
  String department;
  String jobDescription;
  String symbol;
  String phoneticName;
  String officeLocation;
}

class Website {
  Website({
    required this.url,
    required this.label,
    required this.customLabel,
  });
  String url;
  // one of: blog, ftp, home, homepage, profile, school, work, other, custom
  String label;
  String customLabel;
}

class SocialMedia {
  SocialMedia({
    required this.userName,
    required this.label,
    required this.customLabel,
  });
  String userName;
  // one of: aim, baiduTieba, discord, facebook, flickr, gaduGadu, gameCenter,
  // googleTalk, icq, instagram, jabber, line, linkedIn, medium, messenger, msn,
  // mySpace, netmeeting, pinterest, qqchat, qzone, reddit, sinaWeibo, skype,
  // snapchat, telegram, tencentWeibo, tikTok, tumblr, twitter, viber, wechat,
  // whatsapp, yahoo, yelp, youtube, zoom, other, custom
  String label;
  String customLabel;
}

class Event {
  Event({
    required this.year,
    required this.month,
    required this.day,
    required this.label,
    required this.customLabel,
  });
  int? year;
  int month;
  int day;
  // one of: anniversary, birthday, other, custom
  String label;
  String customLabel;
}

class Note {
  Note({
    required this.note,
  });
  String note;
}

class Account {
  Account({
    required this.rawId,
    required this.name,
    required this.type,
    required this.mimetypes,
  });
  String rawId;
  String name;
  String type;
  List<String?> mimetypes;
}

class Group {
  Group({required this.id, required this.name});
  String id;
  String name;
}

class Contact {
  Contact(
      {required this.name,
      required this.id,
      required this.displayName,
      required this.isStarred,
      required this.thumbnail,
      required this.photo,
      required this.phones,
      required this.emails,
      required this.addresses,
      required this.organizations,
      required this.websites,
      required this.socialMedias,
      required this.events,
      required this.notes,
      required this.accounts,
      required this.groups});
  String id;
  String displayName;
  bool isStarred;
  Name? name;
  Uint8List? thumbnail;
  Uint8List? photo;
  List<Phone?> phones;
  List<Email?> emails;
  List<Address?> addresses;
  List<Organization?> organizations;
  List<Website?> websites;
  List<SocialMedia?> socialMedias;
  List<Event?> events;
  List<Note?> notes;
  List<Account?> accounts;
  List<Group?> groups;
}

class ContactsRequest {
  ContactsRequest({
     this.withProperties = false,
     this.withThumbnail = false,
     this.withPhoto = false,
     this.withGroups = false,
     this.withAccounts = false,
     this.returnUnifiedContacts = false,
     this.includeNotesOnIos13AndAbove = false,
  });
  bool withProperties;
  bool withThumbnail;
  bool withPhoto;
  bool withGroups;
  bool withAccounts;
  bool returnUnifiedContacts;
  bool includeNotesOnIos13AndAbove;
}


@HostApi()
abstract class ContactsHostApi {
  @async
  List<Contact> getContacts(ContactsRequest config);

  @async
  List<Contact> getContactsWithName(String name,ContactsRequest config);

  @async
  List<Contact> getContactsWithEmail(String email,ContactsRequest config);

  @async
  List<Contact> getContactsWithPhone(String phone,ContactsRequest config);

  @async
  List<Contact> getContactsWithIds(List<String> ids,ContactsRequest config);

  @async
  List<Contact> getContactsInGroup(String groupId,ContactsRequest config);

  @async
  List<Contact> getContactsInContainer(String containerId,ContactsRequest config);

  @async
  String checkPermission();


  @async
  bool requestPermission();
}
