import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entity/user/user.dart';
import '../../../../domain/repository/auth_repository.dart';

part 'me_event.dart';
part 'me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  final AuthRepository _authRepositoryImpl;

  MeBloc(this._authRepositoryImpl) : super(MeInitial()) {
    on<FetchMe>((event, emit) async {
      emit(MeLoading());

      final result = await _authRepositoryImpl.me();

      result.fold((l) => emit(MeError(message: l.message)), (r) => emit(MeSuccess(me: r)));
    });
  }
}
