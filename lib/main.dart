import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/app_route/app_route.dart';
import 'package:time_verse/config/connectivity/no_connectivity.dart';
import 'package:time_verse/core/theme/theme.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/features/auth/signup/controller/signup_controller.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((status) {
      setState(() {
        hasConnection = status != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final status = await Connectivity().checkConnectivity();
    setState(() {
      hasConnection = status != ConnectivityResult.none;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 846),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => SignupController()),
          ],
          child: Builder(
            builder: (context) {
              final themeProvider = Provider.of<ThemeProvider>(context);

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: lightTheme,  
                darkTheme: darkTheme, 
                themeMode: themeProvider.themeMode, 
                routerConfig: appRouter,
                builder: (context, child) {
                  return hasConnection ? child! : const NoInternetWidget();
                },
              );
            }
          ),
        );
      },
    );
  }
}