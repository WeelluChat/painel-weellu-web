import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  String? _profileImageBase64;

  String? get profileImageBase64 => _profileImageBase64;

  void updateProfileImage(String base64Image) {
    _profileImageBase64 = base64Image;
    notifyListeners();
  }
}
