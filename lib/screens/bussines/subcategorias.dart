import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/models/categoria.dart';
import 'package:monitor_site_weellu/rotas/apiservice.dart';
import 'package:monitor_site_weellu/rotas/config.dart';
import 'package:monitor_site_weellu/screens/bussines/addCategorias.dart';
import 'package:monitor_site_weellu/screens/bussines/page_busines.dart';
import 'package:monitor_site_weellu/screens/bussines/popUp_delete.dart';
import 'package:monitor_site_weellu/utilitarios/datanotfier.dart';

class Subcategorias extends StatefulWidget {
  const Subcategorias({super.key});

  @override
  State<Subcategorias> createState() => _SubcategoriasState();
}

class _SubcategoriasState extends State<Subcategorias> {
  List<ResponseModel> _Subcategorias = [];
  final ApiService _apiService = ApiService(baseUrl: Config.apiUrl);
  final DataNotfier _dataNotfier = DataNotfier();

  @override
  void initState() {
    super.initState();
    loadDataSubcategoria();
  }

  Future<void> loadDataSubcategoria() async {
    _Subcategorias = await _dataNotfier.fetchSubcategoriesModel();
    setState(() {});
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
              Container(
                // color: Colors.amber,
                width: 1157.sp,
                // height: 739.sp,
                child: ListView.builder(
                  shrinkWrap:
                      true, // Faz a lista ocupar apenas o espaço necessário
                  physics:
                      ClampingScrollPhysics(), // Impede o scroll da página quando a lista atinge o final
                  itemCount: _Subcategorias.length,
                  itemBuilder: (context, index) {
                    int _hexToColor(String hexColor) {
                      hexColor = hexColor.replaceAll('#', '');
                      return int.tryParse('0xFF$hexColor') ?? 0xFF000000;
                    }

                    // Invertendo a ordem dos itens manualmente
                    final Subcategoria =
                        _Subcategorias[_Subcategorias.length - 1 - index];

                    // Fazendo a contagem reversa
                    final reverseIndex = _Subcategorias.length - index;
                    print(Subcategoria.colorIcon);
                    return _containerHeader(
                        // cor: Colors.w,
                        idCategoria: Subcategoria.idCategoria.toString(),
                        index: reverseIndex.toString(),
                        Categorias: Subcategoria.parentId.toString(),
                        Subcategorias: Subcategoria.nameCategoria.toString(),
                        code: Subcategoria.iconName as int ?? 62791,
                        color: _hexToColor(Subcategoria.colorIcon.toString()),
                        cor: Subcategoria.colorIcon.toString()

                        // categoria: categoria,
                        // idCategoria: categoria.idCategoria.toString(),
                        // color: _hexToColor(categoria.colorIcon.toString()),
                        // nomeCategoria: categoria.nameCategoria.toString(),
                        // code: categoria.iconName as int ?? 62791,
                        // index: reverseIndex, // Começando do maior para o menor
                        // cor: categoria.colorIcon.toString(),
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

  Widget _containerHeader({
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
