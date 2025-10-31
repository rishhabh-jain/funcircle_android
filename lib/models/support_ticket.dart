class SupportTicket {
  final String? ticketId;
  final String userId;
  final String subject;
  final String description;
  final String category; // bug, feature_request, help, other
  final String status; // open, in_progress, resolved, closed
  final String priority; // low, medium, high
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;

  SupportTicket({
    this.ticketId,
    required this.userId,
    required this.subject,
    required this.description,
    required this.category,
    this.status = 'open',
    this.priority = 'medium',
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      ticketId: json['ticket_id'] as String?,
      userId: json['user_id'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String,
      category: json['category'] as String? ?? 'other',
      status: json['status'] as String? ?? 'open',
      priority: json['priority'] as String? ?? 'medium',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (ticketId != null) 'ticket_id': ticketId,
      'user_id': userId,
      'subject': subject,
      'description': description,
      'category': category,
      'status': status,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (resolvedAt != null) 'resolved_at': resolvedAt!.toIso8601String(),
    };
  }

  String get categoryDisplay {
    switch (category.toLowerCase()) {
      case 'bug':
        return 'Bug Report';
      case 'feature_request':
        return 'Feature Request';
      case 'help':
        return 'Help & Support';
      case 'other':
        return 'Other';
      default:
        return category;
    }
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }
}
