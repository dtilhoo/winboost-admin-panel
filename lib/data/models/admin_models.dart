class Merchant {
  final String id;
  final String name;
  final String owner;
  final String created;
  final String badge;
  final String status;

  Merchant({
    required this.id,
    required this.name,
    required this.owner,
    required this.created,
    required this.badge,
    required this.status,
  });
}

class MerchantApp {
  final String id;
  final String merchant;
  final String email;
  final String submitted;
  final String status;
  final String docs;

  MerchantApp({
    required this.id,
    required this.merchant,
    required this.email,
    required this.submitted,
    required this.status,
    required this.docs,
  });
}

class CreatorApp {
  final String id;
  final String creator;
  final String submitted;
  final String status;
  final String social;

  CreatorApp({
    required this.id,
    required this.creator,
    required this.submitted,
    required this.status,
    required this.social,
  });
}

class Topup {
  final String id;
  final String merchant;
  final double amount;
  final String ref;
  final String submitted;
  final String status;
  final bool proof;

  Topup({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.ref,
    required this.submitted,
    required this.status,
    required this.proof,
  });
}

class Refund {
  final String id;
  final String merchant;
  final double amount;
  final String reason;
  final String submitted;
  final String status;

  Refund({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.reason,
    required this.submitted,
    required this.status,
  });
}

class Withdrawal {
  final String id;
  final String ownerName; // merchant or creator
  final double amount;
  final String submitted;
  final String status;

  Withdrawal({
    required this.id,
    required this.ownerName,
    required this.amount,
    required this.submitted,
    required this.status,
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String channel;
  final String audience;
  final String created;
  final String status;

  NotificationModel({
    required this.id,
    required this.title,
    required this.channel,
    required this.audience,
    required this.created,
    required this.status,
  });
}

class LogItem {
  final String time;
  final String level;
  final String message;

  LogItem({required this.time, required this.level, required this.message});
}

class Category {
  final String id;
  final String name;
  final double minCommission;
  final double maxCommission;
  final String status;

  Category({
    required this.id,
    required this.name,
    required this.minCommission,
    required this.maxCommission,
    required this.status,
  });
}

class Partnership {
  final String id;
  final String merchant;
  final String creator;
  final String status;
  final String date;

  Partnership({
    required this.id,
    required this.merchant,
    required this.creator,
    required this.status,
    required this.date,
  });
}

class MessageThread {
  final String id;
  final String partnershipId;
  final String participants;
  final int messageCount;
  final String lastMessage;

  MessageThread({
    required this.id,
    required this.partnershipId,
    required this.participants,
    required this.messageCount,
    required this.lastMessage,
  });
}

class MerchantCounter {
  final String id;
  final String merchant;
  final int activeOffers;
  final int totalScans;

  MerchantCounter({
    required this.id,
    required this.merchant,
    required this.activeOffers,
    required this.totalScans,
  });
}
