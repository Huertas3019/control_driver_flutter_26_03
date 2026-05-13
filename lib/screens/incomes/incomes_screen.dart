import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/income_model.dart';
import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/providers/platform_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class IncomesScreen extends StatelessWidget {
  const IncomesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incomeProvider = context.watch<IncomeProvider>();
    final incomes = incomeProvider.filteredIncomes;
    final monthName = DateFormat('MMMM yyyy', 'es').format(incomeProvider.selectedDate);

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
            const Text('Ingresos y Jornadas'),
            Text(
              monthName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: incomeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : incomes.isEmpty
              ? const Center(child: Text('No hay ingresos en este mes.'))
              : ListView.builder(
                  itemCount: incomes.length,
                  itemBuilder: (context, index) {
                    final income = incomes[index];
                    final isCompleted = income.isCompleted;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isCompleted ? const Color(0xFF039BE5).withValues(alpha:0.3) : Colors.amber.withValues(alpha:0.3)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCompleted ? const Color(0xFF039BE5).withValues(alpha:0.15) : Colors.amber.withValues(alpha:0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCompleted ? Icons.check_circle_rounded : Icons.timer_rounded,
                              color: isCompleted ? const Color(0xFF039BE5) : Colors.amber,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            isCompleted 
                              ? '${income.platform} - Bruto: \$${((income.subtotalEarning ?? 0) + (income.extraEarning ?? 0)).toStringAsFixed(2)}'
                              : '${income.platform} - En curso',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                               if (isCompleted) Text('Neto: \$${income.totalEarning.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('${income.date.day}/${income.date.month}/${income.date.year}${isCompleted ? ' | Kms: ${income.kilometersDriven} | Nafta: \$${income.fuelCostForDay.toStringAsFixed(2)}' : ' | Inició: ${income.initialOdometer}km'}', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha:0.7), fontSize: 13)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isCompleted)
                                IconButton(
                                  icon: const Icon(Icons.flag_rounded, color: Colors.amber),
                                  tooltip: 'Finalizar Jornada',
                                  onPressed: () => _showIncomeDialog(context, incomeProvider, income: income),
                                ),
                              if (isCompleted)
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: Color(0xFF0288D1)),
                                  tooltip: 'Editar',
                                  onPressed: () => _showIncomeDialog(context, incomeProvider, income: income),
                                ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                tooltip: 'Eliminar',
                                onPressed: () => _confirmDelete(context, incomeProvider, income),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final hasActive = incomeProvider.filteredIncomes.any((i) => !i.isCompleted);
          if (hasActive) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ya tienes una jornada en curso. Finalízala antes de iniciar otra.'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
          _showIncomeDialog(context, incomeProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, IncomeProvider provider, Income income) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este ingreso? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteIncome(income.id!);
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
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
    String? selectedPlatform = income?.platform;

    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    final selectedVehicle = vehicleProvider.selectedVehicle;
    final vehicleId = selectedVehicle?.id;
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final platforms = Provider.of<PlatformProvider>(context, listen: false).platforms;

    DateTime selectedDate = income?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(income == null 
                ? 'Iniciar Jornada' 
                : (isCompleting ? 'Finalizar Jornada' : 'Editar Jornada')),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            content: SizedBox(
              width: double.maxFinite,
              child: Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
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
                    const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: subtotalCtrl,
                            decoration: const InputDecoration(labelText: 'Subtotal Recaudado'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Ingresa el subtotal';
                              final cleanValue = value.replaceAll(',', '.');
                              if (double.tryParse(cleanValue) == null) return 'Monto inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: extraEarningCtrl,
                            decoration: const InputDecoration(labelText: 'Ingresos Extra / Propinas'),
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
                
                final currentUserId = provider.userId;
                if (currentUserId == null || currentUserId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: Usuario no identificado. No se puede guardar.')),
                  );
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
                  // Iniciando jornada (Paso 1)
                  completed = false;
                } else {
                  // Finalizando jornada (Paso 2) o Editando
                  // Usamos parse directo asumiendo que el validator ya los filtró
                  // y limpiamos posibles comas por puntos
                  final odoText = finalOdometerCtrl.text.trim();
                  final subText = subtotalCtrl.text.trim().replaceAll(',', '.');
                  final extraText = extraEarningCtrl.text.trim().replaceAll(',', '.');

                  finalOdo = int.tryParse(odoText);
                  subtotal = double.tryParse(subText);
                  extra = double.tryParse(extraText) ?? 0.0;
                  
                  if (finalOdo != null && subtotal != null) {
                    kms = finalOdo - initOdo;
                    
                    // Auto-calcular gasto teórico de combustible
                    if (selectedVehicle != null) {
                      final latestFuel = expenseProvider.getLatestFuelExpense(selectedVehicle.id!);
                      if (latestFuel != null && latestFuel.pricePerLiter != null && latestFuel.pricePerLiter! > 0) {
                        double pricePerKm = latestFuel.pricePerLiter! / selectedVehicle.fuelEfficiency;
                        fuel = (kms > 0 ? kms : 0) * pricePerKm;
                      }
                    }
                    
                    // Ganancia total neta (Ingresos - Gastos teóricos)
                    total = (subtotal + extra) - fuel;
                    
                    // IMPORTANTE: Si estamos en modo completion o ya estaba completado, forzar true
                    completed = isCompleting || income.isCompleted;
                  } else {
                    // Si no es completion (solo edición de inicio), mantener estado
                    completed = income.isCompleted;
                  }
                }

                final newIncome = Income(
                  id: income?.id ?? const Uuid().v4(),
                  userId: currentUserId,
                  vehicleId: vehicleId,
                  platform: selectedPlatform ?? income!.platform,
                  date: selectedDate,
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
                  provider.addIncome(newIncome).catchError((e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                    }
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jornada iniciada con éxito')));
                  }
                } else {
                  provider.updateIncome(newIncome);
                  if (isCompleting && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Jornada finalizada y balance calculado'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(income == null ? 'Iniciar' : (isCompleting ? 'Finalizar' : 'Guardar')),
          ),
        ],
      );
    }),
  );
}
}
