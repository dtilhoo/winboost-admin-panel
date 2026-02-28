import '../models/admin_models.dart';

class AdminRepository {
  // Dummy in-memory data
  List<Merchant> merchants = [
    Merchant(
      id: "M-UG-001",
      name: "Urban Grind Coffee",
      owner: "D. Patel",
      created: "2026-02-05",
      badge: "B",
      status: "Active",
    ),
    Merchant(
      id: "M-FM-014",
      name: "FreshMart",
      owner: "A. Nundlall",
      created: "2026-02-09",
      badge: "A",
      status: "Active",
    ),
    Merchant(
      id: "M-FL-007",
      name: "FitLab Gym",
      owner: "S. R.",
      created: "2026-02-11",
      badge: "C",
      status: "Suspended",
    ),
  ];

  List<MerchantApp> merchantApps = [
    MerchantApp(
      id: "MA-102",
      merchant: "Urban Grind Coffee",
      email: "owner@urbangrind.mu",
      submitted: "2026-02-05",
      status: "Pending",
      docs: "OK",
    ),
    MerchantApp(
      id: "MA-117",
      merchant: "FitLab Gym",
      email: "admin@fitlab.mu",
      submitted: "2026-02-11",
      status: "Rejected",
      docs: "Missing BRN",
    ),
    MerchantApp(
      id: "MA-121",
      merchant: "GreenLeaf Pharmacy",
      email: "ops@greenleaf.mu",
      submitted: "2026-02-12",
      status: "Pending",
      docs: "OK",
    ),
  ];

  List<CreatorApp> creatorApps = [
    CreatorApp(
      id: "CA-88",
      creator: "Alex Doe (@alex.mu)",
      submitted: "2026-02-08",
      status: "Pending",
      social: "25k IG",
    ),
    CreatorApp(
      id: "CA-92",
      creator: "Mia D. (@mia.d)",
      submitted: "2026-02-10",
      status: "Approved",
      social: "12k IG",
    ),
    CreatorApp(
      id: "CA-95",
      creator: "Jay K. (@jayk)",
      submitted: "2026-02-12",
      status: "Rejected",
      social: "Low proof",
    ),
  ];

  List<Topup> topups = [
    Topup(
      id: "TU-1029",
      merchant: "Urban Grind Coffee",
      amount: 10000,
      ref: "WB-TU-1029",
      submitted: "2026-02-13",
      status: "Pending",
      proof: true,
    ),
    Topup(
      id: "TU-1021",
      merchant: "Urban Grind Coffee",
      amount: 5000,
      ref: "WB-TU-1021",
      submitted: "2026-02-10",
      status: "Confirmed",
      proof: true,
    ),
    Topup(
      id: "TU-1033",
      merchant: "FreshMart",
      amount: 15000,
      ref: "WB-TU-1033",
      submitted: "2026-02-14",
      status: "Rejected",
      proof: true,
    ),
  ];

  List<Refund> refunds = [
    Refund(
      id: "RF-54",
      merchant: "Urban Grind Coffee",
      amount: 3000,
      reason: "Reduce deposit",
      submitted: "2026-02-13",
      status: "Pending",
    ),
    Refund(
      id: "RF-49",
      merchant: "FitLab Gym",
      amount: 5000,
      reason: "Close campaign",
      submitted: "2026-02-09",
      status: "Paid",
    ),
  ];

  List<Withdrawal> merchantWithdrawals = [
    Withdrawal(
      id: "MW-14",
      ownerName: "FreshMart",
      amount: 8000,
      submitted: "2026-02-12",
      status: "Pending",
    ),
    Withdrawal(
      id: "MW-11",
      ownerName: "Urban Grind Coffee",
      amount: 4000,
      submitted: "2026-02-10",
      status: "Approved",
    ),
    Withdrawal(
      id: "MW-07",
      ownerName: "FitLab Gym",
      amount: 2500,
      submitted: "2026-02-08",
      status: "Rejected",
    ),
  ];

  List<Withdrawal> creatorWithdrawals = [
    Withdrawal(
      id: "CW-22",
      ownerName: "Alex Doe",
      amount: 1500,
      submitted: "2026-02-14",
      status: "Pending",
    ),
    Withdrawal(
      id: "CW-19",
      ownerName: "Mia D.",
      amount: 900,
      submitted: "2026-02-11",
      status: "Paid",
    ),
    Withdrawal(
      id: "CW-15",
      ownerName: "Jay K.",
      amount: 500,
      submitted: "2026-02-09",
      status: "Rejected",
    ),
  ];

  List<NotificationModel> notifications = [
    NotificationModel(
      id: "N-301",
      title: "Top-up pending",
      channel: "In-app + Push",
      audience: "Merchant",
      created: "2026-02-13",
      status: "Sent",
    ),
    NotificationModel(
      id: "N-297",
      title: "Creator approved",
      channel: "In-app + Push",
      audience: "Influencer",
      created: "2026-02-10",
      status: "Sent",
    ),
  ];

  List<LogItem> logs = [
    LogItem(
      time: "2026-02-14 12:03",
      level: "INFO",
      message: "QR_CLAIM_SUCCESS tx=WBX-UG-83912 wins=150",
    ),
    LogItem(
      time: "2026-02-14 12:15",
      level: "ERROR",
      message: "TOPUP_CONFIRM_FAIL TU-1033 reason=bank_ref_mismatch",
    ),
    LogItem(
      time: "2026-02-14 12:20",
      level: "INFO",
      message: "WITHDRAW_REQUEST_CREATED CW-22 amount=1500",
    ),
  ];

  List<Category> categories = [
    Category(
      id: "C-1",
      name: "Food & Beverage",
      minCommission: 5.0,
      maxCommission: 15.0,
      status: "Active",
    ),
    Category(
      id: "C-2",
      name: "Fashion",
      minCommission: 8.0,
      maxCommission: 20.0,
      status: "Active",
    ),
    Category(
      id: "C-3",
      name: "Electronics",
      minCommission: 2.0,
      maxCommission: 10.0,
      status: "Suspended",
    ),
  ];

  List<Partnership> partnerships = [
    Partnership(
      id: "P-044",
      merchant: "Urban Grind Coffee",
      creator: "Alex Doe",
      status: "Active",
      date: "2026-02-10",
    ),
    Partnership(
      id: "P-045",
      merchant: "FreshMart",
      creator: "Mia D.",
      status: "Pending",
      date: "2026-02-14",
    ),
  ];

  List<MessageThread> messageThreads = [
    MessageThread(
      id: "MSG-P-044",
      partnershipId: "P-044",
      participants: "Urban Grind Coffee, Alex Doe",
      messageCount: 14,
      lastMessage: "2026-02-14 10:30",
    ),
    MessageThread(
      id: "MSG-P-045",
      partnershipId: "P-045",
      participants: "FreshMart, Mia D.",
      messageCount: 2,
      lastMessage: "2026-02-14 18:00",
    ),
  ];

  List<MerchantCounter> merchantCounters = [
    MerchantCounter(
      id: "MC-01",
      merchant: "Urban Grind Coffee",
      activeOffers: 3,
      totalScans: 850,
    ),
    MerchantCounter(
      id: "MC-02",
      merchant: "FreshMart",
      activeOffers: 1,
      totalScans: 120,
    ),
  ];

  // Simulated API Delays
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  // TODO: Real API Calls below

  Future<List<Merchant>> getMerchants() async {
    await _delay();
    return merchants;
  }

  Future<List<MerchantApp>> getMerchantApps() async {
    await _delay();
    return merchantApps;
  }

  Future<List<CreatorApp>> getCreatorApps() async {
    await _delay();
    return creatorApps;
  }

  Future<List<Topup>> getTopups() async {
    await _delay();
    return topups;
  }

  Future<List<Refund>> getRefunds() async {
    await _delay();
    return refunds;
  }

  Future<List<Withdrawal>> getMerchantWithdrawals() async {
    await _delay();
    return merchantWithdrawals;
  }

  Future<List<Withdrawal>> getCreatorWithdrawals() async {
    await _delay();
    return creatorWithdrawals;
  }

  Future<List<NotificationModel>> getNotifications() async {
    await _delay();
    return notifications;
  }

  Future<List<LogItem>> getLogs() async {
    await _delay();
    return logs;
  }

  Future<List<Category>> getCategories() async {
    await _delay();
    return categories;
  }

  Future<List<Partnership>> getPartnerships() async {
    await _delay();
    return partnerships;
  }

  Future<List<MessageThread>> getMessageThreads() async {
    await _delay();
    return messageThreads;
  }

  Future<List<MerchantCounter>> getMerchantCounters() async {
    await _delay();
    return merchantCounters;
  }

  // Actions
  Future<void> updateMerchantAppStatus(
    String id,
    String newStatus, {
    String? notes,
  }) async {
    await _delay();
    final index = merchantApps.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = merchantApps[index];
      merchantApps[index] = MerchantApp(
        id: old.id,
        merchant: old.merchant,
        email: old.email,
        submitted: old.submitted,
        docs: old.docs,
        status: newStatus,
      );
    }
  }

  Future<void> updateCreatorAppStatus(
    String id,
    String newStatus, {
    String? notes,
  }) async {
    await _delay();
    final index = creatorApps.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = creatorApps[index];
      creatorApps[index] = CreatorApp(
        id: old.id,
        creator: old.creator,
        submitted: old.submitted,
        social: old.social,
        status: newStatus,
      );
    }
  }

  Future<void> updateTopupStatus(
    String id,
    String newStatus, {
    String? notes,
  }) async {
    await _delay();
    final index = topups.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = topups[index];
      topups[index] = Topup(
        id: old.id,
        merchant: old.merchant,
        amount: old.amount,
        ref: old.ref,
        submitted: old.submitted,
        proof: old.proof,
        status: newStatus,
      );
    }
  }

  Future<void> updateRefundStatus(
    String id,
    String newStatus, {
    String? ref,
  }) async {
    await _delay();
    final index = refunds.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = refunds[index];
      refunds[index] = Refund(
        id: old.id,
        merchant: old.merchant,
        amount: old.amount,
        reason: old.reason,
        submitted: old.submitted,
        status: newStatus,
      );
    }
  }

  Future<void> updateWithdrawalStatus(
    String id,
    String newStatus,
    bool isMerchant, {
    String? ref,
  }) async {
    await _delay();
    final list = isMerchant ? merchantWithdrawals : creatorWithdrawals;
    final index = list.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = list[index];
      list[index] = Withdrawal(
        id: old.id,
        ownerName: old.ownerName,
        amount: old.amount,
        submitted: old.submitted,
        status: newStatus,
      );
    }
  }

  Future<void> updateCategoryStatus(String id, String status) async {
    await _delay();
    final index = categories.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = categories[index];
      categories[index] = Category(
        id: old.id,
        name: old.name,
        minCommission: old.minCommission,
        maxCommission: old.maxCommission,
        status: status,
      );
    }
  }

  Future<void> cancelPartnership(String id) async {
    await _delay();
    final index = partnerships.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = partnerships[index];
      partnerships[index] = Partnership(
        id: old.id,
        merchant: old.merchant,
        creator: old.creator,
        status: "Cancelled",
        date: old.date,
      );
    }
  }

  Future<void> addNotification(
    String title,
    String channel,
    String audience,
    String content,
  ) async {
    await _delay();
    notifications.insert(
      0,
      NotificationModel(
        id: "N-${DateTime.now().millisecondsSinceEpoch % 1000}",
        title: title,
        channel: channel,
        audience: audience,
        created: "Just now",
        status: "Sent",
      ),
    );
  }
}
