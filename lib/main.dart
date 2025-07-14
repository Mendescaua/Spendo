import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:spendo/providers/theme_provider.dart';
import 'package:spendo/ui/bank_info_screen.dart';
import 'package:spendo/ui/bank_screen.dart';
import 'package:spendo/ui/category/add_category_screen.dart';
import 'package:spendo/ui/wallet/add_money_card_screen.dart';
import 'package:spendo/controllers/auth_gate.dart';
import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/ui/category/category_screen.dart';
import 'package:spendo/ui/home_screen.dart';
import 'package:spendo/ui/auth/login_screen.dart';
import 'package:spendo/ui/main_screen.dart';
import 'package:spendo/ui/auth/register_screen.dart';
import 'package:spendo/ui/wallet/money_card_screen.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Spendo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
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
        '/transactions': (context) => const TransactionScreen(type: 'all',),
        '/transactions_despesa': (context) => const TransactionScreen(type: 'd',),
        '/transactions_receita': (context) => const TransactionScreen(type: 'r',),
        '/saving_picker_image': (context) => const ImagePickerScreen(),
        '/category_chart': (context) => const CategoryChart(),
        '/money_card': (context) => const MoneyCardScreen(),
        '/add_money_card': (context) => const AddMoneyCardScreen(),
        '/saving': (context) => const SavingScreen(),
        '/category': (context) => const CategoryScreen(),
        '/add_category': (context) => const CriarCategoriaScreen(),
        '/bank': (context) => const BankScreen(),
      },
    );
  }
}
