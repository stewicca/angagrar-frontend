import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensetracker/common/session_manager.dart';
import '../../../domain/entity/conversation/conversation.dart';
import '../../../domain/entity/conversation/conversation_history.dart';
import '../../../domain/entity/conversation/conversation_response.dart';
import '../../../domain/repository/conversation_repository.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository _repository;

  ConversationBloc(this._repository) : super(ConversationInitial()) {
    on<StartConversation>((event, emit) async {
      emit(ConversationLoading());

      final result = await _repository.startConversation();

      await result.fold(
        (failure) async {
          emit(ConversationError(message: failure.message));
        },
        (conversation) async {
          // Persist session_id
          await SessionManager.saveSessionId(conversation.sessionId);

          emit(ConversationStarted(conversation: conversation));
        },
      );
    });

    on<SendMessage>((event, emit) async {
      emit(MessageSending());

      final result = await _repository.sendMessage(
        sessionId: event.sessionId,
        message: event.message,
      );

      await result.fold(
        (failure) async {
          emit(ConversationError(message: failure.message));
        },
        (response) async {
          if (response.completed && response.budgetGenerated == true) {
            // Mark conversation as completed
            await SessionManager.setConversationCompleted(true);
            emit(ConversationCompleted(response: response));
          } else {
            emit(MessageReceived(response: response));
          }
        },
      );
    });

    on<LoadConversationHistory>((event, emit) async {
      emit(ConversationLoading());

      final result = await _repository.getHistory(event.sessionId);

      result.fold(
        (failure) => emit(ConversationError(message: failure.message)),
        (history) => emit(ConversationHistoryLoaded(history: history)),
      );
    });

    on<ResetConversation>((event, emit) async {
      emit(ConversationLoading());

      final result = await _repository.resetConversation(event.sessionId);

      await result.fold(
        (failure) async {
          emit(ConversationError(message: failure.message));
        },
        (conversation) async {
          // Update session_id and reset completion status
          await SessionManager.saveSessionId(conversation.sessionId);
          await SessionManager.setConversationCompleted(false);

          emit(ConversationStarted(conversation: conversation));
        },
      );
    });
  }
}
