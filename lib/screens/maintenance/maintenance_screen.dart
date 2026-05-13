import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/maintenance_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/models/maintenance_model.dart';
import 'package:uuid/uuid.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    final maintenanceProvider = context.watch<MaintenanceProvider>();
    final vehicleProvider = context.watch<VehicleProvider>();
    
    final selectedVehicleId = vehicleProvider.selectedVehicle?.id;
    
    if (selectedVehicleId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mantenimiento')),
        body: const Center(child: Text('Selecciona un vehículo en Inicio primero.')),
      );
    }

    final maintenances = maintenanceProvider.maintenances
        .where((m) => m.vehicleId == selectedVehicleId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimiento'),
      ),
      body: maintenanceProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : maintenances.isEmpty
              ? const Center(child: Text('No hay mantenimientos registrados.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: maintenances.length,
                  itemBuilder: (context, index) {
                    final m = maintenances[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.build, color: Colors.blueGrey),
                        title: Text(m.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Último: ${m.lastMaintenanceKm} km | Próximo: ${m.nextDueKm} km\nIntervalo: ${m.intervalKm} km'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              tooltip: 'Editar mantenimiento',
                              onPressed: () => _showEditMaintenanceDialog(context, m, maintenanceProvider),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                              tooltip: 'Marcar como completado ahora',
                              onPressed: () => _markCompleted(context, m, maintenanceProvider),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              tooltip: 'Eliminar',
                              onPressed: () => maintenanceProvider.deleteMaintenance(m.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMaintenanceDialog(context, selectedVehicleId, maintenanceProvider),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _markCompleted(BuildContext context, Maintenance m, MaintenanceProvider mp) async {
    // Show a dialog asking for the current KM
    final kmController = TextEditingController(text: m.nextDueKm.toString());
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar Completado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¿A qué kilometraje realizaste el ${m.description}?'),
            const SizedBox(height: 16),
            TextField(
              controller: kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Kilómetros', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
        ],
      ),
    );

    if (confirmed == true && kmController.text.isNotEmpty) {
      final newKm = int.tryParse(kmController.text);
      if (newKm != null) {
        final updatedM = Maintenance(
          id: m.id,
          userId: m.userId,
          vehicleId: m.vehicleId,
          description: m.description,
          lastMaintenanceKm: newKm,
          intervalKm: m.intervalKm,
        );
        await mp.updateMaintenance(updatedM);
      }
    }
  }

  Future<void> _showAddMaintenanceDialog(BuildContext context, String vehicleId, MaintenanceProvider mp) async {
    final descController = TextEditingController();
    final lastKmController = TextEditingController();
    final intervalController = TextEditingController();
    
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Mantenimiento'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descripción (Ej. Aceite)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: intervalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Intervalo en km (Ej. 3000)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastKmController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Último cambio (km)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final m = Maintenance(
                  id: const Uuid().v4(),
                  userId: mp.userId!,
                  vehicleId: vehicleId,
                  description: descController.text,
                  lastMaintenanceKm: int.parse(lastKmController.text),
                  intervalKm: int.parse(intervalController.text),
                );
                await mp.addMaintenance(m);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditMaintenanceDialog(BuildContext context, Maintenance m, MaintenanceProvider mp) async {
    final descController = TextEditingController(text: m.description);
    final lastKmController = TextEditingController(text: m.lastMaintenanceKm.toString());
    final intervalController = TextEditingController(text: m.intervalKm.toString());
    
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Mantenimiento'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descripción (Ej. Aceite)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: intervalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Intervalo en km (Ej. 3000)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastKmController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Último cambio (km)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final updatedM = Maintenance(
                  id: m.id,
                  userId: m.userId,
                  vehicleId: m.vehicleId,
                  description: descController.text,
                  lastMaintenanceKm: int.parse(lastKmController.text),
                  intervalKm: int.parse(intervalController.text),
                );
                await mp.updateMaintenance(updatedM);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}
