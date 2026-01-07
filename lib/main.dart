import '/custom_code/actions/index.dart' as actions;
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: Stack(
        children: [
          // Main content - full screen
          _currentPage ?? tabs[_currentPageName]!,
          // Floating navigation bar overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildGlassyBottomNav(context, currentIndex, tabs),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassyBottomNav(BuildContext context, int currentIndex, Map<String, Widget> tabs) {
    // Native iOS-style navigation items with filled/outline icon variants
    final navItems = [
      {'iconOutline': Icons.home_outlined, 'iconFilled': Icons.home_rounded, 'label': 'Home'},
      {'iconOutline': Icons.explore_outlined, 'iconFilled': Icons.explore_rounded, 'label': 'Find'},
      {'iconOutline': Icons.sports_tennis_outlined, 'iconFilled': Icons.sports_tennis_rounded, 'label': 'Play'},
      {'iconOutline': Icons.stadium_outlined, 'iconFilled': Icons.stadium_rounded, 'label': 'Venues'},
      {'iconOutline': Icons.forum_outlined, 'iconFilled': Icons.forum_rounded, 'label': 'Chats'},
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, bottomPadding > 0 ? 10 : 8), // Native iOS margins with safe area
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38), // iOS native radius (larger)
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), // iOS native blur strength
          child: Container(
            height: 68, // iOS native tab bar height
            decoration: BoxDecoration(
              // iOS native material background - dark mode
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 0.33, // Hairline border like iOS
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(navItems.length, (index) {
                  final item = navItems[index];
                  final isSelected = currentIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Haptic feedback - iOS style
                        HapticFeedback.selectionClick();
                        safeSetState(() {
                          _currentPage = null;
                          _currentPageName = tabs.keys.toList()[index];
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon with native iOS spring animation
                            AnimatedScale(
                              scale: isSelected ? 1.0 : 0.95,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              child: Icon(
                                // Filled when selected, outline when not (native iOS style)
                                isSelected
                                    ? item['iconFilled'] as IconData
                                    : item['iconOutline'] as IconData,
                                color: isSelected
                                    ? Colors.white // Dark mode - white when selected
                                    : Colors.white.withValues(alpha: 0.55), // Gray when not selected
                                size: 28, // iOS native icon size
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Label - iOS native style
                            Text(
                              item['label'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.55),
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                letterSpacing: -0.08, // iOS native tight kerning
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
