import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'estilizadores_Page_User.dart';
import 'modelsClients.dart';

class UsersPages extends StatefulWidget {
  const UsersPages({super.key});

  @override
  State<UsersPages> createState() => _UsersPagesState();
}

class _UsersPagesState extends State<UsersPages> {
  List<Modelsclients> users = [];
  List<Modelsclients> filteredUsers = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  String searchQuery = "";
  String filterOption = 'Todos';
  String selectedCountry = 'Todos'; // Novo filtro para o país

  final DateTime currentDate = DateTime.now();
  final Duration newUserDuration = Duration(days: 7);

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    while (hasMore && !isLoading) {
      await fetchUsers();
    }
  }

  Future<void> fetchUsers() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://api.weellu.com/api/v1/admin-panel/users?page=$page'),
      headers: {
        'admin-key': 'super_password_for_admin',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final apiUsers = List<Modelsclients>.from(
        data['data']['docs'].map(
          (user) => Modelsclients.fromJson(user),
        ),
      );

      // Carregar os usuários do Hive
      var box = await Hive.openBox<Modelsclients>('modelsclients');
      final storedUsers = box.values.toList();

      // Filtrar novos usuários
      final newUsers = apiUsers.where((apiUser) {
        return !storedUsers.any((storedUser) => storedUser.id == apiUser.id);
      }).toList();

      // Salvar novos usuários no Hive
      for (var user in newUsers) {
        await box.put(user.id, user);
      }

      // Atualizar a lista de usuários com todos (incluindo novos)
      setState(() {
        users = storedUsers + newUsers;
        applyFilter(); // Aplica a filtragem após a busca
        isLoading = false;
        page++;
        hasMore = data['data']['docs'].length == 30;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Erro ao buscar usuários: ${response.statusCode}');
    }
  }

  void applyFilter() {
    setState(() {
      filteredUsers = users.where((user) {
        final isUserNew = isNewUser(user.createdAt);
        final matchesSearchQuery =
            user.fullName.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCountry =
            selectedCountry == 'Todos' || user.countryCode == selectedCountry;

        if (filterOption == 'Novos') {
          return isUserNew && matchesSearchQuery && matchesCountry;
        } else {
          return matchesSearchQuery && matchesCountry;
        }
      }).toList();
    });
  }

  void filterUsers(String query) {
    setState(() {
      searchQuery = query;
      applyFilter(); // Aplica o filtro ao alterar a busca
    });
  }

  bool isNewUser(String createdAt) {
    final userCreationDate = DateTime.parse(createdAt);
    final difference = currentDate.difference(userCreationDate);
    return difference <= newUserDuration;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30.sp),
                child: Container(
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
                        padding: EdgeInsets.only(left: 15.sp),
                        child: Text(
                          'Usuários',
                          style: TextStyle(
                            color: Color(0xFFEAEAF0),
                            fontSize: 40.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.67,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildStatusOptions(),
                  _buildCountryFilter(), // Adiciona o filtro por país
                  _buildSearchField(),
                ],
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(35.sp),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff292929),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildHeaderRow(),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!isLoading &&
                                  hasMore &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                fetchUsers();
                              }
                              return false;
                            },
                            child: ListView.builder(
                              itemCount:
                                  filteredUsers.length + (hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == filteredUsers.length) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final user = filteredUsers[index];
                                return _buildUserRow(
                                  index: index + 1,
                                  userImageUrl: user.fullImageUrl ?? '',
                                  fullName: user.fullName,
                                  email: user.email,
                                  createdAt: user.createdAt,
                                  countryCode: user.countryCode ?? '',
                                  userId: user.id,
                                  context: context,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryFilter() {
    // Lista de países para exemplo; você pode adaptar conforme necessário.
    List<String> countries = ['Todos', 'BR', 'US', 'CA', 'FR', 'DE'];

    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Container(
        width: 120.sp,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButton2<String>(
          value: selectedCountry,
          isExpanded: true,
          alignment: Alignment.center,
          items: countries.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: 17.sp),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCountry = newValue!;
              applyFilter(); // Reaplica o filtro quando a opção é alterada
            });
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOptions() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 20.sp),
          child: Text(
            'Exibindo ${filteredUsers.length} usuários',
            style: TextStyle(color: Colors.white, fontSize: 17.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.sp),
          child: Container(
            width: 120.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton2<String>(
              value: filterOption,
              isExpanded:
                  true, // Expande o botão para ocupar todo o espaço disponível
              alignment: Alignment.center, // Centraliza o texto no item
              items: <String>['Todos', 'Novos'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  alignment: Alignment.center, // Centraliza o texto no item
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black, fontSize: 17.sp),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  filterOption = newValue!;
                  applyFilter(); // Reaplica o filtro quando a opção é alterada
                });
              },
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.only(right: 35.sp),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        width: 200.sp,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 190.sp,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                onChanged: filterUsers,
                decoration: InputDecoration(
                  hintText: "Buscar usuário",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      height: 40.sp,
      child: Row(
        children: [
          containerFlexHeader(value: 1, label: '#'),
          containerFlexHeader(value: 1, label: 'Perfil'),
          containerFlexHeader(value: 3, label: 'Nome'),
          containerFlexHeader(value: 1, label: 'País'),
          // containerFlagColumn(countryCode: 'País', value: 1),
          containerFlexHeader(value: 3, label: 'Email'),
          containerFlexHeader(value: 2, label: 'Ações'),
        ],
      ),
    );
  }

  Widget _buildUserRow({
    required int index,
    required String userImageUrl,
    required String fullName,
    required String countryCode,
    required String email,
    required String createdAt,
    required String userId,
    required BuildContext context,
  }) {
    final isNew = isNewUser(createdAt);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.08.sp,
          color: Color(0xff979797),
        ),
      ),
      height: 50.sp,
      child: Row(
        children: [
          containerFlex(value: 1, label: '$index'),
          Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: AspectRatio(
                  aspectRatio:
                      1, // Mantém a proporção 1:1, garantindo um círculo
                  child: CachedNetworkImage(
                    imageUrl: userImageUrl,
                    fit: BoxFit.cover, // Preenche o círculo sem distorções
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          containerFlex(value: 3, label: fullName, isNew: isNew),
          containerFlagColumn(countryCode: countryCode ?? '', value: 1),
          containerFlex(value: 3, label: email),
          containerActions(value: 2, userId: userId, context: context),
        ],
      ),
    );
  }
}
