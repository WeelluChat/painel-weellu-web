import 'package:flutter/material.dart';
import 'package:monitor_site_weellu/screens/admin/config_profile.dart';
import 'package:monitor_site_weellu/screens/bussines/business.dart';
import '../comentarios/comentarios.dart';
import '../dashboard/dashboard.dart';
import '../integracao/integracao.dart';
import '../../models/auth.dart';
import '../profileUsers/profile_user.dart';
import '../side menu/side_menu.dart';
import '../users/user copy.dart';

class dashdotata extends StatefulWidget {
  final UserModel user;
  const dashdotata({required this.user});

  @override
  State<dashdotata> createState() => _dashdotataState();
}

class _dashdotataState extends State<dashdotata> {
  String _currentPage = 'DashboardMaster';

  void _onMenuItemSelected(String page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: SideMenu(
                user: widget.user,
                onMenuItemSelected: _onMenuItemSelected,
                userName: widget.user.name,
                userEmail: widget.user.email,
                onProfileImageUpdated: () {
                  // Atualize o perfil ou execute qualquer ação necessária após a imagem ser atualizada
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff212121),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: _buildCurrentPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case 'Integration':
        return Integration();

      case 'tatateste':
        return Tatateste(
          onProfileImageUpdated: () {
            // Atualize o perfil ou execute qualquer ação necessária após a imagem ser atualizada
          },
          user: widget.user,
        );

      case "Dashboard":
        return Dashboard();

      case "business":
        return Business();

      case "DashboardMaster":
        return DashMaster();

      case "users":
        return Navigator(
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (BuildContext _) => UsersPages();
                break;
              case '/profileUser':
                final userId = settings.arguments
                    as String; // Recebe o userId como argumento
                builder = (BuildContext _) => ProfileUser(
                    userId: userId); // Passa o userId para ProfileUser
                break;
              default:
                throw Exception('Rota inválida: ${settings.name}');
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        );

      default:
        return Center(
          child: Text(
            'Page not found',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }
}
