import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/income_model.dart';
import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/providers/platform_provider.dart';
import 'package:uuid/uuid.dart';

class IncomesScreen extends StatelessWidget {
  const IncomesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incomeProvider = context.watch<IncomeProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresos y Jornadas')),
      body: incomeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : incomeProvider.incomes.isEmpty
              ? const Center(child: Text('No hay ingresos registrados.'))
              : ListView.builder(
                  itemCount: incomeProvider.incomes.length,
                  itemBuilder: (context, index) {
                    final income = incomeProvider.incomes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.attach_money)),
                        title: Text('${income.platform} - \$${income.totalEarning.toStringAsFixed(2)}'),
                        subtitle: Text('${income.date.day}/${income.date.month}/${income.date.year} | Kms: ${income.kilometersDriven}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
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
    final initialOdometerCtrl = TextEditingController(text: income?.initialOdometer.toString());
    final finalOdometerCtrl = TextEditingController(text: income?.finalOdometer.toString());
    final subtotalCtrl = TextEditingController(text: income?.subtotalEarning.toString());
    final extraEarningCtrl = TextEditingController(text: income?.extraEarning?.toString());
    final fuelCostCtrl = TextEditingController(text: income?.fuelCostForDay.toString());
    String? selectedPlatform = income?.platform;

    final vehicleId = Provider.of<VehicleProvider>(context, listen: false).selectedVehicle?.id;
    final platforms = Provider.of<PlatformProvider>(context, listen: false).platforms;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(income == null ? 'Registrar Jornada' : 'Editar Jornada'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedPlatform,
                  hint: const Text('Plataforma (Uber, Didi, etc.)'),
                  items: platforms.map((p) => DropdownMenuItem(value: p.name, child: Text(p.name))).toList(),
                  onChanged: (value) => selectedPlatform = value,
                  validator: (value) => value == null ? 'Selecciona una plataforma' : null,
                ),
                 TextFormField(
                  controller: initialOdometerCtrl,
                  decoration: const InputDecoration(labelText: 'Odómetro Inicial (kms)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || int.tryParse(value) == null ? 'Valor inválido' : null,
                ),
                TextFormField(
                  controller: finalOdometerCtrl,
                  decoration: const InputDecoration(labelText: 'Odómetro Final (kms)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || int.tryParse(value) == null ? 'Valor inválido' : null,
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
                final finalOdo = int.parse(finalOdometerCtrl.text);
                final subtotal = double.parse(subtotalCtrl.text);
                final extra = double.tryParse(extraEarningCtrl.text) ?? 0.0;
                final fuel = double.tryParse(fuelCostCtrl.text) ?? 0.0;
                
                final total = subtotal + extra;
                final kms = finalOdo - initOdo;

                final newIncome = Income(
                  id: income?.id ?? const Uuid().v4(),
                  userId: provider.userId ?? '',
                  vehicleId: vehicleId,
                  platform: selectedPlatform!,
                  date: income?.date ?? DateTime.now(),
                  initialOdometer: initOdo,
                  finalOdometer: finalOdo,
                  subtotalEarning: subtotal,
                  extraEarning: extra,
                  fuelCostForDay: fuel,
                  kilometersDriven: kms > 0 ? kms : 0,
                  totalEarning: total,
                );

                if (income == null) {
                  provider.addIncome(newIncome);
                } else {
                  provider.updateIncome(newIncome);
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
