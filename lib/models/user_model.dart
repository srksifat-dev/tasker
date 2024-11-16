class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String password;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'mobile': this.mobile,
      'password': this.password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      mobile: map['mobile'] as String,
      password: map['password'] as String,
    );
  }
}
