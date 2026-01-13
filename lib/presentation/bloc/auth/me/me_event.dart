part of 'me_bloc.dart';

sealed class MeEvent extends Equatable {
  const MeEvent();
}

class FetchMe extends MeEvent {
  const FetchMe();

  @override
  List<Object?> get props => [];
}
