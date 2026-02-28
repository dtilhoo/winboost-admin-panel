import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class MerchantCountersState extends Equatable {
  const MerchantCountersState();
  @override
  List<Object?> get props => [];
}

class MerchantCountersInitial extends MerchantCountersState {}

class MerchantCountersLoading extends MerchantCountersState {}

class MerchantCountersLoaded extends MerchantCountersState {
  final List<MerchantCounter> counters;

  const MerchantCountersLoaded({required this.counters});

  @override
  List<Object?> get props => [counters];
}

class MerchantCountersError extends MerchantCountersState {
  final String message;
  const MerchantCountersError(this.message);
  @override
  List<Object?> get props => [message];
}

class MerchantCountersCubit extends Cubit<MerchantCountersState> {
  final ManageCountersUseCase countersUseCase;

  MerchantCountersCubit({required this.countersUseCase})
    : super(MerchantCountersInitial());

  Future<void> load() async {
    emit(MerchantCountersLoading());
    try {
      final counters = await countersUseCase.getMerchantCounters();
      emit(MerchantCountersLoaded(counters: counters));
    } catch (e) {
      emit(MerchantCountersError(e.toString()));
    }
  }
}
