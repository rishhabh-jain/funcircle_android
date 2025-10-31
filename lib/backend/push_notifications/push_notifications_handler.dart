import 'dart:async';

import 'serialization_util.dart';
import '/backend/backend.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


final _handledMessageIds = <String?>{};

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  _PushNotificationsHandlerState createState() =>
      _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    if (isWeb) {
      return;
    }

    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    safeSetState(() => _loading = true);
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);
      final parametersBuilder = parametersBuilderMap[initialPageName];
      if (parametersBuilder != null) {
        final parameterData = await parametersBuilder(initialParameterData);
        if (mounted) {
          context.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        } else {
          appNavigatorKey.currentContext?.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      safeSetState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handleOpenedPushNotification();
    });
  }

  @override
  Widget build(BuildContext context) => _loading
      ? isWeb
          ? Container()
          : Container(
              color: Colors.transparent,
              child: Image.asset(
                'assets/images/faceout_(4).png',
                fit: BoxFit.cover,
              ),
            )
      : widget.child;
}

class ParameterData {
  const ParameterData(
      {this.requiredParams = const {}, this.allParams = const {}});
  final Map<String, String?> requiredParams;
  final Map<String, dynamic> allParams;

  Map<String, String> get pathParameters => Map.fromEntries(
        requiredParams.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
  Map<String, dynamic> get extra => Map.fromEntries(
        allParams.entries.where((e) => e.value != null),
      );

  static Future<ParameterData> Function(Map<String, dynamic>) none() =>
      (data) async => ParameterData();
}

final parametersBuilderMap =
    <String, Future<ParameterData> Function(Map<String, dynamic>)>{
  'onboarding': ParameterData.none(),
  'myProfile': ParameterData.none(),
  'othersProfile': (data) async {
    final allParams = {
      'uid': getParameter<String>(data, 'uid'),
    };
    return ParameterData(
      requiredParams: {
        'uid': serializeParam(
          allParams['uid'],
          ParamType.String,
        ),
      },
      allParams: allParams,
    );
  },
  'editProfile': ParameterData.none(),
  'searchProfile': ParameterData.none(),
  'searchProfileFilters': ParameterData.none(),
  'connectionandgroups': (data) async => ParameterData(
        allParams: {
          'tabindex': getParameter<int>(data, 'tabindex'),
        },
      ),
  'Social': (data) async => ParameterData(
        allParams: {
          'tabindex': getParameter<int>(data, 'tabindex'),
        },
      ),
  'viewGroup': (data) async {
    final allParams = {
      'groupid': getParameter<int>(data, 'groupid'),
    };
    return ParameterData(
      requiredParams: {
        'groupid': serializeParam(
          allParams['groupid'],
          ParamType.int,
        ),
      },
      allParams: allParams,
    );
  },
  'Recommended': ParameterData.none(),
  'Premium': ParameterData.none(),
  'CreateGroup': ParameterData.none(),
  'CompleteProfilePage': ParameterData.none(),
  'Name': (data) async => ParameterData(
        allParams: {
          'location': getParameter<LatLng>(data, 'location'),
        },
      ),
  'SignupNew': ParameterData.none(),
  'OtpVerification': (data) async => ParameterData(
        allParams: {
          'mobilenumber': getParameter<String>(data, 'mobilenumber'),
          'type': getParameter<String>(data, 'type'),
          'name': getParameter<String>(data, 'name'),
          'email': getParameter<String>(data, 'email'),
        },
      ),
  'AddImages': ParameterData.none(),
  'Drink': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'Workandeducation': (data) async => ParameterData(
        allParams: {
          'workTitle': getParameter<String>(data, 'workTitle'),
          'company': getParameter<String>(data, 'company'),
          'college': getParameter<String>(data, 'college'),
          'graduationyear': getParameter<String>(data, 'graduationyear'),
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'doyousmoke': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'Religion': ParameterData.none(),
  'MotherTungue': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'Lookingfor': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'Hometown': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'Height': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'PoliticalLeanings': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'Workout': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'Zodiac': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
        },
      ),
  'bio': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
          'biotext': getParameter<String>(data, 'biotext'),
        },
      ),
  'interests': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
          'filters': getParameter<bool>(data, 'filters'),
          'groupid': getParameter<int>(data, 'groupid'),
          'ifonlyfogroups': getParameter<bool>(data, 'ifonlyfogroups'),
        },
      ),
  'Prompts': (data) async => ParameterData(
        allParams: {
          'fromeditprofile': getParameter<bool>(data, 'fromeditprofile'),
        },
      ),
  'answerprompt': (data) async => ParameterData(
        allParams: {
          'questionText': getParameter<String>(data, 'questionText'),
          'promptid': getParameter<int>(data, 'promptid'),
          'answertext': getParameter<String>(data, 'answertext'),
          'fromeditProfile': getParameter<bool>(data, 'fromeditProfile'),
          'questionisset': getParameter<bool>(data, 'questionisset'),
        },
      ),
  'chat': (data) async => ParameterData(
        allParams: {
          'chatUser': await getDocumentParameter<UsersRecord>(
              data, 'chatUser', UsersRecord.fromSnapshot),
          'chatRef': getParameter<DocumentReference>(data, 'chatRef'),
        },
      ),
  'allchats': ParameterData.none(),
  'paymentsuccess': (data) async => ParameterData(
        allParams: {
          'amount': getParameter<String>(data, 'amount'),
        },
      ),
  'groupfilters': (data) async => ParameterData(
        allParams: {
          'tabindex': getParameter<int>(data, 'tabindex'),
        },
      ),
  'likedusers': ParameterData.none(),
  'settings': ParameterData.none(),
  'helpcenter': ParameterData.none(),
  'notifications': ParameterData.none(),
  'webview': (data) async => ParameterData(
        allParams: {
          'url': getParameter<String>(data, 'url'),
        },
      ),
  'accesslocation': ParameterData.none(),
  'createtickets': (data) async => ParameterData(
        allParams: {
          'groupId': getParameter<int>(data, 'groupId'),
          'groupName': getParameter<String>(data, 'groupName'),
          'ifMyGroups': getParameter<bool>(data, 'ifMyGroups'),
        },
      ),
  'mygroups': ParameterData.none(),
  'booktickets': (data) async => ParameterData(
        allParams: {
          'groupid': getParameter<int>(data, 'groupid'),
          'groupname': getParameter<String>(data, 'groupname'),
          'ticketid': getParameter<int>(data, 'ticketid'),
        },
      ),
  'myticket': (data) async => ParameterData(
        allParams: {
          'ticketid': getParameter<int>(data, 'ticketid'),
          'orderid': getParameter<int>(data, 'orderid'),
        },
      ),
  'mytickets': ParameterData.none(),
  'editgroups': (data) async => ParameterData(
        allParams: {
          'groupid': getParameter<int>(data, 'groupid'),
        },
      ),
  'groupordating': ParameterData.none(),
  'likesbyrecommended': ParameterData.none(),
  'Requests': (data) async => ParameterData(
        allParams: {
          'groupId': getParameter<int>(data, 'groupId'),
        },
      ),
  'postrequest': (data) async => ParameterData(
        allParams: {
          'groupId': getParameter<int>(data, 'groupId'),
        },
      ),
  'Myrequests': ParameterData.none(),
  'Interestedpeople': (data) async => ParameterData(
        allParams: {
          'requestid': getParameter<int>(data, 'requestid'),
        },
      ),
  'myinterestedrequests': ParameterData.none(),
  'Createticketgroups': (data) async => ParameterData(
        allParams: {
          'groupId': getParameter<int>(data, 'groupId'),
          'ticketId': getParameter<int>(data, 'ticketId'),
          'isRsvp': getParameter<bool>(data, 'isRsvp'),
          'isclone': getParameter<bool>(data, 'isclone'),
        },
      ),
  'seewhojoined': (data) async => ParameterData(
        allParams: {
          'ticketid': getParameter<int>(data, 'ticketid'),
        },
      ),
  'ticketwebview': ParameterData.none(),
  'secretfields': ParameterData.none(),
  'reportaglitch': (data) async => ParameterData(
        allParams: {
          'uid': getParameter<String>(data, 'uid'),
          'biotext': getParameter<String>(data, 'biotext'),
        },
      ),
  'Sales': (data) async => ParameterData(
        allParams: <String, dynamic>{},
      ),
  'Createvenue': ParameterData.none(),
  'EditTicket': (data) async => ParameterData(
        allParams: {
          'ticketId': getParameter<int>(data, 'ticketId'),
        },
      ),
  'sendNotification': ParameterData.none(),
  'slots': (data) async => ParameterData(
        allParams: {
          'groupid': getParameter<int>(data, 'groupid'),
        },
      ),
  'subscriptionquestions': ParameterData.none(),
  'homepagewebview': (data) async => ParameterData(
        allParams: {
          'url': getParameter<String>(data, 'url'),
        },
      ),
  'Play': ParameterData.none(),
  'Venues': ParameterData.none(),
  'Profile': ParameterData.none(),
  'Mygroupsweb': ParameterData.none(),
  'Bookingsweb': ParameterData.none(),
  'duoconnectionsweb': ParameterData.none(),
  'Requestsweb': ParameterData.none(),
  'editprofileweb': ParameterData.none(),
  'HomeNew': ParameterData.none(),
  'VenuesNew': ParameterData.none(),
  'SingleVenueNew': (data) async => ParameterData(
        allParams: {
          'venueid': getParameter<int>(data, 'venueid'),
        },
      ),
  'playnew': ParameterData.none(),
  'findPlayersNew': ParameterData.none(),
  'chatsnew': ParameterData.none(),
  'playerNew': ParameterData.none(),
  'GameRequestsnew': ParameterData.none(),
  'Duorequestsnew': ParameterData.none(),
  'LoginNew': ParameterData.none(),
};

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null ||
        parameterDataStr is! String ||
        parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}
