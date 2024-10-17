//
//  ContactsService.swift
//  flutter_contacts_plus
//
//  Created by David Londono on 29/07/23.
//
import Contacts
import ContactsUI
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif




@available(iOS 9.0, *)
public enum ContactsService {
  // Fetches contact(s).
  static func selectInternal(
    store: CNContactStore,
    predicate: NSPredicate?,
    withProperties: Bool,
    withThumbnail: Bool,
    withPhoto: Bool,
    returnUnifiedContacts: Bool,
    includeNotesOnIos13AndAbove: Bool,
    externalIntent: Bool = false
  ) throws -> [CNContact] {
    var contacts: [CNContact] = []
    var keys: [Any] = [
      CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
      CNContactIdentifierKey,
    ]
    if withProperties {
      keys += [
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactMiddleNameKey,
        CNContactNamePrefixKey,
        CNContactNameSuffixKey,
        CNContactNicknameKey,
        CNContactPhoneticGivenNameKey,
        CNContactPhoneticFamilyNameKey,
        CNContactPhoneticMiddleNameKey,
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
        CNContactPostalAddressesKey,
        CNContactOrganizationNameKey,
        CNContactJobTitleKey,
        CNContactDepartmentNameKey,
        CNContactUrlAddressesKey,
        CNContactSocialProfilesKey,
        CNContactInstantMessageAddressesKey,
        CNContactBirthdayKey,
        CNContactDatesKey,
      ]
      if #available(iOS 10, macOS 10.12, *) {
        keys.append(CNContactPhoneticOrganizationNameKey)
      }
      // Notes need explicit entitlement from Apple starting with iOS13.
      // https://stackoverflow.com/questions/57442114/ios-13-cncontacts-no-longer-working-to-retrieve-all-contacts
      if #available(iOS 13, *), !includeNotesOnIos13AndAbove {
      } else {
        // keys.append(CNContactNoteKey)
      }
      if externalIntent {
        keys.append(CNContactViewController.descriptorForRequiredKeys())
      }
    }
    if withThumbnail { keys.append(CNContactThumbnailImageDataKey) }
    if withPhoto { keys.append(CNContactImageDataKey) }

    let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
    request.unifyResults = returnUnifiedContacts
    if predicate != nil {
      // Request for a specific contact.
      request.predicate = predicate
    }
  try store.enumerateContacts(
    with: request,
    usingBlock: { (contact, _) -> Void in
      contacts.append(contact)
    }
  )
    return contacts
  }

  static func select(
    predicate: NSPredicate?,
    config: ContactsRequest
  ) throws -> [Contact] {
    let store = CNContactStore()
    let contactsInternal = try selectInternal(
      store: store,
      predicate: predicate,
      withProperties: config.withProperties,
      withThumbnail: config.withThumbnail,
      withPhoto: config.withPhoto,
      returnUnifiedContacts: config.returnUnifiedContacts,
      includeNotesOnIos13AndAbove: config.includeNotesOnIos13AndAbove
    )
      var contacts = contactsInternal.map { $0.toContact() }
      if config.withGroups {
      let groups = fetchGroups(store)
      let groupMemberships = fetchGroupMemberships(store, groups)
      for (index, contact) in contacts.enumerated() {
        if let contactGroups = groupMemberships[contact.id] {
            contacts[index].groups = contactGroups.map { groups[$0].toGroup() }
        }
      }
    }
      if config.withAccounts {
      let containers = fetchContainers(store)
      let containerMemberships = fetchContainerMemberships(store, containers)
      for (index, contact) in contacts.enumerated() {
        if let contactContainers = containerMemberships[contact.id] {
          contacts[index].accounts = contactContainers.map {
              containers[$0].toAccount()
          }
        }
      }
    }
    return contacts
  }

  static func fetchGroups(_ store: CNContactStore) -> [CNGroup] {
    var groups: [CNGroup] = []
    do {
      try groups = store.groups(matching: nil)
    } catch {
      print("Unexpected error: \(error)")
      return []
    }
    return groups
  }

  static func fetchGroupMemberships(
    _ store: CNContactStore, _ groups: [CNGroup], forContactId contactId: String? = nil
  ) -> [String: [Int]] {
    var memberships = [String: [Int]]()
    for (groupIndex, group) in groups.enumerated() {
      let request = CNContactFetchRequest(
        keysToFetch: [CNContactIdentifierKey] as [CNKeyDescriptor])
      request.predicate = CNContact.predicateForContactsInGroup(withIdentifier: group.identifier)
      do {
        try store.enumerateContacts(with: request) { (contact, _) -> Void in
          if contactId == nil || contact.identifier == contactId {
            if let contactGroups = memberships[contact.identifier] {
              memberships[contact.identifier] = contactGroups + [groupIndex]
            } else {
              memberships[contact.identifier] = [groupIndex]
            }
          }
        }
      } catch {
        print("Unexpected error: \(error)")
      }
    }
    return memberships
  }

  static func fetchContainers(_ store: CNContactStore) -> [CNContainer] {
    var containers: [CNContainer] = []
    do {
      try containers = store.containers(matching: nil)
    } catch {
      print("Unexpected error: \(error)")
      return []
    }
    return containers
  }

  static func fetchContainerMemberships(_ store: CNContactStore, _ containers: [CNContainer])
    -> [String: [Int]]
  {
    var memberships = [String: [Int]]()
    for (containerIndex, container) in containers.enumerated() {
      let request = CNContactFetchRequest(
        keysToFetch: [CNContactIdentifierKey] as [CNKeyDescriptor])
      request.predicate = CNContact.predicateForContactsInContainer(
        withIdentifier: container.identifier)
      do {
        try store.enumerateContacts(with: request) { (contact, _) -> Void in
          if let contactContainers = memberships[contact.identifier] {
            memberships[contact.identifier] = contactContainers + [containerIndex]
          } else {
            memberships[contact.identifier] = [containerIndex]
          }
        }
      } catch {
        print("Unexpected error: \(error)")
      }
    }
    return memberships
  }

  // Inserts a new contact into the database.
  static func insert(
    _ args: Contact,
    _ includeNotesOnIos13AndAbove: Bool
  ) throws -> Contact {
    let contact = CNMutableContact()

    addFieldsToContact(args, contact, includeNotesOnIos13AndAbove)

    let saveRequest = CNSaveRequest()
    saveRequest.add(contact, toContainerWithIdentifier: nil)
    try CNContactStore().execute(saveRequest)
    return contact.toContact()
  }

  // Updates an existing contact in the database.
  static func update(
    _ args: Contact,
    _ withGroups: Bool,
    _ includeNotesOnIos13AndAbove: Bool
  ) throws -> Contact? {
    // First, fetch the original contact.
      let id = args.id
    var keys: [Any] = [
      CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
      CNContactIdentifierKey,
      CNContactGivenNameKey,
      CNContactFamilyNameKey,
      CNContactMiddleNameKey,
      CNContactNamePrefixKey,
      CNContactNameSuffixKey,
      CNContactNicknameKey,
      CNContactPhoneticGivenNameKey,
      CNContactPhoneticFamilyNameKey,
      CNContactPhoneticMiddleNameKey,
      CNContactPhoneNumbersKey,
      CNContactEmailAddressesKey,
      CNContactPostalAddressesKey,
      CNContactOrganizationNameKey,
      CNContactJobTitleKey,
      CNContactDepartmentNameKey,
      CNContactUrlAddressesKey,
      CNContactSocialProfilesKey,
      CNContactInstantMessageAddressesKey,
      CNContactBirthdayKey,
      CNContactDatesKey,
      CNContactThumbnailImageDataKey,
      CNContactImageDataKey,
    ]
    if #available(iOS 10, *) { keys.append(CNContactPhoneticOrganizationNameKey) }
    if #available(iOS 13, *), !includeNotesOnIos13AndAbove {
    } else {
      keys.append(CNContactNoteKey)
    }

    let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
    if #available(iOS 10, *) { request.mutableObjects = true }
    request.predicate = CNContact.predicateForContacts(withIdentifiers: [id])
    let store = CNContactStore()
    var contacts: [CNContact] = []
    try store.enumerateContacts(
      with: request,
      usingBlock: { (contact, _) -> Void in
        contacts.append(contact)
      })

    // Mutate the contact
    if let firstContact = contacts.first {
      let contact = firstContact.mutableCopy() as! CNMutableContact
      clearFields(contact, includeNotesOnIos13AndAbove)
      addFieldsToContact(args, contact, includeNotesOnIos13AndAbove)

      let saveRequest = CNSaveRequest()
      saveRequest.update(contact)
      try store.execute(saveRequest)

      // Update group membership
      if withGroups {
        let groups = fetchGroups(store)
        let groupMemberships = fetchGroupMemberships(
          store, groups, forContactId: contact.identifier)
        for groupIndex in groupMemberships[contact.identifier] ?? [] {
          let deleteRequest = CNSaveRequest()
          deleteRequest.removeMember(contact, from: groups[groupIndex])
          try store.execute(deleteRequest)
        }

          let groupIds = Set(args.groups.map { $0?.id })
        for group in groups {
          if groupIds.contains(group.identifier) {
            let addRequest = CNSaveRequest()
            addRequest.addMember(contact, to: group)
            try store.execute(addRequest)
          }
        }
      }

        return contact.toContact()
    } else {
      return nil
    }
  }

  // Delete contact
  static func delete(_ ids: [String]) throws {
    let request = CNContactFetchRequest(keysToFetch: [])
    if #available(iOS 10, *) {
      request.mutableObjects = true
    }
    request.predicate = CNContact.predicateForContacts(withIdentifiers: ids)
    let store = CNContactStore()
    var contacts: [CNContact] = []
    try store.enumerateContacts(
      with: request,
      usingBlock: { (contact, _) -> Void in
        contacts.append(contact)
      })
    let saveRequest = CNSaveRequest()
    contacts.forEach { contact in
      saveRequest.delete(contact.mutableCopy() as! CNMutableContact)
    }
    try store.execute(saveRequest)
  }

  static func getGroups() -> [Group] {
    let store = CNContactStore()
    let groups = fetchGroups(store)
      return groups.map { $0.toGroup() }
  }

  static func insertGroup(_ group: Group) throws -> Group {
    let newGroup = CNMutableGroup()
    newGroup.name = group.name

    let saveRequest = CNSaveRequest()
    saveRequest.add(newGroup, toContainerWithIdentifier: nil)
    try CNContactStore().execute(saveRequest)

      return newGroup.toGroup()
  }

  static func updateGroup(_ group: Group) throws -> Group {

    let store = CNContactStore()
    let groups = fetchGroups(store)

    for g in groups {
      if g.identifier == group.id {
        let updatedGroup = g.mutableCopy() as! CNMutableGroup
        updatedGroup.name = group.name

        let saveRequest = CNSaveRequest()
        saveRequest.update(updatedGroup)
        try CNContactStore().execute(saveRequest)
          
        return updatedGroup.toGroup()
      }
    }

    return group
  }

  static func deleteGroup(_ group: Group) throws {

    let store = CNContactStore()
    let groups = fetchGroups(store)

    for g in groups {
      if g.identifier == group.id {
        let deletedGroup = g.mutableCopy() as! CNMutableGroup

        let saveRequest = CNSaveRequest()
        saveRequest.delete(deletedGroup)
        try CNContactStore().execute(saveRequest)

        return
      }
    }
  }

  private static func clearFields(
    _ contact: CNMutableContact,
    _ includeNotesOnIos13AndAbove: Bool
  ) {
    contact.imageData = nil
    contact.phoneNumbers = []
    contact.emailAddresses = []
    contact.postalAddresses = []
    contact.urlAddresses = []
    contact.socialProfiles = []
    contact.instantMessageAddresses = []
    contact.dates = []
    contact.birthday = nil
    if #available(iOS 13, *), !includeNotesOnIos13AndAbove {
    } else {
      contact.note = ""
    }
  }

  static func addFieldsToContact(
    _ contact: Contact,
    _ newContact: CNMutableContact,
    _ includeNotesOnIos13AndAbove: Bool
  ) {
      contact.name?.addTo(newContact)
      contact.phones.forEach {
          $0?.addTo(newContact)
      }
      contact.emails.forEach { $0?.addTo(newContact) }
      contact.addresses.forEach{ $0?.addTo(newContact)}
      contact.organizations.forEach{ $0?.addTo(newContact)}
      contact.websites.forEach{ $0?.addTo(newContact) }
      contact.socialMedias.forEach{ $0?.addTo(newContact) }
      contact.events.forEach{ $0?.addTo(newContact) }
      contact.events.forEach{ $0?.addTo(newContact) }
      
      
    
    if #available(iOS 13, *), !includeNotesOnIos13AndAbove {
    } else {
        if let note = contact.notes.first {
            note?.addTo(newContact)
      }
    }
      if let photo = contact.photo {
          newContact.imageData = photo.data
    }
  }
}
