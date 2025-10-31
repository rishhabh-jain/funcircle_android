import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'edit_ticket_model.dart';
export 'edit_ticket_model.dart';

/// remove users, message etc.
class EditTicketWidget extends StatefulWidget {
  const EditTicketWidget({
    super.key,
    int? ticketId,
  }) : this.ticketId = ticketId ?? 1;

  final int ticketId;

  static String routeName = 'EditTicket';
  static String routePath = '/editTicket';

  @override
  State<EditTicketWidget> createState() => _EditTicketWidgetState();
}

class _EditTicketWidgetState extends State<EditTicketWidget> {
  late EditTicketModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditTicketModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TicketsRow>>(
      future: TicketsTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.ticketId,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitRing(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 50.0,
                ),
              ),
            ),
          );
        }
        List<TicketsRow> editTicketTicketsRowList = snapshot.data!;

        final editTicketTicketsRow = editTicketTicketsRowList.isNotEmpty
            ? editTicketTicketsRowList.first
            : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).secondary),
                automaticallyImplyLeading: true,
                leading: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Icon_navigate_back');
                    context.safePop();
                  },
                  child: Icon(
                    FFIcons.karrowLeft,
                    color: FlutterFlowTheme.of(context).secondary,
                    size: 24.0,
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        width: 100.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'scsh3cg6' /* Edit ticket */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [],
                centerTitle: true,
                toolbarHeight: MediaQuery.sizeOf(context).height * 1.0,
                elevation: 1.0,
              ),
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.95,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 12.0, 12.0, 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                '3hviee19' /* Ticket info */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 19.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'ID - ${editTicketTicketsRow?.id.toString()}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Created at - ${dateTimeFormat(
                                "MMMMEEEEd",
                                editTicketTicketsRow?.createdAt,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              )}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Type - ${editTicketTicketsRow?.type}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              '${editTicketTicketsRow?.title}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Start date time${dateTimeFormat(
                                "MMMMEEEEd",
                                editTicketTicketsRow?.startdatetime,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              )} | ${dateTimeFormat(
                                "d/M h:mm a",
                                editTicketTicketsRow?.startdatetime,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              )}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'End date time${dateTimeFormat(
                                "MMMMEEEEd",
                                editTicketTicketsRow?.enddatetime,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              )} | ${'Start date time${dateTimeFormat(
                                "MMMMEEEEd",
                                editTicketTicketsRow?.enddatetime,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              )} | ${dateTimeFormat(
                                "d/M h:mm a",
                                editTicketTicketsRow?.enddatetime,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              )}'}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Price - ${editTicketTicketsRow?.price}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Booked tickets - ${editTicketTicketsRow?.bookedtickets?.toString()}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Capacity - ${editTicketTicketsRow?.capacity?.toString()}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Description - ${editTicketTicketsRow?.description}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'Location - ${editTicketTicketsRow?.location}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Status - ${editTicketTicketsRow?.ticketstatus}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                                Switch.adaptive(
                                  value: _model.switchValue ??=
                                      editTicketTicketsRow?.ticketstatus ==
                                              'live'
                                          ? true
                                          : false,
                                  onChanged: (newValue) async {
                                    safeSetState(
                                        () => _model.switchValue = newValue);
                                    if (newValue) {
                                      logFirebaseEvent('Switch_backend_call');
                                      await TicketsTable().update(
                                        data: {
                                          'ticketstatus': 'live',
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'id',
                                          widget.ticketId,
                                        ),
                                      );
                                    } else {
                                      logFirebaseEvent('Switch_backend_call');
                                      await TicketsTable().update(
                                        data: {
                                          'ticketstatus': 'archieved',
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'id',
                                          widget.ticketId,
                                        ),
                                      );
                                    }
                                  },
                                  activeColor:
                                      FlutterFlowTheme.of(context).primary,
                                  activeTrackColor:
                                      FlutterFlowTheme.of(context).primary,
                                  inactiveTrackColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  inactiveThumbColor:
                                      FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                ),
                              ],
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                      ),
                    ),
                    FlutterFlowDropDown<String>(
                      controller: _model.dropDownValueController ??=
                          FormFieldController<String>(null),
                      options: [
                        FFLocalizations.of(context).getText(
                          '0wk5uxc7' /* Mark as completed */,
                        ),
                        FFLocalizations.of(context).getText(
                          'txvf9ti2' /* Remove user */,
                        ),
                        FFLocalizations.of(context).getText(
                          'c0xyj2jg' /* Message */,
                        )
                      ],
                      onChanged: (val) async {
                        safeSetState(() => _model.dropDownValue = val);
                        if (_model.dropDownValue == 'Message') {
                          logFirebaseEvent('DropDown_alert_dialog');
                          var confirmDialogResponse = await showDialog<bool>(
                                context: context,
                                builder: (alertDialogContext) {
                                  return WebViewAware(
                                    child: AlertDialog(
                                      title: Text('Are you sure?'),
                                      content: Text('Are you sure?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, true),
                                          child: Text('Confirm'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ) ??
                              false;
                          if (confirmDialogResponse) {
                            if ((_model.selectedusers.isNotEmpty) == true) {
                              while (_model.initialindex <
                                  _model.selectedusers.length) {
                                logFirebaseEvent('DropDown_update_page_state');
                                _model.initialindex = _model.initialindex + 1;
                                safeSetState(() {});
                                logFirebaseEvent('DropDown_launch_u_r_l');
                                await launchURL(
                                    'https://wa.me/${_model.selectedusers.elementAtOrNull(_model.initialindex)?.number}?text=Please be on time for the event.');
                              }
                            } else {
                              logFirebaseEvent('DropDown_alert_dialog');
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return WebViewAware(
                                    child: AlertDialog(
                                      title: Text('Select some users first'),
                                      content: Text('Select some users first'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        } else if (_model.dropDownValue ==
                            'Mark as completed') {
                          logFirebaseEvent('DropDown_alert_dialog');
                          var confirmDialogResponse = await showDialog<bool>(
                                context: context,
                                builder: (alertDialogContext) {
                                  return WebViewAware(
                                    child: AlertDialog(
                                      title: Text('Are you sure?'),
                                      content: Text('Are you sure?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, true),
                                          child: Text('Confirm'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ) ??
                              false;
                          if (confirmDialogResponse) {
                            if (_model.checkboxListTileCheckedItems.length >
                                0) {
                              while (_model.initialindex <
                                  _model.selectedusers.length) {
                                logFirebaseEvent('DropDown_backend_call');
                                await OrdersTable().update(
                                  data: {
                                    'status': 'completed',
                                  },
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'id',
                                    _model.selectedusers
                                        .elementAtOrNull(_model.initialindex)
                                        ?.orderid,
                                  ),
                                );
                                logFirebaseEvent('DropDown_backend_call');
                                await OrderitemsTable().update(
                                  data: {
                                    'status': 'completed',
                                  },
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'order_id',
                                    _model.selectedusers
                                        .elementAtOrNull(_model.initialindex)
                                        ?.orderid,
                                  ),
                                );
                                logFirebaseEvent('DropDown_update_page_state');
                                _model.initialindex = _model.initialindex + 1;
                                safeSetState(() {});
                              }
                            } else {
                              logFirebaseEvent('DropDown_alert_dialog');
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return WebViewAware(
                                    child: AlertDialog(
                                      title: Text('Select some users first'),
                                      content: Text('Select some users first'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        } else if (_model.dropDownValue == 'Remove user') {
                          logFirebaseEvent('DropDown_alert_dialog');
                          var confirmDialogResponse = await showDialog<bool>(
                                context: context,
                                builder: (alertDialogContext) {
                                  return WebViewAware(
                                    child: AlertDialog(
                                      title: Text('Are you sure?'),
                                      content: Text('Are you sure?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext, true),
                                          child: Text('Confirm'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ) ??
                              false;
                          if (confirmDialogResponse) {
                            if (_model.checkboxListTileCheckedItems.length >
                                0) {
                              while (_model.initialindex <
                                  _model.selectedusers.length) {
                                logFirebaseEvent('DropDown_backend_call');
                                await OrdersTable().update(
                                  data: {
                                    'status': 'cancelled',
                                  },
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'id',
                                    _model.selectedusers
                                        .elementAtOrNull(_model.initialindex)
                                        ?.orderid,
                                  ),
                                );
                                logFirebaseEvent('DropDown_backend_call');
                                await OrderitemsTable().update(
                                  data: {
                                    'status': 'cancelled',
                                  },
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'order_id',
                                    _model.selectedusers
                                        .elementAtOrNull(_model.initialindex)
                                        ?.orderid,
                                  ),
                                );
                                logFirebaseEvent('DropDown_update_page_state');
                                _model.initialindex = _model.initialindex + 1;
                                safeSetState(() {});
                              }
                            } else {
                              logFirebaseEvent('DropDown_alert_dialog');
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return WebViewAware(
                                    child: AlertDialog(
                                      title: Text('Select some users first'),
                                      content: Text('Select some users first'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        }
                      },
                      width: double.infinity,
                      height: 40.0,
                      textStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      hintText: FFLocalizations.of(context).getText(
                        'tc3yymvf' /* Take action */,
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2.0,
                      borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      borderRadius: 8.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      hidesUnderline: true,
                      isOverButton: false,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 287.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 5.0, 12.0, 5.0),
                            child: GridView(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 30.0,
                                childAspectRatio: 1.0,
                              ),
                              primary: false,
                              scrollDirection: Axis.vertical,
                              children: [
                                FlutterFlowIconButton(
                                  borderColor:
                                      FlutterFlowTheme.of(context).secondary,
                                  borderRadius: 20.0,
                                  borderWidth: 1.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    FFIcons.kplus,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    size: 32.0,
                                  ),
                                  onPressed: () async {
                                    logFirebaseEvent(
                                        'IconButton_upload_media_to_firebase');
                                    final selectedMedia = await selectMedia(
                                      imageQuality: 87,
                                      includeBlurHash: true,
                                      mediaSource: MediaSource.photoGallery,
                                      multiImage: true,
                                    );
                                    if (selectedMedia != null &&
                                        selectedMedia.every((m) =>
                                            validateFileFormat(
                                                m.storagePath, context))) {
                                      safeSetState(() => _model
                                              .isDataUploading_firebaseImages4 =
                                          true);
                                      var selectedUploadedFiles =
                                          <FFUploadedFile>[];

                                      var downloadUrls = <String>[];
                                      try {
                                        showUploadMessage(
                                          context,
                                          'Uploading file...',
                                          showLoading: true,
                                        );
                                        selectedUploadedFiles = selectedMedia
                                            .map((m) => FFUploadedFile(
                                                  name: m.storagePath
                                                      .split('/')
                                                      .last,
                                                  bytes: m.bytes,
                                                  height: m.dimensions?.height,
                                                  width: m.dimensions?.width,
                                                  blurHash: m.blurHash,
                                                ))
                                            .toList();

                                        downloadUrls = (await Future.wait(
                                          selectedMedia.map(
                                            (m) async => await uploadData(
                                                m.storagePath, m.bytes),
                                          ),
                                        ))
                                            .where((u) => u != null)
                                            .map((u) => u!)
                                            .toList();
                                      } finally {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        _model.isDataUploading_firebaseImages4 =
                                            false;
                                      }
                                      if (selectedUploadedFiles.length ==
                                              selectedMedia.length &&
                                          downloadUrls.length ==
                                              selectedMedia.length) {
                                        safeSetState(() {
                                          _model.uploadedLocalFiles_firebaseImages4 =
                                              selectedUploadedFiles;
                                          _model.uploadedFileUrls_firebaseImages4 =
                                              downloadUrls;
                                        });
                                        showUploadMessage(context, 'Success!');
                                      } else {
                                        safeSetState(() {});
                                        showUploadMessage(
                                            context, 'Failed to upload data');
                                        return;
                                      }
                                    }

                                    logFirebaseEvent(
                                        'IconButton_update_page_state');
                                    _model.imageupdates = _model
                                        .uploadedFileUrls_firebaseImages4
                                        .toList()
                                        .cast<String>();
                                    safeSetState(() {});
                                  },
                                ),
                                Align(
                                  alignment: AlignmentDirectional(1.0, 0.0),
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'Image_expand_image');
                                          await Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:
                                                  FlutterFlowExpandedImageView(
                                                image: Image.network(
                                                  valueOrDefault<String>(
                                                    _model.imageupdates.length >
                                                            0
                                                        ? _model.imageupdates
                                                            .elementAtOrNull(0)
                                                        : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  ),
                                                  fit: BoxFit.contain,
                                                ),
                                                allowRotation: false,
                                                tag: valueOrDefault<String>(
                                                  _model.imageupdates.length > 0
                                                      ? _model.imageupdates
                                                          .elementAtOrNull(0)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                useHeroAnimation: true,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: valueOrDefault<String>(
                                            _model.imageupdates.length > 0
                                                ? _model.imageupdates
                                                    .elementAtOrNull(0)
                                                : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                          ),
                                          transitionOnUserGestures: true,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              valueOrDefault<String>(
                                                _model.imageupdates.length > 0
                                                    ? _model.imageupdates
                                                        .elementAtOrNull(0)
                                                    : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              width: 300.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 1.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 6.0),
                                          child: Container(
                                            width: 70.0,
                                            height: 15.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'o35bcxh6' /* Cover Pic */,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent('Image_expand_image');
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imageupdates.length > 1
                                                      ? _model.imageupdates
                                                          .elementAtOrNull(1)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              allowRotation: false,
                                              tag: valueOrDefault<String>(
                                                _model.imageupdates.length > 1
                                                    ? _model.imageupdates
                                                        .elementAtOrNull(1)
                                                    : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: valueOrDefault<String>(
                                          _model.imageupdates.length > 1
                                              ? _model.imageupdates
                                                  .elementAtOrNull(1)
                                              : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                          'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                        ),
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            valueOrDefault<String>(
                                              _model.imageupdates.length > 1
                                                  ? _model.imageupdates
                                                      .elementAtOrNull(1)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            width: 300.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 20.0,
                                        borderWidth: 1.0,
                                        buttonSize: 35.0,
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 18.0,
                                        ),
                                        onPressed: () async {
                                          logFirebaseEvent(
                                              'IconButton_update_page_state');
                                          _model
                                              .removeAtIndexFromImageupdates(1);
                                          safeSetState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent('Image_expand_image');
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imageupdates.length > 2
                                                      ? _model.imageupdates
                                                          .elementAtOrNull(2)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              allowRotation: false,
                                              tag: valueOrDefault<String>(
                                                _model.imageupdates.length > 2
                                                    ? _model.imageupdates
                                                        .elementAtOrNull(2)
                                                    : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: valueOrDefault<String>(
                                          _model.imageupdates.length > 2
                                              ? _model.imageupdates
                                                  .elementAtOrNull(2)
                                              : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                          'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                        ),
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            valueOrDefault<String>(
                                              _model.imageupdates.length > 2
                                                  ? _model.imageupdates
                                                      .elementAtOrNull(2)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            width: 300.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 20.0,
                                        borderWidth: 1.0,
                                        buttonSize: 35.0,
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 18.0,
                                        ),
                                        onPressed: () async {
                                          logFirebaseEvent(
                                              'IconButton_update_page_state');
                                          _model
                                              .removeAtIndexFromImageupdates(1);
                                          safeSetState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent('Image_expand_image');
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imageupdates.length > 3
                                                      ? _model.imageupdates
                                                          .elementAtOrNull(3)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              allowRotation: false,
                                              tag: valueOrDefault<String>(
                                                _model.imageupdates.length > 3
                                                    ? _model.imageupdates
                                                        .elementAtOrNull(3)
                                                    : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: valueOrDefault<String>(
                                          _model.imageupdates.length > 3
                                              ? _model.imageupdates
                                                  .elementAtOrNull(3)
                                              : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                          'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                        ),
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            valueOrDefault<String>(
                                              _model.imageupdates.length > 3
                                                  ? _model.imageupdates
                                                      .elementAtOrNull(3)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            width: 300.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 20.0,
                                        borderWidth: 1.0,
                                        buttonSize: 35.0,
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 18.0,
                                        ),
                                        onPressed: () async {
                                          logFirebaseEvent(
                                              'IconButton_update_page_state');
                                          _model
                                              .removeAtIndexFromImageupdates(3);
                                          safeSetState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent('Image_expand_image');
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imageupdates.length > 4
                                                      ? _model.imageupdates
                                                          .elementAtOrNull(4)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              allowRotation: false,
                                              tag: valueOrDefault<String>(
                                                _model.imageupdates.length > 4
                                                    ? _model.imageupdates
                                                        .elementAtOrNull(4)
                                                    : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: valueOrDefault<String>(
                                          _model.imageupdates.length > 4
                                              ? _model.imageupdates
                                                  .elementAtOrNull(4)
                                              : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                          'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                        ),
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            valueOrDefault<String>(
                                              _model.imageupdates.length > 4
                                                  ? _model.imageupdates
                                                      .elementAtOrNull(4)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            width: 300.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 20.0,
                                        borderWidth: 1.0,
                                        buttonSize: 35.0,
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 18.0,
                                        ),
                                        onPressed: () async {
                                          logFirebaseEvent(
                                              'IconButton_update_page_state');
                                          _model
                                              .removeAtIndexFromImageupdates(4);
                                          safeSetState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<List<OrderitemsRow>>(
                      future: OrderitemsTable().queryRows(
                        queryFn: (q) => q
                            .eqOrNull(
                              'ticket_id',
                              widget.ticketId,
                            )
                            .eqOrNull(
                              'status',
                              'confirmed',
                            ),
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: SpinKitRing(
                                color: FlutterFlowTheme.of(context).primary,
                                size: 50.0,
                              ),
                            ),
                          );
                        }
                        List<OrderitemsRow> listViewOrderitemsRowList =
                            snapshot.data!;

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listViewOrderitemsRowList.length,
                          itemBuilder: (context, listViewIndex) {
                            final listViewOrderitemsRow =
                                listViewOrderitemsRowList[listViewIndex];
                            return StreamBuilder<List<UsersRecord>>(
                              stream: queryUsersRecord(
                                queryBuilder: (usersRecord) =>
                                    usersRecord.where(
                                  'uid',
                                  isEqualTo: listViewOrderitemsRow.userid,
                                ),
                                singleRecord: true,
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: SpinKitRing(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 50.0,
                                      ),
                                    ),
                                  );
                                }
                                List<UsersRecord>
                                    checkboxListTileUsersRecordList =
                                    snapshot.data!;
                                // Return an empty Container when the item does not exist.
                                if (snapshot.data!.isEmpty) {
                                  return Container();
                                }
                                final checkboxListTileUsersRecord =
                                    checkboxListTileUsersRecordList.isNotEmpty
                                        ? checkboxListTileUsersRecordList.first
                                        : null;

                                return Material(
                                  color: Colors.transparent,
                                  child: Theme(
                                    data: ThemeData(
                                      checkboxTheme: CheckboxThemeData(
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      unselectedWidgetColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                    ),
                                    child: CheckboxListTile(
                                      value: _model.checkboxListTileValueMap[
                                          listViewOrderitemsRow] ??= false,
                                      onChanged: (newValue) async {
                                        safeSetState(() => _model
                                                .checkboxListTileValueMap[
                                            listViewOrderitemsRow] = newValue!);
                                        if (newValue!) {
                                          logFirebaseEvent(
                                              'CheckboxListTile_update_page_state');
                                          _model.addToSelectedusers(
                                              SelectedusersStruct(
                                            userid: checkboxListTileUsersRecord
                                                ?.uid,
                                            name: checkboxListTileUsersRecord
                                                ?.displayName,
                                            number: checkboxListTileUsersRecord
                                                ?.phoneNumber,
                                            orderid:
                                                listViewOrderitemsRow.orderId,
                                          ));
                                          safeSetState(() {});
                                        } else {
                                          logFirebaseEvent(
                                              'CheckboxListTile_update_page_state');
                                          _model.removeFromSelectedusers(
                                              SelectedusersStruct(
                                            userid: checkboxListTileUsersRecord
                                                ?.uid,
                                            name: checkboxListTileUsersRecord
                                                ?.displayName,
                                            number: checkboxListTileUsersRecord
                                                ?.phoneNumber,
                                            orderid:
                                                listViewOrderitemsRow.orderId,
                                          ));
                                          safeSetState(() {});
                                        }
                                      },
                                      title: Text(
                                        '${checkboxListTileUsersRecord?.displayName} - ${checkboxListTileUsersRecord?.phoneNumber}',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLargeFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleLargeIsCustom,
                                            ),
                                      ),
                                      subtitle: Text(
                                        'Order id - ${listViewOrderitemsRow.orderId?.toString()} | ₹${listViewOrderitemsRow.subPrice}-${listViewOrderitemsRow.quantity?.toString()} | ${listViewOrderitemsRow.status}',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelMediumIsCustom,
                                            ),
                                      ),
                                      tileColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      activeColor:
                                          FlutterFlowTheme.of(context).primary,
                                      checkColor:
                                          FlutterFlowTheme.of(context).info,
                                      dense: false,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 12.0, 0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
