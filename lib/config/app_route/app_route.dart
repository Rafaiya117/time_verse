import 'package:go_router/go_router.dart';
import 'package:time_verse/core/theme/theme_background_wrapper.dart';
import 'package:time_verse/features/auth/forgot_passowrd/view/forgot_password.dart';
import 'package:time_verse/features/auth/login/view/login.dart';
import 'package:time_verse/features/auth/otp/view/otp_view.dart';
import 'package:time_verse/features/auth/reset_password/view/reset_password.dart';
import 'package:time_verse/features/auth/signup/view/signup.dart';
import 'package:time_verse/features/lending/view/lending.dart';

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
  ],
);
