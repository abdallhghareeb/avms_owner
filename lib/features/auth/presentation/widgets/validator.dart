import 'package:easy_localization/easy_localization.dart';
import 'package:intl_phone_field/phone_number.dart';

String? validator(String? value) {
  if (value == null || value.isEmpty) return 'هذا العنصر مطلوب'.tr();
  return null;
}

String? phoneValidator(PhoneNumber? p1) {
  if (p1?.number == '' ) return 'برجاء ادخال رقم الهاتف'.tr();
  return null;

}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required'.tr();
  }
  // else if (value.length < 6) {
  //   return 'Password must be at least 6 characters'.tr();
  // }
  return null;
}

String? confirmPasswordValidator(String? password,confirmPass) {
  if (password != confirmPass) {
    return 'Passwords do not match'.tr();
  }
  return null;
}
