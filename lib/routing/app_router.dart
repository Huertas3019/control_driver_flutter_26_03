
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/expenses/expenses_screen.dart';
import 'package:myapp/screens/platforms/platform_management_screen.dart';
import '../services/auth_service.dart';
import '../providers/vehicle_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/vehicles/vehicle_management_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter getRouter(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);

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

        // If the user is logged in, check if they have a vehicle
        if (loggedIn && (vehicleProvider.vehicles.isEmpty)) {
            vehicleProvider.fetchVehicles(); // ensure the list is up to date
        }

        final hasVehicle = vehicleProvider.vehicles.isNotEmpty;

        // If logged in and trying to go to login/register, redirect to home
        if (isLoggingIn) {
          return '/';
        }

        // If logged in but has no vehicle, force to add_vehicle screen
        if (!hasVehicle && state.matchedLocation != '/add-vehicle') {
            return '/add-vehicle';
        }

        // If logged in, has a vehicle, but is on the add_vehicle screen, go home
        if(hasVehicle && state.matchedLocation == '/add-vehicle'){
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
              path: '/expenses',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ExpensesScreen(),
              ),
            ),            
            GoRoute(
              path: '/reports',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ReportsScreen(),
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
