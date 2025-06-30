import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:spendo/ui/add_money_card_screen.dart';
import 'package:spendo/controllers/auth_gate.dart';
import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/ui/home_screen.dart';
import 'package:spendo/ui/auth/login_screen.dart';
import 'package:spendo/ui/main_screen.dart';
import 'package:spendo/ui/auth/register_screen.dart';
import 'package:spendo/ui/money_card_screen.dart';
import 'package:spendo/ui/saving/saving_picker_image.dart';
import 'package:spendo/ui/saving/saving_screen.dart';
import 'package:spendo/ui/splash_screen.dart';
import 'package:spendo/ui/transaction/transaction_screen.dart';
import 'package:spendo/ui/transactionChart/category_chart.dart';
import 'package:spendo/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initSupabase();

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendo',
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      locale: const Locale('pt', 'BR'), // para funcionar a localização
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // <<< importante
      ],
      supportedLocales: const [
        Locale('pt'), // Português
        Locale('en'), // Inglês (ou outras línguas que você queira)
      ],
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/menu': (context) => const MainScreen(),
        '/transactions': (context) => const TransactionScreen(),
        '/saving_picker_image': (context) => const ImagePickerScreen(),
        '/category_chart': (context) => const CategoryChart(),
        '/money_card': (context) => const MoneyCardScreen(),
        '/add_money_card': (context) => const AddMoneyCardScreen(),
        '/saving': (context) => const SavingScreen(),
      },
    );
  }
}
