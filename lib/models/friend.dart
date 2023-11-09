class Friend {
  final String id;
  final String email;

  const Friend(this.id, this.email);

  Friend.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      email = json['email'];
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
  };

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is Friend && other.email == email;

  @override
  int get hashCode => email.hashCode;
}