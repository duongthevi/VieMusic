class CreateUserReq {
  final String fullName;
  final String email;
  final String password;

  CreateUserReq({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toPocketBaseBody() {
    final username =
        '${fullName.replaceAll(' ', '_')}_${DateTime.now().microsecondsSinceEpoch}';
    return <String, dynamic>{
      "username": username,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": password,
      "name": fullName
    };
  }
}