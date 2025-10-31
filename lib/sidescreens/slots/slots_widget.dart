import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'slots_model.dart';
export 'slots_model.dart';

class SlotsWidget extends StatefulWidget {
  const SlotsWidget({
    super.key,
    int? groupid,
  }) : this.groupid = groupid ?? 90;

  /// groupid
  final int groupid;

  static String routeName = 'slots';
  static String routePath = '/slots';

  @override
  State<SlotsWidget> createState() => _SlotsWidgetState();
}

class _SlotsWidgetState extends State<SlotsWidget> {
  late SlotsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SlotsModel());

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
      future: TicketsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'ticketstatus',
              'live',
            )
            .eqOrNull(
              'group_id',
              widget.groupid,
            )
            .order('startdatetime', ascending: true),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFF131315),
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
        List<TicketsRow> slotsTicketsRowList = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFF131315),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      logFirebaseEvent('Icon_navigate_back');
                                      context.safePop();
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'bhm0a3eq' /* Gurugram */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xFFF7F6FC),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4.0, 0.0, 0.0, 0.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFFACABB0),
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      'zw1mijrg' /* Badminton */,
                                    ),
                                    FFIcons.kbadmintonPlayerSvgrepoCom),
                                ChipData(
                                    FFLocalizations.of(context).getText(
                                      '9084hw31' /* Pickleball */,
                                    ),
                                    Icons.call_made)
                              ],
                              onChanged: (val) async {
                                safeSetState(() =>
                                    _model.choiceChipsValue = val?.firstOrNull);
                                logFirebaseEvent(
                                    'ChoiceChips_update_page_state');

                                safeSetState(() {});
                              },
                              selectedChipStyle: ChipStyle(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).info,
                                iconSize: 16.0,
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                iconColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                iconSize: 16.0,
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              chipSpacing: 8.0,
                              rowSpacing: 8.0,
                              multiselect: false,
                              initialized: _model.choiceChipsValue != null,
                              alignment: WrapAlignment.start,
                              controller: _model.choiceChipsValueController ??=
                                  FormFieldController<List<String>>(
                                [
                                  FFLocalizations.of(context).getText(
                                    'it3a4xeb' /* Badminton */,
                                  )
                                ],
                              ),
                              wrapped: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 12.0, 0.0, 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Builder(
                            builder: (context) {
                              final ticketsdata = functions
                                      .groupTicketsByDate(
                                          slotsTicketsRowList.toList(),
                                          _model.time)
                                      ?.toList() ??
                                  [];

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(ticketsdata.length,
                                          (ticketsdataIndex) {
                                    final ticketsdataItem =
                                        ticketsdata[ticketsdataIndex];
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent(
                                            'Container_update_page_state');
                                        _model.currenttickets = getJsonField(
                                          ticketsdataItem,
                                          r'''$.tickets''',
                                          true,
                                        )!
                                            .toList()
                                            .cast<dynamic>();
                                        _model.currentindex =
                                            valueOrDefault<int>(
                                          ticketsdataIndex,
                                          0,
                                        );
                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: valueOrDefault<Color>(
                                            _model.currentindex ==
                                                    ticketsdataIndex
                                                ? Color(0x1FFFFFFF)
                                                : Color(0xFF131315),
                                            Color(0xFF131315),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                valueOrDefault<String>(
                                                  getJsonField(
                                                    ticketsdataItem,
                                                    r'''$.date''',
                                                  )?.toString(),
                                                  '29',
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
                                                      fontSize: 18.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                              Text(
                                                valueOrDefault<String>(
                                                  getJsonField(
                                                    ticketsdataItem,
                                                    r'''$.day''',
                                                  )?.toString(),
                                                  'TUE',
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
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                      .divide(SizedBox(width: 12.0))
                                      .addToStart(SizedBox(width: 12.0))
                                      .addToEnd(SizedBox(width: 12.0)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(),
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent('Button_update_page_state');
                                  _model.time = _model.time == 'pm' ? '' : 'pm';
                                  _model.currentindex = null;
                                  _model.currenttickets = [];
                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  't29en3ey' /*  */,
                                ),
                                icon: Icon(
                                  Icons.dark_mode,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0x21C702CC),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: valueOrDefault<Color>(
                                      _model.time == 'pm'
                                          ? FlutterFlowTheme.of(context)
                                              .tertiary
                                          : Color(0xFF131315),
                                      Color(0xFF131315),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(0.0),
                                  ),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent('Button_update_page_state');
                                  _model.time = _model.time == 'am' ? '' : 'am';
                                  _model.currenttickets = [];
                                  _model.currentindex = null;
                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  'dipdljgy' /*  */,
                                ),
                                icon: Icon(
                                  Icons.sunny,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFFDAA01A),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: valueOrDefault<Color>(
                                      _model.time == 'am'
                                          ? FlutterFlowTheme.of(context)
                                              .tertiary
                                          : Color(0xFF131315),
                                      Color(0xFF131315),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(16.0),
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      final ticketsfromselectedtickets =
                          _model.currenttickets.toList();

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children:
                              List.generate(ticketsfromselectedtickets.length,
                                  (ticketsfromselectedticketsIndex) {
                            final ticketsfromselectedticketsItem =
                                ticketsfromselectedtickets[
                                    ticketsfromselectedticketsIndex];
                            return Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getJsonField(
                                            ticketsfromselectedticketsItem,
                                            r'''$.time''',
                                          ).toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                spacing: 0.0,
                                                runSpacing: 0.0,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.start,
                                                direction: Axis.horizontal,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  FutureBuilder<
                                                      List<VenuesRow>>(
                                                    future: VenuesTable()
                                                        .querySingleRow(
                                                      queryFn: (q) =>
                                                          q.eqOrNull(
                                                        'id',
                                                        getJsonField(
                                                          ticketsfromselectedticketsItem,
                                                          r'''$.venueid''',
                                                        ),
                                                      ),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: SpinKitRing(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 50.0,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      List<VenuesRow>
                                                          textVenuesRowList =
                                                          snapshot.data!;

                                                      final textVenuesRow =
                                                          textVenuesRowList
                                                                  .isNotEmpty
                                                              ? textVenuesRowList
                                                                  .first
                                                              : null;

                                                      return Text(
                                                        valueOrDefault<String>(
                                                          textVenuesRow
                                                              ?.location,
                                                          'Location',
                                                        ).maybeHandleOverflow(
                                                          maxChars: 30,
                                                          replacement: '…',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: Color(
                                                                      0xFFB3A6A6),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  logFirebaseEvent(
                                                      'Container_navigate_to');

                                                  context.pushNamed(
                                                    BookticketsWidget.routeName,
                                                    queryParameters: {
                                                      'groupid': serializeParam(
                                                        90,
                                                        ParamType.int,
                                                      ),
                                                      'groupname':
                                                          serializeParam(
                                                        'Badminton',
                                                        ParamType.String,
                                                      ),
                                                      'ticketid':
                                                          serializeParam(
                                                        valueOrDefault<int>(
                                                          getJsonField(
                                                            ticketsfromselectedticketsItem,
                                                            r'''$.ticketid''',
                                                          ),
                                                          81,
                                                        ),
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.6,
                                                  decoration: BoxDecoration(
                                                    color: Color(0x1FFFFFFF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        getJsonField(
                                                          ticketsfromselectedticketsItem,
                                                          r'''$.title''',
                                                        )?.toString(),
                                                        'Title',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.8,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 8.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
