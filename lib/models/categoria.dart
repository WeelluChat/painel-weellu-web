class ResponseModel {
  final String? idCategoria;
  final String? nameCategoria;
  final int? iconName;
  final String? colorIcon;
  final String? parentId; // ID da categoria pai
  final List<ResponseModel> subcategories; // Lista de subcategorias

  ResponseModel({
    required this.idCategoria,
    required this.nameCategoria,
    required this.iconName,
    required this.colorIcon,
    this.parentId, // Pode ser nulo se for uma categoria principal
    this.subcategories = const [],
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      idCategoria: json['_id'],
      nameCategoria: json['name'],
      iconName: int.tryParse(json['icon']?.toString() ?? ''),
      colorIcon: json['iconColor'],
      parentId: json['parentCategoryId'], // Define o ID do pai
      subcategories: (json['subcategories'] as List<dynamic>?)
              ?.map((subJson) => ResponseModel.fromJson(subJson))
              .toList() ??
          [], // Se não houver subcategorias, retorna uma lista vazia
    );
  }

  static List<ResponseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ResponseModel.fromJson(json)).toList();
  }
}
