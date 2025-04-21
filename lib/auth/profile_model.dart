// TODO Implement this library.
class AppUser {
  final String id;
  final String email;
  final String? fullName;
  final DateTime? createdAt;

  AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }
}
