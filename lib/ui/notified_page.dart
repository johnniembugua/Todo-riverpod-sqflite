import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/theme_services.dart';

class NotifiedPage extends ConsumerWidget {
  final String label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme ? Colors.grey[600] : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkTheme ? Colors.white : Colors.grey,
          ),
        ),
        title: Text(
          label.toString().split("|")[0],
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            color: isDarkTheme ? Colors.white : Colors.grey[400],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                label.toString().split("|")[0],
                style: TextStyle(
                    color: isDarkTheme ? Colors.black : Colors.white,
                    fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
