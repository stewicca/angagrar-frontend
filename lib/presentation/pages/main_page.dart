import 'package:expensetracker/presentation/pages/expense/expense_page.dart';
import 'package:flutter/material.dart';
import 'home/home_page.dart';

class MainPage extends StatefulWidget {
  static const ROUTE_NAME = '/main_page';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return HomePage();

      case 1:
        return ExpensePage();

      default:
        return HomePage();
    }
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Expense'),
      ],
    );
  }
}
