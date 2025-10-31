// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DatetimeformatStruct extends FFFirebaseStruct {
  DatetimeformatStruct({
    DateTime? datetime,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _datetime = datetime,
        super(firestoreUtilData);

  // "datetime" field.
  DateTime? _datetime;
  DateTime? get datetime => _datetime;
  set datetime(DateTime? val) => _datetime = val;

  bool hasDatetime() => _datetime != null;

  static DatetimeformatStruct fromMap(Map<String, dynamic> data) =>
      DatetimeformatStruct(
        datetime: data['datetime'] as DateTime?,
      );

  static DatetimeformatStruct? maybeFromMap(dynamic data) => data is Map
      ? DatetimeformatStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'datetime': _datetime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'datetime': serializeParam(
          _datetime,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static DatetimeformatStruct fromSerializableMap(Map<String, dynamic> data) =>
      DatetimeformatStruct(
        datetime: deserializeParam(
          data['datetime'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'DatetimeformatStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DatetimeformatStruct && datetime == other.datetime;
  }

  @override
  int get hashCode => const ListEquality().hash([datetime]);
}

DatetimeformatStruct createDatetimeformatStruct({
  DateTime? datetime,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DatetimeformatStruct(
      datetime: datetime,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DatetimeformatStruct? updateDatetimeformatStruct(
  DatetimeformatStruct? datetimeformat, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    datetimeformat
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDatetimeformatStructData(
  Map<String, dynamic> firestoreData,
  DatetimeformatStruct? datetimeformat,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (datetimeformat == null) {
    return;
  }
  if (datetimeformat.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && datetimeformat.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final datetimeformatData =
      getDatetimeformatFirestoreData(datetimeformat, forFieldValue);
  final nestedData =
      datetimeformatData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = datetimeformat.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDatetimeformatFirestoreData(
  DatetimeformatStruct? datetimeformat, [
  bool forFieldValue = false,
]) {
  if (datetimeformat == null) {
    return {};
  }
  final firestoreData = mapToFirestore(datetimeformat.toMap());

  // Add any Firestore field values
  datetimeformat.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDatetimeformatListFirestoreData(
  List<DatetimeformatStruct>? datetimeformats,
) =>
    datetimeformats
        ?.map((e) => getDatetimeformatFirestoreData(e, true))
        .toList() ??
    [];
