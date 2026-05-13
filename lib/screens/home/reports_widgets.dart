import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/income_provider.dart';

class ReportsWidgets {
  static Widget buildReports(BuildContext context, ExpenseProvider expenseProvider, IncomeProvider incomeProvider) {
    final incomes = incomeProvider.filteredIncomes;
    final expenses = expenseProvider.filteredExpenses;

    final totalExpenses = expenses.fold<double>(0, (sum, item) => sum + item.amount);
    
    final totalGrossIncome = incomes.fold<double>(
        0, (sum, item) => sum + (item.subtotalEarning ?? 0.0) + (item.extraEarning ?? 0.0));
    
    final totalEstimatedNet = incomes.fold<double>(0, (sum, item) => sum + item.totalEarning);
    
    final realBalance = totalGrossIncome - totalExpenses;

    final totalKms = incomes.fold<int>(0, (sum, item) => sum + item.kilometersDriven);

    final expenseByCategory = <String, double>{};
    for (var expense in expenses) {
      expenseByCategory.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }

    final incomeByPlatform = <String, double>{};
    for (var income in incomes) {
      if (income.isCompleted) {
        final total = (income.subtotalEarning ?? 0.0) + (income.extraEarning ?? 0.0);
        incomeByPlatform.update(income.platform, (value) => value + total, ifAbsent: () => total);
      }
    }

    return Column(
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
        expenses.isEmpty
            ? const Center(child: Text('No hay datos de gastos.'))
            : _buildPieChart(context, expenseByCategory, isIncome: false),
      ],
    );
  }

  static Widget _buildFinancialSummary(BuildContext context, double grossIncome, double expenses, double balance, double estimatedNet) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0288D1).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Resumen Financiero Real', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSummaryRow('Ingresos Brutos:', '\$${grossIncome.toStringAsFixed(2)}', const Color(0xFF81D4FA)),
          const SizedBox(height: 8),
          _buildSummaryRow('Gastos Reales:', '\$${expenses.toStringAsFixed(2)}', Colors.redAccent.shade200),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: const Color(0xFF0288D1).withValues(alpha: 0.3), thickness: 1),
          ),
          _buildSummaryRow(
            'Balance de Caja:', 
            '\$${balance.toStringAsFixed(2)}', 
            balance >= 0 ? const Color(0xFF039BE5) : Colors.orangeAccent, 
            isBold: true,
            size: 20
          ),
          const SizedBox(height: 12),
          Text(
            'Diferencia entre el dinero que entró y salió físicamente.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: const Color(0xFF0288D1).withValues(alpha: 0.3), thickness: 1),
          ),
          _buildSummaryRow('Ingreso Neto Est.:', '\$${estimatedNet.toStringAsFixed(2)}', Colors.white70),
          const SizedBox(height: 8),
          Text(
            'Ingresos menos costo de nafta estimado por KM.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget _buildPerformanceMetrics(BuildContext context, double income, double expenses, int kms) {
    final earningsPerKm = kms > 0 ? income / kms : 0.0;
    final costPerKm = kms > 0 ? expenses / kms : 0.0;
    final profitPerKm = earningsPerKm - costPerKm;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0288D1).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Rendimiento por KM', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSummaryRow('Kilómetros Totales:', '$kms km', Colors.white),
          const SizedBox(height: 8),
          _buildSummaryRow('Recaudado por KM:', '\$${earningsPerKm.toStringAsFixed(2)}', const Color(0xFF81D4FA)),
          const SizedBox(height: 8),
          _buildSummaryRow('Gasto Real por KM:', '\$${costPerKm.toStringAsFixed(2)}', Colors.redAccent.shade200),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: const Color(0xFF039BE5).withValues(alpha: 0.5), thickness: 1),
          ),
          _buildSummaryRow(
            'Ganancia por KM:', 
            '\$${profitPerKm.toStringAsFixed(2)}', 
            profitPerKm >= 0 ? const Color(0xFF039BE5) : Colors.orangeAccent, 
            isBold: true,
            size: 18
          ),
        ],
      ),
    );
  }

  static Widget _buildSummaryRow(String title, String amount, Color color, {bool isBold = false, double size = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white70, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: size - 2)),
        Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size)),
      ],
    );
  }

  static Widget _buildPieChart(BuildContext context, Map<String, double> data, {required bool isIncome}) {
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

  static Color _getColorForPlatform(String platform) {
    final colors = {
      'Uber': Colors.black87,
      'Didi': Colors.orange,
      'Cabify': Colors.deepPurple,
      'Rappi': Colors.redAccent,
      'PedidosYa': Colors.red,
    };
    return colors[platform] ?? Colors.teal;
  }

  static Color _getColorForCategory(String category) {
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
