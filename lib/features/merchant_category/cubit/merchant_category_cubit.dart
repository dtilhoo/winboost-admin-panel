import 'package:equatable/equatable.dart';
import '../../../data/models/admin_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/admin_usecases.dart';

abstract class MerchantCategoryState extends Equatable {
  const MerchantCategoryState();
  @override
  List<Object?> get props => [];
}

class MerchantCategoryInitial extends MerchantCategoryState {}

class MerchantCategoryLoading extends MerchantCategoryState {}

class MerchantCategoryLoaded extends MerchantCategoryState {
  final List<Category> categories;

  const MerchantCategoryLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class MerchantCategoryError extends MerchantCategoryState {
  final String message;
  const MerchantCategoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class MerchantCategoryCubit extends Cubit<MerchantCategoryState> {
  final ManageCategoryUseCase categoryUseCase;

  MerchantCategoryCubit({required this.categoryUseCase})
    : super(MerchantCategoryInitial());

  Future<void> load() async {
    emit(MerchantCategoryLoading());
    try {
      final categories = await categoryUseCase.getCategories();
      emit(MerchantCategoryLoaded(categories: categories));
    } catch (e) {
      emit(MerchantCategoryError(e.toString()));
    }
  }

  Future<void> suspendCategory(String id) async {
    await categoryUseCase.updateStatus(id, 'Suspended');
    await load();
  }

  Future<void> activateCategory(String id) async {
    await categoryUseCase.updateStatus(id, 'Active');
    await load();
  }
}
