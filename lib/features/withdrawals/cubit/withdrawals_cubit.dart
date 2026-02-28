import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class WithdrawalsState extends Equatable {
  const WithdrawalsState();
  @override
  List<Object?> get props => [];
}

class WithdrawalsInitial extends WithdrawalsState {}

class WithdrawalsLoading extends WithdrawalsState {}

class WithdrawalsLoaded extends WithdrawalsState {
  final List<Withdrawal> merchantWithdrawals;
  final List<Withdrawal> creatorWithdrawals;

  const WithdrawalsLoaded({
    required this.merchantWithdrawals,
    required this.creatorWithdrawals,
  });

  @override
  List<Object?> get props => [merchantWithdrawals, creatorWithdrawals];
}

class WithdrawalsError extends WithdrawalsState {
  final String message;
  const WithdrawalsError(this.message);
  @override
  List<Object?> get props => [message];
}

class WithdrawalsCubit extends Cubit<WithdrawalsState> {
  final ManageWalletUseCase walletUseCase;

  WithdrawalsCubit({required this.walletUseCase}) : super(WithdrawalsInitial());

  Future<void> load() async {
    emit(WithdrawalsLoading());
    try {
      final merchantWithdrawals = await walletUseCase.getMerchantWithdrawals();
      final creatorWithdrawals = await walletUseCase.getCreatorWithdrawals();
      emit(
        WithdrawalsLoaded(
          merchantWithdrawals: merchantWithdrawals,
          creatorWithdrawals: creatorWithdrawals,
        ),
      );
    } catch (e) {
      emit(WithdrawalsError(e.toString()));
    }
  }

  Future<void> updateMerchantWithdrawal(
    String id,
    String status, {
    String? ref,
  }) async {
    await walletUseCase.updateWithdrawal(id, status, true, ref: ref);
    await load();
  }

  Future<void> updateCreatorWithdrawal(
    String id,
    String status, {
    String? ref,
  }) async {
    await walletUseCase.updateWithdrawal(id, status, false, ref: ref);
    await load();
  }
}
