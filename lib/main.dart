import '/custom_code/actions/index.dart' as actions;
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/push_notifications/push_notifications_util.dart';
import '/backend/supabase/supabase.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'flutter_flow/firebase_app_check_util.dart';
import 'index.dart';
// RevenueCat disabled - uncomment if re-enabling in-app purchases
// import 'flutter_flow/revenue_cat_util.dart' as revenue_cat;

import '/backend/firebase_dynamic_links/firebase_dynamic_links.dart';
import '/playnow/services/payment_reconciliation_service.dart';
import '/playnow/services/game_deep_link_handler.dart';
import '/utils/room_invite_deep_link_handler.dart';
import '/funcirclefinalapp/services/venue_deep_link_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // Start initial custom actions code
  await actions.changeStatusBarColor();
  // End initial custom actions code

  await SupaFlow.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // NOTE: RevenueCat disabled - no in-app purchases in current version
  // Uncomment below if you want to re-enable subscriptions/in-app purchases
  // await revenue_cat.initialize(
  //   "appl_YkelnentWgJrnnWWGdMxZCVEJKx",
  //   "goog_ONdyIZjXXVhUiLwBBFiPqLVucqk",
  //   loadDataAfterLaunch: true,
  // );

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  await initializeFirebaseAppCheck();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((user) {
    // RevenueCat disabled - no in-app purchases in current version
    // revenue_cat.login(user?.uid);
  });
  final fcmTokenSub = fcmTokenUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = funCircleFirebaseUserStream()
      ..listen((user) async {
        _appStateNotifier.update(user);

        // Check if user is logged in
        // NOTE: Deleted user checking is now handled in login screens
        // (welcome_screen, otp_verification_screen) to show proper UI messages
        if (user.loggedIn) {
          // Check for pending payments when user logs in
          PaymentReconciliationService.checkPendingPayments();
        }
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: isWeb ? 0 : 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();
    fcmTokenSub.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Faceout social',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      builder: (context, child) {
        // Initialize all deep link handlers
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GameDeepLinkHandler().initialize(context);
          RoomInviteDeepLinkHandler().initialize(context);
          VenueDeepLinkHandler().initialize(context);
        });

        return DynamicLinksHandler(
          router: _router,
          child: child!,
        );
      },
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  NavBarPageState createState() => NavBarPageState();
}

/// This is the State class that goes with NavBarPage.
class NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomeNew';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  // Public method to switch tabs from child widgets
  void switchToTab(String tabName) {
    safeSetState(() {
      _currentPage = null;
      _currentPageName = tabName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomeNew': HomeNewWidget(),
      'findPlayersNew': FindPlayersNewWidget(),
      'playnew': PlaynewWidget(),
      'venuesNew': VenueBookingWidget(),
      'chatsnew': ChatsnewWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: _buildGlassyBottomNav(context, currentIndex, tabs),
    );
  }

  Widget _buildGlassyBottomNav(BuildContext context, int currentIndex, Map<String, Widget> tabs) {
    final navItems = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_rounded, 'label': 'Find'},
      {'icon': Icons.sports_tennis_rounded, 'label': 'Play'},
      {'icon': Icons.stadium_rounded, 'label': 'Venues'},
      {'icon': Icons.forum_rounded, 'label': 'Chats'},
    ];

    // Get bottom safe area padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          // Main shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            // Add bottom padding for safe area
            padding: EdgeInsets.only(bottom: bottomPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1C1C1E).withValues(alpha: 0.97),
                  const Color(0xFF141414).withValues(alpha: 0.98),
                  Colors.black.withValues(alpha: 0.99),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: SizedBox(
              height: 65,
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(navItems.length, (index) {
                      final item = navItems[index];
                      final isSelected = currentIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            safeSetState(() {
                              _currentPage = null;
                              _currentPageName = tabs.keys.toList()[index];
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon with gradient background when selected
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutCubic,
                                  width: isSelected ? 42 : 34,
                                  height: isSelected ? 42 : 34,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFFF6B35),
                                              Color(0xFFF7931E),
                                            ],
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(13),
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white.withValues(alpha: 0.35),
                                            width: 1.5,
                                          )
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFFFF6B35)
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 16,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.45),
                                    size: isSelected ? 24 : 22,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // Label
                                Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.55),
                                    fontSize: isSelected ? 9.5 : 8.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    letterSpacing: 0.1,
                                    shadows: isSelected
                                        ? [
                                            Shadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
