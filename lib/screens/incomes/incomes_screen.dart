import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/income_model.dart';
import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/providers/platform_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class IncomesScreen extends StatelessWidget {
  const IncomesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incomeProvider = context.watch<IncomeProvider>();
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
        title: const Text('Ingresos y Jornadas'),
      ),
      body: incomeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : incomeProvider.incomes.isEmpty
              ? const Center(child: Text('No hay ingresos registrados.'))
              : ListView.builder(
                  itemCount: incomeProvider.incomes.length,
                  itemBuilder: (context, index) {
                    final income = incomeProvider.incomes[index];
                    final isCompleted = income.isCompleted;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
                          child: Icon(
                            isCompleted ? Icons.check_circle : Icons.timer,
                            color: isCompleted ? Colors.green : Colors.orange,
                          ),
                        ),
                        title: Text('${income.platform} - ${isCompleted ? '\$${income.totalEarning.toStringAsFixed(2)}' : 'En curso'}'),
                        subtitle: Text('${income.date.day}/${income.date.month}/${income.date.year}${isCompleted ? ' | Kms: ${income.kilometersDriven}' : ' | Inició: ${income.initialOdometer}km'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                isCompleted ? Icons.edit : Icons.flag,
                                color: isCompleted ? Colors.blue : Colors.orange,
                              ),
                              tooltip: isCompleted ? 'Editar' : 'Finalizar Jornada',
                              onPressed: () => _showIncomeDialog(context, incomeProvider, income: income),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => incomeProvider.deleteIncome(income.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showIncomeDialog(context, incomeProvider),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showIncomeDialog(BuildContext context, IncomeProvider provider, {Income? income}) {
    final formKey = GlobalKey<FormState>();
    final isEditing = income != null;
    final isCompleting = isEditing && !income.isCompleted;

    final initialOdometerCtrl = TextEditingController(text: income?.initialOdometer.toString());
    final finalOdometerCtrl = TextEditingController(text: isCompleting ? '' : income?.finalOdometer?.toString());
    final subtotalCtrl = TextEditingController(text: isCompleting ? '' : income?.subtotalEarning?.toString());
    final extraEarningCtrl = TextEditingController(text: income?.extraEarning?.toString());
    final fuelCostCtrl = TextEditingController(text: income?.fuelCostForDay.toString());
    String? selectedPlatform = income?.platform;

    final vehicleId = Provider.of<VehicleProvider>(context, listen: false).selectedVehicle?.id;
    final platforms = Provider.of<PlatformProvider>(context, listen: false).platforms;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(income == null 
            ? 'Iniciar Jornada' 
            : (isCompleting ? 'Finalizar Jornada' : 'Editar Jornada')),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isEditing)
                  DropdownButtonFormField<String>(
                    initialValue: selectedPlatform,
                    hint: const Text('Plataforma (Uber, Didi, etc.)'),
                    items: platforms.map((p) => DropdownMenuItem(value: p.name, child: Text(p.name))).toList(),
                    onChanged: (value) => selectedPlatform = value,
                    validator: (value) => value == null ? 'Selecciona una plataforma' : null,
                  ),
                if (isEditing)
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 8.0),
                     child: Text('Plataforma: ${income.platform}', style: const TextStyle(fontWeight: FontWeight.bold)),
                   ),
                TextFormField(
                  controller: initialOdometerCtrl,
                  decoration: const InputDecoration(labelText: 'Odómetro Inicial (kms)'),
                  keyboardType: TextInputType.number,
                  enabled: !isEditing, // No permitir cambiar odo inicial al finalizar
                  validator: (value) => value == null || int.tryParse(value) == null ? 'Valor inválido' : null,
                ),
                if (income == null || income.isCompleted || isCompleting) ...[
                  if (income != null) // Solo mostrar campos finales si estamos editando/finalizando
                    ...[
                      TextFormField(
                        controller: finalOdometerCtrl,
                        decoration: const InputDecoration(labelText: 'Odómetro Final (kms)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || int.tryParse(value) == null) return 'Valor inválido';
                          if (int.parse(value) <= int.parse(initialOdometerCtrl.text)) return 'Debe ser mayor al inicial';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: subtotalCtrl,
                        decoration: const InputDecoration(labelText: 'Subtotal Recaudado'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || double.tryParse(value) == null ? 'Valor inválido' : null,
                      ),
                      TextFormField(
                        controller: extraEarningCtrl,
                        decoration: const InputDecoration(labelText: 'Ingresos Extra / Propinas'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      TextFormField(
                        controller: fuelCostCtrl,
                        decoration: const InputDecoration(labelText: 'Gasto de Combustible Diario (Opcional)'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ]
                ],
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
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Debes seleccionar un vehículo en Inicio primero.')));
                   return;
                }
                
                final initOdo = int.parse(initialOdometerCtrl.text);
                
                // Si es solo inicio, los valores finales son nulos/0
                int? finalOdo;
                double? subtotal;
                double extra = 0.0;
                double fuel = 0.0;
                double total = 0.0;
                int kms = 0;
                bool completed = income?.isCompleted ?? false;

                if (income == null) {
                  // Iniciando jornada
                  completed = false;
                } else {
                  // Finalizando o Editando
                  finalOdo = int.parse(finalOdometerCtrl.text);
                  subtotal = double.parse(subtotalCtrl.text);
                  extra = double.tryParse(extraEarningCtrl.text) ?? 0.0;
                  fuel = double.tryParse(fuelCostCtrl.text) ?? 0.0;
                  total = subtotal + extra;
                  kms = finalOdo - initOdo;
                  completed = true;
                }

                final newIncome = Income(
                  id: income?.id ?? const Uuid().v4(),
                  userId: provider.userId ?? '',
                  vehicleId: vehicleId,
                  platform: selectedPlatform ?? income!.platform,
                  date: income?.date ?? DateTime.now(),
                  initialOdometer: initOdo,
                  finalOdometer: finalOdo,
                  subtotalEarning: subtotal,
                  extraEarning: extra,
                  fuelCostForDay: fuel,
                  kilometersDriven: kms > 0 ? kms : 0,
                  totalEarning: total,
                  isCompleted: completed,
                );

                if (income == null) {
                  provider.addIncome(newIncome);
                } else {
                  provider.updateIncome(newIncome);
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(income == null ? 'Iniciar' : 'Guardar'),
          ),
        ],
      ),
    );
  }
}
