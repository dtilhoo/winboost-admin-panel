import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class WalletFundingState extends Equatable {
  const WalletFundingState();
  @override
  List<Object?> get props => [];
}

class WalletFundingInitial extends WalletFundingState {}

class WalletFundingLoading extends WalletFundingState {}

class WalletFundingLoaded extends WalletFundingState {
  final List<Topup> topups;

  const WalletFundingLoaded({required this.topups});

  @override
  List<Object?> get props => [topups];
}

class WalletFundingError extends WalletFundingState {
  final String message;
  const WalletFundingError(this.message);
  @override
  List<Object?> get props => [message];
}

class WalletFundingCubit extends Cubit<WalletFundingState> {
  final ManageWalletUseCase walletUseCase;

  WalletFundingCubit({required this.walletUseCase})
    : super(WalletFundingInitial());

  Future<void> load() async {
    emit(WalletFundingLoading());
    try {
      final topups = await walletUseCase.getTopups();
      emit(WalletFundingLoaded(topups: topups));
    } catch (e) {
      emit(WalletFundingError(e.toString()));
    }
  }

  Future<void> confirmTopup(String id) async {
    await walletUseCase.confirmTopup(id);
    await load();
  }

  Future<void> rejectTopup(String id, String notes) async {
    await walletUseCase.rejectTopup(id, notes);
    await load();
  }
}
