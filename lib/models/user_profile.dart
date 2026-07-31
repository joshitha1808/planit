// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserProfile {
  final String name;
  final String email;
  final String avatar;

  UserProfile({
    required this.name,
    required this.email,
    required this.avatar,
  });

  UserProfile copyWith({String? name, String? email, String? avatar}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}
