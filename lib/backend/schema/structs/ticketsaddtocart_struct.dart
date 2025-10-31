// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class TicketsaddtocartStruct extends FFFirebaseStruct {
  TicketsaddtocartStruct({
    int? ticketid,
    int? quantity,
    String? ticketname,
    String? ticketprice,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _ticketid = ticketid,
        _quantity = quantity,
        _ticketname = ticketname,
        _ticketprice = ticketprice,
        super(firestoreUtilData);

  // "ticketid" field.
  int? _ticketid;
  int get ticketid => _ticketid ?? 0;
  set ticketid(int? val) => _ticketid = val;

  void incrementTicketid(int amount) => ticketid = ticketid + amount;

  bool hasTicketid() => _ticketid != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "ticketname" field.
  String? _ticketname;
  String get ticketname => _ticketname ?? '';
  set ticketname(String? val) => _ticketname = val;

  bool hasTicketname() => _ticketname != null;

  // "ticketprice" field.
  String? _ticketprice;
  String get ticketprice => _ticketprice ?? '';
  set ticketprice(String? val) => _ticketprice = val;

  bool hasTicketprice() => _ticketprice != null;

  static TicketsaddtocartStruct fromMap(Map<String, dynamic> data) =>
      TicketsaddtocartStruct(
        ticketid: castToType<int>(data['ticketid']),
        quantity: castToType<int>(data['quantity']),
        ticketname: data['ticketname'] as String?,
        ticketprice: data['ticketprice'] as String?,
      );

  static TicketsaddtocartStruct? maybeFromMap(dynamic data) => data is Map
      ? TicketsaddtocartStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ticketid': _ticketid,
        'quantity': _quantity,
        'ticketname': _ticketname,
        'ticketprice': _ticketprice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ticketid': serializeParam(
          _ticketid,
          ParamType.int,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
        'ticketname': serializeParam(
          _ticketname,
          ParamType.String,
        ),
        'ticketprice': serializeParam(
          _ticketprice,
          ParamType.String,
        ),
      }.withoutNulls;

  static TicketsaddtocartStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TicketsaddtocartStruct(
        ticketid: deserializeParam(
          data['ticketid'],
          ParamType.int,
          false,
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        ticketname: deserializeParam(
          data['ticketname'],
          ParamType.String,
          false,
        ),
        ticketprice: deserializeParam(
          data['ticketprice'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TicketsaddtocartStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TicketsaddtocartStruct &&
        ticketid == other.ticketid &&
        quantity == other.quantity &&
        ticketname == other.ticketname &&
        ticketprice == other.ticketprice;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([ticketid, quantity, ticketname, ticketprice]);
}

TicketsaddtocartStruct createTicketsaddtocartStruct({
  int? ticketid,
  int? quantity,
  String? ticketname,
  String? ticketprice,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TicketsaddtocartStruct(
      ticketid: ticketid,
      quantity: quantity,
      ticketname: ticketname,
      ticketprice: ticketprice,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TicketsaddtocartStruct? updateTicketsaddtocartStruct(
  TicketsaddtocartStruct? ticketsaddtocart, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    ticketsaddtocart
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTicketsaddtocartStructData(
  Map<String, dynamic> firestoreData,
  TicketsaddtocartStruct? ticketsaddtocart,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (ticketsaddtocart == null) {
    return;
  }
  if (ticketsaddtocart.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && ticketsaddtocart.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final ticketsaddtocartData =
      getTicketsaddtocartFirestoreData(ticketsaddtocart, forFieldValue);
  final nestedData =
      ticketsaddtocartData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = ticketsaddtocart.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTicketsaddtocartFirestoreData(
  TicketsaddtocartStruct? ticketsaddtocart, [
  bool forFieldValue = false,
]) {
  if (ticketsaddtocart == null) {
    return {};
  }
  final firestoreData = mapToFirestore(ticketsaddtocart.toMap());

  // Add any Firestore field values
  ticketsaddtocart.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTicketsaddtocartListFirestoreData(
  List<TicketsaddtocartStruct>? ticketsaddtocarts,
) =>
    ticketsaddtocarts
        ?.map((e) => getTicketsaddtocartFirestoreData(e, true))
        .toList() ??
    [];
