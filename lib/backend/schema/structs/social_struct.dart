// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SocialStruct extends FFFirebaseStruct {
  SocialStruct({
    int? groupId,
    String? name,
    String? description,
    String? groupType,
    String? location,
    bool? exclusive,
    bool? topEvents,
    String? profileImage,
    List<String>? interests,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _groupId = groupId,
        _name = name,
        _description = description,
        _groupType = groupType,
        _location = location,
        _exclusive = exclusive,
        _topEvents = topEvents,
        _profileImage = profileImage,
        _interests = interests,
        super(firestoreUtilData);

  // "group_id" field.
  int? _groupId;
  int get groupId => _groupId ?? 0;
  set groupId(int? val) => _groupId = val;

  void incrementGroupId(int amount) => groupId = groupId + amount;

  bool hasGroupId() => _groupId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "group_type" field.
  String? _groupType;
  String get groupType => _groupType ?? '';
  set groupType(String? val) => _groupType = val;

  bool hasGroupType() => _groupType != null;

  // "location" field.
  String? _location;
  String get location => _location ?? '';
  set location(String? val) => _location = val;

  bool hasLocation() => _location != null;

  // "exclusive" field.
  bool? _exclusive;
  bool get exclusive => _exclusive ?? false;
  set exclusive(bool? val) => _exclusive = val;

  bool hasExclusive() => _exclusive != null;

  // "top_events" field.
  bool? _topEvents;
  bool get topEvents => _topEvents ?? false;
  set topEvents(bool? val) => _topEvents = val;

  bool hasTopEvents() => _topEvents != null;

  // "profile_image" field.
  String? _profileImage;
  String get profileImage => _profileImage ?? '';
  set profileImage(String? val) => _profileImage = val;

  bool hasProfileImage() => _profileImage != null;

  // "interests" field.
  List<String>? _interests;
  List<String> get interests => _interests ?? const [];
  set interests(List<String>? val) => _interests = val;

  void updateInterests(Function(List<String>) updateFn) {
    updateFn(_interests ??= []);
  }

  bool hasInterests() => _interests != null;

  static SocialStruct fromMap(Map<String, dynamic> data) => SocialStruct(
        groupId: castToType<int>(data['group_id']),
        name: data['name'] as String?,
        description: data['description'] as String?,
        groupType: data['group_type'] as String?,
        location: data['location'] as String?,
        exclusive: data['exclusive'] as bool?,
        topEvents: data['top_events'] as bool?,
        profileImage: data['profile_image'] as String?,
        interests: getDataList(data['interests']),
      );

  static SocialStruct? maybeFromMap(dynamic data) =>
      data is Map ? SocialStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'group_id': _groupId,
        'name': _name,
        'description': _description,
        'group_type': _groupType,
        'location': _location,
        'exclusive': _exclusive,
        'top_events': _topEvents,
        'profile_image': _profileImage,
        'interests': _interests,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'group_id': serializeParam(
          _groupId,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'group_type': serializeParam(
          _groupType,
          ParamType.String,
        ),
        'location': serializeParam(
          _location,
          ParamType.String,
        ),
        'exclusive': serializeParam(
          _exclusive,
          ParamType.bool,
        ),
        'top_events': serializeParam(
          _topEvents,
          ParamType.bool,
        ),
        'profile_image': serializeParam(
          _profileImage,
          ParamType.String,
        ),
        'interests': serializeParam(
          _interests,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static SocialStruct fromSerializableMap(Map<String, dynamic> data) =>
      SocialStruct(
        groupId: deserializeParam(
          data['group_id'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        groupType: deserializeParam(
          data['group_type'],
          ParamType.String,
          false,
        ),
        location: deserializeParam(
          data['location'],
          ParamType.String,
          false,
        ),
        exclusive: deserializeParam(
          data['exclusive'],
          ParamType.bool,
          false,
        ),
        topEvents: deserializeParam(
          data['top_events'],
          ParamType.bool,
          false,
        ),
        profileImage: deserializeParam(
          data['profile_image'],
          ParamType.String,
          false,
        ),
        interests: deserializeParam<String>(
          data['interests'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'SocialStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SocialStruct &&
        groupId == other.groupId &&
        name == other.name &&
        description == other.description &&
        groupType == other.groupType &&
        location == other.location &&
        exclusive == other.exclusive &&
        topEvents == other.topEvents &&
        profileImage == other.profileImage &&
        listEquality.equals(interests, other.interests);
  }

  @override
  int get hashCode => const ListEquality().hash([
        groupId,
        name,
        description,
        groupType,
        location,
        exclusive,
        topEvents,
        profileImage,
        interests
      ]);
}

SocialStruct createSocialStruct({
  int? groupId,
  String? name,
  String? description,
  String? groupType,
  String? location,
  bool? exclusive,
  bool? topEvents,
  String? profileImage,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SocialStruct(
      groupId: groupId,
      name: name,
      description: description,
      groupType: groupType,
      location: location,
      exclusive: exclusive,
      topEvents: topEvents,
      profileImage: profileImage,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SocialStruct? updateSocialStruct(
  SocialStruct? social, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    social
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSocialStructData(
  Map<String, dynamic> firestoreData,
  SocialStruct? social,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (social == null) {
    return;
  }
  if (social.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && social.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final socialData = getSocialFirestoreData(social, forFieldValue);
  final nestedData = socialData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = social.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSocialFirestoreData(
  SocialStruct? social, [
  bool forFieldValue = false,
]) {
  if (social == null) {
    return {};
  }
  final firestoreData = mapToFirestore(social.toMap());

  // Add any Firestore field values
  social.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSocialListFirestoreData(
  List<SocialStruct>? socials,
) =>
    socials?.map((e) => getSocialFirestoreData(e, true)).toList() ?? [];
