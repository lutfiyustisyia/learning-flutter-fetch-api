class User {
  final int id;
  final String title;
  final String body;

  User({required this.id, required this.title, required this.body});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
