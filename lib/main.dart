import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('protokolle');
  await Hive.openBox<String>('settings');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider()..init(),
      child: const ProtokollantApp(),
    ),
  );
}

class ProtokollantApp extends StatelessWidget {
  const ProtokollantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protokollant',
      theme: AppTheme.light(),
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
