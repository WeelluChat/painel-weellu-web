import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/utilitarios/icones_phospor.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  // Controladores de texto
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  // Filtro para armazenar os ícones filtrados
  List<String> filteredIcons = [];
  String currentFilter = ''; // Para armazenar o filtro atual
  String? selectedIconName; // Nome do ícone selecionado
  Color selectedColor = Colors.black; // Cor do ícone selecionado
  int? selectedIconCode;

  @override
  void initState() {
    super.initState();
    filteredIcons =
        phosphorIconsMap.keys.toList(); // Inicializa com todos os ícones
  }

  // Função de filtragem por nome
  void _filterIconsByName(String query) {
    setState(() {
      filteredIcons = phosphorIconsMap.keys
          .where((iconName) =>
              iconName.toLowerCase().contains(query.toLowerCase()) &&
              (currentFilter.isEmpty || iconName.contains(currentFilter)))
          .toList();
    });
  }

  // Função de filtragem por estilo (bold, fill, etc.)
  void _filterByStyle(String style) {
    setState(() {
      currentFilter = style; // Define o filtro atual
      filteredIcons = phosphorIconsMap.keys
          .where((iconName) =>
              iconName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) &&
              iconName.contains(style))
          .toList();
    });
  }

  // Função para selecionar a cor do ícone
  void _selectColor() async {
    Color pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Escolha uma cor"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );

    if (pickedColor != null) {
      setState(() {
        selectedColor = pickedColor;
      });
    }
  }

  // Função para enviar os dados para a API
  Future<void> _sendData() async {
    String name = _nameController.text;
    String icon = selectedIconCode.toString() ?? "";
    String iconColor =
        "#${selectedColor.value.toRadixString(16).substring(2)}"; // Convertendo a cor para hex

    // Print para ver o que está sendo enviado
    print("Nome: $name");
    print("Ícone: $icon");
    print("Cor do ícone: $iconColor");

    // URL e header da requisição
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
      if (response.statusCode == 200) {
        // Sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria criada com sucesso!')),
        );
      } else {
        // Falha
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar a categoria!')),
        );
      }
    } catch (e) {
      // Erro de requisição
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão com o servidor!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String teste = "PhosphorIcons.car";
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Container(
          color: Color(0xff181818),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Criar novas Categorias',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 250.sp,
                            // height: 40.sp,
                            decoration: ShapeDecoration(
                              color: Color(0xFF313131),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.sp)),
                            ),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.ubuntu(
                                  color: Color(0xFF707070),
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                hintText: 'Nome da Categoria',
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged:
                                  _filterIconsByName, // Atualiza o filtro sempre que o texto mudar
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 230.sp,
                            height: 40.sp,
                            decoration: BoxDecoration(
                              color: Color(0xFF313131),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7)),
                              border: Border(
                                bottom: BorderSide(
                                    width: 0.50, color: Color(0xFF707070)),
                              ),
                            ),
                          ),
                          Container(
                            width: 140.sp,
                            height: 40.sp,
                            decoration: BoxDecoration(
                              color: Color(0xFF313131),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(7)),
                              border: Border(
                                bottom: BorderSide(
                                    width: 0.50, color: Color(0xFF707070)),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 370.sp,
                        height: 500.sp,
                        decoration: ShapeDecoration(
                          color: Color(0xFF313131),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Categorias Existentes',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: 480.sp,
                        height: 390.sp,
                        decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _categorias({required int code, required int cor}) {
    return Column(
      children: [
        Container(
          width: 50.sp,
          height: 50.sp,
          decoration: ShapeDecoration(
            color: Color(0xFF262626),
            shape: OvalBorder(
              side: BorderSide(width: 1, color: Color(0xFF464646)),
            ),
          ),
          child: Center(
            child: Icon(
              PhosphorIconsData(code),
              color: Color(cor),
              size: 25.sp,
            ),
          ),
        ),
        SizedBox(
          height: 10.sp,
        ),
        Text(
          'Alieniginas',
          style: TextStyle(
            color: Color(0xFF707070),
            fontSize: 19.sp,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
