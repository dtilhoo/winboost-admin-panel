import '../../data/models/admin_models.dart';
import '../../data/repositories/admin_repository.dart';

class GetDashboardMetricsUseCase {
  final AdminRepository repository;
  GetDashboardMetricsUseCase(this.repository);

  Future<Map<String, dynamic>> execute() async {
    final mApps = await repository.getMerchantApps();
    final cApps = await repository.getCreatorApps();
    final topups = await repository.getTopups();
    final mWithdraws = await repository.getMerchantWithdrawals();
    final cWithdraws = await repository.getCreatorWithdrawals();

    return {
      'pendingMerchantApps': mApps.where((e) => e.status == 'Pending').length,
      'pendingCreatorApps': cApps.where((e) => e.status == 'Pending').length,
      'pendingTopups': topups.where((e) => e.status == 'Pending').length,
      'pendingWithdrawals':
          mWithdraws.where((e) => e.status == 'Pending').length +
          cWithdraws.where((e) => e.status == 'Pending').length,
    };
  }
}

class GetRoleApprovalsUseCase {
  final AdminRepository repository;
  GetRoleApprovalsUseCase(this.repository);

  Future<List<MerchantApp>> getMerchantApps() => repository.getMerchantApps();
  Future<List<CreatorApp>> getCreatorApps() => repository.getCreatorApps();

  Future<void> approveMerchantApp(String id) =>
      repository.updateMerchantAppStatus(id, 'Approved');
  Future<void> rejectMerchantApp(String id, String notes) =>
      repository.updateMerchantAppStatus(id, 'Rejected', notes: notes);

  Future<void> approveCreatorApp(String id) =>
      repository.updateCreatorAppStatus(id, 'Approved');
  Future<void> rejectCreatorApp(String id, String notes) =>
      repository.updateCreatorAppStatus(id, 'Rejected', notes: notes);
}

class ManageWalletUseCase {
  final AdminRepository repository;
  ManageWalletUseCase(this.repository);

  Future<List<Topup>> getTopups() => repository.getTopups();
  Future<void> confirmTopup(String id) =>
      repository.updateTopupStatus(id, 'Confirmed');
  Future<void> rejectTopup(String id, String notes) =>
      repository.updateTopupStatus(id, 'Rejected', notes: notes);

  Future<List<Withdrawal>> getMerchantWithdrawals() =>
      repository.getMerchantWithdrawals();
  Future<List<Withdrawal>> getCreatorWithdrawals() =>
      repository.getCreatorWithdrawals();
  Future<void> updateWithdrawal(
    String id,
    String status,
    bool isMerchant, {
    String? ref,
  }) => repository.updateWithdrawalStatus(id, status, isMerchant, ref: ref);

  Future<List<Refund>> getRefunds() => repository.getRefunds();
  Future<void> updateRefund(String id, String status, {String? ref}) =>
      repository.updateRefundStatus(id, status, ref: ref);
}

class ManageCategoryUseCase {
  final AdminRepository repository;
  ManageCategoryUseCase(this.repository);

  Future<List<Category>> getCategories() => repository.getCategories();
  Future<void> updateStatus(String id, String status) =>
      repository.updateCategoryStatus(id, status);
}

class ManageMerchantProfileUseCase {
  final AdminRepository repository;
  ManageMerchantProfileUseCase(this.repository);

  // We can treat updating status the same as suspending/activating a merchant
  Future<List<Merchant>> getMerchants() => repository.getMerchants();

  // Future implementation for updateMerchant profile review could be added here
}

class ManagePartnershipsUseCase {
  final AdminRepository repository;
  ManagePartnershipsUseCase(this.repository);

  Future<List<Partnership>> getPartnerships() => repository.getPartnerships();
  Future<void> cancelPartnership(String id) => repository.cancelPartnership(id);
}

class ManageMessagesUseCase {
  final AdminRepository repository;
  ManageMessagesUseCase(this.repository);

  Future<List<MessageThread>> getMessageThreads() =>
      repository.getMessageThreads();
}

class ManageCountersUseCase {
  final AdminRepository repository;
  ManageCountersUseCase(this.repository);

  Future<List<MerchantCounter>> getMerchantCounters() =>
      repository.getMerchantCounters();
}

class ManageNotificationsUseCase {
  final AdminRepository repository;
  ManageNotificationsUseCase(this.repository);

  Future<List<NotificationModel>> getNotifications() =>
      repository.getNotifications();
  Future<void> addNotification(
    String title,
    String channel,
    String audience,
    String content,
  ) => repository.addNotification(title, channel, audience, content);
}

class GetLogsUseCase {
  final AdminRepository repository;
  GetLogsUseCase(this.repository);

  Future<List<LogItem>> getLogs() => repository.getLogs();
}
