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
    final totalIncome = incomeProvider.incomes.fold<double>(0, (sum, item) => sum + item.totalEarning);
    final netProfit = totalIncome - totalExpenses;

    final expenseByCategory = <String, double>{};
    for (var expense in expenseProvider.expenses) {
      expenseByCategory.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFinancialSummary(context, totalIncome, totalExpenses, netProfit),
          const SizedBox(height: 24),
          Text('Distribución de Gastos', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          expenseProvider.expenses.isEmpty
              ? const Center(child: Text('No hay datos de gastos para mostrar.'))
              : _buildPieChart(context, expenseByCategory),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context, double income, double expenses, double profit) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Resumen Financiero', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildSummaryRow('Ingresos Totales:', '${income.toStringAsFixed(2)} €', Colors.green),
            const SizedBox(height: 8),
            _buildSummaryRow('Gastos Totales:', '${expenses.toStringAsFixed(2)} €', Colors.red),
            const Divider(height: 20, thickness: 1),
            _buildSummaryRow('Beneficio Neto:', '${profit.toStringAsFixed(2)} €', profit >= 0 ? Colors.blue : Colors.orange, isBold: true),
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

  Widget _buildPieChart(BuildContext context, Map<String, double> data) {
    final total = data.values.fold(0.0, (a, b) => a + b);

    final List<PieChartSectionData> sections = data.entries.map((entry) {
      final fontSize = 16.0;
      final radius = 50.0;
      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: entry.value,
        title: total > 0 ? '${(entry.value / total * 100).toStringAsFixed(0)}%' : '0%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: sections,
          borderData: FlBorderData(show: false),
          sectionsSpace: 4,
          centerSpaceRadius: 40,
        ),
      ),
    );
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
