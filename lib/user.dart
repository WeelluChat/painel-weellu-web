// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class UsersPage extends StatefulWidget {
//   const UsersPage({super.key});

//   @override
//   State<UsersPage> createState() => _UsersPageState();
// }

// class _UsersPageState extends State<UsersPage> {
//   List<Map<String, dynamic>> users = [];
//   int page = 1;
//   bool isLoading = false;
//   bool hasMore = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

//   Future<void> fetchUsers() async {
//     if (isLoading) return;

//     setState(() {
//       isLoading = true;
//     });

//     final response = await http.get(
//       Uri.parse('https://api.weellu.com/api/v1/admin-panel/users?page=$page'),
//       headers: {
//         'admin-key': 'super_password_for_admin',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       setState(() {
//         users.addAll(List<Map<String, dynamic>>.from(data['data']['docs']));
//         isLoading = false;
//         page++;
//         // Verifica se ainda há mais usuários para carregar
//         hasMore = data['data']['docs'].length == 30;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       print('Erro ao buscar usuários: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Usuários'),
//         backgroundColor: const Color(0xFF292929),
//       ),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollInfo) {
//           if (!isLoading &&
//               hasMore &&
//               scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//             fetchUsers();
//           }
//           return false;
//         },
//         child: ListView.builder(
//           itemCount: users.length + (hasMore ? 1 : 0),
//           itemBuilder: (context, index) {
//             if (index == users.length) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             final user = users[index];
//             final userImage = user['userImages']['smallImage'];
//             final fullName = user['fullName'];
//             final email = user['email'];

//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                   "https://api.weellu.com/$userImage",
//                 ),
//               ),
//               title: Text(
//                 fullName,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               subtitle: Text(
//                 email,
//                 style: const TextStyle(
//                   color: Colors.black54,
//                   fontSize: 16,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
