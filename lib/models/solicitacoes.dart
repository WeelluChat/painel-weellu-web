class Solicitacoes {
  final int reprovado;
  final int pendente;
  final int aprovado;

  Solicitacoes({
    required this.reprovado,
    required this.pendente,
    required this.aprovado,
  });

  // Método para criar uma instância de Solicitacoes a partir de um JSON
  factory Solicitacoes.fromJson(List<dynamic> json) {
    int reprovado = 0;
    int pendente = 0;
    int aprovado = 0;

    for (var item in json) {
      switch (item['_id']) {
        case 'Reprovado':
          reprovado = item['count'];
          break;
        case 'Pendente':
          pendente = item['count'];
          break;
        case 'Aprovado':
          aprovado = item['count'];
          break;
      }
    }

    return Solicitacoes(
      reprovado: reprovado,
      pendente: pendente,
      aprovado: aprovado,
    );
  }
}
