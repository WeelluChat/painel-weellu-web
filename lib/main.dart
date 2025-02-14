import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monitor_site_weellu/rotas/provider2.dart';
import 'package:window_manager/window_manager.dart'; // Use esta biblioteca
import 'package:provider/provider.dart';
import 'login/login_page.dart';
import 'login/provider/ProfileProvider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/users/modelsClients.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(ModelsclientsAdapter());

  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   await WindowManager.instance
  //       .ensureInitialized(); // Inicializa o WindowManager
  //   WindowManager.instance
  //       .setTitle('Monitor Weellu'); // Define o título da janela
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<ProviderComment>(
          create: (context) => ProviderComment(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor Weellu', // Altere o título da aplicação
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
