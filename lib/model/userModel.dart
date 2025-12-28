class AppUser {
  final String id;
  final String name;
  final String email;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map["name"] ?? "",
      email: map["email"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
    };
  }
}
