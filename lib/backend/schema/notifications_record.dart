import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "sender_id" field.
  DocumentReference? _senderId;
  DocumentReference? get senderId => _senderId;
  bool hasSenderId() => _senderId != null;

  // "notification_type" field.
  String? _notificationType;
  String get notificationType => _notificationType ?? '';
  bool hasNotificationType() => _notificationType != null;

  // "content_text" field.
  String? _contentText;
  String get contentText => _contentText ?? '';
  bool hasContentText() => _contentText != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "viewed" field.
  bool? _viewed;
  bool get viewed => _viewed ?? false;
  bool hasViewed() => _viewed != null;

  // "sender_name" field.
  String? _senderName;
  String get senderName => _senderName ?? '';
  bool hasSenderName() => _senderName != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as DocumentReference?;
    _senderId = snapshotData['sender_id'] as DocumentReference?;
    _notificationType = snapshotData['notification_type'] as String?;
    _contentText = snapshotData['content_text'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _image = snapshotData['image'] as String?;
    _viewed = snapshotData['viewed'] as bool?;
    _senderName = snapshotData['sender_name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notifications');

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  DocumentReference? userId,
  DocumentReference? senderId,
  String? notificationType,
  String? contentText,
  DateTime? timestamp,
  String? image,
  bool? viewed,
  String? senderName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'sender_id': senderId,
      'notification_type': notificationType,
      'content_text': contentText,
      'timestamp': timestamp,
      'image': image,
      'viewed': viewed,
      'sender_name': senderName,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.senderId == e2?.senderId &&
        e1?.notificationType == e2?.notificationType &&
        e1?.contentText == e2?.contentText &&
        e1?.timestamp == e2?.timestamp &&
        e1?.image == e2?.image &&
        e1?.viewed == e2?.viewed &&
        e1?.senderName == e2?.senderName;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.senderId,
        e?.notificationType,
        e?.contentText,
        e?.timestamp,
        e?.image,
        e?.viewed,
        e?.senderName
      ]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
