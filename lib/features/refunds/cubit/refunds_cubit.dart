import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class RefundsState extends Equatable {
  const RefundsState();
  @override
  List<Object?> get props => [];
}

class RefundsInitial extends RefundsState {}

class RefundsLoading extends RefundsState {}

class RefundsLoaded extends RefundsState {
  final List<Refund> refunds;

  const RefundsLoaded({required this.refunds});

  @override
  List<Object?> get props => [refunds];
}

class RefundsError extends RefundsState {
  final String message;
  const RefundsError(this.message);
  @override
  List<Object?> get props => [message];
}

class RefundsCubit extends Cubit<RefundsState> {
  final ManageWalletUseCase walletUseCase;

  RefundsCubit({required this.walletUseCase}) : super(RefundsInitial());

  Future<void> load() async {
    emit(RefundsLoading());
    try {
      final refunds = await walletUseCase.getRefunds();
      emit(RefundsLoaded(refunds: refunds));
    } catch (e) {
      emit(RefundsError(e.toString()));
    }
  }

  Future<void> updateRefund(String id, String status, {String? ref}) async {
    await walletUseCase.updateRefund(id, status, ref: ref);
    await load();
  }
}
