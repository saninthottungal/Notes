import 'package:firebase2/Services/Crud/Constants.dart';

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[userId] as int,
        email = map[userEmail] as String;

  @override
  String toString() {
    return "User : id = $id, email = $email";
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
