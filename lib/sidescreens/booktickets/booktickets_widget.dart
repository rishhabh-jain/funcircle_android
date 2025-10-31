import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'booktickets_model.dart';
export 'booktickets_model.dart';

class BookticketsWidget extends StatefulWidget {
  const BookticketsWidget({
    super.key,
    required this.groupid,
    this.groupname,
    int? ticketid,
  }) : this.ticketid = ticketid ?? 90;

  final int? groupid;
  final String? groupname;
  final int ticketid;

  static String routeName = 'booktickets';
  static String routePath = '/booktickets';

  @override
  State<BookticketsWidget> createState() => _BookticketsWidgetState();
}

class _BookticketsWidgetState extends State<BookticketsWidget> {
  late BookticketsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookticketsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('booktickets_update_page_state');
      _model.ticketusername = currentUserDisplayName;
      _model.ticketnumber = currentPhoneNumber;
      _model.addedtocartticketIDs = FFAppState()
          .ticketsaddtocart
          .map((e) => e.ticketid)
          .toList()
          .toList()
          .cast<int>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    // Reset cart when user backs out or closes screen
    FFAppState().ticketsaddtocart = [];
    FFAppState().update(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<List<TicketsRow>>(
      future: TicketsTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.ticketid,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFF131315),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary,
                      strokeWidth: 3.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Loading ticket details...',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).tertiary,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ],
              ),
            ),
          );
        }
        List<TicketsRow> bookticketsTicketsRowList = snapshot.data!;

        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final bookticketsTicketsRow = bookticketsTicketsRowList.isNotEmpty
            ? bookticketsTicketsRowList.first
            : null;

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
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  child: Stack(
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: FutureBuilder<List<VenuesRow>>(
                          future: VenuesTable().querySingleRow(
                            queryFn: (q) => q.eqOrNull(
                              'id',
                              bookticketsTicketsRow?.venueid,
                            ),
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child: CircularProgressIndicator(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          strokeWidth: 3.0,
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      Text(
                                        'Loading venue details...',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            List<VenuesRow> columnVenuesRowList =
                                snapshot.data!;

                            final columnVenuesRow =
                                columnVenuesRowList.isNotEmpty
                                    ? columnVenuesRowList.first
                                    : null;

                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context).primary,
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                        ],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(-1.0, -1.0),
                                        end: AlignmentDirectional(1.0, 1.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 16.0, 16.0, 20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FlutterFlowIconButton(
                                                borderRadius: 12.0,
                                                buttonSize: 44.0,
                                                fillColor: Color(0x33FFFFFF),
                                                icon: Icon(
                                                  FFIcons.karrowLeft,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                  size: 24.0,
                                                ),
                                                onPressed: () async {
                                                  logFirebaseEvent(
                                                      'IconButton_navigate_back');
                                                  context.safePop();
                                                },
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Book Your Spot',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          columnVenuesRow
                                                              ?.venueName,
                                                          'Venue name',
                                                        ).maybeHandleOverflow(
                                                          maxChars: 30,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize:
                                                                      20.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(0.0, -12.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 20.0,
                                              color: Color(0x1A000000),
                                              offset: Offset(0.0, 4.0),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary
                                                              .withValues(
                                                                  alpha: 0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.clock,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.0),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dateTimeFormat(
                                                            "MMMMEEEEd",
                                                            bookticketsTicketsRow
                                                                ?.startdatetime,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                          '${dateTimeFormat(
                                                            "jm",
                                                            bookticketsTicketsRow
                                                                ?.startdatetime,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )} - ${dateTimeFormat(
                                                            "jm",
                                                            bookticketsTicketsRow
                                                                ?.enddatetime,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 13.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12.0),
                                              Divider(
                                                thickness: 1.0,
                                                color: Color(0x1AFFFFFF),
                                              ),
                                              SizedBox(height: 12.0),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary
                                                              .withValues(
                                                                  alpha: 0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: Icon(
                                                      Icons.location_on_rounded,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.0),
                                                  Expanded(
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        columnVenuesRow
                                                            ?.location,
                                                        'Location',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
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
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 16.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            FlutterFlowTheme.of(context)
                                                .primary
                                                .withValues(alpha: 0.1),
                                            FlutterFlowTheme.of(context)
                                                .secondary
                                                .withValues(alpha: 0.05),
                                          ],
                                          stops: [0.0, 1.0],
                                          begin:
                                              AlignmentDirectional(-1.0, -1.0),
                                          end: AlignmentDirectional(1.0, 1.0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primary
                                              .withValues(alpha: 0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20.0, 15.0, 10.0, 15.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 284.0,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    8.0,
                                                                    0.0,
                                                                    8.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            bookticketsTicketsRow
                                                                ?.title,
                                                            'Ticket Name',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
                                                                fontSize: 18.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              '₹${bookticketsTicketsRow?.price}',
                                                              'Price',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'od6dvp7p' /* Court Share (Total price / 4) */,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .tertiary,
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    12.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  'e83jh7dq' /* +15 rs service fee. */,
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .tertiary,
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  5.0,
                                                                  0.0,
                                                                  5.0),
                                                      child: Text(
                                                        valueOrDefault<String>(
                                                          'Total Spots : ${bookticketsTicketsRow?.capacity?.toString()}',
                                                          'Total Spots : 8 ',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                10.0, 10.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.0,
                                                              vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                          ],
                                                          stops: [0.0, 1.0],
                                                          begin:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          end:
                                                              AlignmentDirectional(
                                                                  1.0, 0.0),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                      ),
                                                      child: Container(
                                                        width: 130.0,
                                                        height: 52.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            FlutterFlowIconButton(
                                                              borderRadius:
                                                                  10.0,
                                                              borderWidth: 0.0,
                                                              buttonSize: 40.0,
                                                              fillColor: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primary
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1),
                                                              icon: Icon(
                                                                Icons.remove,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                size: 18.0,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                logFirebaseEvent(
                                                                    'IconButton_custom_action');

                                                                int? currentQuantity = functions.getTicketQuantity(
                                                                    bookticketsTicketsRow
                                                                        ?.id,
                                                                    FFAppState()
                                                                        .ticketsaddtocart
                                                                        .toList());

                                                                _model.outputUpdateCart2 =
                                                                    await actions
                                                                        .updateCart(
                                                                  bookticketsTicketsRow!
                                                                      .id,
                                                                  bookticketsTicketsRow
                                                                      .title!,
                                                                  functions.calculateTotalPricenew(
                                                                      bookticketsTicketsRow
                                                                          .servicecharge,
                                                                      bookticketsTicketsRow
                                                                          .price)!,
                                                                  functions.minus(
                                                                      bookticketsTicketsRow
                                                                          .capacity,
                                                                      bookticketsTicketsRow
                                                                          .bookedtickets)!,
                                                                  true,
                                                                  FFAppState()
                                                                      .ticketsaddtocart
                                                                      .toList(),
                                                                );
                                                                logFirebaseEvent(
                                                                    'IconButton_update_app_state');
                                                                FFAppState()
                                                                        .ticketsaddtocart =
                                                                    _model
                                                                        .outputUpdateCart2!
                                                                        .toList()
                                                                        .cast<
                                                                            TicketsaddtocartStruct>();
                                                                safeSetState(
                                                                    () {});

                                                                if ((currentQuantity ??
                                                                        0) >
                                                                    0) {
                                                                  logFirebaseEvent(
                                                                      'IconButton_show_snack_bar');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        'Removed from cart',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).tertiary,
                                                                        ),
                                                                      ),
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              1500),
                                                                      backgroundColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary,
                                                                    ),
                                                                  );
                                                                }

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                            ),
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                functions
                                                                    .getTicketQuantity(
                                                                        bookticketsTicketsRow
                                                                            ?.id,
                                                                        FFAppState()
                                                                            .ticketsaddtocart
                                                                            .toList())
                                                                    .toString(),
                                                                '0',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            FlutterFlowIconButton(
                                                              borderColor: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  10.0,
                                                              borderWidth: 0.0,
                                                              buttonSize: 40.0,
                                                              fillColor: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primary
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1),
                                                              icon: Icon(
                                                                Icons.add,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                size: 18.0,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                logFirebaseEvent(
                                                                    'IconButton_custom_action');
                                                                _model.outputUpdateCart =
                                                                    await actions
                                                                        .updateCart(
                                                                  bookticketsTicketsRow!
                                                                      .id,
                                                                  bookticketsTicketsRow
                                                                      .title!,
                                                                  functions.calculateTotalPricenew(
                                                                      bookticketsTicketsRow
                                                                          .servicecharge,
                                                                      bookticketsTicketsRow
                                                                          .price)!,
                                                                  functions.minus(
                                                                      bookticketsTicketsRow
                                                                          .capacity,
                                                                      bookticketsTicketsRow
                                                                          .bookedtickets)!,
                                                                  false,
                                                                  FFAppState()
                                                                      .ticketsaddtocart
                                                                      .toList(),
                                                                );
                                                                logFirebaseEvent(
                                                                    'IconButton_update_app_state');
                                                                FFAppState()
                                                                        .ticketsaddtocart =
                                                                    _model
                                                                        .outputUpdateCart!
                                                                        .toList()
                                                                        .cast<
                                                                            TicketsaddtocartStruct>();
                                                                safeSetState(
                                                                    () {});

                                                                logFirebaseEvent(
                                                                    'IconButton_show_snack_bar');
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'Added to cart',
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiary,
                                                                      ),
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            1500),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .success,
                                                                  ),
                                                                );

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: FutureBuilder<
                                                  List<OrderitemsRow>>(
                                                future:
                                                    OrderitemsTable().queryRows(
                                                  queryFn: (q) => q
                                                      .eqOrNull(
                                                        'ticket_id',
                                                        bookticketsTicketsRow
                                                            ?.id,
                                                      )
                                                      .neqOrNull(
                                                        'status',
                                                        'cancelled',
                                                      ),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            12.0),
                                                        child: SizedBox(
                                                          width: 24.0,
                                                          height: 24.0,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            strokeWidth: 2.0,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  return Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                8.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                8.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        topRight:
                                                            Radius.circular(
                                                                0.0),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            logFirebaseEvent(
                                                                'Button_navigate_to');

                                                            context.pushNamed(
                                                              SeewhojoinednewWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'ticketid':
                                                                    serializeParam(
                                                                  bookticketsTicketsRow
                                                                      ?.id,
                                                                  ParamType.int,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                          text: FFLocalizations
                                                                  .of(context)
                                                              .getText(
                                                            'yop182s3' /* See who joined */,
                                                          ),
                                                          icon: Icon(
                                                            Icons
                                                                .people_outline_rounded,
                                                            size: 18.0,
                                                          ),
                                                          options:
                                                              FFButtonOptions(
                                                            height: 44.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        4.0,
                                                                        0.0),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary
                                                                .withValues(
                                                                    alpha:
                                                                        0.15),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleSmallIsCustom,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primary
                                                                  .withValues(
                                                                      alpha:
                                                                          0.3),
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 12.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .success
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .success
                                              .withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success
                                                        .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Icon(
                                                Icons.verified_user_outlined,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                size: 20.0,
                                              ),
                                            ),
                                            SizedBox(width: 12.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(10.0, 4.0,
                                                                10.0, 4.0),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary
                                                              .withValues(
                                                                  alpha: 0.2),
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary
                                                              .withValues(
                                                                  alpha: 0.2),
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                1.0, 0.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary
                                                                .withValues(
                                                                    alpha: 0.3),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        bookticketsTicketsRow
                                                            ?.title,
                                                        'Level',
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
                                                                .primary,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.0),
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'p28egvd0' /* Who can Join */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      functions
                                                          .getTicketLevelDescription(
                                                              bookticketsTicketsRow
                                                                  ?.title),
                                                      'Who can join',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 12.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFA726)
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: Color(0xFFFFA726)
                                              .withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFA726)
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Icon(
                                                Icons.info_outline,
                                                color: Color(0xFFFFA726),
                                                size: 20.0,
                                              ),
                                            ),
                                            SizedBox(width: 12.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'usfkun2g' /* Warning :  */,
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
                                                              Color(0xFFFFA726),
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'lhg2j5wa' /* Players will have to bring the... */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 16.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            FlutterFlowTheme.of(context)
                                                .primary
                                                .withValues(alpha: 0.05),
                                            FlutterFlowTheme.of(context)
                                                .secondary
                                                .withValues(alpha: 0.05),
                                          ],
                                          stops: [0.0, 1.0],
                                          begin:
                                              AlignmentDirectional(-1.0, -1.0),
                                          end: AlignmentDirectional(1.0, 1.0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primary
                                              .withValues(alpha: 0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                      ],
                                                      stops: [0.0, 1.0],
                                                      begin:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      end: AlignmentDirectional(
                                                          1.0, 0.0),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.description_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                SizedBox(width: 12.0),
                                                Text(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    '59nv1m0s' /* Description */,
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
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12.0),
                                            Text(
                                              valueOrDefault<String>(
                                                bookticketsTicketsRow
                                                    ?.description,
                                                'Description',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    lineHeight: 1.5,
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
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF161616),
                            border: Border.all(
                              color: Color(0x18FFFFFF),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    Text(
                                      '${FFAppState().ticketsaddtocart.firstOrNull?.quantity ?? 0}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    Text(
                                      '₹${functions.calculateTotalPrice(FFAppState().ticketsaddtocart.toList()).toString()}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            fontSize: 20.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
