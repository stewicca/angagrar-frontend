import 'package:dio/dio.dart';
import 'package:expensetracker/common/session_manager.dart';
import 'navigation.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SessionManager.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    // If 401 Unauthorized, clear session and redirect to chat (which will re-auth as guest)
    if (status == 401) {
      await SessionManager.clearSession();

      // Navigate to chat page which will trigger guest auth
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/chat_page',
        (route) => false,
      );
    }

    return super.onError(err, handler);
  }
}
