class RegistrationCredentials {
  RegistrationCredentials({
    required this.email,
    required this.password,
    required this.phonenumber,
  });

  String email;
  String password;
  String phonenumber;

  Map<String, dynamic> toJson() =>
      {'email': email, 'password': password, 'lang': phonenumber};
}
