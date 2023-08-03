//
//  extensions.swift
//  flutter_contacts_plus
//
//  Created by David Londono on 29/07/23.
//

import Foundation
import Contacts


extension Name {
    func addTo(_ c: CNMutableContact) {
        c.givenName = first
        c.familyName = last
        c.middleName = middle
        c.namePrefix = prefix
        c.nameSuffix = suffix
        c.nickname = nickname
        c.phoneticGivenName = firstPhonetic
        c.phoneticFamilyName = lastPhonetic
        c.phoneticMiddleName = middlePhonetic
    }
}

extension Address {
    func addTo(_ c: CNMutableContact) {
            let mutableAddress = CNMutablePostalAddress()
            var isAnyFieldPresent = false
            if !street.isEmpty {
                mutableAddress.street = street
                isAnyFieldPresent = true
            }
            if !city.isEmpty {
                mutableAddress.city = city
                isAnyFieldPresent = true
            }
            if !state.isEmpty {
                mutableAddress.state = state
                isAnyFieldPresent = true
            }
            if !postalCode.isEmpty {
                mutableAddress.postalCode = postalCode
                isAnyFieldPresent = true
            }
            if !country.isEmpty {
                mutableAddress.country = country
                isAnyFieldPresent = true
            }
            if !isoCountry.isEmpty {
                mutableAddress.isoCountryCode = isoCountry
                isAnyFieldPresent = true
            }
            if #available(iOS 13, *), !subAdminArea.isEmpty {
                mutableAddress.subAdministrativeArea = subAdminArea
                isAnyFieldPresent = true
            }
            if #available(iOS 13, *), !subLocality.isEmpty {
                mutableAddress.subLocality = subLocality
                isAnyFieldPresent = true
            }
            if !isAnyFieldPresent {
                // fallback to writing the entire address into the `street` field
                mutableAddress.street = address
            }
            var labelInv: String
            switch label {
            case "home":
                labelInv = CNLabelHome
            case "school":
                if #available(iOS 13, macOS 10.15, *) {
                    labelInv = CNLabelSchool
                } else {
                    labelInv = "school"
                }
            case "work":
                labelInv = CNLabelWork
            case "other":
                labelInv = CNLabelOther
            case "custom":
                labelInv = customLabel
            default:
                labelInv = label
            }
            c.postalAddresses.append(
                CNLabeledValue<CNPostalAddress>(
                    label: labelInv,
                    value: mutableAddress
                )
            )
        }
}

extension Email {
    func addTo(_ c: CNMutableContact) {
        var labelInv: String
        switch label {
        case "home":
            labelInv = CNLabelHome
        case "iCloud":
            labelInv = CNLabelEmailiCloud
        case "school":
            if #available(iOS 13, macOS 10.15, *) {
                labelInv = CNLabelSchool
            } else {
                labelInv = "school"
            }
        case "work":
            labelInv = CNLabelWork
        case "other":
            labelInv = CNLabelOther
        case "custom":
            labelInv = customLabel
        default:
            labelInv = label
        }
        c.emailAddresses.append(
            CNLabeledValue<NSString>(
                label: labelInv,
                value: address as NSString
            )
        )
    }
}


extension Event {
    func addTo(_ c: CNMutableContact) {
            var dateComponents: DateComponents
            if year == nil {
                dateComponents = DateComponents(month: month.int, day: day.int)
            } else {
                dateComponents = DateComponents(year: year?.int, month: month.int, day: day.int)
            }
            if label == "birthday" {
                c.birthday = dateComponents
            } else {
                var labelInv: String
                switch label {
                case "anniversary":
                    labelInv = CNLabelDateAnniversary
                case "other":
                    labelInv = CNLabelOther
                case "custom":
                    labelInv = customLabel
                default:
                    labelInv = label
                }
                c.dates.append(
                    CNLabeledValue(
                        label: labelInv,
                        value: dateComponents as NSDateComponents
                    )
                )
            }
        }
}

extension Note {
    func addTo(_ c: CNMutableContact) {
            c.note = note
        }
}

extension Organization {
    func addTo(_ c: CNMutableContact) {
            c.organizationName = company
            c.jobTitle = title
            c.departmentName = department
            if #available(iOS 10, *) {
                c.phoneticOrganizationName = phoneticName
            }
        }
}

extension Phone {
    func addTo(_ c: CNMutableContact) {
            var labelInv: String
            switch label {
            case "faxHome":
                labelInv = CNLabelPhoneNumberHomeFax
            case "faxOther":
                labelInv = CNLabelPhoneNumberOtherFax
            case "faxWork":
                labelInv = CNLabelPhoneNumberWorkFax
            case "home":
                labelInv = CNLabelHome
            case "iPhone":
                labelInv = CNLabelPhoneNumberiPhone
            case "main":
                labelInv = CNLabelPhoneNumberMain
            case "mobile":
                labelInv = CNLabelPhoneNumberMobile
            case "pager":
                labelInv = CNLabelPhoneNumberPager
            case "school":
                if #available(iOS 13, macOS 10.15, *) {
                    labelInv = CNLabelSchool
                } else {
                    labelInv = "school"
                }
            case "work":
                labelInv = CNLabelWork
            case "other":
                labelInv = CNLabelOther
            case "custom":
                labelInv = customLabel
            default:
                labelInv = label
            }
            c.phoneNumbers.append(
                CNLabeledValue<CNPhoneNumber>(
                    label: labelInv,
                    value: CNPhoneNumber(stringValue: number)
                )
            )
        }
}


extension SocialMedia {
    func addTo(_ c: CNMutableContact) {
            var labelInv: String
            var isSocialProfile: Bool = false
            switch label {
            case "aim":
                labelInv = CNInstantMessageServiceAIM
            case "facebook":
                labelInv = CNSocialProfileServiceFacebook
                isSocialProfile = true
            case "flickr":
                labelInv = CNSocialProfileServiceFlickr
                isSocialProfile = true
            case "gaduGadu":
                labelInv = CNInstantMessageServiceGaduGadu
            case "gameCenter":
                labelInv = CNSocialProfileServiceGameCenter
                isSocialProfile = true
            case "googleTalk":
                labelInv = CNInstantMessageServiceGoogleTalk
            case "icq":
                labelInv = CNInstantMessageServiceICQ
            case "jabber":
                labelInv = CNInstantMessageServiceJabber
            case "linkedIn":
                labelInv = CNSocialProfileServiceLinkedIn
                isSocialProfile = true
            case "msn":
                labelInv = CNInstantMessageServiceMSN
            case "myspace":
                labelInv = CNSocialProfileServiceMySpace
                isSocialProfile = true
            case "qqchat":
                labelInv = CNInstantMessageServiceQQ
            case "sinaWeibo":
                labelInv = CNSocialProfileServiceSinaWeibo
                isSocialProfile = true
            case "skype":
                labelInv = CNInstantMessageServiceSkype
            case "tencentWeibo":
                labelInv = CNSocialProfileServiceTencentWeibo
                isSocialProfile = true
            case "twitter":
                labelInv = CNSocialProfileServiceTwitter
                isSocialProfile = true
            case "yahoo":
                labelInv = CNInstantMessageServiceYahoo
            case "yelp":
                labelInv = CNSocialProfileServiceYelp
                isSocialProfile = true
            case "custom":
                labelInv = customLabel
            default:
                labelInv = label
            }
            if isSocialProfile {
                c.socialProfiles.append(
                    CNLabeledValue<CNSocialProfile>(
                        label: nil,
                        value: CNSocialProfile(
                            urlString: nil,
                            username: userName,
                            userIdentifier: nil,
                            service: labelInv
                        )
                    )
                )
            } else {
                c.instantMessageAddresses.append(
                    CNLabeledValue<CNInstantMessageAddress>(
                        label: nil,
                        value: CNInstantMessageAddress(
                            username: userName,
                            service: labelInv
                        )
                    )
                )
            }
        }
}


extension Website {
    func addTo(_ c: CNMutableContact) {
            var labelInv: String
            switch label {
            case "home":
                labelInv = CNLabelHome
            case "homepage":
                labelInv = CNLabelURLAddressHomePage
            case "school":
                if #available(iOS 13, macOS 10.15, *) {
                    labelInv = CNLabelSchool
                } else {
                    labelInv = "school"
                }
            case "work":
                labelInv = CNLabelWork
            case "other":
                labelInv = CNLabelOther
            case "custom":
                labelInv = customLabel
            default:
                labelInv = label
            }
            c.urlAddresses.append(
                CNLabeledValue<NSString>(
                    label: labelInv,
                    value: url as NSString
                )
            )
        }
}
