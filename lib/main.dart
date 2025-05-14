import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gloves_01/pages/splash_screen.dart' show SplashScreen;
import 'package:smart_gloves_01/services/data_provider.dart' show DataProvider;
import 'package:smart_gloves_01/services/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDark = prefs.getBool("isDarkMode") ?? false;


  // Inizializza firebase per gestione notifiche

  WidgetsFlutterBinding.ensureInitialized();

  runApp(

    // inizializza il provider per il tema e i dati
    MultiProvider(
      providers: [
        ChangeNotifierProvider( 
          create: (context) => ThemeProvider()..toggleTheme(isDark),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final dataProvider = DataProvider();
            dataProvider.caricaSoglia();
            return dataProvider;
          },
        ),
      ],
      child: const MyApp(),
    )
  ); 

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider> ( 
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Gloves',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }


  // Supporto multilingua

}