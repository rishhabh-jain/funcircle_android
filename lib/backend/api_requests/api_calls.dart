import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Wordpress  Group Code

class WordpressGroup {
  static String getBaseUrl() => 'https://faceout.in/wp-json';
  static Map<String, String> headers = {
    'Authorization': 'Basic dGVzdGluZzp0ZXN0aW5n',
  };
  static TestingCall testingCall = TestingCall();
  static DigitsCreateUserCall digitsCreateUserCall = DigitsCreateUserCall();
  static CreateEventCall createEventCall = CreateEventCall();
  static PostTicketsAsProductsCall postTicketsAsProductsCall =
      PostTicketsAsProductsCall();
}

class TestingCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = WordpressGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'testing',
      apiUrl: '${baseUrl}/wp/v2/users',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Basic dGVzdGluZzp0ZXN0aW5n',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DigitsCreateUserCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = WordpressGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
 "digits_reg_name": "name", 
"digits_reg_countrycode": "+91",
"digits_reg_mobile": "9561079271", 
"digits_reg_password" : "9561079271",
"digits_reg_username" : "9561079271",
"digits_reg_email" : "testing@number.com"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'digits create user ',
      apiUrl: '${baseUrl}/digits/v1/create_user',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Basic dGVzdGluZzp0ZXN0aW5n',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateEventCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = WordpressGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'create event ',
      apiUrl: '${baseUrl}/tribe/events/v1/events/by-slug/testing-event-2',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Basic dGVzdGluZzp0ZXN0aW5n',
      },
      params: {
        'date': "12/30/2023",
        'title': "testing event 2 ",
        'description': "testing event 2 ",
        'slug': "testing event 2 ",
        'excerpt': "excerpt testing event 2 ",
        'all_day': false,
        'start_date': "12/30/2023",
        'end_date': "12/31/2023",
        'show_map': true,
        'show_map_link': true,
        'featured': true,
        'categories': "Music Events",
        'tags': "Music Events",
        'author': 3,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PostTicketsAsProductsCall {
  Future<ApiCallResponse> call({
    String? title = 'group name  - ticket name',
    String? description = 'ticket description',
    String? saleprice = '99.0',
    String? sku = '124',
    int? inventory = 10,
  }) async {
    final baseUrl = WordpressGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "name": "${title}",
  "type": "simple",
  "regular_price": "999",
  "sale_price": "${saleprice}",
  "manage_stock": true,
  "stock_quantity": ${inventory},
  "sku": "${sku}",
  "description": "${description}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'post tickets as products',
      apiUrl:
          '${baseUrl}/wc/v3/products?consumer_key=ck_54b21b5b7a55bcd56b8658290d70f40193b9c9c9&consumer_secret=cs_180bb5d11c3fb02227fef552a5803f49fd13f5db',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Basic dGVzdGluZzp0ZXN0aW5n',
        'Content-Type': 'application/json',
        'ck_54b21b5b7a55bcd56b8658290d70f40193b9c9c9':
            'cs_180bb5d11c3fb02227fef552a5803f49fd13f5db',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  int? id(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.id''',
      ));
}

/// End Wordpress  Group Code

class GetUserByUidCall {
  static Future<ApiCallResponse> call({
    String? userId = 'M14YHLI5bzXToPugdEWFL1NQQoy2',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getUserByUid',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/users?select=user_id',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'user_id': "eq.${userId}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? userid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].user_id''',
      ));
}

class GetSecretFieldsOfUserCall {
  static Future<ApiCallResponse> call({
    String? userId = 'GhO4QtVW4Dh7MrjfRmiqJI0gZQv2',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'get secret fields of user',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/users?select=secrets',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'user_id': "eq.${userId}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? userid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].user_id''',
      ));
  static List<String>? secrets(dynamic response) => (getJsonField(
        response,
        r'''$[:].secrets''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetTicketsCall {
  static Future<ApiCallResponse> call({
    int? groupId = 90,
    String? ticketstatus = 'live',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'get tickets',
      apiUrl: 'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/tickets',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'group_id': "eq.${groupId}",
        'ticketstatus': "eq.${ticketstatus}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<int>? ticketid(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
}

class GetinterestedrequestsCall {
  static Future<ApiCallResponse> call({
    String? otherUserId = 'o93dAfslWjYdPSHLdMQQkFt1C782',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getinterestedrequests',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/interested_requests',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'other_user_id': "eq.${otherUserId}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? userid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].user_id''',
      ));
  static List<int>? requestids(dynamic response) => (getJsonField(
        response,
        r'''$[:].request_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
}

class GetCompletionStatusCall {
  static Future<ApiCallResponse> call({
    String? userId = 'JPNa4LoWK4OCIGh69DdH7LexICm2',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getCompletionStatus',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/userprofilecompletionstatus?select=completionstatus',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'user_id': "eq.${userId}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? completionstatus(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$[:].completionstatus''',
      ));
}

class GetCurrentstepCall {
  static Future<ApiCallResponse> call({
    String? userId = 'ilVx0ctnXOYvB1fMEE8LrgCAksH3',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getCurrentstep',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/userprofilecompletionstatus?select=current_step',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'user_id': "eq.${userId}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? currentStep(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].current_step''',
      ));
}

class GeocodingCall {
  static Future<ApiCallResponse> call({
    String? latlang = '28.4295618 , 77.1088837',
    String? key = 'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'geocoding ',
      apiUrl: 'https://maps.googleapis.com/maps/api/geocode/json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'latlng': latlang,
        'key': "AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? cityname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.plus_code.compound_code''',
      ));
}

class PlacesapiCall {
  static Future<ApiCallResponse> call({
    String? input = 'sector 55, gurgaon',
    String? key = 'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'placesapi',
      apiUrl: 'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'inout': input,
        'key': key,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CheckConnectionCall {
  static Future<ApiCallResponse> call({
    String? userid1 = 'keKOzCCpv8ff66SyQOMp9wPaafj2',
    String? userid2 = 'wt4N2zkuWTXDwbuZmmnEafZ6qoC3',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'checkConnection',
      apiUrl: 'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/rpc/check3',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'uid1': "${userid1}",
        'uid2': "${userid2}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? result(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$''',
      ));
}

class FindconnectionsforuserCall {
  static Future<ApiCallResponse> call({
    String? userId = 'YTTGuS8keBeTfNN6gpMq8zcQnEi2',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'findconnectionsforuser',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/rpc/find_connections_for_user',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'uid': "${userId}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? userid(dynamic response) => getJsonField(
        response,
        r'''$[:].connected_user_id''',
        true,
      ) as List?;
}

class CheckuserlikestatusCall {
  static Future<ApiCallResponse> call({
    String? uid1 = 'QqKBy2e6QPa4qgluxGqIE9zDRe03',
    String? uid2 = 'YTTGuS8keBeTfNN6gpMq8zcQnEi2',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'checkuserlikestatus',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/userlikes?select=*',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'liker_user_id': "eq.${uid1}",
        'liked_user_id': "eq.${uid2}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? likeid(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].like_id''',
      ));
  static String? liker(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].liker_user_id''',
      ));
  static String? liked(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].liked_user_id''',
      ));
}

class CheckjoinedgroupsCall {
  static Future<ApiCallResponse> call({
    String? uid = 'GhO4QtVW4Dh7MrjfRmiqJI0gZQv2',
    String? groupid = '32',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'checkjoinedgroups',
      apiUrl: 'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/userstogroups',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'user_id': "eq.${uid}",
        'group_id': "eq.${groupid}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<int>? groupid(dynamic response) => (getJsonField(
        response,
        r'''$[:].group_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].invitation_status''',
      ));
}

class CheckconnectionstatusCall {
  static Future<ApiCallResponse> call({
    String? uid1 = 'keKOzCCpv8ff66SyQOMp9wPaafj2',
    String? uid2 = 'wt4N2zkuWTXDwbuZmmnEafZ6qoC3',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'checkconnectionstatus',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/rpc/checkstatus',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'uid1': uid1,
        'uid2': uid2,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$''',
      ));
}

class SearchsocialCall {
  static Future<ApiCallResponse> call({
    String? pSearchQuery = '',
    String? pGroupType = 'Event',
    String? pLocation = '',
    bool? pExclusive = true,
    List<String>? pInterestsList,
  }) async {
    final pInterests = _serializeList(pInterestsList);

    return ApiManager.instance.makeApiCall(
      callName: 'searchsocial',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/rpc/search_with_filters',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'p_search_query': "${pSearchQuery}",
        'p_group_type': "${pGroupType}",
        'p_location': "${pLocation}",
        'p_exclusive': pExclusive,
        'p_interests': "{${pInterests}}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? name(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].name''',
      ));
}

class SearchsocialCopyCall {
  static Future<ApiCallResponse> call({
    String? pSearchQuery = '',
    String? pGroupType = 'Party',
    String? pLocation = '',
    bool? pExclusive = false,
    String? pInterests = '{}',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'searchsocial Copy',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/rpc/search_with_filters_third3',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'p_search_query': "${pSearchQuery}",
        'p_group_type': "${pGroupType}",
        'p_location': "${pLocation}",
        'p_exclusive': pExclusive,
        'p_interests': "{}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? groupdetails(dynamic response) => getJsonField(
        response,
        r'''$[:].groupdetails''',
        true,
      ) as List?;
  static List<int>? id(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? loaction(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.location''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? exclusive(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.exclusive''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? interests(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.interests''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? type(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? topevents(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.top_events''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? profileimage(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.profile_image''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class SearchUsersPremiumCall {
  static Future<ApiCallResponse> call({
    String? maxAge = '24',
    String? minHeight = '',
    String? exerciseStatus = '',
    String? drinkStatus = '',
    String? smokeStatus = '',
    String? relationshipStatus = '',
    String? starSign = '',
    String? politics = '',
    String? religion = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'search users premium',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/rpc/search_users',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'p_max_age': "${maxAge}",
        'p_min_height': "${minHeight}",
        'p_workout_status': "${minHeight}",
        'p_drink': "${drinkStatus}",
        'p_smoke': "${smokeStatus}",
        'p_relationship': "${relationshipStatus}",
        'p_star_sign': "${starSign}",
        'p_politics': "${politics}",
        'p_religion': "${religion}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? groupdetails(dynamic response) => getJsonField(
        response,
        r'''$[:].groupdetails''',
        true,
      ) as List?;
  static List<int>? id(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? loaction(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.location''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? exclusive(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.exclusive''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? interests(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.interests''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? type(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? topevents(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.top_events''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? profileimage(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.profile_image''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$[:].groupdetails.group_description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class RecommendationalgoCall {
  static Future<ApiCallResponse> call({
    String? userId = 'YTTGuS8keBeTfNN6gpMq8zcQnEi2',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": "${userId}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'recommendationalgo',
      apiUrl: 'https://faceout.pythonanywhere.com/recommend',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? userids(dynamic response) => (getJsonField(
        response,
        r'''$.recommendations''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class CheckifuseringroupCall {
  static Future<ApiCallResponse> call({
    String? mobileNumber = '9561079271',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'checkifuseringroup',
      apiUrl:
          'https://vtpylvqmrjlbdjhaxczd.supabase.co/rest/v1/userstogroups?select=*',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0cHlsdnFtcmpsYmRqaGF4Y3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM3Mjc1ODAsImV4cCI6MjAwOTMwMzU4MH0.6pY-BiUqSNASAbbeaEIsa5HTO0oM-ryUeS4kHbD7Pvk',
      },
      params: {
        'mobile_number': "eq.${mobileNumber}",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? mobilenumber(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$[:].mobile_number''',
      ));
}

class GeocodingreverseCall {
  static Future<ApiCallResponse> call({
    String? lat = '19.047321',
    String? long = '73.069908',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'geocodingreverse',
      apiUrl:
          'https://geocode.maps.co/reverse?lat=${lat}&lon=${long}&api_key=658c1e8cc9683564735150ctk6ff140',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? city(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.address.city''',
      ));
}

class HomepagevenuesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'homepagevenues',
      apiUrl: 'https://www.funcircleapp.com/api/location/venues-with-distance',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'lat': "28.429617075273832",
        'lng': "77.10883282488959",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  static List? images(dynamic response) => getJsonField(
        response,
        r'''$.data[:].images''',
        true,
      ) as List?;
}

class GoogledistanceatrixCall {
  static Future<ApiCallResponse> call({
    double? originlat = 28.9999,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'googledistanceatrix',
      apiUrl:
          'https://maps.googleapis.com/maps/api/distancematrix/json?origins=\${origin.lat},\${origin.lng}&destinations=\${destinationsString}&mode=driving&key=AIzaSyCSLETWYUlDFVtFwF7D_73VTKn6ZmsqWM8',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'originlat': originlat,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
