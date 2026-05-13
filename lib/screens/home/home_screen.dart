
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/vehicle_provider.dart';
import 'package:myapp/models/vehicle_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/providers/maintenance_provider.dart';
import 'package:myapp/screens/home/reports_widgets.dart';

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
              _buildMaintenanceAlerts(context, vehicleProvider, incomeProvider, context.watch<ExpenseProvider>(), context.watch<MaintenanceProvider>()),
              const SizedBox(height: 16),
              _buildActiveWorkdayCard(incomeProvider),
              const SizedBox(height: 16),
              _buildVehicleSelector(vehicleProvider),
              const SizedBox(height: 16),
              _buildFuelPrompt(context, vehicleProvider, context.watch<ExpenseProvider>()),
              const SizedBox(height: 24),
              _buildFinancialOverview(),
              const SizedBox(height: 24),
              ReportsWidgets.buildReports(context, context.watch<ExpenseProvider>(), incomeProvider),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(Icons.directions_car_rounded, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha:0.5)),
              const SizedBox(height: 16),
              const Text(
                '¡Bienvenido! Comienza registrando tu primer vehículo para llevar el control.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
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

    return Card(
      child: DropdownButtonFormField<Vehicle>(
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
        decoration: InputDecoration(
          labelText: 'Vehículo Seleccionado',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: Icon(Icons.local_taxi_rounded, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildFuelPrompt(BuildContext context, VehicleProvider vehicleProvider, ExpenseProvider expenseProvider) {
    if (selectedVehicle == null || vehicleProvider.vehicles.isEmpty) return const SizedBox.shrink();

    final latestFuel = expenseProvider.getLatestFuelExpense(selectedVehicle!.id!);
    if (latestFuel != null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha:0.2)),
      ),
      child: ListTile(
        leading: Icon(Icons.local_gas_station_rounded, color: Theme.of(context).colorScheme.primary, size: 32),
        title: Text('Falta Gasto de Nafta', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer)),
        subtitle: Text('Añade un gasto para calcular rendimiento.', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha:0.7))),
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

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0288D1), Color(0xFF01579B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withValues(alpha:0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                const Text('Jornada Activa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Plataforma: ${activeIncome.platform}', style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Text('Km Inicial: ${activeIncome.initialOdometer} km', style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha:0.9))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF01579B),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => context.push('/incomes'),
                child: const Text('Ir a Finalizar Jornada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Consumer2<ExpenseProvider, IncomeProvider>(
      builder: (context, expenseProvider, incomeProvider, child) {
        final totalExpenses = expenseProvider.filteredExpenses.fold<double>(0, (sum, item) => sum + item.amount);
        // Sum subtotal and extra earnings to get actual cash income
        final totalIncome = incomeProvider.filteredIncomes.fold<double>(
            0, (sum, item) => sum + (item.subtotalEarning ?? 0.0) + (item.extraEarning ?? 0.0));
        final netProfit = totalIncome - totalExpenses;

        final monthName = DateFormat('MMMM yyyy', 'es').format(incomeProvider.selectedDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Resumen de $monthName', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () => _selectMonth(context, incomeProvider, expenseProvider),
                  tooltip: 'Cambiar Mes',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildValueCard('Ingresos Brutos', totalIncome, const Color(0xFF81D4FA), Icons.arrow_upward)),
                const SizedBox(width: 12),
                Expanded(child: _buildValueCard('Gastos Reales', totalExpenses, Colors.redAccent.shade200, Icons.arrow_downward)),
              ],
            ),
            const SizedBox(height: 12),
            _buildBalanceCard(netProfit),
          ],
        );
      },
    );
  }

  int _getCurrentOdometer(IncomeProvider ip, ExpenseProvider ep, String vehicleId) {
    int maxIn = ip.incomes.where((i) => i.vehicleId == vehicleId && i.finalOdometer != null)
        .fold(0, (max, i) => i.finalOdometer! > max ? i.finalOdometer! : max);
    
    // Also check initialOdometer as it might be higher if a workday is active
    int maxInInit = ip.incomes.where((i) => i.vehicleId == vehicleId)
        .fold(0, (max, i) => i.initialOdometer > max ? i.initialOdometer : max);
        
    int maxEx = ep.expenses.where((e) => e.vehicleId == vehicleId)
        .fold(0, (max, e) => e.odometer > max ? e.odometer : max);
        
    int maxAll = maxIn > maxEx ? maxIn : maxEx;
    return maxAll > maxInInit ? maxAll : maxInInit;
  }

  Widget _buildMaintenanceAlerts(BuildContext context, VehicleProvider vp, IncomeProvider ip, ExpenseProvider ep, MaintenanceProvider mp) {
    if (selectedVehicle == null || vp.vehicles.isEmpty) return const SizedBox.shrink();

    final currentOdometer = _getCurrentOdometer(ip, ep, selectedVehicle!.id!);
    if (currentOdometer == 0) return const SizedBox.shrink(); // No data yet

    final vehicleMaintenances = mp.maintenances.where((m) => m.vehicleId == selectedVehicle!.id!).toList();
    if (vehicleMaintenances.isEmpty) return const SizedBox.shrink();

    List<Widget> alertCards = [];

    for (var m in vehicleMaintenances) {
      final nextDue = m.nextDueKm;
      final diff = nextDue - currentOdometer;

      if (diff <= 100) {
        final isOverdue = diff < 0;
        alertCards.add(
          Card(
            color: isOverdue ? Colors.red.shade900 : Colors.orange.shade800,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
              title: Text(
                '${m.description} ${isOverdue ? 'Vencido' : 'Próximo'}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                isOverdue 
                    ? 'Te pasaste por ${diff.abs()} km (Toca a los $nextDue km)'
                    : 'Faltan $diff km (Toca a los $nextDue km)',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: isOverdue ? Colors.red.shade900 : Colors.orange.shade800,
                ),
                onPressed: () => context.push('/maintenance'),
                child: const Text('Ver'),
              ),
            ),
          )
        );
      }
    }

    if (alertCards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Alertas de Mantenimiento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...alertCards,
      ],
    );
  }

  Widget _buildValueCard(String title, double amount, Color accentColor, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(title, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha:0.7), fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 8),
            Text('\$${amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double netProfit) {
    final isPositive = netProfit >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive 
              ? [const Color(0xFF039BE5), const Color(0xFF01579B)] 
              : [Colors.orange.shade800, Colors.deepOrange.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPositive ? const Color(0xFF039BE5) : Colors.orange).withValues(alpha:0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Balance de Caja', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text('\$${netProfit.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(isPositive ? Icons.account_balance_wallet : Icons.money_off, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Future<void> _selectMonth(BuildContext context, IncomeProvider incomeProvider, ExpenseProvider expenseProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: incomeProvider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      helpText: 'Seleccionar Mes',
    );
    if (picked != null) {
      incomeProvider.updateFilter(picked);
      expenseProvider.updateFilter(picked);
    }
  }
}
