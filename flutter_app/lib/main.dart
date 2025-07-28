

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:turbovets_flutter_challange/services/local_notification.dart';

import 'app.dart';
import 'models/chat_message.dart';
import 'models/message_type_adapter.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification().initializeNotifications();
  await LocalNotification().requestNotificationPermissionIfNeeded();

  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(MessageTypeAdapter());

  await Hive.openBox<ChatMessage>('chatMessages');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const ChatApp(),
    ),
  );
}
