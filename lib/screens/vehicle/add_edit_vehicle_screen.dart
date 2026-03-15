import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_model.dart';
import '../../services/auth_service.dart';
import '../../providers/vehicle_provider.dart';

class AddEditVehicleScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const AddEditVehicleScreen({super.key, this.vehicle});

  @override
  State<AddEditVehicleScreen> createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _licensePlateController;
  late TextEditingController _nicknameController;
  late TextEditingController _fuelEfficiencyController;

  bool get _isEditMode => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.vehicle?.brand ?? '');
    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _yearController = TextEditingController(text: widget.vehicle?.year.toString() ?? '');
    _licensePlateController = TextEditingController(text: widget.vehicle?.licensePlate ?? '');
    _nicknameController = TextEditingController(text: widget.vehicle?.nickname ?? '');
    _fuelEfficiencyController = TextEditingController(text: widget.vehicle?.fuelEfficiency.toString() ?? '');
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    _nicknameController.dispose();
    _fuelEfficiencyController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final authService = context.read<AuthService>();
      final vehicleProvider = context.read<VehicleProvider>();
      final userId = authService.user?.uid;

      if (userId == null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Error: No se pudo identificar al usuario.')),
        );
        return;
      }
      
      final fuelEfficiency = double.tryParse(_fuelEfficiencyController.text) ?? 0.0;

      if (_isEditMode) {
        final updatedVehicle = widget.vehicle!.copyWith(
          brand: _brandController.text,
          model: _modelController.text,
          year: int.parse(_yearController.text),
          licensePlate: _licensePlateController.text,
          nickname: _nicknameController.text,
          fuelEfficiency: fuelEfficiency,
        );
        await vehicleProvider.updateVehicle(updatedVehicle);
      } else {
        await vehicleProvider.addVehicle(
          userId: userId,
          brand: _brandController.text,
          model: _modelController.text,
          year: int.parse(_yearController.text),
          licensePlate: _licensePlateController.text,
          nickname: _nicknameController.text,
          fuelEfficiency: fuelEfficiency,
        );
      }
      
      if(mounted) Navigator.of(context).pop();

    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error al guardar el vehículo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Vehículo' : 'Añadir Vehículo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Guardar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) => value!.isEmpty ? 'Por favor, introduce la marca' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) => value!.isEmpty ? 'Por favor, introduce el modelo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || int.tryParse(value) == null
                    ? 'Por favor, introduce un año válido'
                    : null,
              ),
              const SizedBox(height: 16),
               TextFormField(
                controller: _fuelEfficiencyController,
                decoration: const InputDecoration(labelText: 'Rendimiento (Km/L)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty || double.tryParse(value) == null
                    ? 'Por favor, introduce un rendimiento válido'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(labelText: 'Matrícula'),
                validator: (value) => value!.isEmpty ? 'Por favor, introduce la matrícula' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Apodo (opcional)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
