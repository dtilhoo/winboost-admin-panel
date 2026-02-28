import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class MessagingModerationState extends Equatable {
  const MessagingModerationState();
  @override
  List<Object?> get props => [];
}

class MessagingModerationInitial extends MessagingModerationState {}

class MessagingModerationLoading extends MessagingModerationState {}

class MessagingModerationLoaded extends MessagingModerationState {
  final List<MessageThread> threads;

  const MessagingModerationLoaded({required this.threads});

  @override
  List<Object?> get props => [threads];
}

class MessagingModerationError extends MessagingModerationState {
  final String message;
  const MessagingModerationError(this.message);
  @override
  List<Object?> get props => [message];
}

class MessagingModerationCubit extends Cubit<MessagingModerationState> {
  final ManageMessagesUseCase messagesUseCase;

  MessagingModerationCubit({required this.messagesUseCase})
    : super(MessagingModerationInitial());

  Future<void> load() async {
    emit(MessagingModerationLoading());
    try {
      final threads = await messagesUseCase.getMessageThreads();
      emit(MessagingModerationLoaded(threads: threads));
    } catch (e) {
      emit(MessagingModerationError(e.toString()));
    }
  }
}
