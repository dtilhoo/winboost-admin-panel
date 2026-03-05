import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BizboostCampaignsState {}

class BizboostCampaignsInitial extends BizboostCampaignsState {}

class BizboostCampaignsLoading extends BizboostCampaignsState {}

class BizboostCampaignsLoaded extends BizboostCampaignsState {
  final List<dynamic> campaigns;

  BizboostCampaignsLoaded(this.campaigns);
}

class BizboostCampaignsError extends BizboostCampaignsState {
  final String message;

  BizboostCampaignsError(this.message);
}

class BizboostCampaignsCubit extends Cubit<BizboostCampaignsState> {
  BizboostCampaignsCubit() : super(BizboostCampaignsInitial());

  void load() async {
    emit(BizboostCampaignsLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 600));
      emit(
        BizboostCampaignsLoaded([
          {
            'id': 'CMP-1049',
            'merchant': 'Urban Grind Coffee',
            'rule': '100 Ws for Rs 500',
            'budget': '15,000 Ws',
            'status': 'Active',
          },
          {
            'id': 'CMP-8821',
            'merchant': 'Fashion Hub',
            'rule': '200 Ws for Rs 1000',
            'budget': '5,000 Ws',
            'status': 'Ended',
          },
          {
            'id': 'CMP-3942',
            'merchant': 'Tech Store Plus',
            'rule': '500 Ws for Rs 5000',
            'budget': '50,000 Ws',
            'status': 'Active',
          },
        ]),
      );
    } catch (e) {
      emit(BizboostCampaignsError(e.toString()));
    }
  }

  void cancelCampaign(String campaignId) {
    if (state is BizboostCampaignsLoaded) {
      final currentState = state as BizboostCampaignsLoaded;

      final updated = currentState.campaigns.map((c) {
        if (c['id'] == campaignId) {
          return {...c, 'status': 'Force Cancelled'};
        }
        return c;
      }).toList();

      emit(BizboostCampaignsLoaded(updated));
    }
  }
}
