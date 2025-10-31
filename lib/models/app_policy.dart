class AppPolicy {
  final String policyId;
  final String policyType; // privacy, terms, community
  final String title;
  final String content;
  final String version;
  final DateTime effectiveDate;
  final DateTime? lastUpdated;

  AppPolicy({
    required this.policyId,
    required this.policyType,
    required this.title,
    required this.content,
    required this.version,
    required this.effectiveDate,
    this.lastUpdated,
  });

  factory AppPolicy.fromJson(Map<String, dynamic> json) {
    return AppPolicy(
      policyId: json['id'] as String, // Changed from 'policy_id' to 'id'
      policyType: json['policy_type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      version: json['version'] as String? ?? '1.0',
      effectiveDate: DateTime.parse(json['effective_date'] as String),
      lastUpdated: json['updated_at'] != null // Changed from 'last_updated' to 'updated_at'
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'policy_id': policyId,
      'policy_type': policyType,
      'title': title,
      'content': content,
      'version': version,
      'effective_date': effectiveDate.toIso8601String(),
      if (lastUpdated != null) 'last_updated': lastUpdated!.toIso8601String(),
    };
  }

  String get typeDisplay {
    switch (policyType.toLowerCase()) {
      case 'privacy':
        return 'Privacy Policy';
      case 'terms':
        return 'Terms of Service';
      case 'community':
        return 'Community Guidelines';
      default:
        return policyType;
    }
  }
}
