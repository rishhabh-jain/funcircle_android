import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'name_model.dart';
export 'name_model.dart';

class NameWidget extends StatefulWidget {
  const NameWidget({
    super.key,
    this.location,
  });

  final LatLng? location;

  static String routeName = 'Name';
  static String routePath = '/name';

  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  late NameModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NameModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
      logFirebaseEvent('Name_request_permissions');
      await requestPermission(locationPermission);
      if (await getPermissionStatus(locationPermission)) {
        if (functions.isZeroZero(currentUserLocationValue) == true) {
          logFirebaseEvent('Name_alert_dialog');
          var confirmDialogResponse = await showDialog<bool>(
                context: context,
                builder: (alertDialogContext) {
                  return WebViewAware(
                    child: AlertDialog(
                      title: Text('Location not enabled'),
                      content: Text('Please enable your device location.'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, false),
                          child: Text('Ok, got it'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, true),
                          child: Text('Go to location settings'),
                        ),
                      ],
                    ),
                  );
                },
              ) ??
              false;
          if (confirmDialogResponse) {
            logFirebaseEvent('Name_custom_action');
            await actions.turnOnGPS();
            logFirebaseEvent('Name_wait__delay');
            await Future.delayed(
              Duration(
                milliseconds: 10000,
              ),
            );
            if (functions.isZeroZero(currentUserLocationValue) == true) {
              logFirebaseEvent('Name_show_snack_bar');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Fetching city failed',
                    style: GoogleFonts.inter(
                      color: FlutterFlowTheme.of(context).error,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).tertiary,
                ),
              );
              logFirebaseEvent('Name_update_page_state');
              _model.showplacepicker = true;
              _model.showlocationbutton = false;
              safeSetState(() {});
            } else {
              logFirebaseEvent('Name_backend_call');

              await currentUserReference!.update(createUsersRecordData(
                latlong: currentUserLocationValue,
              ));
              logFirebaseEvent('Name_backend_call');
              _model.geocodingreverse34 = await GeocodingreverseCall.call(
                lat: valueOrDefault<String>(
                  functions.latLongString(currentUserLocationValue!, true),
                  '28.4281173',
                ),
                long: valueOrDefault<String>(
                  functions.latLongString(currentUserLocationValue!, false),
                  '77.1100123',
                ),
              );

              if ((_model.geocodingreverse34?.succeeded ?? true)) {
                logFirebaseEvent('Name_update_page_state');
                _model.location = GeocodingreverseCall.city(
                  (_model.geocodingreverse34?.jsonBody ?? ''),
                )!;
                _model.showplacepicker = true;
                _model.showlocationbutton = false;
                safeSetState(() {});
              } else {
                logFirebaseEvent('Name_show_snack_bar');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Fetching city failed',
                      style: GoogleFonts.inter(
                        color: FlutterFlowTheme.of(context).error,
                      ),
                    ),
                    duration: Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).tertiary,
                  ),
                );
                logFirebaseEvent('Name_update_page_state');
                _model.showplacepicker = true;
                _model.showlocationbutton = false;
                safeSetState(() {});
              }
            }
          } else {
            if (functions.isZeroZero(currentUserLocationValue) == true) {
              logFirebaseEvent('Name_show_snack_bar');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Fetching city failed',
                    style: GoogleFonts.inter(
                      color: FlutterFlowTheme.of(context).error,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).tertiary,
                ),
              );
              logFirebaseEvent('Name_update_page_state');
              _model.showplacepicker = true;
              _model.showlocationbutton = false;
              safeSetState(() {});
            } else {
              logFirebaseEvent('Name_backend_call');

              await currentUserReference!.update(createUsersRecordData(
                latlong: currentUserLocationValue,
              ));
              logFirebaseEvent('Name_update_page_state');
              _model.showplacepicker = true;
              _model.showlocationbutton = false;
              safeSetState(() {});
            }
          }
        } else {
          logFirebaseEvent('Name_backend_call');

          await currentUserReference!.update(createUsersRecordData(
            latlong: currentUserLocationValue,
          ));
          logFirebaseEvent('Name_update_page_state');
          _model.showplacepicker = true;
          _model.showlocationbutton = false;
          safeSetState(() {});
        }
      } else {
        logFirebaseEvent('Name_show_snack_bar');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fetching Location Failed. Please enter location manually.',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).tertiary,
          ),
        );
        logFirebaseEvent('Name_update_page_state');
        _model.showlocationbutton = false;
        _model.showplacepicker = true;
        safeSetState(() {});
      }
    });

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.emailTextController ??=
        TextEditingController(text: currentUserEmail);
    _model.emailFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!FFAppConstants.onlysocial)
                  LinearPercentIndicator(
                    percent: 0.18,
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    lineHeight: 12.0,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: Color(0xFFDADADA),
                    center: Text(
                      FFLocalizations.of(context).getText(
                        'n02z83lt' /* 18% */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondary,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(33.0, 30.0, 0.0, 0.0),
                    child: Container(
                      width: 221.0,
                      height: 133.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Icon(
                              FFIcons.kuser,
                              color: Color(0xFFF902FF),
                              size: 32.0,
                            ),
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              'pguz45og' /* Introduce yourself */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 32.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          child: TextFormField(
                            controller: _model.textController1,
                            focusNode: _model.textFieldFocusNode,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'o9admbqb' /* First Name */,
                              ),
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFD0D5DD),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            validator: _model.textController1Validator
                                .asValidator(context),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 15.0, 0.0, 15.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              logFirebaseEvent('Button_date_time_picker');
                              final _datePickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        950034600000000),
                                firstDate: DateTime(1900),
                                lastDate: (DateTime.fromMicrosecondsSinceEpoch(
                                        1387909800000000) ??
                                    DateTime(2050)),
                              );

                              if (_datePickedDate != null) {
                                safeSetState(() {
                                  _model.datePicked = DateTime(
                                    _datePickedDate.year,
                                    _datePickedDate.month,
                                    _datePickedDate.day,
                                  );
                                });
                              } else if (_model.datePicked != null) {
                                safeSetState(() {
                                  _model.datePicked =
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          950034600000000);
                                });
                              }
                            },
                            text: valueOrDefault<String>(
                              dateTimeFormat(
                                "yMMMd",
                                _model.datePicked,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              ),
                              'Enter Date of birth',
                            ),
                            options: FFButtonOptions(
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Colors.white,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Color(0xFFD0D5DD),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                      if (currentUserUid == '')
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                valueOrDefault<String>(
                                  _model.location,
                                  'location',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      if (_model.showlocationbutton)
                        Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 20.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                currentUserLocationValue =
                                    await getCurrentUserLocation(
                                        defaultLocation: LatLng(0.0, 0.0));
                                logFirebaseEvent('Button_request_permissions');
                                await requestPermission(locationPermission);
                                if (await getPermissionStatus(
                                    locationPermission)) {
                                  if (functions.isZeroZero(
                                          currentUserLocationValue) ==
                                      true) {
                                    logFirebaseEvent('Button_custom_action');
                                    await actions.turnOnGPS();
                                    logFirebaseEvent('Button_wait__delay');
                                    await Future.delayed(
                                      Duration(
                                        milliseconds: 5000,
                                      ),
                                    );
                                    if (functions.isZeroZero(
                                            currentUserLocationValue) ==
                                        true) {
                                      logFirebaseEvent('Button_show_snack_bar');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Fetching city failed',
                                            style: GoogleFonts.inter(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .tertiary,
                                        ),
                                      );
                                      logFirebaseEvent(
                                          'Button_update_page_state');
                                      _model.showplacepicker = true;
                                      _model.showlocationbutton = true;
                                      safeSetState(() {});
                                    } else {
                                      logFirebaseEvent('Button_backend_call');

                                      await currentUserReference!
                                          .update(createUsersRecordData(
                                        latlong: currentUserLocationValue,
                                      ));
                                      logFirebaseEvent('Button_backend_call');
                                      _model.geocodingreverse4Copy =
                                          await GeocodingreverseCall.call(
                                        lat: valueOrDefault<String>(
                                          functions.latLongString(
                                              currentUserLocationValue!, true),
                                          '28.4281173',
                                        ),
                                        long: valueOrDefault<String>(
                                          functions.latLongString(
                                              currentUserLocationValue!, false),
                                          '77.1100123',
                                        ),
                                      );

                                      if ((_model.geocodingreverse4Copy
                                              ?.succeeded ??
                                          true)) {
                                        logFirebaseEvent(
                                            'Button_update_page_state');
                                        _model.location =
                                            GeocodingreverseCall.city(
                                          (_model.geocodingreverse4Copy
                                                  ?.jsonBody ??
                                              ''),
                                        )!;
                                        safeSetState(() {});
                                        logFirebaseEvent(
                                            'Button_update_page_state');
                                        _model.showplacepicker = false;
                                        _model.showlocationbutton = false;
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'Button_show_snack_bar');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Fetching city failed',
                                              style: GoogleFonts.inter(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .tertiary,
                                          ),
                                        );
                                        logFirebaseEvent(
                                            'Button_update_page_state');
                                        _model.showplacepicker = true;
                                        safeSetState(() {});
                                      }
                                    }
                                  } else {
                                    logFirebaseEvent('Button_backend_call');

                                    await currentUserReference!
                                        .update(createUsersRecordData(
                                      latlong: currentUserLocationValue,
                                    ));
                                    logFirebaseEvent('Button_backend_call');
                                    _model.geocodingreverse3Copy =
                                        await GeocodingreverseCall.call(
                                      lat: valueOrDefault<String>(
                                        functions.latLongString(
                                            currentUserLocationValue!, true),
                                        '28.4281173',
                                      ),
                                      long: valueOrDefault<String>(
                                        functions.latLongString(
                                            currentUserLocationValue!, false),
                                        '77.1100123',
                                      ),
                                    );

                                    if ((_model
                                            .geocodingreverse3Copy?.succeeded ??
                                        true)) {
                                      logFirebaseEvent(
                                          'Button_update_page_state');
                                      _model.location =
                                          GeocodingreverseCall.city(
                                        (_model.geocodingreverse3Copy
                                                ?.jsonBody ??
                                            ''),
                                      )!;
                                      safeSetState(() {});
                                      logFirebaseEvent(
                                          'Button_update_page_state');
                                      _model.showplacepicker = false;
                                      _model.showlocationbutton = false;
                                      safeSetState(() {});
                                    } else {
                                      logFirebaseEvent('Button_show_snack_bar');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Fetching city failed',
                                            style: GoogleFonts.inter(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .tertiary,
                                        ),
                                      );
                                      logFirebaseEvent(
                                          'Button_update_page_state');
                                      _model.showplacepicker = true;
                                      safeSetState(() {});
                                    }
                                  }
                                } else {
                                  logFirebaseEvent('Button_show_snack_bar');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Fetching Location Failed. Please enter location manually.',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).tertiary,
                                    ),
                                  );
                                  logFirebaseEvent('Button_update_page_state');
                                  _model.showlocationbutton = true;
                                  _model.showplacepicker = true;
                                  safeSetState(() {});
                                }

                                safeSetState(() {});
                              },
                              text: FFLocalizations.of(context).getText(
                                'y08w4o5j' /* Retry Location */,
                              ),
                              options: FFButtonOptions(
                                height: 30.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).secondary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      if (_model.showplacepicker)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 5.0, 0.0, 5.0),
                          child: FlutterFlowPlacePicker(
                            iOSGoogleMapsApiKey:
                                'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
                            androidGoogleMapsApiKey:
                                'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
                            webGoogleMapsApiKey:
                                'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
                            onSelect: (place) async {
                              safeSetState(
                                  () => _model.placePickerValue = place);
                            },
                            defaultText: FFLocalizations.of(context).getText(
                              'jzs3wigr' /* Select City  */,
                            ),
                            icon: Icon(
                              FFIcons.kmapPin,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 16.0,
                            ),
                            buttonOptions: FFButtonOptions(
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              height: 40.0,
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Color(0xFFD0D5DD),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          child: TextFormField(
                            controller: _model.emailTextController,
                            focusNode: _model.emailFocusNode,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                '7pcdy73a' /* Email */,
                              ),
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFD0D5DD),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            validator: _model.emailTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 5.0, 15.0, 5.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  logFirebaseEvent(
                                      'Container_update_page_state');
                                  _model.genderValue = 'male';
                                  _model.maleState = true;
                                  _model.femaleState = false;
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(46.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          FFLocalizations.of(context).getText(
                                            'a6i8vb9p' /* Male */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLargeIsCustom,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 15.0, 0.0),
                                        child: ToggleIcon(
                                          onPressed: () async {
                                            safeSetState(() => _model
                                                .maleState = !_model.maleState);
                                            logFirebaseEvent(
                                                'ToggleIcon_update_page_state');
                                            _model.genderValue = 'male';
                                            _model.maleState = true;
                                            _model.femaleState = false;
                                            safeSetState(() {});
                                          },
                                          value: _model.maleState,
                                          onIcon: Icon(
                                            Icons.check_circle_sharp,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 25.0,
                                          ),
                                          offIcon: Icon(
                                            Icons.radio_button_off,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 25.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 5.0, 15.0, 5.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  logFirebaseEvent(
                                      'Container_update_page_state');
                                  _model.genderValue = 'female';
                                  _model.maleState = false;
                                  _model.femaleState = true;
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(46.0),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              'ucjchy8e' /* Female */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLargeFamily,
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 15.0, 0.0),
                                          child: ToggleIcon(
                                            onPressed: () async {
                                              safeSetState(() =>
                                                  _model.femaleState =
                                                      !_model.femaleState);
                                              logFirebaseEvent(
                                                  'ToggleIcon_update_page_state');
                                              _model.genderValue = 'female';
                                              _model.maleState = false;
                                              _model.femaleState = true;
                                              safeSetState(() {});
                                            },
                                            value: _model.femaleState,
                                            onIcon: Icon(
                                              Icons.check_circle_sharp,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 25.0,
                                            ),
                                            offIcon: Icon(
                                              Icons.radio_button_off,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 25.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 20.0),
                    child: Container(
                      width: 335.0,
                      height: 50.0,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: Container(
                                width: 52.0,
                                height: 52.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEE6FF),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 20.0,
                                  borderWidth: 1.0,
                                  buttonSize: 40.0,
                                  fillColor: Color(0xFFFEE6FF),
                                  icon: Icon(
                                    FFIcons.kcaretRight,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 32.0,
                                  ),
                                  showLoadingIndicator: true,
                                  onPressed: () async {
                                    currentUserLocationValue =
                                        await getCurrentUserLocation(
                                            defaultLocation: LatLng(0.0, 0.0));
                                    if (_model.genderValue == null ||
                                        _model.genderValue == '') {
                                      logFirebaseEvent(
                                          'IconButton_show_snack_bar');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please select gender',
                                            style: GoogleFonts.inter(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                    } else {
                                      logFirebaseEvent(
                                          'IconButton_validate_form');
                                      if (_model.formKey.currentState == null ||
                                          !_model.formKey.currentState!
                                              .validate()) {
                                        return;
                                      }
                                      if (_model.datePicked == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Enter date of birth',
                                              style: GoogleFonts.inter(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                        );
                                        return;
                                      }
                                      if (_model.placePickerValue ==
                                          FFPlace()) {
                                        return;
                                      }
                                      logFirebaseEvent(
                                          'IconButton_alert_dialog');
                                      var confirmDialogResponse =
                                          await showDialog<bool>(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return WebViewAware(
                                                    child: AlertDialog(
                                                      title: Text(
                                                          'Please confirm your age, you can\'t change this in future'),
                                                      content: Text(functions
                                                          .getAge(
                                                              _model.datePicked)
                                                          .toString()),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  false),
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  true),
                                                          child:
                                                              Text('Confirm'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ) ??
                                              false;
                                      if (confirmDialogResponse) {
                                        logFirebaseEvent(
                                            'IconButton_backend_call');
                                        await UsersTable().update(
                                          data: {
                                            'first_name':
                                                _model.textController1.text,
                                            'email':
                                                _model.emailTextController.text,
                                            'location':
                                                _model.placePickerValue
                                                                .city !=
                                                            ''
                                                    ? valueOrDefault<String>(
                                                        _model.placePickerValue
                                                            .city,
                                                        'Gurugram',
                                                      )
                                                    : valueOrDefault<String>(
                                                        _model.placePickerValue
                                                            .address,
                                                        'Gurugram',
                                                      ),
                                            'gender': _model.genderValue,
                                            'birthday': supaSerialize<DateTime>(
                                                _model.datePicked),
                                            'age': functions
                                                .getAge(_model.datePicked)
                                                ?.toString(),
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_id',
                                            currentUserUid,
                                          ),
                                        );
                                        logFirebaseEvent(
                                            'IconButton_backend_call');

                                        await currentUserReference!
                                            .update(createUsersRecordData(
                                          latlong: currentUserLocationValue,
                                          displayName:
                                              _model.textController1.text,
                                        ));
                                        if (FFAppConstants.onlysocial == true) {
                                          logFirebaseEvent(
                                              'IconButton_backend_call');
                                          await UsersTable().update(
                                            data: {
                                              'openfordating': false,
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'user_id',
                                              currentUserUid,
                                            ),
                                          );
                                          logFirebaseEvent(
                                              'IconButton_backend_call');
                                          await UserprofilecompletionstatusTable()
                                              .update(
                                            data: {
                                              'completionstatus': true,
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'user_id',
                                              currentUserUid,
                                            ),
                                          );
                                          logFirebaseEvent(
                                              'IconButton_backend_call');

                                          await currentUserReference!
                                              .update(createUsersRecordData(
                                            completionstatus: true,
                                          ));
                                          logFirebaseEvent(
                                              'IconButton_backend_call');
                                          await UserprofilecompletionstatusTable()
                                              .update(
                                            data: {
                                              'name_completed': true,
                                              'current_step': 2,
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'user_id',
                                              currentUserUid,
                                            ),
                                          );
                                          logFirebaseEvent(
                                              'IconButton_navigate_to');

                                          context.pushNamed(
                                              SocialWidget.routeName);
                                        } else {
                                          logFirebaseEvent(
                                              'IconButton_navigate_to');

                                          context.pushNamed(
                                              AddImagesWidget.routeName);
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
