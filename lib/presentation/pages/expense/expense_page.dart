import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import '../../bloc/category/categories_bloc.dart';
import '../../bloc/expense/expenses_bloc.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  static const ROUTE_NAME = '/expense_page';

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpensesBloc>().add(const FetchExpenses());
    context.read<CategoriesBloc>().add(const FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<ExpensesBloc, ExpensesState>(
        builder: (context, state) {
          Widget content;
          if (state is ExpensesLoading) {
            content = const Center(child: CircularProgressIndicator());
          } else if (state is ExpensesLoadSuccess) {
            final expenses = state.expenses.expenses;
            content = expenses.isEmpty
                ? const Center(child: Text('No expenses'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ListTile(
                        title: Text(expense.category),
                        subtitle: Text(expense.description ?? '-'),
                        trailing: Text('Rp ${expense.amount}'),
                      );
                    },
                  );
          } else if (state is ExpensesError) {
            content = Center(child: Text(state.message));
          } else {
            content = const SizedBox.shrink();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: _showAddExpenseDialog,
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }

  void _showAddExpenseDialog() {
    final formKey = GlobalKey<FormBuilderState>();
    final descController = TextEditingController();
    final totalController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ExpensesBloc>(),
          child: BlocListener<ExpensesBloc, ExpensesState>(
            listener: (context, state) {
              if (state is ExpenseAddSuccess) {
                Navigator.pop(dialogContext);
                context.read<ExpensesBloc>().add(const FetchExpenses());
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Expense added',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.lightGreen,
                  ),
                );
              }

              if (state is ExpensesError) {
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<ExpensesBloc, ExpensesState>(
              builder: (context, expenseState) {
                final isLoading = expenseState is ExpensesLoading;
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FormBuilder(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Add Expense',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<CategoriesBloc, CategoriesState>(
                            builder: (context, catState) {
                              if (catState is CategoriesLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (catState is CategoriesSuccess) {
                                final categories =
                                    catState.categories.categories;
                                return FormBuilderDropdown<String>(
                                  name: 'category',
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.required(),
                                  items: categories
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.name,
                                          child: Text(e.label),
                                        ),
                                      )
                                      .toList(),
                                );
                              }
                              if (catState is CategoriesError) {
                                return Text(catState.message);
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'desc',
                            controller: descController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'total',
                            controller: totalController,
                            decoration: const InputDecoration(
                              labelText: 'Total',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
                              FormBuilderValidators.min(1000),
                            ]),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (formKey.currentState
                                                ?.saveAndValidate() ??
                                            false) {
                                          final values =
                                              formKey.currentState!.value;
                                          final category =
                                              values['category'] as String;
                                          final desc = descController.text;
                                          final total =
                                              int.tryParse(
                                                totalController.text,
                                              ) ??
                                              0;
                                          context.read<ExpensesBloc>().add(
                                            AddExpense(
                                              category: category,
                                              description: desc.isEmpty
                                                  ? null
                                                  : desc,
                                              amount: total,
                                            ),
                                          );
                                        }
                                      },
                                child: isLoading
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
