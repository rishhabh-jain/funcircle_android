import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'likedusers_model.dart';
export 'likedusers_model.dart';

class LikedusersWidget extends StatefulWidget {
  const LikedusersWidget({super.key});

  static String routeName = 'likedusers';
  static String routePath = '/likedusers';

  @override
  State<LikedusersWidget> createState() => _LikedusersWidgetState();
}

class _LikedusersWidgetState extends State<LikedusersWidget>
    with TickerProviderStateMixin {
  late LikedusersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LikedusersModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).secondary),
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'zto7yyzy' /* Likes */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Icon_navigate_to');

                    context.pushNamed(NotificationsWidget.routeName);
                  },
                  child: Icon(
                    FFIcons.kbell,
                    color: FlutterFlowTheme.of(context).secondary,
                    size: 24.0,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            toolbarHeight: MediaQuery.sizeOf(context).height * 1.0,
            elevation: 1.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 72.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF950199), Color(0xFFF902FF)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.0),
                      end: AlignmentDirectional(1.0, 0),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: 44.0,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    '9h3frnt5' /* You can only connect with Subs... */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            logFirebaseEvent('Button_navigate_to');

                            context.pushNamed(PremiumWidget.routeName);
                          },
                          text: FFLocalizations.of(context).getText(
                            'msdpc68q' /* Subscribe Now */,
                          ),
                          options: FFButtonOptions(
                            width: 135.0,
                            height: 32.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 0.0, 15.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFFF8F8F8),
                            textStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment(0.0, 0),
                        child: TabBar(
                          labelColor: FlutterFlowTheme.of(context).primaryText,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          labelStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleMediumFamily,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleMediumIsCustom,
                              ),
                          unselectedLabelStyle: TextStyle(),
                          indicatorColor: Color(0xFFF902FF),
                          tabs: [
                            Tab(
                              text: FFLocalizations.of(context).getText(
                                'kjund988' /* You Liked */,
                              ),
                            ),
                            Tab(
                              text: FFLocalizations.of(context).getText(
                                'ln2zslph' /* Others Liked */,
                              ),
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 70.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FutureBuilder<List<UserlikesRow>>(
                                      future: UserlikesTable().queryRows(
                                        queryFn: (q) => q.eqOrNull(
                                          'liker_user_id',
                                          currentUserUid,
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 50.0,
                                              ),
                                            ),
                                          );
                                        }
                                        List<UserlikesRow>
                                            wrapUserlikesRowList =
                                            snapshot.data!;

                                        return Wrap(
                                          spacing: 42.0,
                                          runSpacing: 10.0,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          direction: Axis.horizontal,
                                          runAlignment: WrapAlignment.start,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          clipBehavior: Clip.none,
                                          children: List.generate(
                                              wrapUserlikesRowList.length,
                                              (wrapIndex) {
                                            final wrapUserlikesRow =
                                                wrapUserlikesRowList[wrapIndex];
                                            return FutureBuilder<
                                                List<UsersRow>>(
                                              future:
                                                  UsersTable().querySingleRow(
                                                queryFn: (q) => q.eqOrNull(
                                                  'user_id',
                                                  wrapUserlikesRow.likedUserId,
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 50.0,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                List<UsersRow>
                                                    containerUsersRowList =
                                                    snapshot.data!;

                                                final containerUsersRow =
                                                    containerUsersRowList
                                                            .isNotEmpty
                                                        ? containerUsersRowList
                                                            .first
                                                        : null;

                                                return InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'Container_navigate_to');

                                                    context.pushNamed(
                                                      OthersProfileWidget
                                                          .routeName,
                                                      pathParameters: {
                                                        'uid': serializeParam(
                                                          containerUsersRow
                                                              ?.userId,
                                                          ParamType.String,
                                                        ),
                                                      }.withoutNulls,
                                                      extra: <String, dynamic>{
                                                        kTransitionInfoKey:
                                                            TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType:
                                                              PageTransitionType
                                                                  .bottomToTop,
                                                        ),
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 160.0,
                                                    height: 216.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          child: Image.network(
                                                            valueOrDefault<
                                                                String>(
                                                              containerUsersRow
                                                                  ?.images
                                                                  .firstOrNull,
                                                              'https://picsum.photos/seed/439/600',
                                                            ),
                                                            width: 300.0,
                                                            height: 216.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        6.0,
                                                                        0.0,
                                                                        6.0,
                                                                        12.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.12,
                                                                          0.71),
                                                                  child: Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      '${valueOrDefault<String>(
                                                                        containerUsersRow
                                                                            ?.firstName,
                                                                        'Name',
                                                                      )}, ${valueOrDefault<String>(
                                                                        containerUsersRow
                                                                            ?.age,
                                                                        'Age',
                                                                      )}',
                                                                      'Name, Age',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              Color(0xFFF7F8F9),
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          1.0),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.08,
                                                                              0.89),
                                                                          child:
                                                                              Text(
                                                                            valueOrDefault<String>(
                                                                              containerUsersRow?.location,
                                                                              'location',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: Color(0xFFF7F8F9),
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 70.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FutureBuilder<List<UserlikesRow>>(
                                    future: UserlikesTable().queryRows(
                                      queryFn: (q) => q.eqOrNull(
                                        'liked_user_id',
                                        currentUserUid,
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 50.0,
                                            ),
                                          ),
                                        );
                                      }
                                      List<UserlikesRow> wrapUserlikesRowList =
                                          snapshot.data!;

                                      return Wrap(
                                        spacing: 42.0,
                                        runSpacing: 10.0,
                                        alignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        direction: Axis.horizontal,
                                        runAlignment: WrapAlignment.start,
                                        verticalDirection:
                                            VerticalDirection.down,
                                        clipBehavior: Clip.none,
                                        children: List.generate(
                                            wrapUserlikesRowList.length,
                                            (wrapIndex) {
                                          final wrapUserlikesRow =
                                              wrapUserlikesRowList[wrapIndex];
                                          return FutureBuilder<List<UsersRow>>(
                                            future: UsersTable().querySingleRow(
                                              queryFn: (q) => q.eqOrNull(
                                                'user_id',
                                                wrapUserlikesRow.likerUserId,
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
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 50.0,
                                                    ),
                                                  ),
                                                );
                                              }
                                              List<UsersRow>
                                                  containerUsersRowList =
                                                  snapshot.data!;

                                              final containerUsersRow =
                                                  containerUsersRowList
                                                          .isNotEmpty
                                                      ? containerUsersRowList
                                                          .first
                                                      : null;

                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  logFirebaseEvent(
                                                      'Container_navigate_to');

                                                  context.pushNamed(
                                                    OthersProfileWidget
                                                        .routeName,
                                                    pathParameters: {
                                                      'uid': serializeParam(
                                                        containerUsersRow
                                                            ?.userId,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                    extra: <String, dynamic>{
                                                      kTransitionInfoKey:
                                                          TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .bottomToTop,
                                                      ),
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 160.0,
                                                  height: 216.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            containerUsersRow
                                                                ?.images
                                                                .firstOrNull,
                                                            'https://picsum.photos/seed/439/600',
                                                          ),
                                                          width: 300.0,
                                                          height: 216.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 1.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      6.0,
                                                                      0.0,
                                                                      6.0,
                                                                      12.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.12,
                                                                        0.71),
                                                                child: Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    '${valueOrDefault<String>(
                                                                      containerUsersRow
                                                                          ?.firstName,
                                                                      'Name',
                                                                    )}, ${valueOrDefault<String>(
                                                                      containerUsersRow
                                                                          ?.age,
                                                                      'Age',
                                                                    )}',
                                                                    'Name, Age',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: Color(
                                                                            0xFFF7F8F9),
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        1.0),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.08,
                                                                            0.89),
                                                                        child:
                                                                            Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            containerUsersRow?.location,
                                                                            'location',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFFF7F8F9),
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}
