import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/entity/auth/auth.dart';
import '../../../../domain/repository/auth_repository.dart';

part 'guest_auth_event.dart';
part 'guest_auth_state.dart';

class GuestAuthBloc extends Bloc<GuestAuthEvent, GuestAuthState> {
  final AuthRepository _authRepository;

  GuestAuthBloc(this._authRepository) : super(GuestAuthInitial()) {
    on<CheckExistingAuth>((event, emit) async {
      emit(GuestAuthLoading());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        emit(AlreadyAuthenticated(token: token));
      } else {
        add(const AuthenticateAsGuest());
      }
    });

    on<AuthenticateAsGuest>((event, emit) async {
      emit(GuestAuthLoading());

      final result = await _authRepository.createGuestUser();

      await result.fold(
        (failure) async {
          emit(GuestAuthError(message: failure.message));
        },
        (auth) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (auth.token != null) {
            await prefs.setString('token', auth.token!);
          }
          emit(GuestAuthSuccess(auth: auth));
        },
      );
    });
  }
}
