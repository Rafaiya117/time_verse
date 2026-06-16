class ReviewData {
  final String userEmail;
  final String userName;
  final int rating;
  final String comments;
  final DateTime? createdAt;
   
  ReviewData({
    required this.userEmail,
    required this.userName,
    required this.rating,
    required this.comments,
    required this.createdAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      userEmail: json['user_email'] as String? ?? '',
      userName: json['user_first_name'] as String,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comments: json['comments'] as String? ?? '',
      createdAt: json['created_at'] != null
      ? DateTime.tryParse(json['created_at'])
      : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_email': userEmail,
      'user_first_name': userName,
      'rating': rating,
      'comments': comments,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}