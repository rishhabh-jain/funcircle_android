import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'myticket_model.dart';
export 'myticket_model.dart';

class MyticketWidget extends StatefulWidget {
  const MyticketWidget({
    super.key,
    required this.ticketid,
    required this.orderid,
  });

  final int? ticketid;
  final int? orderid;

  static String routeName = 'myticket';
  static String routePath = '/myticket';

  @override
  State<MyticketWidget> createState() => _MyticketWidgetState();
}

class _MyticketWidgetState extends State<MyticketWidget> {
  late MyticketModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyticketModel());

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
          widget.ticketid,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xF7F8F8F8),
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
        List<TicketsRow> myticketTicketsRowList = snapshot.data!;

        final myticketTicketsRow = myticketTicketsRowList.isNotEmpty
            ? myticketTicketsRowList.first
            : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xF7F8F8F8),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                backgroundColor: Color(0xFF131313),
                iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).secondary),
                automaticallyImplyLeading: true,
                leading: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Icon_navigate_to');

                    context.goNamed(MyticketsWidget.routeName);
                  },
                  child: Icon(
                    FFIcons.karrowLeft,
                    color: FlutterFlowTheme.of(context).tertiary,
                    size: 24.0,
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 253.0,
                      height: 50.0,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                5.0, 0.0, 0.0, 0.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                '2dgoriip' /* My Ticket */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
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
                    Builder(
                      builder: (context) => InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          logFirebaseEvent('Icon_share');
                          await Share.share(
                            'https://www.funcircleapp.com/',
                            sharePositionOrigin: getWidgetBoundingBox(context),
                          );
                        },
                        child: Icon(
                          Icons.share,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 24.0,
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
              child: FutureBuilder<List<OrdersRow>>(
                future: OrdersTable().querySingleRow(
                  queryFn: (q) => q.eqOrNull(
                    'id',
                    widget.orderid,
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
                  List<OrdersRow> columnOrdersRowList = snapshot.data!;

                  final columnOrdersRow = columnOrdersRowList.isNotEmpty
                      ? columnOrdersRowList.first
                      : null;

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FutureBuilder<List<OrderitemsRow>>(
                          future: OrderitemsTable().querySingleRow(
                            queryFn: (q) => q
                                .eqOrNull(
                                  'order_id',
                                  widget.orderid,
                                )
                                .eqOrNull(
                                  'ticket_id',
                                  widget.ticketid,
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
                            List<OrderitemsRow> containerOrderitemsRowList =
                                snapshot.data!;

                            final containerOrderitemsRow =
                                containerOrderitemsRowList.isNotEmpty
                                    ? containerOrderitemsRowList.first
                                    : null;

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 20.0, 12.0, 20.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: Color(0x400D0F11),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 53.0,
                                              decoration: BoxDecoration(
                                                color: valueOrDefault<Color>(
                                                  () {
                                                    if (columnOrdersRow
                                                            ?.status ==
                                                        'cancelled') {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .error;
                                                    } else if (columnOrdersRow
                                                            ?.status ==
                                                        'waitlisted') {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .warning;
                                                    } else {
                                                      return Color(0xFF00BB4D);
                                                    }
                                                  }(),
                                                  Color(0xFF00BB4D),
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(0.0),
                                                  bottomRight:
                                                      Radius.circular(0.0),
                                                  topLeft:
                                                      Radius.circular(12.0),
                                                  topRight:
                                                      Radius.circular(12.0),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(7.0, 0.0,
                                                                7.0, 0.0),
                                                    child: Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      size: 43.0,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 300.0,
                                                    height: 100.0,
                                                    decoration: BoxDecoration(),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dateTimeFormat(
                                                            "M/d h:mm a",
                                                            columnOrdersRow!
                                                                .createdAt,
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
                                                                    .tertiary,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            () {
                                                              if (columnOrdersRow
                                                                      .status ==
                                                                  'cancelled') {
                                                                return 'Your booking is cancelled.';
                                                              } else if (columnOrdersRow
                                                                      .status ==
                                                                  'waitlisted') {
                                                                return 'Your booking is waitlisted.';
                                                              } else {
                                                                return 'Your booking is confirmed.';
                                                              }
                                                            }(),
                                                            'Your booking is confirmed',
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
                                                                fontSize: 16.0,
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
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 30.0, 0.0, 30.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    BarcodeWidget(
                                                      data:
                                                          'FC${widget.orderid?.toString()}${widget.ticketid?.toString()}',
                                                      barcode: Barcode.qrCode(),
                                                      width: 440.0,
                                                      height: 110.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      errorBuilder:
                                                          (_context, _error) =>
                                                              SizedBox(
                                                        width: 440.0,
                                                        height: 110.0,
                                                      ),
                                                      drawText: false,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  30.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'hrg52jhe' /* Ticket ID */,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'FC${widget.orderid?.toString()}${widget.ticketid?.toString()}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
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
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  20.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        '${myticketTicketsRow?.title} X ${containerOrderitemsRow?.quantity?.toString()} - Rs. ${columnOrdersRow.totalPrice}/-',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                              fontSize: 16.0,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 70.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                border: Border.all(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      size: 24.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Container(
                                                        width: 293.0,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              dateTimeFormat(
                                                                "MMMMEEEEd",
                                                                myticketTicketsRow!
                                                                    .startdatetime!,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                '${dateTimeFormat(
                                                                  "jm",
                                                                  myticketTicketsRow
                                                                      .startdatetime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                )} - ${dateTimeFormat(
                                                                  "jm",
                                                                  myticketTicketsRow
                                                                      .enddatetime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                )}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
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
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: FutureBuilder<
                                                  List<VenuesRow>>(
                                                future: VenuesTable()
                                                    .querySingleRow(
                                                  queryFn: (q) => q.eqOrNull(
                                                    'id',
                                                    myticketTicketsRow.venueid,
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 50.0,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<VenuesRow>
                                                      containerVenuesRowList =
                                                      snapshot.data!;

                                                  final containerVenuesRow =
                                                      containerVenuesRowList
                                                              .isNotEmpty
                                                          ? containerVenuesRowList
                                                              .first
                                                          : null;

                                                  return Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x0BFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      5.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: 230.0,
                                                            height: 31.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  'ejenhp2b' /* Venue details */,
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
                                                                          .secondary,
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      8.0,
                                                                      0.0,
                                                                      8.0),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: 80.0,
                                                                  height: 80.0,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      containerVenuesRow
                                                                          ?.images
                                                                          .firstOrNull,
                                                                      'https://picsum.photos/seed/989/600',
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        250.0,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            containerVenuesRow?.venueName,
                                                                            'Venue Name',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                fontSize: 18.0,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                        Wrap(
                                                                          spacing:
                                                                              0.0,
                                                                          runSpacing:
                                                                              0.0,
                                                                          alignment:
                                                                              WrapAlignment.start,
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.start,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          runAlignment:
                                                                              WrapAlignment.start,
                                                                          verticalDirection:
                                                                              VerticalDirection.down,
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  containerVenuesRow?.location,
                                                                                  'Location',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondary,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        FFButtonWidget(
                                                                          onPressed:
                                                                              () async {
                                                                            logFirebaseEvent('Button_launch_u_r_l');
                                                                            await launchURL(containerVenuesRow!.mapsLink!);
                                                                          },
                                                                          text:
                                                                              FFLocalizations.of(context).getText(
                                                                            'rlbfr0vd' /* Maps */,
                                                                          ),
                                                                          icon:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.mapMarkerAlt,
                                                                            size:
                                                                                15.0,
                                                                          ),
                                                                          options:
                                                                              FFButtonOptions(
                                                                            height:
                                                                                39.3,
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                0.0,
                                                                                16.0,
                                                                                0.0),
                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            color:
                                                                                Colors.white,
                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                  color: FlutterFlowTheme.of(context).secondary,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                ),
                                                                            elevation:
                                                                                0.0,
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0xFF196FE2),
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 12.0, 12.0, 12.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'Container_navigate_to');

                                          context.pushNamed(
                                              HelpcenterWidget.routeName);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: Color(0xFFDADADA),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 250.0,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: Icon(
                                                        FFIcons.kquestion,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'ho7cjetb' /* Need help? Messages us */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 8.0, 0.0),
                                                child: Icon(
                                                  FFIcons.kcaretRight,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 12.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'Container_navigate_to');

                                          context.pushNamed(
                                            WebviewWidget.routeName,
                                            queryParameters: {
                                              'url': serializeParam(
                                                'https://www.funcircleapp.com/termsandservice',
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: Color(0xFFDADADA),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 250.0,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons.info_outline,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'n9t5z58p' /* Terms and conditions */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 8.0, 0.0),
                                                child: Icon(
                                                  FFIcons.kcaretRight,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
