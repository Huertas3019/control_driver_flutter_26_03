
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../services/auth_service.dart';

import '../screens/expenses/expenses_screen.dart';
import '../screens/vehicles/vehicles_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final rootNavigatorKey = GlobalKey<NavigatorState>();

    return GoRouter(
      initialLocation: '/', // Start at the root
      navigatorKey: rootNavigatorKey,
      refreshListenable: authService, // Re-route when auth state changes

      routes: <RouteBase>[
        // Auth routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpScreen(),
        ),

        // Main application shell
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            // Branch for the Expenses tab
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/', // Root of the shell
                  builder: (context, state) => const ExpensesScreen(),
                ),
              ],
            ),

            // Branch for the Vehicles tab
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/vehicles',
                  builder: (context, state) => const VehiclesScreen(),
                ),
              ],
            ),

            // Branch for the Settings tab
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],

      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authService.user != null;
        final String location = state.uri.toString();
        final bool onAuthRoute = location == '/login' || location == '/signup';

        // If not logged in and not on an auth route, redirect to login
        if (!loggedIn && !onAuthRoute) {
          return '/login';
        }

        // If logged in and on an auth route, redirect to the main screen
        if (loggedIn && onAuthRoute) {
          return '/';
        }

        // No redirect needed
        return null;
      },
    );
  }
}
