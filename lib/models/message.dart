class Message {
  final String user;
  final String msg;
  final String datetime;

  const Message(this.user, this.msg, this.datetime);

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is Message && other.user == user && other.msg == msg && other.datetime == datetime;

  @override
  int get hashCode => user.hashCode;
}