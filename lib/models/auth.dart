class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  String profileImage;

  UserModel(
      {required this.name,
      required this.id,
      required this.email,
      required this.password,
      required this.profileImage});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      id: json['_id'],
      email: json['email'],
      password: json['password'],
      profileImage: json['profileImage'] ?? '',
    );
  }
  // Método para atualizar a imagem de perfil
  void updateProfileImage(String newImage) {
    profileImage = newImage;
  }
}
