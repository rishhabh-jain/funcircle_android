import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContactRecord extends FirestoreRecord {
  ContactRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "contact" field.
  List<PhoneRecordsStruct>? _contact;
  List<PhoneRecordsStruct> get contact => _contact ?? const [];
  bool hasContact() => _contact != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _createdAt = snapshotData['created_at'] as DateTime?;
    _contact = getStructList(
      snapshotData['contact'],
      PhoneRecordsStruct.fromMap,
    );
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('contact')
          : FirebaseFirestore.instance.collectionGroup('contact');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('contact').doc(id);

  static Stream<ContactRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ContactRecord.fromSnapshot(s));

  static Future<ContactRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ContactRecord.fromSnapshot(s));

  static ContactRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ContactRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ContactRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ContactRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ContactRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ContactRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createContactRecordData({
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class ContactRecordDocumentEquality implements Equality<ContactRecord> {
  const ContactRecordDocumentEquality();

  @override
  bool equals(ContactRecord? e1, ContactRecord? e2) {
    const listEquality = ListEquality();
    return e1?.createdAt == e2?.createdAt &&
        listEquality.equals(e1?.contact, e2?.contact);
  }

  @override
  int hash(ContactRecord? e) =>
      const ListEquality().hash([e?.createdAt, e?.contact]);

  @override
  bool isValidKey(Object? o) => o is ContactRecord;
}
