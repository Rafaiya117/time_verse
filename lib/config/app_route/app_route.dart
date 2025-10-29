import 'package:go_router/go_router.dart';
import 'package:time_verse/core/theme/theme_background_wrapper.dart';
import 'package:time_verse/features/all_events/view/all_events.dart';
import 'package:time_verse/features/auth/forgot_passowrd/view/forgot_password.dart';
import 'package:time_verse/features/auth/login/view/login.dart';
import 'package:time_verse/features/auth/otp/view/otp_view.dart';
import 'package:time_verse/features/auth/reset_password/view/reset_password.dart';
import 'package:time_verse/features/auth/signup/view/signup.dart';
import 'package:time_verse/features/lending/view/lending.dart';
import 'package:time_verse/features/qoutation/saved_qoutation/view/saved_qoutatio.dart';
import 'package:time_verse/features/settings/change_password/view/change_password.dart';
import 'package:time_verse/features/settings/delete_account/view/delete_account.dart';
import 'package:time_verse/features/settings/privacy/view/privacy.dart';
import 'package:time_verse/features/settings/profile/view/profile.dart';
import 'package:time_verse/features/settings/settings.dart';
import 'package:time_verse/features/settings/subscription/controller/subscription_controller.dart';
import 'package:time_verse/features/settings/subscription/view/subscription.dart';
import 'package:time_verse/features/settings/terms_condition/view/terms_&_condition.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: LandingScreen(), 
      ),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: Signup(), 
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: LoginPage(), 
      ),
    ),
    GoRoute(
      path: '/forgot_pass',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: ForgotPassword(), 
      ),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: OtpView(), 
      ),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: ResetPassword(), 
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: Settings(), 
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: Profile(), 
      ),
    ),
    GoRoute(
      path: '/change_password',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: ChangePassword(), 
      ),
    ),
    GoRoute(
      path: '/privacy_policy',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: Privacy(), 
      ),
    ),
    GoRoute(
      path: '/terms_and_condition',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: TermsAndCondition(), 
      ),
    ),
    GoRoute(
      path: '/delete_account',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: DeleteAccount(), 
      ),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: Subscription(controller: SubscriptionController(),), 
      ),
    ),
    GoRoute(
      path: '/saved',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: SavedQoutation(), 
      ),
    ),
    GoRoute(
      path: '/all_events',
      builder: (context, state) => ThemedBackgroundWrapper(
        child: AllEvents(), 
      ),
    ),
  ],
);
