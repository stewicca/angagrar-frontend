part of 'me_bloc.dart';

sealed class MeState extends Equatable {
  const MeState();

  @override
  List<Object> get props => [];
}

class MeInitial extends MeState {}

class MeLoading extends MeState {}

class MeSuccess extends MeState {
  final User me;

  const MeSuccess({ required this.me });
}

class MeError extends MeState {
  final String message;

  const MeError({ required this.message });
}
