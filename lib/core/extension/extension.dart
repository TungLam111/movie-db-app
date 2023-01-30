extension StringNullExtension on String? {
  bool isPhoneNumber() {
    if (this == null) return false;
    final RegExp phoneNumber =
        RegExp(r'^[2-9][0-9][0-9]-[2-9][0-9][0-9]-[0-9]{4}$');
    return phoneNumber.hasMatch(this!);
  }

  bool isVerifyCode() {
    if (this == null) return false;
    final RegExp codeReg = RegExp(r'^[0-9]{6}$');
    return codeReg.hasMatch(this!);
  }

  bool isEmailAddress() {
    if (this == null) return false;
    final RegExp email = RegExp(r'^([\w-\.])*[\w]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.hasMatch(this!);
  }

  bool isEmptyOrNull() {
    if (this == null) return true;
    return this!.isEmpty;
  }
}
