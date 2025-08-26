import 'package:go_router/go_router.dart';
import 'package:frontend_app/screens/auth_screen.dart';
import 'package:frontend_app/screens/home_screen.dart';
import 'package:frontend_app/screens/error_screen.dart';
import 'package:frontend_app/screens/register_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/auth',
    // redirect: (context, GoRouterState state) {},
    routes: [
      GoRoute(
        name: 'auth',
        path: '/auth',
        builder: (context, state) {
          return AuthScreen();
        },
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}
