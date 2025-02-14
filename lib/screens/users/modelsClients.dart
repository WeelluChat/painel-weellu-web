import 'package:hive/hive.dart';

part 'modelsClients.g.dart';

@HiveType(typeId: 0)
class Modelsclients extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? countryCode;

  @HiveField(4)
  String? fullImageUrl;

  @HiveField(5)
  String createdAt;

  Modelsclients({
    required this.id,
    required this.fullName,
    required this.email,
    this.countryCode,
    this.fullImageUrl,
    required this.createdAt,
  });

  factory Modelsclients.fromJson(Map<String, dynamic> json) {
    return Modelsclients(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      countryCode: json['countryId']?['code'],
      fullImageUrl: json['userImages']?['fullImage'] != null
          ? 'https://weellu-chat.s3.us-east-2.amazonaws.com/${json['userImages']['fullImage']}'
          : null,
      createdAt: json['createdAt'],
    );
  }

  // Salvar no Hive
  Future<void> saveToHive() async {
    var box = await Hive.openBox<Modelsclients>('modelsclients');
    await box.put(id, this);
  }

  // Carregar do Hive
  static Future<Modelsclients?> loadFromHive(String id) async {
    var box = await Hive.openBox<Modelsclients>('modelsclients');
    return box.get(id);
  }

  // Remover do Hive
  Future<void> removeFromHive() async {
    var box = await Hive.openBox<Modelsclients>('modelsclients');
    await box.delete(id);
  }
}
