import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'seewhojoined_model.dart';
export 'seewhojoined_model.dart';

class SeewhojoinedWidget extends StatefulWidget {
  const SeewhojoinedWidget({
    super.key,
    required this.ticketid,
  });

  final int? ticketid;

  static String routeName = 'seewhojoined';
  static String routePath = '/seewhojoined';

  @override
  State<SeewhojoinedWidget> createState() => _SeewhojoinedWidgetState();
}

class _SeewhojoinedWidgetState extends State<SeewhojoinedWidget> {
  late SeewhojoinedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SeewhojoinedModel());

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
        backgroundColor: Color(0xFF131517),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).tertiary),
            automaticallyImplyLeading: true,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: 237.0,
                    height: 50.0,
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            '3mhh8j8c' /* See who joined */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: FutureBuilder<List<OrderitemsRow>>(
              future: OrderitemsTable().queryRows(
                queryFn: (q) => q
                    .eqOrNull(
                      'ticket_id',
                      widget.ticketid,
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
                List<OrderitemsRow> columnOrderitemsRowList = snapshot.data!;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(columnOrderitemsRowList.length,
                        (columnIndex) {
                      final columnOrderitemsRow =
                          columnOrderitemsRowList[columnIndex];
                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 5.0, 10.0, 10.0),
                        child: FutureBuilder<List<UsersRow>>(
                          future: UsersTable().querySingleRow(
                            queryFn: (q) => q.eqOrNull(
                              'user_id',
                              columnOrderitemsRow.userid,
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
                            List<UsersRow> containerUsersRowList =
                                snapshot.data!;

                            final containerUsersRow =
                                containerUsersRowList.isNotEmpty
                                    ? containerUsersRowList.first
                                    : null;

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                              child: StreamBuilder<List<UsersRecord>>(
                                stream: queryUsersRecord(
                                  queryBuilder: (usersRecord) =>
                                      usersRecord.where(
                                    'uid',
                                    isEqualTo: containerUsersRow?.userId,
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
                                  List<UsersRecord> columnUsersRecordList =
                                      snapshot.data!;
                                  // Return an empty Container when the item does not exist.
                                  if (snapshot.data!.isEmpty) {
                                    return Container();
                                  }
                                  final columnUsersRecord =
                                      columnUsersRecordList.isNotEmpty
                                          ? columnUsersRecordList.first
                                          : null;

                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 10.0, 10.0, 10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(10.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        containerUsersRow
                                                            ?.firstName,
                                                        'Name',
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
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
