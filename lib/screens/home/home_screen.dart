
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/models/vehicle_model.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    // Data is now fetched in the providers' constructors.
    // No need to call fetch methods here initially.
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final incomeProvider = context.watch<IncomeProvider>();

    if (selectedVehicle == null && vehicleProvider.vehicles.isNotEmpty) {
      selectedVehicle = vehicleProvider.vehicles.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Control'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildActiveWorkdayCard(incomeProvider),
              const SizedBox(height: 16),
              _buildVehicleSelector(vehicleProvider),
              const SizedBox(height: 16),
              _buildFuelPrompt(context, vehicleProvider, context.watch<ExpenseProvider>()),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              _buildFinancialOverview(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // We call the fetch methods directly. They will notify their listeners.
    context.read<VehicleProvider>().fetchVehicles();
    context.read<ExpenseProvider>().fetchExpenses();
    context.read<IncomeProvider>().fetchIncomes();

    // Add a small delay for a better user experience with the refresh indicator.
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget _buildVehicleSelector(VehicleProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.vehicles.isEmpty) {
      return Card(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.directions_car, size: 48, color: Colors.blueGrey),
              const SizedBox(height: 8),
              const Text('Para comenzar, debes registrar tu primer vehículo.', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Agregar Vehículo'),
                onPressed: () => context.push('/vehicles'),
              ),
            ],
          ),
        ),
      );
    }

    return DropdownButtonFormField<Vehicle>(
      key: ValueKey(selectedVehicle),
      initialValue: selectedVehicle,
      onChanged: (Vehicle? newValue) {
        setState(() {
          selectedVehicle = newValue;
          provider.setSelectedVehicleId(newValue?.id ?? '');
        });
      },
      items: provider.vehicles.map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
        return DropdownMenuItem<Vehicle>(
          value: vehicle,
          child: Text('${vehicle.brand} ${vehicle.model}'),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Vehículo Seleccionado',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildFuelPrompt(BuildContext context, VehicleProvider vehicleProvider, ExpenseProvider expenseProvider) {
    if (selectedVehicle == null || vehicleProvider.vehicles.isEmpty) return const SizedBox.shrink();

    final latestFuel = expenseProvider.getLatestFuelExpense(selectedVehicle!.id!);
    if (latestFuel != null) return const SizedBox.shrink();

    return Card(
      color: Colors.orange.shade50,
      child: ListTile(
        leading: const Icon(Icons.local_gas_station, color: Colors.orange),
        title: const Text('Falta Gasto de Nafta'),
        subtitle: const Text('Añade un gasto de nafta para calcular el precio por KM de este vehículo.'),
        trailing: ElevatedButton(
          onPressed: () => context.push('/expenses'),
          child: const Text('Añadir'),
        ),
      ),
    );
  }

  Widget _buildActiveWorkdayCard(IncomeProvider provider) {
    if (provider.isLoading) return const SizedBox.shrink();
    
    final activeIncomes = provider.incomes.where((i) => !i.isCompleted);
    if (activeIncomes.isEmpty) return const SizedBox.shrink();

    final activeIncome = activeIncomes.first;

    return Card(
      color: Colors.lightGreen.shade50,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_fill, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Jornada Activa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Plataforma: ${activeIncome.platform}', style: const TextStyle(fontSize: 16)),
            Text('Km Inicial: ${activeIncome.initialOdometer} km', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () => context.push('/incomes'),
              child: const Text('Ir a Finalizar'),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildFinancialOverview() {
    return Consumer2<ExpenseProvider, IncomeProvider>(
      builder: (context, expenseProvider, incomeProvider, child) {
        final totalExpenses = expenseProvider.expenses.fold<double>(0, (sum, item) => sum + item.amount);
        // Sum subtotal and extra earnings to get actual cash income, ignoring daily theoretical fuel costs
        final totalIncome = incomeProvider.incomes.fold<double>(
            0, (sum, item) => sum + (item.subtotalEarning ?? 0.0) + (item.extraEarning ?? 0.0));
        final netProfit = totalIncome - totalExpenses;

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Resumen del Mes', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                _buildFinancialRow('Ingresos', '${totalIncome.toStringAsFixed(2)} €', Colors.green),
                const SizedBox(height: 8),
                _buildFinancialRow('Gastos', '${totalExpenses.toStringAsFixed(2)} €', Colors.red),
                const Divider(height: 20, thickness: 1),
                _buildFinancialRow('Balance', '${netProfit.toStringAsFixed(2)} €', netProfit >= 0 ? Colors.blue : Colors.orange, isLarge: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFinancialRow(String title, String amount, Color color, {bool isLarge = false}) {
    final style = TextStyle(
      fontSize: isLarge ? 20 : 16,
      fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(amount, style: style.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
