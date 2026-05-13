
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/expenses/expenses_screen.dart';
import 'package:myapp/screens/incomes/incomes_screen.dart';
import 'package:myapp/screens/platforms/platform_management_screen.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/vehicles/vehicle_management_screen.dart';
import '../screens/maintenance/maintenance_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter getRouter(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/' ,
      refreshListenable: authService,
      redirect: (BuildContext context, GoRouterState state) async {
        final bool loggedIn = authService.user != null;
        final bool isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (!loggedIn) {
          return isLoggingIn ? null : '/login';
        }

        // If logged in and trying to go to login/register, redirect to home
        if (isLoggingIn) {
          return '/';
        }

        return null; // No redirect needed
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/add-vehicle',
          builder: (context, state) => const VehicleManagementScreen(),
        ), 
        GoRoute(
          path: '/vehicles',
          builder: (context, state) => const VehicleManagementScreen(),
        ),  
        GoRoute(
          path: '/platforms',
          builder: (context, state) => const PlatformManagementScreen(),
        ),                        
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: '/' ,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
            GoRoute(
              path: '/incomes',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: IncomesScreen(),
              ),
            ),
            GoRoute(
              path: '/expenses',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ExpensesScreen(),
              ),
            ),            
            GoRoute(
              path: '/maintenance',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: MaintenanceScreen(),
              ),
            ),
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsScreen(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
