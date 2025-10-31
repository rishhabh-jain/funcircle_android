import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../funcirclefinalapp/home_new/home_new_widget.dart';
import '../find_players_new/find_players_new_widget.dart';
import '../funcirclefinalapp/playnew/playnew_widget.dart';
import '../chatsnew/chatsnew_widget.dart';
import 'main_navigation_model.dart';
export 'main_navigation_model.dart';

class MainNavigationWidget extends StatefulWidget {
  const MainNavigationWidget({super.key});

  static String routeName = 'MainNavigation';
  static String routePath = '/mainNavigation';

  @override
  State<MainNavigationWidget> createState() => _MainNavigationWidgetState();
}

class _MainNavigationWidgetState extends State<MainNavigationWidget> {
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
            ChatsnewWidget(),
          ],
        ),
      ),
      bottomNavigationBar: _buildGlassyBottomBar(),
    );
  }

  Widget _buildGlassyBottomBar() {
    final navItems = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_rounded, 'label': 'Find'},
      {'icon': Icons.sports_tennis_rounded, 'label': 'Play'},
      {'icon': Icons.forum_rounded, 'label': 'Chats'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Stack(
        children: [
          // Outer glow effect - ice reflection
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                // Top highlight - ice shine
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 25,
                  spreadRadius: -5,
                  offset: const Offset(0, -8),
                ),
                // Main shadow - depth
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
                // Orange glow - brand accent
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: -5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          // Main glass container
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  // Multi-layer border for ice effect
                  border: Border.all(
                    width: 2,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(navItems.length, (index) {
                      final item = navItems[index];
                      final isSelected = _model.currentPageIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _model.updatePageIndex(index);
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon with premium styling
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  width: isSelected ? 56 : 44,
                                  height: isSelected ? 56 : 44,
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
                                    borderRadius: BorderRadius.circular(18),
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white.withValues(alpha: 0.4),
                                            width: 2,
                                          )
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFFFF6B35)
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 20,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 4),
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              spreadRadius: -2,
                                              offset: const Offset(0, -2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.4),
                                    size: isSelected ? 26 : 24,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Label with shadow for readability
                                Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.5),
                                    fontSize: isSelected ? 12 : 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    letterSpacing: 0.3,
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
        ],
      ),
    );
  }
}
