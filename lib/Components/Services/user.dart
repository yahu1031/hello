class User {
  final String uid;
  final String email;
  User({this.uid, this.email});
}

class UserData {
  static String _uid;
  static String _name;
  static String _email;
  static String _role;
  static String _institute;
  static int _phone;

  UserData(
    String uid,
    String name,
    String email,
    String role,
    String institute,
    int phone,
  ) {
    UserData._uid = uid;
    UserData._name = name;
    UserData._email = email;
    UserData._role = role;
    UserData._institute = institute;
    UserData._phone = phone;
  }

  static String get uid => _uid;
  static String get name => _name;
  static String get email => _email;
  static String get role => _role;
  static String get institute => _institute;
  static int get phone => _phone;
}
