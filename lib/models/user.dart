class User {
final String uid ;
final String email ;
final String name ;
User({required this.uid, required this.email, required this.name}




);


factory User.fromMap(Map<String, dynamic> data, String uid) {
    return User(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
    };
  }
}
