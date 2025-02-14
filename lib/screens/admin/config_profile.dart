import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:provider/provider.dart';
import '../../../models/auth.dart';
import '../../login/provider/ProfileProvider.dart'; // Certifique-se de que o caminho está correto
import '../../rotas/apiservice.dart'; // Importar o ApiService

class Tatateste extends StatefulWidget {
  final UserModel user;
  final VoidCallback
      onProfileImageUpdated; // Callback para notificar a atualização da imagem

  const Tatateste({
    required this.user,
    required this.onProfileImageUpdated, // Inicializa o callback
  });

  @override
  State<Tatateste> createState() => _TatatesteState();
}

class _TatatesteState extends State<Tatateste> {
  File? _imageFile;
  final ApiService apiService =
      ApiService(baseUrl: 'http://192.168.99.239:3000'); // URL da API

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final base64Image = await apiService.getProfileImage(widget.user.id);
      if (base64Image != null) {
        Provider.of<ProfileProvider>(context, listen: false)
            .updateProfileImage(base64Image);
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(label: 'Images', extensions: ['jpg', 'jpeg', 'png']),
        ],
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final bytes = await _imageFile!.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      await apiService.updateProfileImage(widget.user.id, base64Image);
      Provider.of<ProfileProvider>(context, listen: false)
          .updateProfileImage(base64Image); // Atualize o ProfileProvider
      widget.onProfileImageUpdated(); // Notifica que a imagem foi atualizada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagem de perfil atualizada com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar a imagem de perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            'Profile picture',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: 0.34,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 170,
                              height: 170,
                              child: CircleAvatar(
                                backgroundImage:
                                    profileProvider.profileImageBase64 != null
                                        ? Image.memory(
                                            base64Decode(profileProvider
                                                .profileImageBase64!),
                                          ).image
                                        : null,
                                child: profileProvider.profileImageBase64 ==
                                        null
                                    ? Center(
                                        child: Text('Add Image',
                                            style:
                                                TextStyle(color: Colors.white)))
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 730,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Nome de perfil'),
                                Container(
                                  width: 730,
                                  height: 43,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF212121),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFF979797)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                _buildInfoRow('Email'),
                                Container(
                                  width: 730,
                                  height: 43,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF212121),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFF979797)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                _buildInfoRow('Senha'),
                                Container(
                                  width: 730,
                                  height: 43,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF212121),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFF979797)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                _buildInfoRow('Confirmar senha'),
                                Container(
                                  width: 730,
                                  height: 43,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF212121),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFF979797)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 176,
                                        height: 43,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFF1E6C56),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Salvar mudanças',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                              letterSpacing: 0.34,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(
        '$label',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: 0,
          letterSpacing: 0.34,
        ),
      ),
    );
  }
}
