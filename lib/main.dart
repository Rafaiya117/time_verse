// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use
import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/config/app_route/app_providers.dart';
import 'package:time_verse/config/app_route/init_app.dart';
import 'package:time_verse/config/app_route/app_route.dart';
import 'package:time_verse/config/connectivity/no_connectivity.dart';
import 'package:time_verse/core/theme/theme.dart';
import 'package:time_verse/core/theme/theme_provider.dart';

// void main() async {
//   await initApp();
//   AlarmSettings? ringingAlarm;
//   try {
//     final alarms = await Alarm.getAlarms();
//     for (final alarm in alarms) {
//       if (await Alarm.isRinging(alarm.id)) {
//         ringingAlarm = alarm;
//         break;
//       }
//     }
//   } catch (_) {
//     ringingAlarm = null;
//   }

//   runApp(MyApp(initialRingingAlarm: ringingAlarm));
// }

// class MyApp extends StatefulWidget {
//   final AlarmSettings? initialRingingAlarm;

//   const MyApp({super.key, this.initialRingingAlarm});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool hasConnection = true;
//   StreamSubscription<AlarmSettings>? _ringSubscription;
//   StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

//   @override
//   void initState() {
//     super.initState();
//     _checkConnectivity();

//     if (widget.initialRingingAlarm != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;
//         final currentRoute = appRouter.routerDelegate.currentConfiguration.uri.toString();
//         if (currentRoute != '/alarm') {
//           appRouter.push('/alarm', extra: widget.initialRingingAlarm);
//         }
//       });
//     }

//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
//       status,
//     ) {
//       if (!mounted) return;
//       setState(() {
//         hasConnection = !status.contains(ConnectivityResult.none);
//       });
//     });

//     _ringSubscription = Alarm.ringStream.stream.listen((alarmSettings) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;

//         final currentRoute = appRouter.routerDelegate.currentConfiguration.uri.toString();
//         if (currentRoute != '/alarm') {
//           appRouter.push('/alarm', extra: alarmSettings);
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _connectivitySubscription?.cancel();
//     _ringSubscription?.cancel();
//     super.dispose();
//   }

//   Future<void> _checkConnectivity() async {
//     final status = await Connectivity().checkConnectivity();
//     if (!mounted) return;
//     setState(() {
//       hasConnection = status != ConnectivityResult.none;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(390, 846),
//       minTextAdapt: true,
//       builder: (context, child) {
//         return AppProviders(
//           child: Builder(
//             builder: (context) {
//               final themeProvider = Provider.of<ThemeProvider>(context);
//               return MaterialApp.router(
//                 debugShowCheckedModeBanner: false,
//                 title: 'Flutter Demo',
//                 theme: lightTheme,
//                 darkTheme: darkTheme,
//                 themeMode: themeProvider.themeMode,
//                 routerConfig: appRouter,
//                 builder: (context, child) {
//                   return hasConnection ? child! : const NoInternetWidget();
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

void main() async {
  await initApp();
  AlarmSettings? ringingAlarm;
  try {
    final alarms = await Alarm.getAlarms();
    for (final alarm in alarms) {
      if (await Alarm.isRinging(alarm.id)) {
        ringingAlarm = alarm;
        break;
      }
    }
  } catch (_) {
    ringingAlarm = null;
  }

  runApp(MyApp(initialRingingAlarm: ringingAlarm));
}

class MyApp extends StatefulWidget {
  final AlarmSettings? initialRingingAlarm;

  const MyApp({super.key, this.initialRingingAlarm});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasConnection = true;
  StreamSubscription<AlarmSettings>? _ringSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();

    if (widget.initialRingingAlarm != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final currentRoute = appRouter.routerDelegate.currentConfiguration.uri.toString();
        if (currentRoute != '/alarm') {
          appRouter.push('/alarm', extra: widget.initialRingingAlarm);
        }
      });
    }

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      status,
    ) {
      if (!mounted) return;
      setState(() {
        hasConnection = !status.contains(ConnectivityResult.none);
      });
    });

    _ringSubscription = Alarm.ringStream.stream.listen((alarmSettings) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final currentRoute = appRouter.routerDelegate.currentConfiguration.uri.toString();
        if (currentRoute != '/alarm') {
          appRouter.push('/alarm', extra: alarmSettings);
        }
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
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
        return AppProviders(
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
            },
          ),
        );
      },
    );
  }
}