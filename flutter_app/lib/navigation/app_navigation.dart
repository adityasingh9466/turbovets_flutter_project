import 'package:flutter/material.dart';
import 'package:turbovets_flutter_challange/screens/chat/chat_screen.dart';
import 'package:turbovets_flutter_challange/screens/dashboard/dashboard_screen.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_tab_bar.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _hasUnreadMessages = false;
  final _chatScreenKey = GlobalKey<ChatScreenState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    final isOnChat = _tabController.index == 0;

    if (isOnChat) {
      setState(() => _hasUnreadMessages = false);
    }

    _chatScreenKey.currentState?.setPageVisibility(isOnChat);

    // Trigger rebuild to update AppBar
    setState(() {});
  }

  void _handleNewMessage() {
    if (_tabController.index != 0) {
      setState(() => _hasUnreadMessages = true);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which tab is active
    final isOnChatPage = _tabController.index == 0;

    return Scaffold(
      appBar: CustomAppBar(
        title: isOnChatPage ? 'Support Agent' : 'Dashboard',
        isOnChatPage: isOnChatPage,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatScreen(
            key: _chatScreenKey,
            onNewMessage: _handleNewMessage,
          ),
          const DashboardScreen(),
        ],
      ),
      bottomNavigationBar: CustomTabBar(
        controller: _tabController,
        hasUnreadMessages: _hasUnreadMessages,
      ),
    );
  }
}
