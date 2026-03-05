import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TreasuryState {}

class TreasuryInitial extends TreasuryState {}

class TreasuryLoading extends TreasuryState {}

class TreasuryLoaded extends TreasuryState {
  final List<dynamic> rates;

  TreasuryLoaded(this.rates);
}

class TreasuryError extends TreasuryState {
  final String message;

  TreasuryError(this.message);
}

class TreasuryCubit extends Cubit<TreasuryState> {
  TreasuryCubit() : super(TreasuryInitial());

  void load() async {
    emit(TreasuryLoading());
    try {
      // Simulate API call for conversion rates
      await Future.delayed(const Duration(milliseconds: 600));
      emit(
        TreasuryLoaded([
          {
            'id': 'MRU-EUR',
            'source': 'Mauritius (MUR Ws)',
            'target': 'France (EUR Ws)',
            'rate': 0.02,
            'status': 'Active',
          },
          {
            'id': 'EUR-MRU',
            'source': 'France (EUR Ws)',
            'target': 'Mauritius (MUR Ws)',
            'rate': 50.0,
            'status': 'Active',
          },
          {
            'id': 'KES-MRU',
            'source': 'Kenya (KES Ws)',
            'target': 'Mauritius (MUR Ws)',
            'rate': 0.35,
            'status': 'Draft',
          },
        ]),
      );
    } catch (e) {
      emit(TreasuryError(e.toString()));
    }
  }

  void updateRate(String rateId, double newRate) {
    if (state is TreasuryLoaded) {
      final currentState = state as TreasuryLoaded;

      final updated = currentState.rates.map((r) {
        if (r['id'] == rateId) {
          return {...r, 'rate': newRate, 'status': 'Active'};
        }
        return r;
      }).toList();

      emit(TreasuryLoaded(updated));
    }
  }
}
