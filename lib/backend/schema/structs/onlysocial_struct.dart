// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class OnlysocialStruct extends FFFirebaseStruct {
  OnlysocialStruct({
    bool? onlysocial,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _onlysocial = onlysocial,
        super(firestoreUtilData);

  // "onlysocial" field.
  bool? _onlysocial;
  bool get onlysocial => _onlysocial ?? true;
  set onlysocial(bool? val) => _onlysocial = val;

  bool hasOnlysocial() => _onlysocial != null;

  static OnlysocialStruct fromMap(Map<String, dynamic> data) =>
      OnlysocialStruct(
        onlysocial: data['onlysocial'] as bool?,
      );

  static OnlysocialStruct? maybeFromMap(dynamic data) => data is Map
      ? OnlysocialStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'onlysocial': _onlysocial,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'onlysocial': serializeParam(
          _onlysocial,
          ParamType.bool,
        ),
      }.withoutNulls;

  static OnlysocialStruct fromSerializableMap(Map<String, dynamic> data) =>
      OnlysocialStruct(
        onlysocial: deserializeParam(
          data['onlysocial'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'OnlysocialStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OnlysocialStruct && onlysocial == other.onlysocial;
  }

  @override
  int get hashCode => const ListEquality().hash([onlysocial]);
}

OnlysocialStruct createOnlysocialStruct({
  bool? onlysocial,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    OnlysocialStruct(
      onlysocial: onlysocial,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

OnlysocialStruct? updateOnlysocialStruct(
  OnlysocialStruct? onlysocialStruct, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    onlysocialStruct
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addOnlysocialStructData(
  Map<String, dynamic> firestoreData,
  OnlysocialStruct? onlysocialStruct,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (onlysocialStruct == null) {
    return;
  }
  if (onlysocialStruct.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && onlysocialStruct.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final onlysocialStructData =
      getOnlysocialFirestoreData(onlysocialStruct, forFieldValue);
  final nestedData =
      onlysocialStructData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = onlysocialStruct.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getOnlysocialFirestoreData(
  OnlysocialStruct? onlysocialStruct, [
  bool forFieldValue = false,
]) {
  if (onlysocialStruct == null) {
    return {};
  }
  final firestoreData = mapToFirestore(onlysocialStruct.toMap());

  // Add any Firestore field values
  onlysocialStruct.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getOnlysocialListFirestoreData(
  List<OnlysocialStruct>? onlysocialStructs,
) =>
    onlysocialStructs
        ?.map((e) => getOnlysocialFirestoreData(e, true))
        .toList() ??
    [];
