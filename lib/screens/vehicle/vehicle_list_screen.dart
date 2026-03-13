import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart'; // Corrected import
import '../../providers/vehicle_provider.dart';
import '../../models/vehicle_model.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch vehicles as soon as the screen is initialized
    // We use listen: false because we are in initState
    final authService = Provider.of<AuthService>(
      context,
      listen: false,
    ); // Corrected to AuthService
    if (authService.user != null) {
      Provider.of<VehicleProvider>(
        context,
        listen: false,
      ).fetchVehicles(authService.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the add/edit screen in 'add' mode
              context.go('/vehicles/add');
            },
            tooltip: 'Añadir Vehículo',
          ),
        ],
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, vehicleProvider, child) {
          if (vehicleProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vehicleProvider.vehicles.isEmpty) {
            return const Center(
              child: Text(
                'No tienes vehículos registrados.\n¡Añade uno nuevo!',
                textAlign: TextAlign.center,
              ),
            );
          }

          // If we have vehicles, display them in a list
          return ListView.builder(
            itemCount: vehicleProvider.vehicles.length,
            itemBuilder: (context, index) {
              final Vehicle vehicle = vehicleProvider.vehicles[index];
              return ListTile(
                title: Text(
                  vehicle.nickname ?? '${vehicle.brand} ${vehicle.model}',
                ),
                subtitle: Text('${vehicle.licensePlate} - ${vehicle.year}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the add/edit screen in 'edit' mode
                  context.go('/vehicles/edit/${vehicle.id}', extra: vehicle);
                },
              );
            },
          );
        },
      ),
    );
  }
}
