class Comment {
  final String id;
  final String nome;
  final String email;
  final int avaliacao;
  final String comentario;
  final String horario;
  final String data;
  final bool approved;

  Comment({
    required this.id,
    required this.nome,
    required this.email,
    required this.avaliacao,
    required this.comentario,
    required this.horario,
    required this.data,
    required this.approved,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      comentario: json['comentario'] ?? '',
      avaliacao: json['avaliacao'] ?? 0,
      horario: json['horario'] ?? '',
      data: json['data'] ?? '',
      approved: json['approved'] ?? false,
    );
  }
}
