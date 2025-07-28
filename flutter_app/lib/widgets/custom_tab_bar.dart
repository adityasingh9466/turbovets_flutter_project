// Improved CustomTabBar with modern selected state UI
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turbovets_flutter_challange/constants/theme/colors.dart';

class CustomTabBar extends StatefulWidget {
  final TabController controller;
  final bool hasUnreadMessages;

  const CustomTabBar({
    super.key,
    required this.controller,
    this.hasUnreadMessages = false,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _selectionController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _selectionAnimation;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _selectionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.elasticOut,
    ));

    // Start pulse animation if there are unread messages
    if (widget.hasUnreadMessages) {
      _pulseController.repeat(reverse: true);
    }

    // Start slide animation
    _slideController.forward();

    // Listen to tab controller changes
    widget.controller.addListener(_handleTabChange);
    _currentIndex = widget.controller.index;

    // Start selection animation for initial tab
    _selectionController.forward();
  }

  void _handleTabChange() {
    if (widget.controller.index != _currentIndex) {
      setState(() {
        _currentIndex = widget.controller.index;
      });

      // Animate selection change
      _selectionController.reset();
      _selectionController.forward();

      // Trigger haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update pulse animation based on unread messages
    if (widget.hasUnreadMessages && !oldWidget.hasUnreadMessages) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.hasUnreadMessages && oldWidget.hasUnreadMessages) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _selectionController.dispose();
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: TabBar(
            controller: widget.controller,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicator: const BoxDecoration(),
            indicatorWeight: 0,
            labelPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            tabs: [
              // Chat tab with notification badge
              _buildModernTab(
                index: 0,
                icon: Icons.chat_bubble_outline,
                selectedIcon: Icons.chat_bubble,
                label: 'Chat',
                hasNotification: widget.hasUnreadMessages,
              ),
              // Dashboard tab
              _buildModernTab(
                index: 1,
                icon: Icons.dashboard_outlined,
                selectedIcon: Icons.dashboard,
                label: 'Dashboard',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTab({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    bool hasNotification = false,
  }) {
    final isSelected = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 60,
      child: Tab(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with notification badge wrapped in Stack
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Icon with bounce animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    transform: Matrix4.identity()
                      ..scale(isSelected ? 1.1 : 1.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        isSelected ? selectedIcon : icon,
                        key: ValueKey('${index}_${isSelected}'),
                        size: 24,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),

                  // Enhanced notification badge positioned relative to icon
                  if (hasNotification && index == 0)
                    Positioned(
                      right: -4, // Positioned relative to the icon's right edge
                      top: -4, // Positioned relative to the icon's top edge
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.error.withOpacity(0.6),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 4),

              // Label with enhanced typography
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                  letterSpacing: isSelected ? 0.8 : 0.5,
                  height: 1.2,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
