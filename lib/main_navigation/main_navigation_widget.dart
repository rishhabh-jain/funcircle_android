import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../funcirclefinalapp/home_new/home_new_widget.dart';
import '../find_players_new/find_players_new_widget.dart';
import '../funcirclefinalapp/playnew/playnew_widget.dart';
import '../venue_booking/venue_booking_widget.dart';
import '../chatsnew/chatsnew_widget.dart';
import 'main_navigation_model.dart';
export 'main_navigation_model.dart';

class MainNavigationWidget extends StatefulWidget {
  const MainNavigationWidget({super.key});

  static String routeName = 'MainNavigation';
  static String routePath = '/mainNavigation';

  @override
  State<MainNavigationWidget> createState() => MainNavigationWidgetState();
}

class MainNavigationWidgetState extends State<MainNavigationWidget> {
  late MainNavigationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainNavigationModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Public method to switch tabs from child widgets
  void switchToTab(int index) {
    setState(() {
      _model.updatePageIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _model.currentPageIndex,
          children: const [
            HomeNewWidget(),
            FindPlayersNewWidget(),
            PlaynewWidget(),
            VenueBookingWidget(),
            ChatsnewWidget(),
          ],
        ),
      ),
      bottomNavigationBar: _buildGlassyBottomBar(),
    );
  }

  Widget _buildGlassyBottomBar() {
    // iOS 18-style navigation items with filled/outline icon variants
    final navItems = [
      {'iconOutline': Icons.home_outlined, 'iconFilled': Icons.home_rounded, 'label': 'Home'},
      {'iconOutline': Icons.explore_outlined, 'iconFilled': Icons.explore_rounded, 'label': 'Find'},
      {'iconOutline': Icons.sports_tennis_outlined, 'iconFilled': Icons.sports_tennis_rounded, 'label': 'Play'},
      {'iconOutline': Icons.calendar_today_outlined, 'iconFilled': Icons.calendar_today_rounded, 'label': 'Book'},
      {'iconOutline': Icons.forum_outlined, 'iconFilled': Icons.forum_rounded, 'label': 'Chats'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32), // iOS 18: More bottom margin for dramatic float
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28), // Slightly larger radius
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24), // Enhanced blur
          child: Container(
            height: 64, // More compact height
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondary.withValues(alpha: 0.7), // Slightly more opaque
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2), // More visible border
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.05),
                  blurRadius: 1,
                  offset: const Offset(0, -0.5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(navItems.length, (index) {
                  final item = navItems[index];
                  final isSelected = _model.currentPageIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Haptic feedback on tap
                        HapticFeedback.lightImpact();
                        setState(() {
                          _model.updatePageIndex(index);
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated icon with scale effect
                            AnimatedScale(
                              scale: isSelected ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutBack, // Spring-like animation
                              child: Icon(
                                // Use filled icon when selected, outline when not
                                isSelected
                                    ? item['iconFilled'] as IconData
                                    : item['iconOutline'] as IconData,
                                color: isSelected
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.6),
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Label - smaller and only visible when selected for cleaner look
                            AnimatedOpacity(
                              opacity: isSelected ? 1.0 : 0.7,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                item['label'] as String,
                                style: TextStyle(
                                  color: isSelected
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.6),
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  letterSpacing: -0.2,
                                ),
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
