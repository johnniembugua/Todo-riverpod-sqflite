import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';

import 'db/db_helper.dart';
import 'ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await DBHelper.initDB();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();
    print(isDarkTheme);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Todo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: const HomePageUi(),
    );
  }
}
