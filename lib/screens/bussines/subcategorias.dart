import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/models/categoria.dart';
import 'package:monitor_site_weellu/rotas/apiservice.dart';
import 'package:monitor_site_weellu/rotas/config.dart';
import 'package:monitor_site_weellu/screens/bussines/addCategorias.dart';
import 'package:monitor_site_weellu/screens/bussines/editCategorias.dart';
import 'package:monitor_site_weellu/screens/bussines/page_busines.dart';
import 'package:monitor_site_weellu/screens/bussines/popUp_delete.dart';
import 'package:monitor_site_weellu/utilitarios/datanotfier.dart';

class Subcategorias extends StatefulWidget {
  const Subcategorias({super.key});

  @override
  State<Subcategorias> createState() => _SubcategoriasState();
}

class _SubcategoriasState extends State<Subcategorias> {
  List<ResponseModel> _filteredSubcategorias = [];
  List<String> _categoriasList = [];
  String? _selectedCategory;
  List<ResponseModel> _Subcategorias = [];
  final ApiService _apiService = ApiService(baseUrl: Config.apiUrl);
  final DataNotfier _dataNotfier = DataNotfier();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchDropdownController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDataSubcategoria();
  }

  Future<void> loadDataSubcategoria() async {
    _Subcategorias = await _dataNotfier.fetchSubcategoriesModel();
    _filteredSubcategorias =
        List.from(_Subcategorias); // Inicializa o filtro com todos os dados
    _categoriasList = _Subcategorias.map((subcategoria) =>
            subcategoria.parentId.toString()) // Pegando os IDs das categorias
        .toSet()
        .toList();
    setState(() {});
  }

  // Função para aplicar o filtro
  void applyFilters() {
    String searchTerm = _searchController.text.toLowerCase();
    String? selectedCategory = _selectedCategory;

    // Filtra as subcategorias pela pesquisa no texto e pela categoria selecionada
    setState(() {
      _filteredSubcategorias = _Subcategorias.where((subcategoria) {
        bool matchesSearch =
            subcategoria.nameCategoria!.toLowerCase().contains(searchTerm);
        bool matchesCategory = selectedCategory == null ||
            subcategoria.parentId.toString() == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  // Função para limpar os filtros
  void clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedCategory = null;
      _filteredSubcategorias =
          List.from(_Subcategorias); // Exibe todos novamente
    });
  }

  Widget _ContainerStyler({required double width, required Widget conteudo}) {
    return Container(
      width: width,
      height: 60.sp,
      decoration: ShapeDecoration(
        color: Color(0xFF1F1F1F),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Color(0xFF686869),
          ),
        ),
      ),
      child: conteudo,
    );
  }

  Widget _HeaderContainerStyler({
    double padding = 0,
    required double width,
    required String text,
    Alignment alignment = Alignment.center,
    double BorderLeft = 0,
    double BorderRight = 0,
  }) {
    return Container(
      width: width,
      height: 60.sp,
      decoration: ShapeDecoration(
        color: Color(0xFF313131),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(BorderLeft),
              topRight: Radius.circular(BorderRight)),
          side: BorderSide(width: 1, color: Color(0xFF53555B)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: Align(
          alignment: alignment,
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFF7D7F87),
              fontSize: 20.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Container(
          // width: 1150.sp,
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
                      controller: _searchController, // Adiciona o controlador
                      onChanged: (value) {
                        applyFilters();
                      },
                      style: TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 20.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintStyle: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 20.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: "Pesquisar"),
                    ),
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          SizedBox(width: 5.sp),
                          Icon(PhosphorIcons.faders_horizontal_bold,
                              color: Color(0xFF7C7C7C)),
                          SizedBox(width: 10.sp),
                          Text(
                            'Filtrar Categoria',
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 20.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      items: _categoriasList.map((categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return CheckboxListTile(
                                title: Text(
                                  '$categoria',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                value: _selectedCategory ==
                                    categoria, // Marca a categoria selecionada
                                onChanged: (bool? isChecked) {
                                  setState(() {
                                    if (isChecked == true) {
                                      // Se o filtro for selecionado
                                      _selectedCategory = categoria;
                                    } else {
                                      // Se o filtro for desmarcado, deseleciona a categoria
                                      _selectedCategory = null;
                                    }
                                  });

                                  // Chama a função de filtro
                                  this.setState(() {
                                    applyFilters(); // Aplica os filtros com base na categoria selecionada
                                  });
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                        );
                      }).toList(),
                      dropdownSearchData: DropdownSearchData(
                        searchController: _searchDropdownController,
                        searchInnerWidgetHeight: 50.sp,
                        searchInnerWidget: Container(
                          height: 50.sp,
                          child: TextFormField(
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                            controller: _searchDropdownController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20.sp,
                                color: Color(0xFF7C7C7C),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.white, fontSize: 20.sp),
                              hintText: "Procurar Categoria",
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        _searchDropdownController
                            .clear(); // Limpa o texto de busca ao abrir o menu
                      },
                      onChanged:
                          (_) {}, // Não é necessário, pois usamos setState manualmente
                      buttonStyleData: ButtonStyleData(
                        height: 50.sp,
                        width: 260.sp,
                        decoration: BoxDecoration(
                          color: Color(0xFF202020),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        iconSize: 24.sp,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 300.sp,
                        width: 300.sp,
                        decoration: BoxDecoration(
                          color: Color(0xff313131),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 50.sp,
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      ),
                    ),
                  ),

                  //aquiiiiiiiii
                  // Container(
                  //   width: 220.sp,
                  //   height: 50.sp,
                  //   decoration: ShapeDecoration(
                  //     color: Color(0xFF202020),
                  //     shape: RoundedRectangleBorder(
                  //       side: BorderSide(width: 0.50, color: Color(0xFF7D7F87)),
                  //       borderRadius: BorderRadius.circular(5.sp),
                  //     ),
                  //   ),
                  //   child: DropdownButton<String>(
                  //     dropdownColor: Color(0xff1F1F1F),
                  //     value: _selectedCategory,
                  //     elevation: 16,
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //     underline: Container(
                  //       height: 2,
                  //       color: Colors.transparent,
                  //     ),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         if (_selectedCategory == newValue) {
                  //           // Se o valor selecionado for o mesmo que o anterior, "deseleciona"
                  //           _selectedCategory = null;
                  //         } else {
                  //           // Caso contrário, aplica o novo filtro
                  //           _selectedCategory = newValue;
                  //         }
                  //         applyFilters(); // Aplica o filtro sempre que a categoria mudar ou for "deselecionada"
                  //       });
                  //     },
                  //     items: _categoriasList
                  //         .map<DropdownMenuItem<String>>((String categoryId) {
                  //       return DropdownMenuItem<String>(
                  //         value: categoryId,
                  //         child: Text('Categoria $categoryId'),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),

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
                  _HeaderContainerStyler(
                      width: 102.sp, text: "#", BorderLeft: 5.sp),
                  _HeaderContainerStyler(width: 100.sp, text: "Ícone"),
                  _HeaderContainerStyler(width: 100.sp, text: "Cor"),
                  _HeaderContainerStyler(
                      padding: 20.sp,
                      width: 300.sp,
                      text: "Subcategories",
                      alignment: Alignment.centerLeft),
                  _HeaderContainerStyler(
                    width: 100.sp,
                    text: "Qnt",
                  ),
                  _HeaderContainerStyler(
                      width: 310.sp,
                      text: "Categories",
                      padding: 20.sp,
                      alignment: Alignment.centerLeft),
                  _HeaderContainerStyler(
                      width: 145.sp,
                      text: "Ações",
                      padding: 20.sp,
                      alignment: Alignment.centerLeft)
                ],
              ),
              Expanded(
                child: Container(
                  height: 300.sp,
                  // color: Colors.amber,
                  width: 1157.sp,
                  // height: 739.sp,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap:
                        true, // Faz a lista ocupar apenas o espaço necessário
                    // physics:
                    //     ClampingScrollPhysics(), // Impede o scroll da página quando a lista atinge o final
                    itemCount: _filteredSubcategorias.length,
                    itemBuilder: (context, index) {
                      int _hexToColor(String hexColor) {
                        hexColor = hexColor.replaceAll('#', '');
                        return int.tryParse('0xFF$hexColor') ?? 0xFF000000;
                      }

                      // Invertendo a ordem dos itens manualmente
                      final Subcategoria = _filteredSubcategorias[
                          _filteredSubcategorias.length - 1 - index];

                      // Fazendo a contagem reversa
                      final reverseIndex =
                          _filteredSubcategorias.length - index;
                      print(Subcategoria.colorIcon);
                      return _containerHeader(
                          // cor: Colors.w,
                          Subcategoria: Subcategoria,
                          idCategoria: Subcategoria.idCategoria.toString(),
                          index: reverseIndex.toString(),
                          Categorias: Subcategoria.parentId.toString(),
                          Subcategorias: Subcategoria.nameCategoria.toString(),
                          code: Subcategoria.iconName ?? 62791,
                          color: _hexToColor(Subcategoria.colorIcon.toString()),
                          cor: Subcategoria.colorIcon.toString());
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _containerHeader({
    required ResponseModel Subcategoria,
    required String idCategoria,
    required String index,
    required int code,
    Color corText = const Color(0xff7D7F87),
    required String Subcategorias,
    required String Categorias,
    required int color,
    required String cor,
  }) {
    return Row(
      children: [
        _ContainerStyler(
          width: 102.sp,
          conteudo: Center(
            child: Text(
              index,
              style: GoogleFonts.poppins(
                color: Color(0xff7D7F87),
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        _ContainerStyler(
          width: 100.sp,
          conteudo: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 5.sp),
            child: Container(
              // width: 10.sp,
              // height: 40.sp,
              decoration: ShapeDecoration(
                color: Color(0xFF313131),
                shape: OvalBorder(
                  side: BorderSide(
                    width: 1.05,
                    color: Color(0xFF686869),
                  ),
                ),
              ),
              child: Center(
                child: Icon(
                  PhosphorIconsData(code),
                  color: Color(color),
                  size: 25.sp,
                ),
              ),
            ),
          ),
        ),
        _ContainerStyler(
          width: 100.sp,
          conteudo: Center(
            child: Text(
              cor,
              style: TextStyle(
                color: Color(color),
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        _ContainerStyler(
          width: 300.sp,
          conteudo: Padding(
            padding: EdgeInsets.only(left: 20.sp),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Subcategorias,
                style: GoogleFonts.poppins(
                  color: Color(0xff7D7F87),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        _ContainerStyler(
          width: 100.sp,
          conteudo: Center(
            child: Text(
              '78',
              style: GoogleFonts.poppins(
                color: Color(0xff7D7F87),
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        _ContainerStyler(
          width: 310.sp,
          conteudo: Padding(
            padding: EdgeInsets.only(left: 20.sp),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Categorias,
                style: GoogleFonts.poppins(
                  color: Color(0xff7D7F87),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        _ContainerStyler(
          width: 145.sp,
          conteudo: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  bool? result = await showDialog(
                    context: context,
                    builder: (context) {
                      return Editcategorias(
                        color: color,
                        categoria: Subcategoria,
                      );
                    },
                  );
                  if (result == true) {
                    // Chama a função loadData após o fechamento do PopupDelete
                    loadDataSubcategoria();
                  }
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              Icon(
                Icons.remove_red_eye,
                size: 25.sp,
                color: Colors.white,
              ),
              InkWell(
                onTap: () async {
                  // Exibe o diálogo PopupDelete
                  bool? result = await showDialog(
                    context: context,
                    builder: (context) {
                      return PopupDelete(
                        idCategoria: idCategoria,
                      );
                    },
                  );

                  // Verifica se o resultado do PopupDelete foi bem-sucedido
                  if (result == true) {
                    // Chama a função loadData após o fechamento do PopupDelete
                    loadDataSubcategoria();
                  }
                },
                child: Icon(
                  Icons.delete,
                  size: 25.sp,
                  color: Colors.red,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
