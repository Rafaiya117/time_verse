import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' hide NotificationSettings;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:time_verse/config/services/alerm_notification_service.dart';
import 'package:time_verse/config/app_route/app_route.dart';
import 'package:time_verse/config/services/firebase/fire_base_service.dart';
import 'package:time_verse/config/connectivity/no_connectivity.dart';
import 'package:time_verse/config/services/firebase/firebase_forground.dart';
import 'package:time_verse/core/components/bottom_card_controller/bottom_card_controller.dart';
import 'package:time_verse/core/theme/theme.dart';
import 'package:time_verse/core/theme/theme_provider.dart';
import 'package:time_verse/features/all_events/controller/all_events.dart';
import 'package:time_verse/features/all_events/controller/event_details_controller.dart';
import 'package:time_verse/features/auth/forgot_passowrd/controller/forgot_password_controller.dart';
import 'package:time_verse/features/auth/login/controller/login_controller.dart';
import 'package:time_verse/features/auth/otp/controller/otp_controller.dart';
import 'package:time_verse/features/auth/reset_password/controller/reset_password_controller.dart';
import 'package:time_verse/features/auth/signup/controller/signup_controller.dart';
import 'package:time_verse/features/calender/controller/add_event_controller.dart';
import 'package:time_verse/features/calender/controller/calender_controller.dart';
import 'package:time_verse/features/calender/controller/time_controller.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';
import 'package:time_verse/features/qoutation/saved_qoutation/controller/saved_qoute_controller.dart';
import 'package:time_verse/features/settings/change_password/controller/changepassowrd_controller.dart';
import 'package:time_verse/features/settings/privacy/controller/privacy_policy_controller.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';
import 'package:time_verse/features/settings/settings_controller.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';
import 'package:time_verse/features/settings/terms_condition/controller/terms_controller.dart';
import 'package:time_verse/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();
  await Alarm.init();

  // ignore: deprecated_member_use
  await Purchases.configure(PurchasesConfiguration("test_BQgLjxhDyZghRPnwBFQAVRSnpSI "));
  
  runApp(const MyApp());
  _initBackgroundServices();
}

Future<void> _initBackgroundServices() async {
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  await FCMService.initialize();
  await NotificationService.init();

  //   await Alarm.set(
  //   alarmSettings: AlarmSettings(
  //     id: 999,
  //     dateTime: DateTime.now().add(const Duration(seconds: 5)),
  //     assetAudioPath: 'assets/alarm.mp3',
  //     loopAudio: true,
  //     vibrate: true,
  //     volumeSettings: VolumeSettings.fixed(volume: 1.0),
  //     notificationSettings: const NotificationSettings(
  //       title: 'Demo Alarm',
  //       body: 'This is a test alarm',
  //       stopButton: 'STOP',
  //     ),
  //   ),
  // );
}





class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasConnection = true;
  StreamSubscription<AlarmSet>? _ringSubscription;
  bool _isAlarmLaunch = false;
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((status) {
      if (!mounted) return; 
      setState(() {
        hasConnection = status != ConnectivityResult.none;
      });
    });

    // _ringSubscription = Alarm.ringing.listen((alarmSet) {
    //   if (alarmSet.alarms.isEmpty) return;
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     appRouter.push('/alarm');
    //   });
    // });

    _ringSubscription = Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isEmpty || _isAlarmLaunch) return;

      _isAlarmLaunch = true;
      final alarm = alarmSet.alarms.first;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        appRouter.go('/alarm', extra: alarm);
      });
    });
  }

  @override
  void dispose() {
    _ringSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final status = await Connectivity().checkConnectivity();
    if (!mounted) return; 
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
            ChangeNotifierProvider(create: (_) => ForgotPasswordController()),
            ChangeNotifierProvider(create: (_) => OtpController()),
            ChangeNotifierProvider(create: (_) => ResetPasswordController()),
            ChangeNotifierProvider(create: (_) => SettingsController()),
            ChangeNotifierProvider(create: (_) => ProfileController()),
            ChangeNotifierProvider(create: (_) => ChangepassowrdController()),
            ChangeNotifierProvider(create: (_) => SubscriptionController()),
            ChangeNotifierProvider(create: (_) => AddEventController()),
            ChangeNotifierProvider(create: (_) => EventController()),
            ChangeNotifierProvider(create: (_) => SavedQouteController()),
            ChangeNotifierProvider(create: (_) => AllEventsController()),
            ChangeNotifierProvider(create: (_) => CalendarController()),
            ChangeNotifierProvider(create: (_) => BottomNavController()),
            ChangeNotifierProvider(create: (_) => TimePickerController()),
            ChangeNotifierProvider(create: (_) => HomeController()),
            ChangeNotifierProvider(create: (_) => TermsController()),
            ChangeNotifierProvider(create: (_) => PrivacyController()),
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
                  return hasConnection
                    ? child!
                    : const NoInternetWidget();
                },
              );
            },
          ),
        );
      },
    );
  }
}
