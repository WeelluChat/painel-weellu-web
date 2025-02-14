import 'package:intl/intl.dart';

// Modelo para os dados de integração
class IntegrationRequest {
  final String usuario;
  final String email;
  final String dataSolicitacao;
  final String infoIntegracao;
  final String status;

  IntegrationRequest({
    required this.usuario,
    required this.email,
    required this.dataSolicitacao,
    required this.infoIntegracao,
    required this.status,
  });

  factory IntegrationRequest.fromJson(Map<String, dynamic> json) {
    String formatDate(String dateString) {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    }

    return IntegrationRequest(
      usuario: json['userId']['fullName'] ?? '',
      email: json['_id'] ?? '',
      dataSolicitacao:
          json['createdAt'] != null ? formatDate(json['createdAt']) : '',
      infoIntegracao: json['token'] ?? '',
      status: json['status'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "_id": email,
      'userId': {
        'fullName': usuario,
      },
      'createdAt': dataSolicitacao,
      'token': infoIntegracao,
      'status': status,
    };
  }
}
