import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:monitor_site_weellu/rotas/provider2.dart';
import 'package:monitor_site_weellu/utilitarios/responsive.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'modelIntegration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Modelo para os dados de integração

class Integration extends StatefulWidget {
  const Integration({super.key});

  @override
  State<Integration> createState() => _IntegrationState();
}

class _IntegrationState extends State<Integration> {
  List<IntegrationRequest> integrationRequests = [];
  String selectedStatus = 'Todos';
  String searchText = '';
  int currentPage = 0;
  final int itemsPerPage = 10;
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchIntegrationRequests();
    context.read<ProviderComment>().loadintegrations();
  }

  // Future<void> fetchIntegrationRequests() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://api.weellu.com/api/v1/admin-panel/users/api'),
  //       headers: {
  //         'admin-key': 'super_password_for_admin',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);

  //       if (data.containsKey('data') && data['data']['docs'] is List) {
  //         List<dynamic> integrationList = data['data']['docs'];
  //         setState(() {
  //           integrationRequests = integrationList
  //               .map((item) => IntegrationRequest.fromJson(item))
  //               .toList();
  //           // print(response.body);
  //           isLoading = false;
  //         });
  //       } else {
  //         throw Exception('Estrutura de dados inesperada');
  //       }
  //     } else {
  //       throw Exception('Erro ao buscar integrações');
  //     }
  //   } catch (error) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print(error);
  //   }
  // }

  List<IntegrationRequest> get filteredRequests {
    List<IntegrationRequest> filteredList = integrationRequests;

    if (selectedStatus != 'Todos') {
      filteredList = filteredList
          .where((request) => request.status == selectedStatus)
          .toList();
    }

    if (searchText.isNotEmpty) {
      filteredList = filteredList
          .where((request) => request.usuario
              .toLowerCase()
              .startsWith(searchText.toLowerCase()))
          .toList();
    }

    return filteredList;
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.yellow;
      default:
        return Colors.grey; // Cor padrão para status desconhecidos
    }
  }

  @override
  Widget build(BuildContext context) {
    List<IntegrationRequest> displayedRequests = filteredRequests
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    // return isLoading
    //     ? const Center(
    //         child: CircularProgressIndicator(),
    //       )
    return ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(30.sp),
                  child: Header(),
                ),
                // const modulo_card(),
                Padding(
                  padding: EdgeInsets.only(right: 30.sp, top: 80.sp),
                  child: StatusAndSearchBar(
                    selectedStatus: selectedStatus,
                    onStatusChanged: (status) {
                      setState(() {
                        selectedStatus = status!;
                      });
                    },
                    onSearchChanged: (query) {
                      setState(() {
                        searchText = query;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20.sp),
                Padding(
                  padding: EdgeInsets.only(left: 35.sp, right: 35.sp),
                  child: TableHeader(),
                ),
                Consumer<ProviderComment>(builder: (context, controller, _) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 30.sp, left: 30.sp),
                      child: ListView.builder(
                        itemCount: controller.newIntergration.length,
                        itemBuilder: (context, index) {
                          return IntegrationRow(
                            index: index,
                            request: controller.newIntergration[index],
                          );
                        },
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.sp),
                  child: PaginationControls(
                    currentPage: currentPage,
                    totalItems: filteredRequests.length,
                    itemsPerPage: itemsPerPage,
                    onPageChanged: (page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1600, 900), // Define o tamanho base do design
        minTextAdapt: true, // Habilitar adaptação mínima do texto
        builder: (context, child) {
          return Container(
            height: 90.sp,
            width: 1600.sp,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0.sp),
                  child: Text(
                    'Integração',
                    style: GoogleFonts.poppins(
                      color: Color(0xFFEAEAF0),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.67,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class StatusAndSearchBar extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String> onSearchChanged;

  const StatusAndSearchBar({
    Key? key,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 40.sp,
          width: 160.sp,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              onChanged: onStatusChanged,
              items: ['Todos', 'Approved', 'Pending', 'Rejected']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(
                        color: Color(0xFF292929),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.all(5),
          height: 40.sp,
          width: 170.sp,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color(0xff979797)),
          ),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Pesquisar',
              hintStyle:
                  TextStyle(color: Colors.white, fontSize: 20.sp, height: 1.4),
              prefixIcon: Icon(Icons.search, color: Colors.white),
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w300,
              // height: 1.2.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class TableHeader extends StatelessWidget {
  const TableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.sp,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 19, 17, 17),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildHeaderCell('Usuário', flex: 1),
          buildHeaderCell('Email', flex: 1),
          buildHeaderCell('Data de Solicitação', flex: 1),
          buildHeaderCell('Info de Integração', flex: 1),
          buildHeaderCell('Status', flex: 1),
          buildHeaderCell('Ações', flex: 1),
        ],
      ),
    );
  }

  Expanded buildHeaderCell(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.08, color: const Color(0xFF9E9E9E)),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: const Color(0xFFEAEAF0),
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class IntegrationRow extends StatelessWidget {
  final int index;
  final IntegrationRequest request;

  const IntegrationRow({
    Key? key,
    required this.index,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37.sp,
      color: index.isEven ? const Color.fromARGB(255, 30, 29, 29) : const Color.fromARGB(255, 19, 17, 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildDataCell(request.usuario, flex: 1),
          buildDataCell(request.email, flex: 1),
          buildDataCell(request.dataSolicitacao, flex: 1),
          buildDataCell(request.infoIntegracao, flex: 1),
          buildDataCell(request.status,
              flex: 1, color: getStatusColor(request.status)),
          ActionButtons(
            flex: 1,
            userId: request.email, // Assumindo que o email seja o ID do usuário
          ),
        ],
      ),
    );
  }

  Expanded buildDataCell(String data, {required int flex, Color? color}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(width: 0.08, color: Colors.grey)),
        child: Center(
          child: Text(
            data,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.montserrat(
              color: color ?? Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final int flex;
  final String userId;

  const ActionButtons({
    Key? key,
    required this.flex,
    required this.userId,
  }) : super(key: key);

  Future<void> updateRequestStatus(String status) async {
    final url = Uri.parse(
        'https://api.weellu.com/api/v1/admin-panel/users/api/$userId?status=$status');

    try {
      final response = await http.patch(
        url,
        headers: {
          'admin-key': 'super_password_for_admin',
        },
      );

      if (response.statusCode == 200) {
        // Sucesso na requisição
        print('Solicitação $status com sucesso.');
      } else {
        // Falha na requisição
        print('Erro ao $status a solicitação.');
      }
    } catch (error) {
      print('Erro ao realizar a requisição: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.08, color: Colors.grey),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // Adicione a ação desejada aqui
                },
                borderRadius: BorderRadius.circular(25.sp),
                child: Icon(
                  Icons.visibility,
                  color: Colors.white,
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 15.sp),
              InkWell(
                onTap: () {
                  updateRequestStatus('approved');
                  context.read<ProviderComment>().loadintegrations();
                },
                borderRadius: BorderRadius.circular(25.sp),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 15.sp),
              InkWell(
                onTap: () {
                  updateRequestStatus('rejected');
                  context.read<ProviderComment>().loadintegrations();
                },
                borderRadius: BorderRadius.circular(25.sp),
                child: Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 25.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalItems / itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:
              currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
        ),
        Text(
          '${currentPage + 1} de $totalPages',
          style: GoogleFonts.montserrat(
            color: const Color(0xFFEAEAF0),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: currentPage < totalPages - 1
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'approved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    case 'pending':
      return Colors.yellow;
    default:
      return Colors.grey; // Cor padrão para status desconhecidos
  }
}
