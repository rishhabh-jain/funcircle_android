import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'seewhojoinednew_model.dart';
export 'seewhojoinednew_model.dart';

class SeewhojoinednewWidget extends StatefulWidget {
  const SeewhojoinednewWidget({
    super.key,
    required this.ticketid,
  });

  final int? ticketid;

  static String routeName = 'seewhojoinednew';
  static String routePath = '/seewhojoinednew';

  @override
  State<SeewhojoinednewWidget> createState() => _SeewhojoinednewWidgetState();
}

class _SeewhojoinednewWidgetState extends State<SeewhojoinednewWidget> {
  late SeewhojoinednewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SeewhojoinednewModel());

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
        backgroundColor: Color(0xFF121212),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primary,
                      FlutterFlowTheme.of(context).secondary,
                    ],
                    stops: [0.0, 1.0],
                    begin: AlignmentDirectional(-1.0, 0.0),
                    end: AlignmentDirectional(1.0, 0.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Color(0x33000000),
                      offset: Offset(0.0, 2.0),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 12.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context)
                            .tertiary
                            .withValues(alpha: 0.2),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.safePop();
                        },
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Who Joined',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Text(
                              'View all participants',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .tertiary
                                        .withValues(alpha: 0.8),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .tertiary
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Icon(
                          Icons.people_rounded,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // User list
              Expanded(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary,
                              strokeWidth: 3.0,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Loading participants...',
                              style: FlutterFlowTheme.of(context)
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
                            ),
                          ],
                        ),
                      );
                    }
                    List<OrderitemsRow> columnOrderitemsRowList =
                        snapshot.data!;

                    if (columnOrderitemsRowList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 64.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'No participants yet',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Be the first to join this event!',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
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
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                      itemCount: columnOrderitemsRowList.length,
                      itemBuilder: (context, index) {
                        final orderItem = columnOrderitemsRowList[index];
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 12.0),
                          child: FutureBuilder<List<UsersRow>>(
                            future: UsersTable().querySingleRow(
                              queryFn: (q) => q.eqOrNull(
                                'user_id',
                                orderItem.userid,
                              ),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Container(
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24.0,
                                      height: 24.0,
                                      child: CircularProgressIndicator(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        strokeWidth: 2.0,
                                      ),
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

                              if (containerUsersRow == null) {
                                return Container();
                              }

                              return Container(
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
                                    begin: AlignmentDirectional(-1.0, -1.0),
                                    end: AlignmentDirectional(1.0, 1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // Avatar
                                      Container(
                                        width: 56.0,
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                            ],
                                            stops: [0.0, 1.0],
                                            begin: AlignmentDirectional(
                                                -1.0, -1.0),
                                            end: AlignmentDirectional(1.0, 1.0),
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(3.0),
                                          child: Container(
                                            width: 50.0,
                                            height: 50.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: containerUsersRow.images.isNotEmpty
                                                ? Image.network(
                                                    containerUsersRow.images.first,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    color: Color(0xFF2A2A2A),
                                                    child: Icon(
                                                      Icons.person,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 28.0,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      // User info
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              valueOrDefault<String>(
                                                containerUsersRow.firstName,
                                                'User',
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
                                                        .tertiary,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (containerUsersRow.age !=
                                                    null)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 4.0),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary
                                                              .withValues(
                                                                  alpha: 0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Text(
                                                      '${containerUsersRow.age} years',
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
                                                                    .secondaryText,
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                    ),
                                                  ),
                                                if (containerUsersRow
                                                        .location !=
                                                    null)
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary
                                                                .withValues(
                                                                    alpha: 0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 12.0,
                                                          ),
                                                          SizedBox(width: 4.0),
                                                          Text(
                                                            containerUsersRow
                                                                .location!,
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
                                                                  fontSize:
                                                                      12.0,
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
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Quantity badge
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                            ],
                                            stops: [0.0, 1.0],
                                            begin:
                                                AlignmentDirectional(-1.0, 0.0),
                                            end: AlignmentDirectional(1.0, 0.0),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${orderItem.quantity ?? 1}',
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
                                                        .tertiary,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            Text(
                                              orderItem.quantity == 1
                                                  ? 'ticket'
                                                  : 'tickets',
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
                                                        .tertiary
                                                        .withValues(alpha: 0.8),
                                                    fontSize: 10.0,
                                                    letterSpacing: 0.0,
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
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
