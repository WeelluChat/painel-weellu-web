import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monitor_site_weellu/models/categoria.dart';
import 'package:monitor_site_weellu/rotas/apiservice.dart';
import 'package:monitor_site_weellu/rotas/config.dart';
import 'package:monitor_site_weellu/screens/bussines/subcategorias.dart';

class DataNotfier extends ValueNotifier<List<ResponseModel>> {
  static final DataNotfier _instance = DataNotfier._internal();
  factory DataNotfier() => _instance;
  DataNotfier._internal() : super([]);

  List<ResponseModel> _categorias = [];

  final ApiService _apiService = ApiService(baseUrl: Config.apiUrlMaster);

  void removeCategory(String idCategoria) {
    _categorias
        .removeWhere((categoria) => categoria.idCategoria == idCategoria);
    value = List.from(_categorias);
  }

  Future<void> deleteCategory(String idCategoria) async {
    final url = Uri.parse(
        'https://api.weellu.com/api/v1/admin-panel/category/$idCategoria/delete');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'admin-key': 'super_password_for_admin',
        },
      );

      if (response.statusCode == 200) {
        removeCategory(idCategoria);
      } else {
        print('Erro ao excluir: ${response.statusCode}');
      }
    } catch (e) {
      print('Exceção ao excluir: $e');
    }
  }

  Future<List<ResponseModel>> fetchSubcategoriesModel() async {
    final url = '${Config.apiUrl}admin-panel/category/all';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'admin-key': 'super_password_for_admin',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> categoryData = data['data']['docs'] ?? [];

          List<ResponseModel> subcategories = [];

          // Itera sobre todas as categorias principais
          for (var category in categoryData) {
            List<dynamic> subcategoryList = category['subcategories'] ?? [];

            // Itera sobre as subcategorias de cada categoria
            for (var subcategory in subcategoryList) {
              // Substitui o parentCategoryId pelo nome da categoria principal
              subcategory['parentCategoryName'] = category['name'];
              subcategory['parentCategoryId'] =
                  category['name']; // Substitui ID por nome

              try {
                subcategories.add(ResponseModel.fromJson(subcategory));
              } catch (e) {
                print('Erro ao parsear subcategoria: $subcategory\nErro: $e');
              }
            }
          }

          return subcategories;
        } else {
          print('Erro: Estrutura de resposta inesperada.');
          return [];
        }
      } else {
        print('Erro na requisição: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Erro ao buscar subcategorias: $error');
      return [];
    }
  }

  Future<void> loadData() async {
    final url =
        Uri.parse('https://api.weellu.com/api/v1/admin-panel/category/all');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'admin-key': 'super_password_for_admin',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> docs = data['data']['docs'];
        _categorias = ResponseModel.fromJsonList(docs);
        value = List.from(_categorias);
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Exceção: $e');
    }
  }

  Future<void> sendData(
      {required String names,
      required BuildContext context,
      required String icons,
      required String iconColors}) async {
    String name = names;
    String icon = icons;
    String iconColor = iconColors; // Convertendo a cor para hex

    // Print para depuração
    print("Nome: $name");
    print("Ícone: $icon");
    print("Cor do ícone: $iconColor");

    // URL e headers
    var url =
        Uri.parse('https://api.weellu.com/api/v1/admin-panel/category/create');
    var headers = {
      'Content-Type': 'application/json',
      'admin-key': 'super_password_for_admin',
    };
    var body = jsonEncode({
      'name': name,
      'icon': icon,
      'iconColor': iconColor,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        // Nova categoria adicionada à lista
        final responseData = jsonDecode(response.body);
        final newCategory = ResponseModel.fromJson(responseData['data']);
        _categorias.add(newCategory);
        value = List.from(_categorias); // Notifica ouvintes sobre a mudança

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria criada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar a categoria!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão com o servidor!')),
      );
    }
  }

  Future<void> sendDataSubcategory(
      {required String names,
      required String IdCategorys,
      required BuildContext context,
      required String icons,
      required String iconColors}) async {
    String IdCategory = IdCategorys;
    String name = names;
    String icon = icons;
    String iconColor = iconColors; // Convertendo a cor para hex

    // Print para depuração
    print('Id da Categoria $IdCategory');
    print("Nome: $name");
    print("Ícone: $icon");
    print("Cor do ícone: $iconColor");

    // URL e headers
    var url =
        Uri.parse('https://api.weellu.com/api/v1/admin-panel/category/create');
    var headers = {
      'Content-Type': 'application/json',
      'admin-key': 'super_password_for_admin',
    };
    var body = jsonEncode({
      'name': name,
      'icon': icon,
      'iconColor': iconColor,
      'parentId': IdCategory
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        // Nova categoria adicionada à lista
        final responseData = jsonDecode(response.body);
        // final newCategory = ResponseModel.fromJson(responseData['data']);
        // _categorias.add(newCategory);
        // value = List.from(_categorias); // Notifica ouvintes sobre a mudança

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subcategoria criada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar a Subcategoria!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão com o servidor!')),
      );
    }
  }

  Future<void> updateData(
      {required String id,
      String? newName,
      String? newIcon,
      String? newIconColor,
      required String currentName,
      required String currentIcon,
      required String currentIconColor,
      required BuildContext context}) async {
    if ((newName == null || newName.isEmpty) &&
        (newIcon == null || newIcon.isEmpty) &&
        (newIconColor == null ||
            newIconColor.isEmpty ||
            newIconColor == "#FFFFFF")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma alteração fornecida!')),
      );
      return;
    }

    Map<String, dynamic> updateFields = {};
    if (newName != null && newName.isNotEmpty && newName != currentName) {
      updateFields['name'] = newName;
    }
    if (newIcon != null && newIcon.isNotEmpty && newIcon != currentIcon) {
      updateFields['icon'] = newIcon;
    }
    if (newIconColor != null &&
        newIconColor.isNotEmpty &&
        newIconColor != "#FFFFFF" &&
        newIconColor != currentIconColor) {
      updateFields['iconColor'] = newIconColor;
    }

    if (updateFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma alteração detectada!')),
      );
      return;
    }

    var url = Uri.parse(
        'https://api.weellu.com/api/v1/admin-panel/category/$id/update');
    var headers = {
      'Content-Type': 'application/json',
      'admin-key': 'super_password_for_admin',
    };
    var body = jsonEncode(updateFields);

    try {
      var response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria atualizada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar a categoria!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão com o servidor!')),
      );
    }
  }
}
