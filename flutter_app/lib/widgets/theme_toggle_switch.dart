// Clean and crisp Theme Toggle Switch without blur effects
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ThemeToggleSwitch extends StatefulWidget {
  const ThemeToggleSwitch({super.key});

  @override
  State<ThemeToggleSwitch> createState() => _ThemeToggleSwitchState();
}

class _ThemeToggleSwitchState extends State<ThemeToggleSwitch>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconRotation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _handleThemeToggle(ThemeProvider themeProvider) {
    // Add haptic feedback
    HapticFeedback.selectionClick();

    // Trigger icon animation
    _iconController.forward().then((_) {
      _iconController.reverse();
    });

    // Toggle theme
    themeProvider.toggleTheme(!themeProvider.isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () => _handleThemeToggle(themeProvider),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Theme icon with clean animations
            AnimatedBuilder(
              animation: Listenable.merge([_iconRotation, _scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _iconRotation.value * 3.14159,
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 6),

            // Clean animated switch
            Container(
              width: 36,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.3),
              ),
              child: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeProvider.isDarkMode
                          ? Colors.indigo.withOpacity(0.8)
                          : Colors.amber.withOpacity(0.8),
                    ),
                  ),

                  // Animated thumb
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    alignment: themeProvider.isDarkMode
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            themeProvider.isDarkMode
                                ? Icons.nights_stay
                                : Icons.wb_sunny,
                            key: ValueKey(themeProvider.isDarkMode),
                            size: 10,
                            color: themeProvider.isDarkMode
                                ? Colors.indigo
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
