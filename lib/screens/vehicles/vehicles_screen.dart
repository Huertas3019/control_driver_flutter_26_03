
import 'package:flutter/material.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
      ),
      body: const Center(
        child: Text('Aquí se mostrará la lista de vehículos.'),
      ),
    );
  }
}
