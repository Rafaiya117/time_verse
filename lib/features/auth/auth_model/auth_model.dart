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
    name: "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}".trim(),
    profilePicture: json['profile_picture'] as String?,
    birthDate: null, // not provided anymore
    password: null,
  );
}

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

  // ✅ Added only this
  User copyWith({
    int? id,
    String? birthDate,
    String? profilePicture,
    String? name,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      birthDate: birthDate ?? this.birthDate,
      profilePicture: profilePicture ?? this.profilePicture,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }
}
