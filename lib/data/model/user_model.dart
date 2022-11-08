class UserModel {
  final String email;
  final String token;

  UserModel.fromJson(Map<String, dynamic> map)
      : email = map['email'],
        token = map['token'];

  Map<String, dynamic> toJson() {
    return {'email': email, 'token': token};
  }

  static const emptyToJson = {'email': '', 'token': ''};

  bool get isEmpty => token == '';
}
