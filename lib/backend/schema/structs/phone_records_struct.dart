// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PhoneRecordsStruct extends FFFirebaseStruct {
  PhoneRecordsStruct({
    String? name,
    String? phone,
    String? avatar,
    String? email,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _phone = phone,
        _avatar = avatar,
        _email = email,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "avatar" field.
  String? _avatar;
  String get avatar => _avatar ?? '';
  set avatar(String? val) => _avatar = val;

  bool hasAvatar() => _avatar != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  static PhoneRecordsStruct fromMap(Map<String, dynamic> data) =>
      PhoneRecordsStruct(
        name: data['name'] as String?,
        phone: data['phone'] as String?,
        avatar: data['avatar'] as String?,
        email: data['email'] as String?,
      );

  static PhoneRecordsStruct? maybeFromMap(dynamic data) => data is Map
      ? PhoneRecordsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'phone': _phone,
        'avatar': _avatar,
        'email': _email,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'avatar': serializeParam(
          _avatar,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
      }.withoutNulls;

  static PhoneRecordsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PhoneRecordsStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        avatar: deserializeParam(
          data['avatar'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PhoneRecordsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PhoneRecordsStruct &&
        name == other.name &&
        phone == other.phone &&
        avatar == other.avatar &&
        email == other.email;
  }

  @override
  int get hashCode => const ListEquality().hash([name, phone, avatar, email]);
}

PhoneRecordsStruct createPhoneRecordsStruct({
  String? name,
  String? phone,
  String? avatar,
  String? email,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PhoneRecordsStruct(
      name: name,
      phone: phone,
      avatar: avatar,
      email: email,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PhoneRecordsStruct? updatePhoneRecordsStruct(
  PhoneRecordsStruct? phoneRecords, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    phoneRecords
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPhoneRecordsStructData(
  Map<String, dynamic> firestoreData,
  PhoneRecordsStruct? phoneRecords,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (phoneRecords == null) {
    return;
  }
  if (phoneRecords.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && phoneRecords.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final phoneRecordsData =
      getPhoneRecordsFirestoreData(phoneRecords, forFieldValue);
  final nestedData =
      phoneRecordsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = phoneRecords.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPhoneRecordsFirestoreData(
  PhoneRecordsStruct? phoneRecords, [
  bool forFieldValue = false,
]) {
  if (phoneRecords == null) {
    return {};
  }
  final firestoreData = mapToFirestore(phoneRecords.toMap());

  // Add any Firestore field values
  phoneRecords.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPhoneRecordsListFirestoreData(
  List<PhoneRecordsStruct>? phoneRecordss,
) =>
    phoneRecordss?.map((e) => getPhoneRecordsFirestoreData(e, true)).toList() ??
    [];
