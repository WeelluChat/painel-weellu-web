class ModelSubcategoria {
  final String? idCategoria;
  final String? nameCategoria;
  final int? iconName;
  final String? colorIcon;
  final String? parentId; // ID da categoria pai
  final List<ModelSubcategoria> subcategories; // Lista de subcategorias

  ModelSubcategoria({
    required this.idCategoria,
    required this.nameCategoria,
    required this.iconName,
    required this.colorIcon,
    this.parentId, // Pode ser nulo se for uma categoria principal
    this.subcategories = const [],
  });

  factory ModelSubcategoria.fromJson(Map<String, dynamic> json) {
    return ModelSubcategoria(
      idCategoria: json['_id'],
      nameCategoria: json['name'],
      iconName: int.tryParse(json['icon']?.toString() ?? ''),
      colorIcon: json['iconColor'],
      parentId: json['parentCategoryId'], // Define o ID do pai
      subcategories: (json['subcategories'] as List<dynamic>?)
              ?.map((subJson) => ModelSubcategoria.fromJson(subJson))
              .toList() ??
          [], // Se não houver subcategorias, retorna uma lista vazia
    );
  }

  static List<ModelSubcategoria> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ModelSubcategoria.fromJson(json)).toList();
  }
}
