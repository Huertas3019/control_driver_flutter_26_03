
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'routing/app_router.dart';
import 'providers/theme_provider.dart';
import 'services/auth_service.dart';
import 'providers/vehicle_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/income_provider.dart';
import 'providers/platform_provider.dart';

import 'providers/maintenance_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, VehicleProvider>(
          create: (_) => VehicleProvider(null),
          update: (_, auth, previous) => VehicleProvider(auth.user?.uid),
        ),
        ChangeNotifierProxyProvider<AuthService, ExpenseProvider>(
          create: (_) => ExpenseProvider(null),
          update: (_, auth, previous) => ExpenseProvider(auth.user?.uid),
        ),
        ChangeNotifierProxyProvider<AuthService, IncomeProvider>(
          create: (_) => IncomeProvider(null),
          update: (_, auth, previous) => IncomeProvider(auth.user?.uid),
        ),
         ChangeNotifierProxyProvider<AuthService, PlatformProvider>(
          create: (_) => PlatformProvider(null),
          update: (_, auth, previous) => PlatformProvider(auth.user?.uid),
        ),
        ChangeNotifierProxyProvider<AuthService, MaintenanceProvider>(
          create: (_) => MaintenanceProvider(null),
          update: (_, auth, previous) {
            previous?.updateUserId(auth.user?.uid);
            return previous ?? MaintenanceProvider(auth.user?.uid);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final router = AppRouter.getRouter(context);

    const Color primaryBlue = Color(0xFF0288D1);
    const Color lightAzure = Color(0xFF81D4FA);
    const Color deepOceanBlue = Color(0xFF01579B);
    const Color cerulean = Color(0xFF039BE5);
    const Color darkBackground = Color(0xFF0A192F); // Deep dark blue background
    const Color cardBackground = Color(0xFF112240); // Slightly lighter for cards

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        surface: const Color(0xFFF8FAFC),
        onSurface: const Color(0xFF0F172A), // Dark slate for text
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      textTheme: appTextTheme.apply(
        bodyColor: const Color(0xFF0F172A),
        displayColor: const Color(0xFF0F172A),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0F172A),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha:0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha:0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryBlue,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        contentTextStyle: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF334155)),
        actionsPadding: const EdgeInsets.all(16),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        surface: darkBackground,
        primary: primaryBlue,
        secondary: cerulean,
        tertiary: lightAzure,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: appTextTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha:0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: deepOceanBlue.withValues(alpha:0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cerulean, width: 2),
        ),
        labelStyle: TextStyle(color: lightAzure.withValues(alpha:0.7), fontSize: 14),
        hintStyle: TextStyle(color: lightAzure.withValues(alpha:0.4), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryBlue,
          elevation: 6,
          shadowColor: primaryBlue.withValues(alpha:0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cerulean,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF112240), // Navy Blue for a cleaner look
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
        actionsPadding: const EdgeInsets.all(16),
      ),
    );

    return MaterialApp.router(
      title: 'Mi Gestor de Flota',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
      ],
    );
  }
}
