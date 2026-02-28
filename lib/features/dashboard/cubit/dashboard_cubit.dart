import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Map<String, dynamic> metrics;
  final List<dynamic> recentActivity; // Mixing latest topups, apps for MVP

  const DashboardLoaded({required this.metrics, required this.recentActivity});

  @override
  List<Object?> get props => [metrics, recentActivity];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardMetricsUseCase metricsUseCase;

  DashboardCubit({required this.metricsUseCase}) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final metrics = await metricsUseCase.execute();

      // For MVP, we'll fetch just a mix of pending items.
      final mApps = await metricsUseCase.repository.getMerchantApps();
      final topups = await metricsUseCase.repository.getTopups();
      final cWithdraws = await metricsUseCase.repository
          .getCreatorWithdrawals();

      List<dynamic> recent = [];
      recent.addAll(topups.where((e) => e.status == 'Pending').take(3));
      recent.addAll(cWithdraws.where((e) => e.status == 'Pending').take(3));
      recent.addAll(mApps.where((e) => e.status == 'Pending').take(3));

      emit(DashboardLoaded(metrics: metrics, recentActivity: recent));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
