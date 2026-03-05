import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserManagementState {}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class UserManagementLoaded extends UserManagementState {
  final List<dynamic> users;

  UserManagementLoaded(this.users);
}

class UserManagementError extends UserManagementState {
  final String message;

  UserManagementError(this.message);
}

class UserManagementCubit extends Cubit<UserManagementState> {
  UserManagementCubit() : super(UserManagementInitial());

  void load() async {
    emit(UserManagementLoading());
    try {
      // TODO: Fetch users from a use case or repository.
      // For now, emit dummy data for the MVP admin panel structure.
      await Future.delayed(const Duration(milliseconds: 600));
      emit(
        UserManagementLoaded([
          {
            'id': 'USR-1029',
            'name': 'Sarah Jenkins',
            'role': 'User',
            'tier': 'Gold',
            'status': 'Active',
          },
          {
            'id': 'CRT-8472',
            'name': 'Alex Creator',
            'role': 'Creator',
            'tier': 'Influencer',
            'status': 'Active',
          },
          {
            'id': 'MCT-3011',
            'name': 'Urban Grind Coffee',
            'role': 'Merchant',
            'tier': 'Level 2',
            'status': 'Active',
          },
        ]),
      );
    } catch (e) {
      emit(UserManagementError(e.toString()));
    }
  }

  void overrideTier(String userId, String newTier) {
    if (state is UserManagementLoaded) {
      final currentState = state as UserManagementLoaded;
      final updatedUsers = currentState.users.map((u) {
        if (u['id'] == userId) {
          return {...u, 'tier': newTier};
        }
        return u;
      }).toList();
      emit(UserManagementLoaded(updatedUsers));
    }
  }
}
