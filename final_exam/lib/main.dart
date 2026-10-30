import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ระบบคำนวณรายได้และประเมินค่าใช้จ่าย',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const IncomeCalculatorScreen(),
    );
  }
}

class IncomeCalculatorScreen extends StatefulWidget {
  const IncomeCalculatorScreen({super.key});

  @override
  State<IncomeCalculatorScreen> createState() => _IncomeCalculatorScreenState();
}

class _IncomeCalculatorScreenState extends State<IncomeCalculatorScreen> {
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _salesController = TextEditingController();

  void _calculateIncome() {
    final String salaryText = _salaryController.text.trim();
    final String salesText = _salesController.text.trim();

    final double? salary = double.tryParse(salaryText);
    final double? sales = double.tryParse(salesText);

    if (salary == null || sales == null || salary < 0 || sales < 0) {
      _showCustomAlertDialog(
        title: 'ข้อผิดพลาด',
        message: 'กรอกข้อมูลไม่ถูกต้อง/เว้นว่าง/ตัวเลขติดลบ ข้อมูลไม่ถูกต้อง ไม่สามารถคำนวณได้',
        themeColor: Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        icon: Icons.error_outline,
      );
      return;
    }

    double commissionPercent = 0.0;
    if (salary < 20000) {
      commissionPercent = 0.05;
    } else if (salary <= 50000) {
      commissionPercent = 0.08;
    } else {
      commissionPercent = 0.12;
    }
    final double commission = sales * commissionPercent;

    double bonus = 0.0;
    if (sales >= 200000) {
      bonus = 3000.0;
    }

    double extraBonus = 0.0;
    if (salary > 50000 && sales >= 300000) {
      extraBonus = 5000.0;
    }

    final double totalIncome = salary + commission + bonus + extraBonus;

    Color themeColor;
    Color backgroundColor;
    IconData icon;
    String performanceLevel;

    if (totalIncome < 30000) {
      themeColor = Colors.deepOrange.shade700;
      backgroundColor = Colors.orange.shade50;
      icon = Icons.workspace_premium_outlined;
      performanceLevel = 'ระดับบรอนซ์ (Bronze)';
    } else if (totalIncome <= 70000) {
      themeColor = Colors.blue.shade800;
      backgroundColor = Colors.blue.shade50;
      icon = Icons.workspace_premium;
      performanceLevel = 'ระดับเงิน (Silver)';
    } else {
      themeColor = Colors.green.shade800;
      backgroundColor = Colors.green.shade50;
      icon = Icons.stars_rounded;
      performanceLevel = 'ระดับทอง (Gold)';
    }

    String calculationDetail = 'ระดับผลงาน: $performanceLevel\n\n'
        'เงินเดือน: ${salary.toStringAsFixed(0)} บาท\n'
        'ค่าคอมมิชชัน (${(commissionPercent * 100).toInt()}%): ${commission.toStringAsFixed(0)} บาท\n'
        'โบนัสพิเศษ: ${bonus.toStringAsFixed(0)} บาท';

    if (extraBonus > 0) {
      calculationDetail += '\nเงินพิเศษเพิ่มเติม: ${extraBonus.toStringAsFixed(0)} บาท';
    }

    calculationDetail += '\n\nรวมรายได้สุทธิ: ${totalIncome.toStringAsFixed(0)} บาท';

    _showCustomAlertDialog(
      title: 'ผลการคำนวณรายได้',
      message: calculationDetail,
      themeColor: themeColor,
      backgroundColor: backgroundColor,
      icon: icon,
    );
  }

  void _showCustomAlertDialog({
    required String title,
    required String message,
    required Color themeColor,
    required Color backgroundColor,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: themeColor, width: 2),
          ),
          backgroundColor: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 50, color: themeColor),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: themeColor.withOpacity(0.9),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'ตกลง',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _salesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 1: คำนวณรายได้(016830641014-8 ศุภณัฐ)'),
        backgroundColor: Colors.indigo.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'ไปหน้าถัดไป (ประเมินค่าใช้จ่าย)',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExpenseEvaluationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'คำนวณเงินเดือน + ค่าคอมมิชชัน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _salaryController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'ฐานเงินเดือน (บาท)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _salesController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'ยอดขายรวม (บาท)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.point_of_sale_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _calculateIncome,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text(
                    'คำนวณรายได้',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpenseEvaluationScreen extends StatefulWidget {
  const ExpenseEvaluationScreen({super.key});

  @override
  State<ExpenseEvaluationScreen> createState() => _ExpenseEvaluationScreenState();
}

class _ExpenseEvaluationScreenState extends State<ExpenseEvaluationScreen> {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();

  void _evaluateExpenses() {
    final double? income = double.tryParse(_incomeController.text.trim());
    final double? expense = double.tryParse(_expenseController.text.trim());

    if (income == null || expense == null || income <= 0 || expense < 0) {
      _showDialogAlert(
        title: 'ข้อผิดพลาด',
        message: 'กรอกข้อมูลไม่ถูกต้อง/เว้นว่าง/ตัวเลขติดลบ',
        themeColor: Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        icon: Icons.error_outline,
      );
      return;
    }

    final double percentage = (expense / income) * 100;

    if (percentage <= 50) {
      _showDialogAlert(
        title: 'ประเมินเยี่ยม',
        message: 'ค่าใช้จ่ายคิดเป็น ${percentage.toStringAsFixed(1)}% ของรายได้\nเยี่ยมมาก! คุณบริหารจัดการเงินได้ดีและมีเงินออมเหลือ',
        themeColor: Colors.green.shade800,
        backgroundColor: Colors.green.shade50,
        icon: Icons.sentiment_very_satisfied,
      );
    } else {
      _showDialogAlert(
        title: 'คำเตือน',
        message: 'ค่าใช้จ่ายคิดเป็น ${percentage.toStringAsFixed(1)}% ของรายได้\nควรวางแผนการเงินใหม่และควบคุมค่าใช้จ่ายโดยด่วน',
        themeColor: Colors.deepOrange.shade700,
        backgroundColor: Colors.orange.shade50,
        icon: Icons.warning_amber_rounded,
      );
    }
  }

  void _showDialogAlert({
    required String title,
    required String message,
    required Color themeColor,
    required Color backgroundColor,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: themeColor, width: 2),
          ),
          backgroundColor: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 50, color: themeColor),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: themeColor.withOpacity(0.9),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('ปิด'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 2: ประเมินค่าใช้จ่าย'),
        backgroundColor: Colors.teal.shade100,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'ประเมินสัดส่วนค่าใช้จ่ายประจำเดือน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _incomeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'รายได้สุทธิ (บาท)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _expenseController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'ค่าใช้จ่ายรวม (บาท)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_cart_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _evaluateExpenses,
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text(
                    'ประเมินค่าใช้จ่าย',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}