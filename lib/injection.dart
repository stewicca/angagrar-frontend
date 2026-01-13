import 'package:dio/dio.dart';
import 'package:expensetracker/presentation/bloc/auth/me/me_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/guest_auth/guest_auth_bloc.dart';
import 'package:expensetracker/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:expensetracker/presentation/bloc/budget/budgets_bloc.dart';
import 'package:expensetracker/presentation/bloc/category/categories_bloc.dart';
import 'package:expensetracker/presentation/bloc/expense/expenses_bloc.dart';
import 'package:expensetracker/presentation/bloc/transaction/transactions_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'common/auth_interceptor.dart';
import 'common/logging_interceptor.dart';
import 'data/repository/auth_repository_impl.dart';
import 'data/repository/conversation_repository_impl.dart';
import 'data/repository/budgets_repository_impl.dart';
import 'data/repository/categories_repository_impl.dart';
import 'data/repository/expenses_repository_impl.dart';
import 'data/repository/transactions_repository_impl.dart';
import 'data/repository/users_repository_impl.dart';
import 'data/source/remote/auth_remote_data_source.dart';
import 'data/source/remote/conversation_remote_data_source.dart';
import 'data/source/remote/budgets_remote_data_source.dart';
import 'data/source/remote/categories_remote_data_source.dart';
import 'data/source/remote/expenses_remote_data_source.dart';
import 'data/source/remote/transactions_remote_data_source.dart';
import 'data/source/remote/users_remote_data_source.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/repository/conversation_repository.dart';
import 'domain/repository/budgets_repository.dart';
import 'domain/repository/categories_repository.dart';
import 'domain/repository/expenses_repository.dart';
import 'domain/repository/transactions_repository.dart';
import 'domain/repository/users_repository.dart';

final locator = GetIt.instance;

void initializeDependencies() {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(AuthInterceptor(dio));
  dio.interceptors.add(LoggingInterceptor());

  locator.registerLazySingleton<Dio>(() => dio);

  // Data Sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<ConversationRemoteDataSource>(
    () => ConversationRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<BudgetsRemoteDataSource>(
    () => BudgetsRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<ExpensesRemoteDataSource>(
    () => ExpensesRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<TransactionsRemoteDataSource>(
    () => TransactionsRemoteDataSourceImpl(dio: locator()),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<BudgetsRepository>(
    () => BudgetsRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(remoteDataSource: locator()),
  );

  // BLoCs
  locator.registerFactory<MeBloc>(() => MeBloc(locator()));
  locator.registerFactory<GuestAuthBloc>(() => GuestAuthBloc(locator()));
  locator.registerFactory<ConversationBloc>(() => ConversationBloc(locator()));
  locator.registerFactory<BudgetsBloc>(() => BudgetsBloc(locator()));
  locator.registerFactory<CategoriesBloc>(() => CategoriesBloc(locator()));
  locator.registerFactory<ExpensesBloc>(() => ExpensesBloc(locator()));
  locator.registerFactory<TransactionsBloc>(() => TransactionsBloc(locator()));
}
