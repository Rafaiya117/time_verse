import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_verse/core/components/bottom_card_controller/bottom_card_controller.dart';
import 'package:time_verse/core/components/mood_tracker/controller.dart';
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
import 'package:time_verse/features/edit_event/controller/edit_event_controller.dart';
import 'package:time_verse/features/home/controller/home_controller.dart';
import 'package:time_verse/features/qoutation/saved_qoutation/controller/saved_qoute_controller.dart';
import 'package:time_verse/features/settings/change_password/controller/changepassowrd_controller.dart';
import 'package:time_verse/features/settings/delete_account/controller/delete_ac_controller.dart';
import 'package:time_verse/features/settings/notification/controller/notification_controller.dart';
import 'package:time_verse/features/settings/privacy/controller/privacy_policy_controller.dart';
import 'package:time_verse/features/settings/profile/controller/profile_controller.dart';
import 'package:time_verse/features/settings/settings_controller.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';
import 'package:time_verse/features/settings/terms_condition/controller/terms_controller.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
        ChangeNotifierProvider(create: (_) => DeleteAcController()),
        ChangeNotifierProvider(create: (_) => MoodController()),
        ChangeNotifierProvider(create: (_) => EditEventController()),
        ChangeNotifierProvider(create: (_) => NotificationSettingsController()),
      ],
      child: child,
    );
  }
}