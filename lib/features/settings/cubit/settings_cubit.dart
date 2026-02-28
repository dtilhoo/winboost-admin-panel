import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool isDevEnv;
  final bool enableRounding;
  final bool enableSentry;

  const SettingsLoaded({
    required this.isDevEnv,
    required this.enableRounding,
    required this.enableSentry,
  });

  @override
  List<Object?> get props => [isDevEnv, enableRounding, enableSentry];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(
        const SettingsLoaded(
          isDevEnv: true,
          enableRounding: false,
          enableSentry: true,
        ),
      );

  void toggleEnv(bool val) {
    if (state is SettingsLoaded) {
      final s = state as SettingsLoaded;
      emit(
        SettingsLoaded(
          isDevEnv: val,
          enableRounding: s.enableRounding,
          enableSentry: s.enableSentry,
        ),
      );
    }
  }

  void toggleRounding(bool val) {
    if (state is SettingsLoaded) {
      final s = state as SettingsLoaded;
      emit(
        SettingsLoaded(
          isDevEnv: s.isDevEnv,
          enableRounding: val,
          enableSentry: s.enableSentry,
        ),
      );
    }
  }

  void toggleSentry(bool val) {
    if (state is SettingsLoaded) {
      final s = state as SettingsLoaded;
      emit(
        SettingsLoaded(
          isDevEnv: s.isDevEnv,
          enableRounding: s.enableRounding,
          enableSentry: val,
        ),
      );
    }
  }
}
