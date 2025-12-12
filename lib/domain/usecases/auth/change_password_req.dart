class ChangePasswordReq {
  final String oldPassword;
  final String newPassword;

  ChangePasswordReq({
    required this.oldPassword,
    required this.newPassword,
  });
}