import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class InAppNotificationsState extends Equatable {
  const InAppNotificationsState();
  @override
  List<Object?> get props => [];
}

class InAppNotificationsInitial extends InAppNotificationsState {}

class InAppNotificationsLoading extends InAppNotificationsState {}

class InAppNotificationsLoaded extends InAppNotificationsState {
  final List<NotificationModel> notifications;

  const InAppNotificationsLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class InAppNotificationsError extends InAppNotificationsState {
  final String message;
  const InAppNotificationsError(this.message);
  @override
  List<Object?> get props => [message];
}

class InAppNotificationsCubit extends Cubit<InAppNotificationsState> {
  final ManageNotificationsUseCase notificationsUseCase;

  InAppNotificationsCubit({required this.notificationsUseCase})
    : super(InAppNotificationsInitial());

  Future<void> load() async {
    emit(InAppNotificationsLoading());
    try {
      final notifications = await notificationsUseCase.getNotifications();
      emit(InAppNotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(InAppNotificationsError(e.toString()));
    }
  }

  Future<void> sendNotification(
    String title,
    String channel,
    String audience,
    String content,
  ) async {
    await notificationsUseCase.addNotification(
      title,
      channel,
      audience,
      content,
    );
    await load();
  }
}
