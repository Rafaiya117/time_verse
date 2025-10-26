import 'package:go_router/go_router.dart';
import 'package:time_verse/core/theme/theme_background_wrapper.dart';
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
  ],
);
