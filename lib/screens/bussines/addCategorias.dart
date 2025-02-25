import 'dart:convert';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/utilitarios/datanotfier.dart';
import 'package:monitor_site_weellu/utilitarios/icones_phospor.dart';

class Addcategorias extends StatefulWidget {
  const Addcategorias({super.key});

  @override
  State<Addcategorias> createState() => _AddcategoriasState();
}

class _AddcategoriasState extends State<Addcategorias> {
  // Função para filtrar os ícones com base no texto de pesquisa
  List<MapEntry<String, IconData>> _filterIcons(String query) {
    return phosphorIconsMap.entries
        .where((entry) => entry.key.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  TextEditingController _searchController =
      TextEditingController(); // Controlador para o campo de pesquisa
  String _searchQuery = ''; // Variável que armazena o texto de pesquisa
  final TextEditingController _categoriaController = TextEditingController();
  IconData? _selectedIcon; // Variável para armazenar o ícone selecionado
  // Posições iniciais do círculo (horizontal e vertical)
  double _circlePositionX = 0.0;
  double _circlePositionY = 0.0;
  double _GreencirclePositionX = 0.0;
  Color _selectedColor = Colors.white; // Variável para armazenar a cor

  // Lista de cores do gradiente
  final List<Color> gradientColors = [
    Color(0xFFFF0000), // Vermelho
    Color(0xFFFF4D00), // Laranja avermelhado
    Color(0xFFFF8600), // Laranja
    Color(0xFFFFC100), // Amarelo alaranjado
    Color(0xFFFFF400), // Amarelo
    Color(0xFFD4FF00), // Amarelo esverdeado
    Color(0xFF68FF00), // Verde limão
    Color(0xFF00FF40), // Verde claro
    Color(0xFF00FFCE), // Verde água
    Color(0xFF00CFFF), // Azul esverdeado
    Color(0xFF0020FF), // Azul
    Color(0xFF5100FF), // Azul arroxeado
    Color(0xFFAE00FF), // Roxo
    Color(0xFFE200FF), // Roxo rosado
    Color(0xFFFF00C7), // Rosa
    Color(0xFFFF0085), // Rosa avermelhado
    Color(0xFFFF0000), // Retorno ao Vermelho para continuidade
  ];

  // Color _selectedColor =
  //     const Color.fromARGB(255, 255, 255, 255); // Cor padrão inicial

  Color _getColorTonalidadePosition(Color baseColor, double positionX) {
    double normalizedPosition = positionX / 950; // Normaliza entre 0 e 1

    // Define tons mais claros e escuros da cor base
    Color lighterColor =
        Color.lerp(baseColor, Colors.white, 0.5)!; // Mais claro
    Color darkerColor =
        Color.lerp(baseColor, Colors.black, 0.5)!; // Mais escuro

    // Interpolação da tonalidade
    return Color.lerp(lighterColor, darkerColor, normalizedPosition)!;
  }

  // Função que calcula a cor com base na posição do círculo
  Color _getColorAtPosition(double position) {
    double segmentWidth = 956.0 / (gradientColors.length - 1);
    int index = (position / segmentWidth).floor();
    return gradientColors[index];
  }

  // Color _getColorTonalidadePosition(double positionX) {
  //   // Normaliza a posição para um valor entre 0 e 1
  //   double normalizedPosition = positionX / 950;

  //   // Interpola entre as cores do gradiente
  //   return Color.lerp(Colors.black, Colors.white, normalizedPosition)!;
  // }

  // Função para obter o código hexadecimal da cor
  String _getHexColor(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  // Função para enviar os dados para a API
  // Future<void> _sendData() async {
  //   String name = _categoriaController.text;
  //   String icon = _selectedIcon?.codePoint.toString() ?? "";
  //   String iconColor = _getHexColor(_getColorTonalidadePosition(
  //       _selectedColor, _circlePositionX)); // Convertendo a cor para hex

  //   // Print para ver o que está sendo enviado
  //   print("Nome: $name");
  //   print("Ícone: $icon");
  //   print("Cor do ícone: $iconColor");

  //   // URL e header da requisição
  //   var url =
  //       Uri.parse('https://api.weellu.com/api/v1/admin-panel/category/create');
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'admin-key': 'super_password_for_admin',
  //   };
  //   var body = jsonEncode({
  //     'name': name,
  //     'icon': icon,
  //     'iconColor': iconColor,
  //   });

  //   try {
  //     var response = await http.post(url, headers: headers, body: body);
  //     if (response.statusCode == 201) {
  //       // Sucesso
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Categoria criada com sucesso!')),
  //       );
  //     } else {
  //       // Falha
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Erro ao criar a categoria!')),
  //       );
  //     }
  //   } catch (e) {
  //     // Erro de requisição
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Erro de conexão com o servidor!')),
  //     );
  //   }
  // }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          title: Text("Selecione uma cor"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedColor = tempColor;
                });
                Navigator.pop(context);
              },
              child: Text("Selecionar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: 1062.sp,
            height: 956.sp,
            decoration: ShapeDecoration(
              color: Color(0xFF181818),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.sp, vertical: 25.sp),
              child: Column(
                children: [
                  Text(
                    'New Category',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 15.sp),
                  Container(
                    width: 950.sp,
                    // height: 50.sp,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1F1F1F),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.68, color: Color(0xFF53555B)),
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      child: Row(
                        children: [
                          Text(
                            'Name:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Container(
                            width: 300.sp,
                            child: TextFormField(
                              controller: _categoriaController,
                              style: TextStyle(
                                color: Color(0xFF3E3E3E),
                                fontSize: 18.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write a Category name'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.sp),
                  Text(
                    'Select icon color',
                    style: TextStyle(
                      color: Color(0xFFB4B4B4),
                      fontSize: 20.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 15.sp),

                  // Container de seletor de tonalidade de cor
                  // Container(
                  //   width: 950.sp,
                  //   height: 100.sp,
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(colors: [
                  //       Colors.black, // Cor escura no lado esquerdo
                  //       _getColorAtPosition(_GreencirclePositionX),
                  //       Colors.white, // Cor clara no lado direito
                  //     ]),
                  //   ),
                  //   child: Stack(
                  //     children: [
                  //       Positioned(
                  //         left: _circlePositionX,
                  //         top: _circlePositionY,
                  //         child: GestureDetector(
                  //           onPanUpdate: (details) {
                  //             setState(() {
                  //               _circlePositionX = details.localPosition.dx;
                  //               _circlePositionY = details.localPosition.dy;

                  //               // Garante que o círculo fica dentro dos limites
                  //               _circlePositionX =
                  //                   _circlePositionX.clamp(0.0, 950.0 - 28.66);
                  //               _circlePositionY =
                  //                   _circlePositionY.clamp(0.0, 100.0 - 28.66);

                  //               // Atualiza a cor selecionada
                  //               _selectedColor = _getColorTonalidadePosition(
                  //                   _selectedColor, _GreencirclePositionX);
                  //             });
                  //           },
                  //           child: Container(
                  //             width: 28.sp,
                  //             height: 28.sp,
                  //             decoration: ShapeDecoration(
                  //               color: Colors.white,
                  //               shape: OvalBorder(
                  //                 side: BorderSide(
                  //                   width: 2.32,
                  //                   strokeAlign: BorderSide.strokeAlignCenter,
                  //                   color: Colors.black,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // SizedBox(height: 15.sp),

                  // Container do seletor de cor
                  // Container(
                  //   width: 956.sp,
                  //   height: 40.sp,
                  //   child: Stack(
                  //     children: [
                  //       // Gradiente de cores
                  //       Positioned(
                  //         left: 0,
                  //         top: 7.75,
                  //         child: Container(
                  //           width: 956.55.sp,
                  //           height: 13.17.sp,
                  //           decoration: ShapeDecoration(
                  //             gradient: LinearGradient(
                  //               begin: Alignment(1.00, 0.00),
                  //               end: Alignment(-1, 0),
                  //               colors: gradientColors,
                  //             ),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(8.sp),
                  //             ),
                  //           ),
                  //         ),
                  //       ),

                  //       // Círculo movível
                  //       Positioned(
                  //         left: _GreencirclePositionX,
                  //         // top: _circlePositionY,
                  //         child: GestureDetector(
                  //           onPanUpdate: (details) {
                  //             setState(() {
                  //               // Atualiza a posição do círculo em ambas as direções
                  //               _GreencirclePositionX =
                  //                   details.localPosition.dx;
                  //               // _circlePositionY = details.localPosition.dy;

                  //               // Limita o movimento dentro da área permitida
                  //               if (_GreencirclePositionX < 0) {
                  //                 _GreencirclePositionX = 0;
                  //               } else if (_GreencirclePositionX >
                  //                   956 - 28.66) {
                  //                 _GreencirclePositionX = 956 - 28.66;
                  //               }

                  //               // if (_circlePositionY < 0) {
                  //               //   _circlePositionY = 0;
                  //               // } else if (_circlePositionY > 171 - 28.66) {
                  //               //   _circlePositionY = 171 - 28.66;
                  //               // }
                  //             });
                  //           },
                  //           child: Container(
                  //             width: 30.sp,
                  //             height: 30.sp,
                  //             decoration: ShapeDecoration(
                  //               color: Color(0xFF48FF40),
                  //               shape: OvalBorder(
                  //                 side: BorderSide(
                  //                   width: 2.32,
                  //                   strokeAlign: BorderSide.strokeAlignCenter,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(height: 15.sp),

                  // Exibindo a cor hexadecimal selecionada
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Adicione o filtro de pesquisa aqui

                      Container(
                        width: 460.sp,
                        // height: 50.sp,
                        decoration: ShapeDecoration(
                          color: Color(0xBF303030),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value; // Atualiza a pesquisa
                            });
                          },
                          style: GoogleFonts.poppins(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Pesquisar ícones...",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.sp),
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                          ),
                        ),
                      ),

                      Container(
                        width: 480.sp,
                        height: 80.sp,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFF53555B)),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 240.sp,
                              height: 55.sp,
                              decoration: ShapeDecoration(
                                color: Color(
                                    0xFF2B2B2B), // Atualiza a cor do container
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                ),
                              ),
                              child: InkWell(
                                onTap: () => _pickColor(context),
                                child: Center(
                                  child: Text(
                                    'Selecionar Cor',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 100.sp,
                              height: 50.sp,
                              decoration: ShapeDecoration(
                                color: Color(0xBF303030),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _getHexColor(_getColorTonalidadePosition(
                                      _selectedColor, _circlePositionX)),
                                  style: GoogleFonts.poppins(
                                    color: _getColorTonalidadePosition(
                                        _selectedColor, _circlePositionX),
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 70.sp,
                              height: 70.sp,
                              decoration: ShapeDecoration(
                                color: Color(0xFF313131),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.50, color: Color(0xFF686869)),
                                  borderRadius: BorderRadius.circular(34.sp),
                                ),
                              ),
                              child: _selectedIcon != null
                                  ? Icon(_selectedIcon,
                                      size: 50.sp, color: _selectedColor)
                                  : SizedBox(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),

                  SizedBox(
                    height: 20.sp,
                  ),
                  Container(
                    width: 950.sp,
                    height: 310.sp,
                    decoration: BoxDecoration(
                      color: Color(0xBF303030),
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 19,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount:
                          _filterIcons(_searchQuery).length, // Use o filtro
                      itemBuilder: (context, index) {
                        String iconName = _filterIcons(_searchQuery)[index].key;
                        IconData iconData =
                            _filterIcons(_searchQuery)[index].value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon =
                                  iconData; // Atualiza o ícone selecionado
                            });
                          },
                          child: Tooltip(
                            message: iconName,
                            child: Icon(
                              iconData,
                              size: 30.sp,
                              color: _selectedIcon == iconData
                                  ? _selectedColor // Cor diferente para ícone selecionado
                                  : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(height: 20),
                  // // Exibição do ícone selecionado
                  // _selectedIcon != null
                  //     ? Icon(_selectedIcon, size: 50, color: Colors.blue)
                  //     : Text(
                  //         "Nenhum ícone selecionado",
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 340.sp,
                        height: 55.sp,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFF5151),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancelar',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.sp,
                      ),
                      InkWell(
                        onTap: () {
                          DataNotfier().sendData(
                              context: context,
                              names: _categoriaController.text,
                              icons: _selectedIcon?.codePoint.toString() ?? "",
                              iconColors: _getHexColor(
                                  _getColorTonalidadePosition(
                                      _selectedColor, _circlePositionX)));
                        },
                        child: Container(
                          width: 340.sp,
                          height: 55.sp,
                          decoration: ShapeDecoration(
                            color: Color(0xFF22C55E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Salvar',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
