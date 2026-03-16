
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/providers/platform_provider.dart';
import 'package:myapp/models/vehicle_model.dart';
import 'package:myapp/models/platform_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Vehicle? selectedVehicle;
  Platform? selectedPlatform;

  @override
  void initState() {
    super.initState();
    // Data is now fetched in the providers' constructors.
    // No need to call fetch methods here initially.
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final platformProvider = context.watch<PlatformProvider>();

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
              _buildVehicleSelector(vehicleProvider),
              const SizedBox(height: 16),
              _buildPlatformSelector(platformProvider),
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
    context.read<PlatformProvider>().fetchPlatforms();
    context.read<ExpenseProvider>().fetchExpenses();
    context.read<IncomeProvider>().fetchIncomes();

    // Add a small delay for a better user experience with the refresh indicator.
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget _buildVehicleSelector(VehicleProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.vehicles.isEmpty) return const Center(child: Text('No hay vehículos.'));

    return DropdownButtonFormField<Vehicle>(
      key: ValueKey(selectedVehicle),
      initialValue: selectedVehicle,
      onChanged: (Vehicle? newValue) {
        setState(() {
          selectedVehicle = newValue;
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

  Widget _buildPlatformSelector(PlatformProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());

    return DropdownButtonFormField<Platform>(
      key: ValueKey(selectedPlatform),
      initialValue: selectedPlatform,
      onChanged: (Platform? newValue) {
        setState(() {
          selectedPlatform = newValue;
        });
      },
      items: provider.platforms.map<DropdownMenuItem<Platform>>((Platform platform) {
        return DropdownMenuItem<Platform>(
          value: platform,
          child: Text(platform.name),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Plataforma (Opcional)',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Consumer2<ExpenseProvider, IncomeProvider>(
      builder: (context, expenseProvider, incomeProvider, child) {
        final totalExpenses = expenseProvider.expenses.fold<double>(0, (sum, item) => sum + item.amount);
        final totalIncome = incomeProvider.incomes.fold<double>(0, (sum, item) => sum + item.totalEarning);
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
