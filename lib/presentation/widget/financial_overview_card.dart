import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final int budgetAmount;
  final int currentAmount;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.budgetAmount,
    required this.currentAmount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Budget: Rp ${budgetAmount.toString()}", style: TextStyle(color: color, fontSize: 14)),
            Text("Remaining: Rp ${currentAmount.toString()}", style: TextStyle(color: color, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
