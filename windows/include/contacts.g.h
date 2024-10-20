// Autogenerated from Pigeon (v22.4.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#ifndef PIGEON_CONTACTS_G_H_
#define PIGEON_CONTACTS_G_H_
#include <flutter/basic_message_channel.h>
#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_message_codec.h>

#include <map>
#include <optional>
#include <string>

namespace pigeon_example {


// Generated class from Pigeon.

class FlutterError {
 public:
  explicit FlutterError(const std::string& code)
    : code_(code) {}
  explicit FlutterError(const std::string& code, const std::string& message)
    : code_(code), message_(message) {}
  explicit FlutterError(const std::string& code, const std::string& message, const flutter::EncodableValue& details)
    : code_(code), message_(message), details_(details) {}

  const std::string& code() const { return code_; }
  const std::string& message() const { return message_; }
  const flutter::EncodableValue& details() const { return details_; }

 private:
  std::string code_;
  std::string message_;
  flutter::EncodableValue details_;
};

template<class T> class ErrorOr {
 public:
  ErrorOr(const T& rhs) : v_(rhs) {}
  ErrorOr(const T&& rhs) : v_(std::move(rhs)) {}
  ErrorOr(const FlutterError& rhs) : v_(rhs) {}
  ErrorOr(const FlutterError&& rhs) : v_(std::move(rhs)) {}

  bool has_error() const { return std::holds_alternative<FlutterError>(v_); }
  const T& value() const { return std::get<T>(v_); };
  const FlutterError& error() const { return std::get<FlutterError>(v_); };

 private:
  friend class ContactsHostApi;
  ErrorOr() = default;
  T TakeValue() && { return std::get<T>(std::move(v_)); }

  std::variant<T, FlutterError> v_;
};


enum class PermisionsApi {
  kGranted = 0,
  kDenied = 1,
  kRestricted = 2,
  kUnknown = 3,
  kNotDetermined = 4
};


// Generated class from Pigeon that represents data sent in messages.
class Name {
 public:
  // Constructs an object setting all fields.
  explicit Name(
    const std::string& first,
    const std::string& last,
    const std::string& middle,
    const std::string& prefix,
    const std::string& suffix,
    const std::string& nickname,
    const std::string& first_phonetic,
    const std::string& last_phonetic,
    const std::string& middle_phonetic);

  const std::string& first() const;
  void set_first(std::string_view value_arg);

  const std::string& last() const;
  void set_last(std::string_view value_arg);

  const std::string& middle() const;
  void set_middle(std::string_view value_arg);

  const std::string& prefix() const;
  void set_prefix(std::string_view value_arg);

  const std::string& suffix() const;
  void set_suffix(std::string_view value_arg);

  const std::string& nickname() const;
  void set_nickname(std::string_view value_arg);

  const std::string& first_phonetic() const;
  void set_first_phonetic(std::string_view value_arg);

  const std::string& last_phonetic() const;
  void set_last_phonetic(std::string_view value_arg);

  const std::string& middle_phonetic() const;
  void set_middle_phonetic(std::string_view value_arg);


 private:
  static Name FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class Contact;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string first_;
  std::string last_;
  std::string middle_;
  std::string prefix_;
  std::string suffix_;
  std::string nickname_;
  std::string first_phonetic_;
  std::string last_phonetic_;
  std::string middle_phonetic_;

};


// Generated class from Pigeon that represents data sent in messages.
class Phone {
 public:
  // Constructs an object setting all fields.
  explicit Phone(
    const std::string& number,
    const std::string& normalized_number,
    const std::string& label,
    const std::string& custom_label,
    bool is_primary);

  const std::string& number() const;
  void set_number(std::string_view value_arg);

  const std::string& normalized_number() const;
  void set_normalized_number(std::string_view value_arg);

  const std::string& label() const;
  void set_label(std::string_view value_arg);

  const std::string& custom_label() const;
  void set_custom_label(std::string_view value_arg);

  bool is_primary() const;
  void set_is_primary(bool value_arg);


 private:
  static Phone FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string number_;
  std::string normalized_number_;
  std::string label_;
  std::string custom_label_;
  bool is_primary_;

};


// Generated class from Pigeon that represents data sent in messages.
class Email {
 public:
  // Constructs an object setting all fields.
  explicit Email(
    const std::string& address,
    const std::string& label,
    const std::string& custom_label,
    bool is_primary);

  const std::string& address() const;
  void set_address(std::string_view value_arg);

  const std::string& label() const;
  void set_label(std::string_view value_arg);

  const std::string& custom_label() const;
  void set_custom_label(std::string_view value_arg);

  bool is_primary() const;
  void set_is_primary(bool value_arg);


 private:
  static Email FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string address_;
  std::string label_;
  std::string custom_label_;
  bool is_primary_;

};


// Generated class from Pigeon that represents data sent in messages.
class Address {
 public:
  // Constructs an object setting all fields.
  explicit Address(
    const std::string& address,
    const std::string& label,
    const std::string& custom_label,
    const std::string& street,
    const std::string& pobox,
    const std::string& neighborhood,
    const std::string& city,
    const std::string& state,
    const std::string& postal_code,
    const std::string& country,
    const std::string& iso_country,
    const std::string& sub_admin_area,
    const std::string& sub_locality);

  const std::string& address() const;
  void set_address(std::string_view value_arg);

  const std::string& label() const;
  void set_label(std::string_view value_arg);

  const std::string& custom_label() const;
  void set_custom_label(std::string_view value_arg);

  const std::string& street() const;
  void set_street(std::string_view value_arg);

  const std::string& pobox() const;
  void set_pobox(std::string_view value_arg);

  const std::string& neighborhood() const;
  void set_neighborhood(std::string_view value_arg);

  const std::string& city() const;
  void set_city(std::string_view value_arg);

  const std::string& state() const;
  void set_state(std::string_view value_arg);

  const std::string& postal_code() const;
  void set_postal_code(std::string_view value_arg);

  const std::string& country() const;
  void set_country(std::string_view value_arg);

  const std::string& iso_country() const;
  void set_iso_country(std::string_view value_arg);

  const std::string& sub_admin_area() const;
  void set_sub_admin_area(std::string_view value_arg);

  const std::string& sub_locality() const;
  void set_sub_locality(std::string_view value_arg);


 private:
  static Address FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string address_;
  std::string label_;
  std::string custom_label_;
  std::string street_;
  std::string pobox_;
  std::string neighborhood_;
  std::string city_;
  std::string state_;
  std::string postal_code_;
  std::string country_;
  std::string iso_country_;
  std::string sub_admin_area_;
  std::string sub_locality_;

};


// Generated class from Pigeon that represents data sent in messages.
class Organization {
 public:
  // Constructs an object setting all fields.
  explicit Organization(
    const std::string& company,
    const std::string& title,
    const std::string& department,
    const std::string& job_description,
    const std::string& symbol,
    const std::string& phonetic_name,
    const std::string& office_location);

  const std::string& company() const;
  void set_company(std::string_view value_arg);

  const std::string& title() const;
  void set_title(std::string_view value_arg);

  const std::string& department() const;
  void set_department(std::string_view value_arg);

  const std::string& job_description() const;
  void set_job_description(std::string_view value_arg);

  const std::string& symbol() const;
  void set_symbol(std::string_view value_arg);

  const std::string& phonetic_name() const;
  void set_phonetic_name(std::string_view value_arg);

  const std::string& office_location() const;
  void set_office_location(std::string_view value_arg);


 private:
  static Organization FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string company_;
  std::string title_;
  std::string department_;
  std::string job_description_;
  std::string symbol_;
  std::string phonetic_name_;
  std::string office_location_;

};


// Generated class from Pigeon that represents data sent in messages.
class Website {
 public:
  // Constructs an object setting all fields.
  explicit Website(
    const std::string& url,
    const std::string& label,
    const std::string& custom_label);

  const std::string& url() const;
  void set_url(std::string_view value_arg);

  const std::string& label() const;
  void set_label(std::string_view value_arg);

  const std::string& custom_label() const;
  void set_custom_label(std::string_view value_arg);


 private:
  static Website FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string url_;
  std::string label_;
  std::string custom_label_;

};


// Generated class from Pigeon that represents data sent in messages.
class SocialMedia {
 public:
  // Constructs an object setting all fields.
  explicit SocialMedia(
    const std::string& user_name,
    const std::string& label,
    const std::string& custom_label);

  const std::string& user_name() const;
  void set_user_name(std::string_view value_arg);

  const std::string& label() const;
  void set_label(std::string_view value_arg);

  const std::string& custom_label() const;
  void set_custom_label(std::string_view value_arg);


 private:
  static SocialMedia FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string user_name_;
  std::string label_;
  std::string custom_label_;

};


// Generated class from Pigeon that represents data sent in messages.
class Event {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit Event(
    int64_t month,
    int64_t day,
    const std::string& label,
    const std::string& custom_label);

  // Constructs an object setting all fields.
  explicit Event(
    const int64_t* year,
    int64_t month,
    int64_t day,
    const std::string& label,
    const std::string& custom_label);

  const int64_t* year() const;
  void set_year(const int64_t* value_arg);
  void set_year(int64_t value_arg);

  int64_t month() const;
  void set_month(int64_t value_arg);

  int64_t day() const;
  void set_day(int64_t value_arg);

  const std::string& label() const;
  void set_label(std::string_view value_arg);

  const std::string& custom_label() const;
  void set_custom_label(std::string_view value_arg);


 private:
  static Event FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::optional<int64_t> year_;
  int64_t month_;
  int64_t day_;
  std::string label_;
  std::string custom_label_;

};


// Generated class from Pigeon that represents data sent in messages.
class Note {
 public:
  // Constructs an object setting all fields.
  explicit Note(const std::string& note);

  const std::string& note() const;
  void set_note(std::string_view value_arg);


 private:
  static Note FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string note_;

};


// Generated class from Pigeon that represents data sent in messages.
class Account {
 public:
  // Constructs an object setting all fields.
  explicit Account(
    const std::string& raw_id,
    const std::string& name,
    const std::string& type,
    const flutter::EncodableList& mimetypes);

  const std::string& raw_id() const;
  void set_raw_id(std::string_view value_arg);

  const std::string& name() const;
  void set_name(std::string_view value_arg);

  const std::string& type() const;
  void set_type(std::string_view value_arg);

  const flutter::EncodableList& mimetypes() const;
  void set_mimetypes(const flutter::EncodableList& value_arg);


 private:
  static Account FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string raw_id_;
  std::string name_;
  std::string type_;
  flutter::EncodableList mimetypes_;

};


// Generated class from Pigeon that represents data sent in messages.
class Group {
 public:
  // Constructs an object setting all fields.
  explicit Group(
    const std::string& id,
    const std::string& name);

  const std::string& id() const;
  void set_id(std::string_view value_arg);

  const std::string& name() const;
  void set_name(std::string_view value_arg);


 private:
  static Group FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string id_;
  std::string name_;

};


// Generated class from Pigeon that represents data sent in messages.
class Contact {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit Contact(
    const std::string& id,
    const std::string& display_name,
    bool is_starred,
    const flutter::EncodableList& phones,
    const flutter::EncodableList& emails,
    const flutter::EncodableList& addresses,
    const flutter::EncodableList& organizations,
    const flutter::EncodableList& websites,
    const flutter::EncodableList& social_medias,
    const flutter::EncodableList& events,
    const flutter::EncodableList& notes,
    const flutter::EncodableList& accounts,
    const flutter::EncodableList& groups);

  // Constructs an object setting all fields.
  explicit Contact(
    const std::string& id,
    const std::string& display_name,
    bool is_starred,
    const Name* name,
    const std::vector<uint8_t>* thumbnail,
    const std::vector<uint8_t>* photo,
    const flutter::EncodableList& phones,
    const flutter::EncodableList& emails,
    const flutter::EncodableList& addresses,
    const flutter::EncodableList& organizations,
    const flutter::EncodableList& websites,
    const flutter::EncodableList& social_medias,
    const flutter::EncodableList& events,
    const flutter::EncodableList& notes,
    const flutter::EncodableList& accounts,
    const flutter::EncodableList& groups);

  ~Contact() = default;
  Contact(const Contact& other);
  Contact& operator=(const Contact& other);
  Contact(Contact&& other) = default;
  Contact& operator=(Contact&& other) noexcept = default;
  const std::string& id() const;
  void set_id(std::string_view value_arg);

  const std::string& display_name() const;
  void set_display_name(std::string_view value_arg);

  bool is_starred() const;
  void set_is_starred(bool value_arg);

  const Name* name() const;
  void set_name(const Name* value_arg);
  void set_name(const Name& value_arg);

  const std::vector<uint8_t>* thumbnail() const;
  void set_thumbnail(const std::vector<uint8_t>* value_arg);
  void set_thumbnail(const std::vector<uint8_t>& value_arg);

  const std::vector<uint8_t>* photo() const;
  void set_photo(const std::vector<uint8_t>* value_arg);
  void set_photo(const std::vector<uint8_t>& value_arg);

  const flutter::EncodableList& phones() const;
  void set_phones(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& emails() const;
  void set_emails(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& addresses() const;
  void set_addresses(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& organizations() const;
  void set_organizations(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& websites() const;
  void set_websites(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& social_medias() const;
  void set_social_medias(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& events() const;
  void set_events(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& notes() const;
  void set_notes(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& accounts() const;
  void set_accounts(const flutter::EncodableList& value_arg);

  const flutter::EncodableList& groups() const;
  void set_groups(const flutter::EncodableList& value_arg);


 private:
  static Contact FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  std::string id_;
  std::string display_name_;
  bool is_starred_;
  std::unique_ptr<Name> name_;
  std::optional<std::vector<uint8_t>> thumbnail_;
  std::optional<std::vector<uint8_t>> photo_;
  flutter::EncodableList phones_;
  flutter::EncodableList emails_;
  flutter::EncodableList addresses_;
  flutter::EncodableList organizations_;
  flutter::EncodableList websites_;
  flutter::EncodableList social_medias_;
  flutter::EncodableList events_;
  flutter::EncodableList notes_;
  flutter::EncodableList accounts_;
  flutter::EncodableList groups_;

};


// Generated class from Pigeon that represents data sent in messages.
class ContactsRequest {
 public:
  // Constructs an object setting all fields.
  explicit ContactsRequest(
    bool with_properties,
    bool with_thumbnail,
    bool with_photo,
    bool with_groups,
    bool with_accounts,
    bool return_unified_contacts,
    bool include_notes_on_ios13_and_above);

  bool with_properties() const;
  void set_with_properties(bool value_arg);

  bool with_thumbnail() const;
  void set_with_thumbnail(bool value_arg);

  bool with_photo() const;
  void set_with_photo(bool value_arg);

  bool with_groups() const;
  void set_with_groups(bool value_arg);

  bool with_accounts() const;
  void set_with_accounts(bool value_arg);

  bool return_unified_contacts() const;
  void set_return_unified_contacts(bool value_arg);

  bool include_notes_on_ios13_and_above() const;
  void set_include_notes_on_ios13_and_above(bool value_arg);


 private:
  static ContactsRequest FromEncodableList(const flutter::EncodableList& list);
  flutter::EncodableList ToEncodableList() const;
  friend class ContactsHostApi;
  friend class PigeonInternalCodecSerializer;
  bool with_properties_;
  bool with_thumbnail_;
  bool with_photo_;
  bool with_groups_;
  bool with_accounts_;
  bool return_unified_contacts_;
  bool include_notes_on_ios13_and_above_;

};


class PigeonInternalCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  PigeonInternalCodecSerializer();
  inline static PigeonInternalCodecSerializer& GetInstance() {
    static PigeonInternalCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(
    const flutter::EncodableValue& value,
    flutter::ByteStreamWriter* stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(
    uint8_t type,
    flutter::ByteStreamReader* stream) const override;

};

// Generated interface from Pigeon that represents a handler of messages from Flutter.
class ContactsHostApi {
 public:
  ContactsHostApi(const ContactsHostApi&) = delete;
  ContactsHostApi& operator=(const ContactsHostApi&) = delete;
  virtual ~ContactsHostApi() {}
  virtual void GetContacts(
    const ContactsRequest& config,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void GetContactsWithName(
    const std::string& name,
    const ContactsRequest& config,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void GetContactsWithEmail(
    const std::string& email,
    const ContactsRequest& config,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void GetContactsWithPhone(
    const std::string& phone,
    const ContactsRequest& config,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void GetContactsWithIds(
    const flutter::EncodableList& ids,
    const ContactsRequest& config,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void GetContactsInGroup(
    const std::string& group_id,
    const ContactsRequest& config,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void GetContactsInContainer(
    const std::string& container_id,
    const ContactsRequest& config,
    std::function<void(ErrorOr<flutter::EncodableList> reply)> result) = 0;
  virtual void CheckPermission(std::function<void(ErrorOr<PermisionsApi> reply)> result) = 0;
  virtual void RequestPermission(std::function<void(ErrorOr<bool> reply)> result) = 0;

  // The codec used by ContactsHostApi.
  static const flutter::StandardMessageCodec& GetCodec();
  // Sets up an instance of `ContactsHostApi` to handle messages through the `binary_messenger`.
  static void SetUp(
    flutter::BinaryMessenger* binary_messenger,
    ContactsHostApi* api);
  static void SetUp(
    flutter::BinaryMessenger* binary_messenger,
    ContactsHostApi* api,
    const std::string& message_channel_suffix);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError& error);

 protected:
  ContactsHostApi() = default;

};
}  // namespace pigeon_example
#endif  // PIGEON_CONTACTS_G_H_
