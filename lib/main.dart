import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/app_route/app_route.dart';
import 'package:time_verse/config/connectivity/no_connectivity.dart';
import 'package:time_verse/core/components/bottom_card_controller/bottom_card_controller.dart';
import 'package:time_verse/core/theme/theme.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/features/all_events/controller/all_events.dart';
import 'package:time_verse/features/auth/forgot_passowrd/controller/forgot_password_controller.dart';
import 'package:time_verse/features/auth/login/controller/login_controller.dart';
import 'package:time_verse/features/auth/otp/controller/otp_controller.dart';
import 'package:time_verse/features/auth/reset_password/controller/reset_password_controller.dart';
import 'package:time_verse/features/auth/signup/controller/signup_controller.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';
import 'package:time_verse/features/qoutation/saved_qoutation/controller/saved_qoute_controller.dart';
import 'package:time_verse/features/settings/change_password/controller/changepassowrd_controller.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';
import 'package:time_verse/features/settings/settings_controller.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
            ChangeNotifierProvider(create: (_) => LoginController()),
            ChangeNotifierProvider(create: (_)=>  ForgotPasswordController()),
            ChangeNotifierProvider(create: (_)=>  OtpController()),
            ChangeNotifierProvider(create: (_)=>  ResetPasswordController()),
            ChangeNotifierProvider(create: (_)=>  SettingsController()),
            ChangeNotifierProvider(create: (_)=>  ProfileController()),
            ChangeNotifierProvider(create: (_)=>  ChangepassowrdController()),
            ChangeNotifierProvider(create: (_)=>  SubscriptionController()),
            ChangeNotifierProvider(create: (_)=>  SavedQouteController()),
            ChangeNotifierProvider(create: (_)=>  AllEventsController()),
            ChangeNotifierProvider(create: (_)=>  CalendarController()),
            ChangeNotifierProvider(create: (_)=>  BottomNavController()),
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