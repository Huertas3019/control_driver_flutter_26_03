
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/vehicle_model.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:uuid/uuid.dart';

class VehicleManagementScreen extends StatelessWidget {
  const VehicleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final vehicles = vehicleProvider.vehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showVehicleDialog(context, vehicleProvider),
          ),
        ],
      ),
      body: vehicleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vehicles.isEmpty
              ? const Center(child: Text('No tienes vehículos registrados.'))
              : ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ListTile(
                        title: Text('${vehicle.brand} ${vehicle.model}'),
                        subtitle: Text('Patente: ${vehicle.plate}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showVehicleDialog(context, vehicleProvider, vehicle: vehicle),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => vehicleProvider.deleteVehicle(vehicle.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },), 
    );
  }

  void _showVehicleDialog(BuildContext context, VehicleProvider provider, {Vehicle? vehicle}) {
    final formKey = GlobalKey<FormState>();
    final brandController = TextEditingController(text: vehicle?.brand);
    final modelController = TextEditingController(text: vehicle?.model);
    final yearController = TextEditingController(text: vehicle?.year.toString());
    final plateController = TextEditingController(text: vehicle?.plate);
    final odometerController = TextEditingController(text: vehicle?.initialOdometer.toString());
    final fuelEfficiencyController = TextEditingController(text: vehicle?.fuelEfficiency.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(vehicle == null ? 'Añadir Vehículo' : 'Editar Vehículo'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: yearController,
                  decoration: const InputDecoration(labelText: 'Año'),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || int.tryParse(value) == null) ? 'Año inválido' : null,
                ),
                TextFormField(
                  controller: plateController,
                  decoration: const InputDecoration(labelText: 'Patente'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: odometerController,
                  decoration: const InputDecoration(labelText: 'Odómetro (km)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || int.tryParse(value) == null) ? 'Odómetro inválido' : null,
                ),
                 TextFormField(
                  controller: fuelEfficiencyController,
                  decoration: const InputDecoration(labelText: 'Rendimiento (km/L)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => (value == null || double.tryParse(value) == null) ? 'Rendimiento inválido' : null,
                ),                
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final currentUserId = provider.userId;
                if (currentUserId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: Usuario no identificado. No se puede guardar.')),
                  );
                  return;
                }

                final newVehicle = Vehicle(
                  id: vehicle?.id ?? const Uuid().v4(),
                  userId: currentUserId,
                  brand: brandController.text,
                  model: modelController.text,
                  year: int.parse(yearController.text),
                  plate: plateController.text,
                  initialOdometer: int.parse(odometerController.text),
                  fuelEfficiency: double.parse(fuelEfficiencyController.text),
                  createdAt: vehicle?.createdAt ?? DateTime.now(),
                );

                if (vehicle == null) {
                  provider.addVehicle(newVehicle);
                } else {
                  provider.updateVehicle(newVehicle);
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
