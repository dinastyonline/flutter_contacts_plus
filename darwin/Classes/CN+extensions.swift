//
//  CN+extensions.swift
//  flutter_contacts_plus
//
//  Created by David Londono on 28/07/23.
//

import Contacts
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

extension CNContainer {
  func toAccount() -> Account {
    let type: String
    switch self.type {
    case .local:
      type = "local"
    case .exchange:
      type = "exchange"
    case .cardDAV:
      type = "cardDAV"
    case .unassigned:
      type = "unassigned"
    default:
      type = "unassigned"
    }
    return Account(rawId: identifier, name: name, type: type, mimetypes: [String]())
  }
}

var addressFormatter = CNPostalAddressFormatter()
extension CNLabeledValue<CNPostalAddress> {
  func toAdress() -> Address {
    var label = "home"
    var customLabel = ""
    switch self.label {
    case CNLabelHome:
      label = "home"
    case CNLabelWork:
      label = "work"
    case CNLabelOther:
      label = "other"
    default:
      if #available(iOS 13, macOS 10.15, *), self.label == CNLabelSchool {
        label = "school"
      } else {
        label = "custom"
        customLabel = self.label ?? ""
      }
    }
    var subAdminArea = ""
    var subLocality = ""
    if #available(iOS 13, *) {
      subAdminArea = value.subAdministrativeArea
      subLocality = value.subLocality
    }
    return Address(
      address: addressFormatter.string(from: value), label: label, customLabel: customLabel,
      street: value.street, pobox: "", neighborhood: "", city: value.city, state: value.state,
      postalCode: value.postalCode, country: value.country, isoCountry: value.isoCountryCode,
      subAdminArea: subAdminArea, subLocality: subLocality)

  }

}

extension CNLabeledValue<NSString> {
  func toEmail() -> Email {
    var label = ""
    var customLabel = ""
    switch self.label {
    case CNLabelHome:
      label = "home"
    case CNLabelEmailiCloud:
      label = "iCloud"
    case CNLabelWork:
      label = "work"
    case CNLabelOther:
      label = "other"
    default:
      if #available(iOS 13, macOS 10.15, *), self.label == CNLabelSchool {
        label = "school"
      } else {
        label = "custom"
        customLabel = self.label ?? ""
      }
    }
    return Email(address: value as String, label: label, customLabel: customLabel, isPrimary: false)
  }
}

extension CNContact {
  func toEvent() -> Event {
    // It seems like NSDateComponents use 2^64-1 as a value for year when there is
    // no year. This should cover similar edge cases.
    let y = birthday!.year
    let year = (y == nil || y! < -100_000 || y! > 100_000) ? nil : y?.int64
    return Event(
      year: year, month: (birthday!.month ?? 1).int64, day: (birthday!.day ?? 1).int64,
      label: "birthday", customLabel: "")
  }
    func toName() -> Name {
        return Name(first: givenName, last: familyName, middle: middleName, prefix: namePrefix, suffix: nameSuffix, nickname: nickname, firstPhonetic: phoneticGivenName, lastPhonetic: phoneticFamilyName, middlePhonetic: phoneticMiddleName)
    }
    func toNote() -> Note {
        return Note(note: note)
    }
    func toOrganization() -> Organization {
        var phoneticName = ""
        if #available(iOS 10, *) {
                    phoneticName = phoneticOrganizationName
                }
        
        // jobDescription, symbol and officeLocation not supported
        return Organization(company: organizationName, title: jobTitle, department: departmentName, jobDescription: "", symbol: "", phoneticName: phoneticName, officeLocation: "")
    }
}

extension CNLabeledValue<NSDateComponents> {

  func toEvent() -> Event {
    // It seems like NSDateComponents use 2^64-1 as a value for year when there is
    // no year. This should cover similar edge cases.
    let y = value.year
    let year = (y < -100_000 || y > 100_000) ? nil : y.int64
    var label = ""
    var customLabel = ""
    switch self.label {
    case CNLabelDateAnniversary:
      label = "anniversary"
    case CNLabelOther:
      label = "other"
    default:
      label = "custom"
      customLabel = self.label ?? ""
    }
    return Event(
      year: year, month: value.month.int64, day: value.day.int64, label: label,
      customLabel: customLabel)
  }
}

extension CNGroup {
    func toGroup() -> Group {
        return Group(id: identifier, name: name)
    }
}

extension CNLabeledValue<CNPhoneNumber> {
    func toPhone() -> Phone {
        var label = ""
        var customLabel = ""
        switch self.label {
                case CNLabelPhoneNumberHomeFax:
                    label = "faxHome"
                case CNLabelPhoneNumberOtherFax:
                    label = "faxOther"
                case CNLabelPhoneNumberWorkFax:
                    label = "faxWork"
                case CNLabelHome:
                    label = "home"
                case CNLabelPhoneNumberiPhone:
                    label = "iPhone"
                case CNLabelPhoneNumberMain:
                    label = "main"
                case CNLabelPhoneNumberMobile:
                    label = "mobile"
                case CNLabelPhoneNumberPager:
                    label = "pager"
                case CNLabelWork:
                    label = "work"
                case CNLabelOther:
                    label = "other"
                default:
                    if #available(iOS 13, macOS 10.15, *), self.label == CNLabelSchool {
                        label = "school"
                    } else {
                        label = "custom"
                        customLabel = self.label ?? ""
                    }
                }
        return Phone(number: value.stringValue, normalizedNumber: "", label: label, customLabel: customLabel, isPrimary: false)
    }
}

extension CNLabeledValue<CNSocialProfile> {
    func toSocialMedia() -> SocialMedia {
        var label = ""
        var customLabel = ""
        switch self.value.service {
        case CNSocialProfileServiceFacebook:
            label = "facebook"
        case CNSocialProfileServiceFlickr:
            label = "flickr"
        case CNSocialProfileServiceGameCenter:
            label = "gameCenter"
        case CNSocialProfileServiceLinkedIn:
            label = "linkedIn"
        case CNSocialProfileServiceMySpace:
            label = "mySpace"
        case CNSocialProfileServiceSinaWeibo:
            label = "sinaWeibo"
        case CNSocialProfileServiceTencentWeibo:
            label = "tencentWeibo"
        case CNSocialProfileServiceTwitter:
            label = "twitter"
        case CNSocialProfileServiceYelp:
            label = "yelp"
        default:
            label = "custom"
            customLabel = self.value.service
        }
        return SocialMedia(userName: value.username, label: label, customLabel: customLabel)
    }
}


extension CNLabeledValue<CNInstantMessageAddress> {
    
    func toSocialMedia() -> SocialMedia {
        var label = ""
        var customLabel = ""
        switch value.service {
                case CNInstantMessageServiceAIM:
                    label = "aim"
                case CNInstantMessageServiceFacebook:
                    label = "facebook"
                case CNInstantMessageServiceGaduGadu:
                    label = "gaduGadu"
                case CNInstantMessageServiceGoogleTalk:
                    label = "googleTalk"
                case CNInstantMessageServiceICQ:
                    label = "icq"
                case CNInstantMessageServiceJabber:
                    label = "jabber"
                case CNInstantMessageServiceMSN:
                    label = "msn"
                case CNInstantMessageServiceQQ:
                    label = "qqchat"
                case CNInstantMessageServiceSkype:
                    label = "skype"
                case CNInstantMessageServiceYahoo:
                    label = "yahoo"
                default:
                    label = "custom"
                    customLabel = self.value.service
                }
        return SocialMedia(userName: value.username, label: label, customLabel: customLabel)
    }
    
}

extension CNLabeledValue<NSString> {
    func toWebsite() -> Website {
        var label = ""
        var customLabel = ""
                switch self.label {
                case CNLabelHome:
                    label = "home"
                case CNLabelURLAddressHomePage:
                    label = "homepage"
                case CNLabelWork:
                    label = "work"
                case CNLabelOther:
                    label = "other"
                default:
                    if #available(iOS 13, macOS 10.15, *), self.label == CNLabelSchool {
                        label = "school"
                    } else {
                        label = "custom"
                        customLabel = self.label ?? ""
                    }
                }
        return Website(url: value as String, label: label, customLabel: customLabel)
    }
}

extension CNContact {
    func toContact() -> Contact {
        var name = Name(first: "", last: "", middle: "", prefix: "", suffix: "", nickname: "", firstPhonetic: "", lastPhonetic: "", middlePhonetic: "")
        var phones = [Phone]()
        var emails = [Email]()
        var addresses = [Address]()
        var organizations = [Organization]()
        var websites = [Website]()
        var socialMedias = [SocialMedia]()
        var events = [Event]()
        var notes = [Note]()
        var thumbnail: FlutterStandardTypedData?
        var photo: FlutterStandardTypedData?

        // Hack/shortcut: if this key is available, all others are too. (We could have
        // CNContactGivenNameKey instead but it seems to be included by default along
        // with some others, so we're going with a more exotic one here.)
        if self.isKeyAvailable(CNContactPhoneticGivenNameKey) {
            name = toName()
            phones = phoneNumbers.map { $0.toPhone() }
            emails = emailAddresses.map { $0.toEmail() }
            addresses = postalAddresses.map { $0.toAdress() }
            if !organizationName.isEmpty
                || !jobTitle.isEmpty
                || !departmentName.isEmpty
            {
                organizations = [toOrganization()]
            } else if #available(iOS 10, *), !phoneticOrganizationName.isEmpty {
                organizations = [toOrganization()]
            }
            websites = urlAddresses.map { $0.toWebsite() }
            socialMedias = socialProfiles.map {
                $0.toSocialMedia()
            } + instantMessageAddresses.map {
                $0.toSocialMedia()
            }
            if birthday != nil {
                events = [toEvent()]
            }
            events += dates.map { $0.toEvent() }
            // Notes need entitlements to be accessed in iOS 13+.
            // https://stackoverflow.com/questions/57442114/ios-13-cncontacts-no-longer-working-to-retrieve-all-contacts
            if isKeyAvailable(CNContactNoteKey) {
                notes = [toNote()]
            }
        }
        if isKeyAvailable(CNContactThumbnailImageDataKey) {
            thumbnail = thumbnailImageData?.flutterStandardTypedData
        }
        if isKeyAvailable(CNContactImageDataKey) {
            photo = imageData?.flutterStandardTypedData
        }
        return Contact(id: identifier, displayName: CNContactFormatter.string(
            from: self,
            style: CNContactFormatterStyle.fullName
        ) ?? "", isStarred: false, name: name, thumbnail: thumbnail, photo: photo, phones: phones, emails: emails, addresses: addresses, organizations: organizations, websites: websites, socialMedias: socialMedias, events: events, notes: notes, accounts: [], groups: [])
    }
}



extension Data {
    var flutterStandardTypedData: FlutterStandardTypedData {
      return FlutterStandardTypedData(bytes: self)
    }
}


extension Int {
  var int64: Int64 {
    return Int64(self)
  }
}

extension Int64 {
  var int: Int {
    return Int(self)
  }
}
