import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/income_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
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
        title: const Text('Informes y Estadísticas'),
      ),
      body: (expenseProvider.isLoading || incomeProvider.isLoading)
          ? const Center(child: CircularProgressIndicator())
          : _buildReports(context, expenseProvider, incomeProvider),
    );
  }

  Widget _buildReports(BuildContext context, ExpenseProvider expenseProvider, IncomeProvider incomeProvider) {
    final totalExpenses = expenseProvider.expenses.fold<double>(0, (sum, item) => sum + item.amount);
    
    // Theoretical estimated fuel cost from journeys
    // final totalEstimatedFuel = incomeProvider.incomes.fold<double>(0, (sum, item) => sum + item.fuelCostForDay);
    
    // Gross income (what's actually received from platforms + extras)
    final totalGrossIncome = incomeProvider.incomes.fold<double>(
        0, (sum, item) => sum + (item.subtotalEarning ?? 0.0) + (item.extraEarning ?? 0.0));
    
    // Estimated Net Income (Gross - Theoretical Fuel)
    final totalEstimatedNet = incomeProvider.incomes.fold<double>(0, (sum, item) => sum + item.totalEarning);
    
    // Real Cash Balance (Gross - Real Expenses)
    final realBalance = totalGrossIncome - totalExpenses;

    final totalKms = incomeProvider.incomes.fold<int>(0, (sum, item) => sum + item.kilometersDriven);

    final expenseByCategory = <String, double>{};
    for (var expense in expenseProvider.expenses) {
      expenseByCategory.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }

    final incomeByPlatform = <String, double>{};
    for (var income in incomeProvider.incomes) {
      if (income.isCompleted) {
        final total = (income.subtotalEarning ?? 0.0) + (income.extraEarning ?? 0.0);
        incomeByPlatform.update(income.platform, (value) => value + total, ifAbsent: () => total);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFinancialSummary(context, totalGrossIncome, totalExpenses, realBalance, totalEstimatedNet),
          const SizedBox(height: 24),
          _buildPerformanceMetrics(context, totalGrossIncome, totalExpenses, totalKms),
          const SizedBox(height: 24),
          Text('Distribución de Ingresos por Plataforma', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          incomeByPlatform.isEmpty
              ? const Center(child: Text('No hay datos de ingresos.'))
              : _buildPieChart(context, incomeByPlatform, isIncome: true),
          const SizedBox(height: 24),
          Text('Distribución de Gastos Reales', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          expenseProvider.expenses.isEmpty
              ? const Center(child: Text('No hay datos de gastos.'))
              : _buildPieChart(context, expenseByCategory, isIncome: false),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context, double grossIncome, double expenses, double balance, double estimatedNet) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Resumen Financiero Real', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildSummaryRow('Ingresos Brutos:', '\$${grossIncome.toStringAsFixed(2)}', Colors.green),
            _buildSummaryRow('Gastos Reales:', '\$${expenses.toStringAsFixed(2)}', Colors.red),
            const Divider(height: 20, thickness: 1),
            _buildSummaryRow('Balance de Caja:', '\$${balance.toStringAsFixed(2)}', balance >= 0 ? Colors.blue : Colors.orange, isBold: true),
            const SizedBox(height: 10),
            Text(
              'Este balance es la diferencia entre el dinero que entró y el que salió físicamente.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Divider(height: 24),
            _buildSummaryRow('Ingreso Neto Est.:', '\$${estimatedNet.toStringAsFixed(2)}', Colors.blueGrey),
            Text(
              'Cálculo basado en ingresos menos costo de nafta estimado por KM.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context, double income, double expenses, int kms) {
    final earningsPerKm = kms > 0 ? income / kms : 0.0;
    final costPerKm = kms > 0 ? expenses / kms : 0.0;
    final profitPerKm = earningsPerKm - costPerKm;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Rendimiento por KM', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildSummaryRow('Kilómetros Totales:', '$kms km', Colors.grey),
            _buildSummaryRow('Recaudado por KM:', '\$${earningsPerKm.toStringAsFixed(2)}', Colors.green),
            _buildSummaryRow('Gasto Real por KM:', '\$${costPerKm.toStringAsFixed(2)}', Colors.red),
            const Divider(),
            _buildSummaryRow('Ganancia por KM:', '\$${profitPerKm.toStringAsFixed(2)}', profitPerKm >= 0 ? Colors.blue : Colors.orange, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
        Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, double> data, {required bool isIncome}) {
    final total = data.values.fold(0.0, (a, b) => a + b);

    final List<PieChartSectionData> sections = data.entries.map((entry) {
      final fontSize = 14.0;
      final radius = 60.0;
      final color = isIncome ? _getColorForPlatform(entry.key) : _getColorForCategory(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: total > 0 ? '${(entry.value / total * 100).toStringAsFixed(0)}%' : '0%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: data.keys.map((key) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: isIncome ? _getColorForPlatform(key) : _getColorForCategory(key)),
                const SizedBox(width: 4),
                Text(key, style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorForPlatform(String platform) {
    final colors = {
      'Uber': Colors.black87,
      'Didi': Colors.orange,
      'Cabify': Colors.deepPurple,
      'Rappi': Colors.redAccent,
      'PedidosYa': Colors.red,
    };
    return colors[platform] ?? Colors.teal;
  }

  Color _getColorForCategory(String category) {
    final colors = {
      'Combustible': Colors.orange,
      'Mantenimiento': Colors.blue,
      'Seguro': Colors.purple,
      'Limpieza': Colors.green,
      'Peajes': Colors.red,
      'Otros': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }
}
