import 'package:dailysync/providers/theme_provider.dart';
import 'package:dailysync/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: "AIzaSyBpr_LhYBMH1NPVvHkNuoJ775Wtw4NORAY",
     appId: "1:184902571321:android:d9d124a16e2c97b51f84e8", 
     messagingSenderId: "184902571321",
      projectId: "dailysync-9f0e8"));
  // Wrap the app with the ThemeNotifier provider
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const HealthApp(),
    ),
  );
}


class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to rebuild MaterialApp when the theme changes
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Health Manager',
          debugShowCheckedModeBanner: false,

          // Define your light theme
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF5F5F5),
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            fontFamily: 'Roboto',
            cardTheme: CardTheme(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
            ),
             chipTheme: ChipThemeData(
                backgroundColor: Colors.teal.withOpacity(0.1),
                labelStyle: TextStyle(color: Colors.teal[800])),
          ),

          // Define your dark theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardTheme: CardTheme(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF1E1E1E),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Color(0xFF121212),
            ),
            chipTheme: ChipThemeData(
                backgroundColor: Colors.teal.withOpacity(0.2),
                labelStyle: const TextStyle(color: Colors.tealAccent)),
            fontFamily: 'Roboto',
          ),

          // Set the theme mode based on the notifier
          themeMode: themeNotifier.themeMode,

          home: const SplashScreen(),
        );
      },
    );
  }
}
