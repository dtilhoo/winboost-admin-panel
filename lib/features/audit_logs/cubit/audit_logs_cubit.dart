import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class AuditLogsState extends Equatable {
  const AuditLogsState();
  @override
  List<Object?> get props => [];
}

class AuditLogsInitial extends AuditLogsState {}

class AuditLogsLoading extends AuditLogsState {}

class AuditLogsLoaded extends AuditLogsState {
  final List<LogItem> logs;

  const AuditLogsLoaded({required this.logs});

  @override
  List<Object?> get props => [logs];
}

class AuditLogsError extends AuditLogsState {
  final String message;
  const AuditLogsError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuditLogsCubit extends Cubit<AuditLogsState> {
  final GetLogsUseCase logsUseCase;

  AuditLogsCubit({required this.logsUseCase}) : super(AuditLogsInitial());

  Future<void> load() async {
    emit(AuditLogsLoading());
    try {
      final logs = await logsUseCase.getLogs();
      emit(AuditLogsLoaded(logs: logs));
    } catch (e) {
      emit(AuditLogsError(e.toString()));
    }
  }
}
