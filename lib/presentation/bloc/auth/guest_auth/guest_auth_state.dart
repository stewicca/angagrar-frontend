part of 'guest_auth_bloc.dart';

sealed class GuestAuthState extends Equatable {
  const GuestAuthState();
}

class GuestAuthInitial extends GuestAuthState {
  @override
  List<Object> get props => [];
}

class GuestAuthLoading extends GuestAuthState {
  @override
  List<Object> get props => [];
}

class GuestAuthSuccess extends GuestAuthState {
  final Auth auth;

  const GuestAuthSuccess({required this.auth});

  @override
  List<Object> get props => [auth];
}

class AlreadyAuthenticated extends GuestAuthState {
  final String token;

  const AlreadyAuthenticated({required this.token});

  @override
  List<Object> get props => [token];
}

class GuestAuthError extends GuestAuthState {
  final String message;

  const GuestAuthError({required this.message});

  @override
  List<Object> get props => [message];
}
