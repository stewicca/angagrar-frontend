import 'package:expensetracker/domain/entity/budget/budget.dart';
import 'package:expensetracker/presentation/bloc/auth/me/me_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/guest_auth/guest_auth_bloc.dart';
import 'package:expensetracker/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:expensetracker/presentation/bloc/budget/budgets_bloc.dart';
import 'package:expensetracker/presentation/bloc/category/categories_bloc.dart';
import 'package:expensetracker/presentation/bloc/expense/expenses_bloc.dart';
import 'package:expensetracker/presentation/bloc/transaction/transactions_bloc.dart';
import 'package:expensetracker/presentation/pages/auth/welcome_page.dart';
import 'package:expensetracker/presentation/pages/conversation/chat_page.dart';
import 'package:expensetracker/presentation/pages/conversation/budget_loading_page.dart';
import 'package:expensetracker/presentation/pages/budget/budget_result_page.dart';
import 'package:expensetracker/presentation/pages/splash/splash_page.dart';
import 'package:expensetracker/presentation/pages/expense/expense_page.dart';
import 'package:expensetracker/presentation/pages/home/home_page.dart';
import 'package:expensetracker/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'common/navigation.dart';
import 'injection.dart' as di;

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  di.initializeDependencies();
  runApp(const MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GuestAuthBloc>(
          create: (context) => di.locator<GuestAuthBloc>(),
        ),
        BlocProvider<ConversationBloc>(
          create: (context) => di.locator<ConversationBloc>(),
        ),
        BlocProvider<MeBloc>(create: (context) => di.locator<MeBloc>()),
        BlocProvider<BudgetsBloc>(
          create: (context) => di.locator<BudgetsBloc>(),
        ),
        BlocProvider<CategoriesBloc>(
          create: (context) => di.locator<CategoriesBloc>(),
        ),
        BlocProvider<ExpensesBloc>(
          create: (context) => di.locator<ExpensesBloc>(),
        ),
        BlocProvider<TransactionsBloc>(
          create: (context) => di.locator<TransactionsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Angagrar',
        navigatorObservers: [routeObserver],
        navigatorKey: navigatorKey,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: SplashPage.ROUTE_NAME,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case SplashPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (context) => const SplashPage(),
              );

            case WelcomePage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (context) => const WelcomePage(),
              );

            case ChatPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (context) => const ChatPage());

            case '/budget_loading_page':
              return MaterialPageRoute(
                builder: (context) => BudgetLoadingPage(
                  budgets: settings.arguments as List<Budget>?,
                ),
              );

            case '/budget_result_page':
              return MaterialPageRoute(
                builder: (context) => BudgetResultPage(
                  initialBudgets: settings.arguments as List<Budget>?,
                ),
              );

            case '/main_page':
              return MaterialPageRoute(builder: (context) => MainPage());

            case '/home_page':
              return MaterialPageRoute(builder: (context) => HomePage());

            case '/expense_page':
              return MaterialPageRoute(builder: (context) => ExpensePage());

            default:
              return MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
