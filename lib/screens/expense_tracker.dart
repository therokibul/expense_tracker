// lib/expense_tracker.dart
import 'package:expense_tracker/data/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Expense>('expenses').listenable(),
              builder: (context, Box<Expense> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                    child: Text('No expenses added yet!'),
                  );
                }

                return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    Expense expense = box.getAt(index)!;
                    return Card(
                      child: ListTile(
                        title: Text(expense.name),
                        subtitle: Text('৳${expense.amount.toStringAsFixed(2)}'),
                        trailing: Text(
                          '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Expense Name',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: '0.0',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final String name = _nameController.text;
                    final double? amount =
                        double.tryParse(_amountController.text);

                    if (name.isNotEmpty && amount != null) {
                      final expense = Expense(
                        name: name,
                        amount: amount,
                        date: DateTime.now(),
                      );

                      Hive.box<Expense>('expenses').add(expense);

                      _nameController.clear();
                      _amountController.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
