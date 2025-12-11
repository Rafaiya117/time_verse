class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  String? userId;
  String? username;
   String? profileImageUrl;

  //!------breaks name ------------!

  String get formattedUsername {
  if (username == null || username!.trim().isEmpty) return '';

  final parts = username!.trim().split(' ');

  if (parts.length == 1) return username!;

  final first = parts.first;
  final rest = parts.sublist(1).join(' ');

  return '$first\n$rest';
}

}