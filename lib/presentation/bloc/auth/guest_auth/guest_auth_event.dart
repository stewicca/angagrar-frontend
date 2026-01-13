part of 'guest_auth_bloc.dart';

sealed class GuestAuthEvent extends Equatable {
  const GuestAuthEvent();
}

class AuthenticateAsGuest extends GuestAuthEvent {
  const AuthenticateAsGuest();

  @override
  List<Object?> get props => [];
}

class CheckExistingAuth extends GuestAuthEvent {
  const CheckExistingAuth();

  @override
  List<Object?> get props => [];
}
