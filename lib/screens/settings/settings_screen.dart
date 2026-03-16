
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          ListTile(
            title: const Text('Vehículos'),
            leading: const Icon(Icons.directions_car),
            onTap: () => context.go('/vehicles'),
          ),
          ListTile(
            title: const Text('Plataformas'),
            leading: const Icon(Icons.workspaces_outline),
            onTap: () => context.go('/platforms'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            secondary: Icon(
              themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Cerrar Sesión'),
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
    );
  }
}
