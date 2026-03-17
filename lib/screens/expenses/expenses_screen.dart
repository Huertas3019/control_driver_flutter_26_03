
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/expense_model.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final expenses = expenseProvider.expenses;

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
        title: const Text('Movimientos y Gastos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showExpenseDialog(context, expenseProvider),
          ),
        ],
      ),
      body: expenseProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : expenses.isEmpty
              ? const Center(child: Text('No hay gastos registrados.'))
              : ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ListTile(
                        title: Text(expense.category),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(expense.description ?? 'Sin descripción'),
                            if (expense.category == 'Combustible' && expense.pricePerLiter != null)
                              Builder(
                                builder: (context) {
                                  final vehicles = context.read<VehicleProvider>().vehicles;
                                  final vehicle = vehicles.any((v) => v.id == expense.vehicleId) 
                                      ? vehicles.firstWhere((v) => v.id == expense.vehicleId)
                                      : null;
                                  
                                  if (vehicle != null && vehicle.fuelEfficiency > 0) {
                                    final pricePerKm = expense.pricePerLiter! / vehicle.fuelEfficiency;
                                    return Text(
                                      'Prec. x KM: \$${pricePerKm.toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${expense.amount.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showExpenseDialog(context, expenseProvider, expense: expense),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => expenseProvider.deleteExpense(expense.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },), 
    );
  }

  void _showExpenseDialog(BuildContext context, ExpenseProvider provider, {Expense? expense}) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(text: expense?.amount.toString());
    final descriptionController = TextEditingController(text: expense?.description);
    final odometerController = TextEditingController(text: expense?.odometer.toString());
    String? selectedCategory = expense?.category;
    final List<String> categories = ['Combustible', 'Mantenimiento', 'Seguro', 'Limpieza', 'Peajes', 'Impuestos', 'Otros'];

    // Usamos el vehicleId del provider
    final vehicleId = Provider.of<VehicleProvider>(context, listen: false).selectedVehicle?.id;

    // Variables for fuel
    final litersController = TextEditingController(text: expense?.liters?.toString() ?? '');
    bool isCashPayment = expense?.isCash ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
        title: Text(expense == null ? 'Añadir Gasto' : 'Editar Gasto'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Monto (€)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value == null || double.tryParse(value) == null ? 'Monto inválido' : null,
                ),
                TextFormField(
                  controller: odometerController,
                  decoration: const InputDecoration(labelText: 'Kilometraje'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || double.tryParse(value) == null ? 'Kilometraje inválido' : null,
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  hint: const Text('Categoría'),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Selecciona una categoría' : null,
                ),
                if (selectedCategory == 'Combustible') ...[
                  TextFormField(
                    controller: litersController,
                    decoration: const InputDecoration(labelText: 'Litros de Nafta'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value == null || double.tryParse(value) == null ? 'Ingresa litros' : null,
                  ),
                ],
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción (Opcional)'),
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
                if (vehicleId == null) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Debes seleccionar un vehículo primero.')));
                   return;
                }

                double amount = double.parse(amountController.text);
                
                // Map category to internal ExpenseType
                ExpenseType mappedType;
                switch (selectedCategory) {
                  case 'Combustible': mappedType = ExpenseType.nafta; break;
                  case 'Mantenimiento': mappedType = ExpenseType.mantenimiento; break;
                  case 'Seguro': mappedType = ExpenseType.seguro; break;
                  case 'Impuestos': mappedType = ExpenseType.impuestos; break;
                  default: mappedType = ExpenseType.otros;
                }

                double liters = (mappedType == ExpenseType.nafta) ? (double.tryParse(litersController.text) ?? 0.0) : 0.0;
                double pricePerLiter = (liters > 0) ? (amount / liters) : 0.0;

                final newExpense = Expense(
                  id: expense?.id ?? const Uuid().v4(),
                  userId: provider.userId ?? '', // Handle null userId
                  vehicleId: vehicleId,
                  amount: amount,
                  odometer: int.parse(odometerController.text),
                  category: selectedCategory!,
                  type: mappedType,
                  date: expense?.date ?? DateTime.now(),
                  description: descriptionController.text,
                  liters: liters,
                  pricePerLiter: pricePerLiter,
                  isCash: isCashPayment,
                );

                if (expense == null) {
                  provider.addExpense(newExpense);
                } else {
                  provider.updateExpense(newExpense);
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
     },
    ));
  }
}

