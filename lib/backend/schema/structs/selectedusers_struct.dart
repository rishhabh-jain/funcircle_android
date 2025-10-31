// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SelectedusersStruct extends FFFirebaseStruct {
  SelectedusersStruct({
    String? userid,
    String? name,
    String? number,
    int? orderid,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _userid = userid,
        _name = name,
        _number = number,
        _orderid = orderid,
        super(firestoreUtilData);

  // "userid" field.
  String? _userid;
  String get userid => _userid ?? '';
  set userid(String? val) => _userid = val;

  bool hasUserid() => _userid != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "number" field.
  String? _number;
  String get number => _number ?? '';
  set number(String? val) => _number = val;

  bool hasNumber() => _number != null;

  // "orderid" field.
  int? _orderid;
  int get orderid => _orderid ?? 0;
  set orderid(int? val) => _orderid = val;

  void incrementOrderid(int amount) => orderid = orderid + amount;

  bool hasOrderid() => _orderid != null;

  static SelectedusersStruct fromMap(Map<String, dynamic> data) =>
      SelectedusersStruct(
        userid: data['userid'] as String?,
        name: data['name'] as String?,
        number: data['number'] as String?,
        orderid: castToType<int>(data['orderid']),
      );

  static SelectedusersStruct? maybeFromMap(dynamic data) => data is Map
      ? SelectedusersStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'userid': _userid,
        'name': _name,
        'number': _number,
        'orderid': _orderid,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'userid': serializeParam(
          _userid,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'number': serializeParam(
          _number,
          ParamType.String,
        ),
        'orderid': serializeParam(
          _orderid,
          ParamType.int,
        ),
      }.withoutNulls;

  static SelectedusersStruct fromSerializableMap(Map<String, dynamic> data) =>
      SelectedusersStruct(
        userid: deserializeParam(
          data['userid'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        number: deserializeParam(
          data['number'],
          ParamType.String,
          false,
        ),
        orderid: deserializeParam(
          data['orderid'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SelectedusersStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectedusersStruct &&
        userid == other.userid &&
        name == other.name &&
        number == other.number &&
        orderid == other.orderid;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([userid, name, number, orderid]);
}

SelectedusersStruct createSelectedusersStruct({
  String? userid,
  String? name,
  String? number,
  int? orderid,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SelectedusersStruct(
      userid: userid,
      name: name,
      number: number,
      orderid: orderid,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SelectedusersStruct? updateSelectedusersStruct(
  SelectedusersStruct? selectedusers, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    selectedusers
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSelectedusersStructData(
  Map<String, dynamic> firestoreData,
  SelectedusersStruct? selectedusers,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (selectedusers == null) {
    return;
  }
  if (selectedusers.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && selectedusers.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final selectedusersData =
      getSelectedusersFirestoreData(selectedusers, forFieldValue);
  final nestedData =
      selectedusersData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = selectedusers.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSelectedusersFirestoreData(
  SelectedusersStruct? selectedusers, [
  bool forFieldValue = false,
]) {
  if (selectedusers == null) {
    return {};
  }
  final firestoreData = mapToFirestore(selectedusers.toMap());

  // Add any Firestore field values
  selectedusers.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSelectedusersListFirestoreData(
  List<SelectedusersStruct>? selecteduserss,
) =>
    selecteduserss
        ?.map((e) => getSelectedusersFirestoreData(e, true))
        .toList() ??
    [];
