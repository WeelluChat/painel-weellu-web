class ResponseModel {
  final String? idCategoria;
  final String? nameCategoria;
  final int? iconName;
  final String? colorIcon;

  ResponseModel({
    required this.idCategoria,
    required this.nameCategoria,
    required this.iconName,
    required this.colorIcon,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      idCategoria: json['_id'],
      nameCategoria: json['name'],
      iconName: int.tryParse(json['icon'] ?? ''), // Converte string para int
      colorIcon: json['iconColor'],
    );
  }

  static List<ResponseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ResponseModel.fromJson(json)).toList();
  }
}
