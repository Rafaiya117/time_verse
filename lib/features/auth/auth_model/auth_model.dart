class User {
  final int id;
  final String? birthDate;
  final String? profilePicture;
  final String name;
  final String? password; 

  User({
    required this.id,
    this.birthDate,
    this.profilePicture,
    required this.name,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    birthDate: json['birth_date'] != null ? json['birth_date'] as String : null,
    profilePicture: json['profile_picture'] != null ? json['profile_picture'] as String : null,
    name: json['name'] as String,
    password: json['password'] != null ? json['password'] as String : null,
  );
}

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'birth_date': birthDate,
      'profile_picture': profilePicture,
      'name': name,
    };
    if (password != null) {
      data['password'] = password!;
    }
    return data;
  }
}
