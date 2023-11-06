class Friend {
  final String email;

  const Friend(this.email);

  Friend.fromJson(Map<String, dynamic> json)
    : email = json['email'];
  Map<String, dynamic> toJson() => {
    'email': email,
  };

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is Friend && other.email == email;

  @override
  int get hashCode => email.hashCode;
}