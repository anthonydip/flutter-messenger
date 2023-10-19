class PostUser {
  final String email;
  final String provider;
  final String password;

  PostUser(this.email, this.provider, this.password);

  PostUser.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      provider = json['provider'],
      password = json['password'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'provider': provider,
    'password': password,
  };
}