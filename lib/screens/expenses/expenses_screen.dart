
import 'package:flutter/material.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Gastos'),
      ),
      body: const Center(
        child: Text('Aquí se mostrará la lista de gastos.'),
      ),
    );
  }
}
