import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class PartnershipsState extends Equatable {
  const PartnershipsState();
  @override
  List<Object?> get props => [];
}

class PartnershipsInitial extends PartnershipsState {}

class PartnershipsLoading extends PartnershipsState {}

class PartnershipsLoaded extends PartnershipsState {
  final List<Partnership> partnerships;

  const PartnershipsLoaded({required this.partnerships});

  @override
  List<Object?> get props => [partnerships];
}

class PartnershipsError extends PartnershipsState {
  final String message;
  const PartnershipsError(this.message);
  @override
  List<Object?> get props => [message];
}

class PartnershipsCubit extends Cubit<PartnershipsState> {
  final ManagePartnershipsUseCase partnershipsUseCase;

  PartnershipsCubit({required this.partnershipsUseCase})
    : super(PartnershipsInitial());

  Future<void> load() async {
    emit(PartnershipsLoading());
    try {
      final partnerships = await partnershipsUseCase.getPartnerships();
      emit(PartnershipsLoaded(partnerships: partnerships));
    } catch (e) {
      emit(PartnershipsError(e.toString()));
    }
  }

  Future<void> cancelPartnership(String id) async {
    await partnershipsUseCase.cancelPartnership(id);
    await load();
  }
}
