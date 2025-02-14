import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/comenters.dart';
import '../screens/integracao/modelIntegration.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Header padrão para autenticação administrativa
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'admin-key': 'super_password_for_admin',
  };

  // Função para buscar requisições de integração
  Future<List<IntegrationRequest>> fetchIntegrationRequests() async {
    final response = await http.get(
      Uri.parse('https://api.weellu.com/api/v1/admin-panel/users/api'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('data') && data['data']['docs'] is List) {
        List<dynamic> integrationList = data['data']['docs'];
        return integrationList
            .map((item) => IntegrationRequest.fromJson(item))
            .toList();
      } else {
        throw Exception('Estrutura de dados inesperada');
      }
    } else {
      throw Exception('Erro ao buscar integrações');
    }
  }

  // Rota para obter todos os comentários
  Future<List<Comment>> fetchComments() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/BUSCAR_COMENTARIOS'), headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // Future fetchIntegrationRequests() async {
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
  //       } else {
  //         throw Exception('Estrutura de dados inesperada');
  //       }
  //     } else {
  //       throw Exception('Erro ao buscar integrações');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Rota de validar o email
  Future<bool> verifyEmail(String email) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/verify-email?email=$email'),
        headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['exists'];
    } else {
      throw Exception('Failed to verify email');
    }
  }

  // Rota de login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Inclui accessToken e refreshToken aqui
    } else {
      throw Exception('Failed to login');
    }
  }

  // Rota para atualizar um comentário
  Future<void> updateComment(String id, bool approved) async {
    final url = Uri.parse('$baseUrl/api/ATUALIZAR_COMENTARIO/$id');
    print('Updating comment at: $url');

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'approved': approved,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update comment');
    }
  }

  // Rota para inativar um comentário
  Future<void> inactivateComment(String id, bool approved) async {
    final url = Uri.parse('$baseUrl/api/desativar_comentario/$id');
    print('Inactivating comment at: $url');

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'approved': approved,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to inactivate comment');
    }
  }

  // Rota para atualizar a imagem de perfil
  Future<void> updateProfileImage(String userId, String base64Image) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/profile-image');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'profileImage': base64Image}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile image');
    }
  }

  // Rota para obter a imagem de perfil
  Future<String?> getProfileImage(String userId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/profile-image');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['profileImage'] as String?;
    } else {
      throw Exception('Failed to fetch profile image');
    }
  }
}
