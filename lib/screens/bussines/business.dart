import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/models/categoria.dart';
import 'package:monitor_site_weellu/rotas/apiservice.dart';
import 'package:monitor_site_weellu/rotas/config.dart';
import 'package:monitor_site_weellu/screens/bussines/addCategorias.dart';
import 'package:monitor_site_weellu/screens/bussines/addSubcategory.dart';
import 'package:monitor_site_weellu/screens/bussines/editCategorias.dart';
import 'package:monitor_site_weellu/screens/bussines/page_busines.dart';
import 'package:monitor_site_weellu/screens/bussines/popUp_delete.dart';
import 'package:monitor_site_weellu/screens/bussines/subcategorias.dart';
import 'package:monitor_site_weellu/utilitarios/datanotfier.dart';
import 'package:monitor_site_weellu/utilitarios/icones_phospor.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

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
  List<ResponseModel> _categorias = [];
  String currentFilter = ''; // Para armazenar o filtro atual
  String? selectedIconName; // Nome do ícone selecionado
  Color selectedColor = Colors.black; // Cor do ícone selecionado
  int? selectedIconCode;
  final ApiService _apiService = ApiService(baseUrl: Config.apiUrl);
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
    filteredIcons =
        phosphorIconsMap.keys.toList(); // Inicializa com todos os ícones
  }

  Future<void> _loadData() async {
    _categorias = await _apiService.fetchCategoriesModel();
    setState(() {});
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

  Widget _containerBussines({required String text}) {
    return IntrinsicWidth(
      child: Container(
        height: 40.sp,
        decoration: ShapeDecoration(
          color: Color(0xFF1A1A1B),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.sp)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Color(0xFF9C9C9C),
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _containerInfo() {
    return Container(
      width: 360.sp,
      height: 190.sp,
      decoration: ShapeDecoration(
        color: Color(0xFF171718),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.75,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFF53545B),
          ),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 0.71,
          )
        ],
      ),
    );
  }

  List<Widget> pages = [
    PageBusines(),
    Bussinespage(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      indexSelected = index; // Atualiza o item selecionado
    });
  }

  List<Map<String, dynamic>> Headers = [
    {'text': 'Business'},
    {'text': 'Settings'},
    {'text': 'Adversiting'}
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Container(
          color: Color(0xff0F0F0F),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.sp),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Business Dashboard',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 35.sp,
                        // fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.sp,
                  ),
                  Row(
                    children: [
                      _containerBussines(text: "Today"),
                      SizedBox(
                        width: 5.sp,
                      ),
                      _containerBussines(text: 'Weekly'),
                      SizedBox(
                        width: 5.sp,
                      ),
                      _containerBussines(text: "Monthly"),
                      SizedBox(
                        width: 5.sp,
                      ),
                      _containerBussines(text: "Anual"),
                      SizedBox(
                        width: 5.sp,
                      ),
                      _containerBussines(text: "Total"),
                    ],
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _containerInfo(),
                      _containerInfo(),
                      _containerInfo(),
                      _containerInfo(),
                    ],
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _containerInfo(),
                      _containerInfo(),
                      _containerInfo(),
                      _containerInfo(),
                    ],
                  ),
                  SizedBox(
                    height: 60.sp,
                  ),
                  _HeaderMenu(),
                  Container(
                    width: 1540.sp,
                    height: 900.sp,
                    decoration: BoxDecoration(
                      color: Color(0xFF171718),
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10.sp)),
                      border: Border(
                        left: BorderSide(
                          width: 0.75,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF53545B),
                        ),
                        top: BorderSide(
                          width: 0.75,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF53545B),
                        ),
                        right: BorderSide(
                          width: 0.75,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF53545B),
                        ),
                        bottom: BorderSide(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF53545B),
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 0,
                          offset: Offset(0, 0),
                          spreadRadius: 0.71,
                        )
                      ],
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 25.sp, right: 30.sp, left: 30.sp),
                        child: pages[indexSelected]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _HeaderMenu() {
    return Row(
      children: List.generate(
        Headers.length,
        (index) {
          return InkWell(
            onTap: () => _onItemSelected(index),
            child: Container(
              width: 180.sp,
              height: 60.sp,
              decoration: BoxDecoration(
                color: indexSelected == index
                    ? Color(0xFF181818)
                    : Color(0xFF0F0F0F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.sp),
                  topRight: Radius.circular(10.sp),
                ),
                border: Border(
                  left: BorderSide(
                    width: 0.75,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF53555B),
                  ),
                  top: BorderSide(
                    width: 0.75,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF53555B),
                  ),
                  right: BorderSide(
                    width: 0.75,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF53555B),
                  ),
                  bottom: BorderSide(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF53555B),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  Headers[index]['text'],
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _categorieas({required int code, required int cor}) {
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

class Categorias extends StatefulWidget {
  const Categorias({super.key});

  @override
  State<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  final DataNotfier dataNotfier = DataNotfier();
  final ApiService _apiService = ApiService(baseUrl: Config.apiUrl);

  @override
  void initState() {
    super.initState();
    dataNotfier.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ResponseModel>>(
      valueListenable: dataNotfier,
      builder: (context, categorias, child) {
        // if (categorias.isEmpty) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 500.sp,
                    // height: 50.sp,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1F1F1F),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.75, color: Color(0xFF53555B)),
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Pesquisar"),
                    ),
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  Container(
                    width: 170.sp,
                    height: 50.sp,
                    decoration: ShapeDecoration(
                      color: Color(0xFF202020),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFF7D7F87)),
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierColor: Color.fromARGB(141, 87, 87, 87),
                        context: context,
                        builder: (context) {
                          return Addcategorias();
                        },
                      );
                    },
                    child: Container(
                      width: 120.sp,
                      height: 50.sp,
                      decoration: ShapeDecoration(
                        color: Color(0xFF009D6D),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.sp)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 25.sp,
                          ),
                          Text(
                            'Add',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 17.sp,
                              // fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.sp,
              ),
              Row(
                children: [
                  headerContainer(
                      text: "#",
                      width: 80.sp,
                      borderLeft: 8.sp,
                      borderRight: 0),
                  headerContainer(
                    text: 'Icon',
                    width: 105.sp,
                  ),
                  headerContainer(text: "Color", width: 120.sp),
                  headerContainer(text: "Items", width: 100.sp),
                  headerContainer(
                      text: "Categories",
                      width: 580.sp,
                      alignment: Alignment.centerLeft),
                  headerContainer(text: "Ações", width: 150.sp, borderRight: 8)
                ],
              ),
              Container(
                width: 1135.sp,
                height: 739.sp,
                child: ListView.builder(
                  shrinkWrap:
                      true, // Faz a lista ocupar apenas o espaço necessário
                  physics:
                      ClampingScrollPhysics(), // Impede o scroll da página quando a lista atinge o final
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    int _hexToColor(String hexColor) {
                      hexColor = hexColor.replaceAll('#', '');
                      return int.tryParse('0xFF$hexColor') ?? 0xFF000000;
                    }

                    // Invertendo a ordem dos itens manualmente
                    final categoria = categorias[categorias.length - 1 - index];

                    // Fazendo a contagem reversa
                    final reverseIndex = categorias.length - index;
                    print(categoria.colorIcon);
                    return _categoriasTable(
                      categoria: categoria,
                      idCategoria: categoria.idCategoria.toString(),
                      color: _hexToColor(categoria.colorIcon.toString()),
                      nomeCategoria: categoria.nameCategoria.toString(),
                      code: categoria.iconName as int ?? 62791,
                      index: reverseIndex, // Começando do maior para o menor
                      cor: categoria.colorIcon.toString(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoriasTable(
      {required ResponseModel categoria,
      required String cor,
      required String idCategoria,
      required int color,
      required int index,
      required int code,
      required String nomeCategoria}) {
    return Row(
      children: [
        Row(
          children: [
            headerContainer(
                text: '${index}', width: 80.sp, cor: Color(0xff1F1F1F)),
            headerContainer(
              width: 105.sp,
              cor: Color(0xff1F1F1F),
              customChild: Container(
                width: 40.sp,
                height: 40.sp,
                decoration: ShapeDecoration(
                  color: Color(0xFF313131),
                  shape: OvalBorder(
                    side: BorderSide(width: 1.05, color: Color(0xFF686869)),
                  ),
                ),
                child: Center(
                  child: Icon(
                    PhosphorIconsData(code),
                    color: Color(color),
                  ),
                ),
              ),
            ),
            headerContainer(
              width: 120.sp,
              corText: Color(color),
              text: cor,
              cor: Color(0xff1F1F1F),
            ),
            headerContainer(
              width: 100.sp,
              text: "76",
              cor: Color(0xff1F1F1F),
            ),
            headerContainer(
              alignment: Alignment.centerLeft,
              width: 580.sp,
              text: nomeCategoria,
              cor: Color(0xff1F1F1F),
            ),
            headerContainer(
              customChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Addsubcategory(
                            categoryId: idCategoria,
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Editcategorias(
                            color: color,
                            categoria: categoria,
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PopupDelete(
                            idCategoria: idCategoria,
                            // ontap: () {
                            //   dataNotfier.deleteCategory(idCategoria);
                            // },
                          );
                        },
                      );
                      // dataNotfier.deleteCategory(idCategoria);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Color(0xffFF3032),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              width: 150.sp,
              cor: Color(0xff1F1F1F),
            )
          ],
        ),
      ],
    );
  }

  Widget headerContainer(
      {String? text, // Agora pode ser nulo
      Widget? customChild, // Novo parâmetro para substituir o texto
      Color cor = const Color(0xFF313131),
      required double width,
      double borderLeft = 0,
      double borderRight = 0,
      Alignment alignment = Alignment.center,
      Color corText = const Color(0xff7D7F87)}) {
    return Container(
      width: width,
      height: 55.sp,
      decoration: ShapeDecoration(
        color: cor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.80, color: Color(0xFF53555B)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderLeft),
            topRight: Radius.circular(borderRight),
          ),
        ),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child:
              customChild ?? // Se customChild existir, usa ele, senão usa o texto
                  Text(
                    text ?? "",
                    style: GoogleFonts.poppins(
                      color: corText,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
        ),
      ),
    );
  }
}

class MenuCategorias extends StatefulWidget {
  @override
  _MenuCategoriasState createState() => _MenuCategoriasState();
}

class _MenuCategoriasState extends State<MenuCategorias> {
  int selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      selectedIndex = index; // Atualiza o item selecionado
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categorias = [
      {'icone': PhosphorIcons.list, 'text': 'Categories'},
      {'icone': PhosphorIcons.list_dashes, 'text': 'Subcategories'},
    ];

    return Column(
      children: List.generate(categorias.length, (index) {
        return InkWell(
          onTap: () {
            _onItemSelected(index);
          },
          child: Container(
            width: 220.sp,
            height: 40.sp,
            decoration: ShapeDecoration(
              color: selectedIndex == index
                  ? Color(0xFF112720)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.50,
                  color: selectedIndex == index
                      ? Color(0xFF009D6D)
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(4.sp),
              ),
              shadows: selectedIndex == index
                  ? [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 0,
                        offset: Offset(0, 0),
                        spreadRadius: 0.50,
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                SizedBox(width: 10.sp),
                Icon(
                  categorias[index]['icone'],
                  size: 25.sp,
                  color: selectedIndex == index
                      ? Color(0xff009D6D)
                      : Color(0xff7D7F87),
                ),
                SizedBox(width: 10.sp),
                Text(
                  categorias[index]['text'],
                  style: TextStyle(
                    color: selectedIndex == index
                        ? Color(0xFF009D6D)
                        : Color(0xff7D7F87),
                    fontSize: 17.30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class Bussinespage extends StatefulWidget {
  const Bussinespage({super.key});

  @override
  State<Bussinespage> createState() => _BussinespageState();
}

class _BussinespageState extends State<Bussinespage> {
  int selectedMenuIndex = 0;

  void _onMenuItemSelected(int index) {
    setState(() {
      selectedMenuIndex = index; // Atualiza o item selecionado
    });
  }

  List<Map<String, dynamic>> categorias = [
    {'icone': PhosphorIcons.list, 'text': 'Categories'},
    {'icone': PhosphorIcons.list_dashes, 'text': 'Subcategories'},
  ];

  Widget _MenuCategorias() {
    return Column(
      children: List.generate(categorias.length, (index) {
        return InkWell(
          onTap: () {
            _onMenuItemSelected(index);
          },
          child: Container(
            width: 220.sp,
            height: 40.sp,
            decoration: ShapeDecoration(
              color: selectedMenuIndex == index
                  ? Color(0xFF112720)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.50,
                  color: selectedMenuIndex == index
                      ? Color(0xFF009D6D)
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(4.sp),
              ),
              shadows: selectedMenuIndex == index
                  ? [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 0,
                        offset: Offset(0, 0),
                        spreadRadius: 0.50,
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                SizedBox(width: 10.sp),
                Icon(
                  categorias[index]['icone'],
                  size: 25.sp,
                  color: selectedMenuIndex == index
                      ? Color(0xff009D6D)
                      : Color(0xff7D7F87),
                ),
                SizedBox(width: 10.sp),
                Text(
                  categorias[index]['text'],
                  style: TextStyle(
                    color: selectedMenuIndex == index
                        ? Color(0xFF009D6D)
                        : Color(0xff7D7F87),
                    fontSize: 17.30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> telas = [Categorias(), Subcategorias()];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 270.sp,
              height: 900.sp,
              decoration: ShapeDecoration(
                color: Color(0xFF1F1F1F),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.80, color: Color(0xFF53555B)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9.sp),
                    topRight: Radius.circular(9.sp),
                  ),
                ),
              ),
              child: Column(
                children: [_MenuCategorias()],
              ),
            ),
            telas[selectedMenuIndex]
          ],
        );
      },
    );
  }
}
