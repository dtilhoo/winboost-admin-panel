import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class RoleApprovalsState extends Equatable {
  const RoleApprovalsState();
  @override
  List<Object?> get props => [];
}

class RoleApprovalsInitial extends RoleApprovalsState {}

class RoleApprovalsLoading extends RoleApprovalsState {}

class RoleApprovalsLoaded extends RoleApprovalsState {
  final List<MerchantApp> merchantApps;
  final List<CreatorApp> creatorApps;

  const RoleApprovalsLoaded({
    required this.merchantApps,
    required this.creatorApps,
  });

  @override
  List<Object?> get props => [merchantApps, creatorApps];
}

class RoleApprovalsError extends RoleApprovalsState {
  final String message;
  const RoleApprovalsError(this.message);
  @override
  List<Object?> get props => [message];
}

class RoleApprovalsCubit extends Cubit<RoleApprovalsState> {
  final GetRoleApprovalsUseCase approvalsUseCase;

  RoleApprovalsCubit({required this.approvalsUseCase})
    : super(RoleApprovalsInitial());

  Future<void> load() async {
    emit(RoleApprovalsLoading());
    try {
      final merchantApps = await approvalsUseCase.getMerchantApps();
      final creatorApps = await approvalsUseCase.getCreatorApps();
      emit(
        RoleApprovalsLoaded(
          merchantApps: merchantApps,
          creatorApps: creatorApps,
        ),
      );
    } catch (e) {
      emit(RoleApprovalsError(e.toString()));
    }
  }

  Future<void> approveMerchant(String id) async {
    await approvalsUseCase.approveMerchantApp(id);
    await load();
  }

  Future<void> rejectMerchant(String id, String notes) async {
    await approvalsUseCase.rejectMerchantApp(id, notes);
    await load();
  }

  Future<void> approveCreator(String id) async {
    await approvalsUseCase.approveCreatorApp(id);
    await load();
  }

  Future<void> rejectCreator(String id, String notes) async {
    await approvalsUseCase.rejectCreatorApp(id, notes);
    await load();
  }
}
