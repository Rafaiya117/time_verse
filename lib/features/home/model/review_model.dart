class ReviewData {
  final String userEmail;
  final int rating;
  final String comments;
  final String createdAt;

  ReviewData({
    required this.userEmail,
    required this.rating,
    required this.comments,
    required this.createdAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      userEmail: json['user_email'] ?? '',
      rating: json['rating'] ?? 0,
      comments: json['comments'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}