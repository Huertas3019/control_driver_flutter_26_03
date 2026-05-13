
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/expense_model.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/models/vehicle_model.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final expenses = expenseProvider.filteredExpensesWithReference;
    final selectedDate = expenseProvider.selectedDate;
    final monthName = DateFormat('MMMM yyyy', 'es').format(selectedDate);

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Movimientos y Gastos'),
            Text(
              monthName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: expenseProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : expenses.isEmpty
              ? const Center(child: Text('No hay gastos en este mes.'))
              : ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final isReference = expense.date.month != selectedDate.month || expense.date.year != selectedDate.year;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Stack(
                        children: [
                          if (isReference)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'ÚLTIMA CARGA',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // 1. Icono circular
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    expense.category == 'Combustible' ? Icons.local_gas_station_rounded :
                                    expense.category == 'Mantenimiento' ? Icons.build_rounded :
                                    expense.category == 'Seguro' ? Icons.shield_rounded : Icons.receipt_long_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // 2. Información central (Flexible)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        expense.category,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (expense.description != null && expense.description!.isNotEmpty)
                                        Text(
                                          expense.description!,
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha:0.6),
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (expense.category == 'Combustible' && expense.pricePerLiter != null)
                                        Builder(
                                          builder: (context) {
                                            final vehicle = context.read<VehicleProvider>().vehicles.cast<Vehicle?>().firstWhere(
                                              (v) => v?.id == expense.vehicleId,
                                              orElse: () => null,
                                            );
                                            
                                            if (vehicle != null && vehicle.fuelEfficiency > 0) {
                                              final pricePerKm = expense.pricePerLiter! / vehicle.fuelEfficiency;
                                              return Text(
                                                'x KM: \$${pricePerKm.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600, 
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 11,
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(width: 8),
                                
                                // 3. Monto y Acciones (Contenido a la derecha)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\$${expense.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF0288D1)),
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                          onPressed: () => _showExpenseDialog(context, expenseProvider, expense: expense),
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                          onPressed: () => expenseProvider.deleteExpense(expense.id!),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseDialog(context, expenseProvider),
        child: const Icon(Icons.add),
      ),
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
    DateTime selectedDate = expense?.date ?? DateTime.now();

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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Fecha: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', style: const TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.calendar_today_rounded, size: 20),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: litersController,
                    decoration: const InputDecoration(labelText: 'Litros de Nafta'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value == null || double.tryParse(value) == null ? 'Ingresa litros' : null,
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Monto (\$)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value == null || double.tryParse(value) == null ? 'Monto inválido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: odometerController,
                  decoration: const InputDecoration(labelText: 'Kilometraje'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || double.tryParse(value) == null ? 'Kilometraje inválido' : null,
                ),
                const SizedBox(height: 16),
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

                final currentUserId = provider.userId;
                if (currentUserId == null || currentUserId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: Usuario no identificado. No se puede guardar.')),
                  );
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
                  userId: currentUserId,
                  vehicleId: vehicleId,
                  amount: amount,
                  odometer: int.parse(odometerController.text),
                  category: selectedCategory!,
                  type: mappedType,
                  date: selectedDate,
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

