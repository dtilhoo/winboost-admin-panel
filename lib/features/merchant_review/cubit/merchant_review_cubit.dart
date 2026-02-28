import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class MerchantReviewState extends Equatable {
  const MerchantReviewState();
  @override
  List<Object?> get props => [];
}

class MerchantReviewInitial extends MerchantReviewState {}

class MerchantReviewLoading extends MerchantReviewState {}

class MerchantReviewLoaded extends MerchantReviewState {
  final List<Merchant> merchants;

  const MerchantReviewLoaded({required this.merchants});

  @override
  List<Object?> get props => [merchants];
}

class MerchantReviewError extends MerchantReviewState {
  final String message;
  const MerchantReviewError(this.message);
  @override
  List<Object?> get props => [message];
}

class MerchantReviewCubit extends Cubit<MerchantReviewState> {
  final ManageMerchantProfileUseCase profileUseCase;

  MerchantReviewCubit({required this.profileUseCase})
    : super(MerchantReviewInitial());

  Future<void> load() async {
    emit(MerchantReviewLoading());
    try {
      final merchants = await profileUseCase.getMerchants();
      emit(MerchantReviewLoaded(merchants: merchants));
    } catch (e) {
      emit(MerchantReviewError(e.toString()));
    }
  }

  // Update logic to be implemented on repository when needed
}
