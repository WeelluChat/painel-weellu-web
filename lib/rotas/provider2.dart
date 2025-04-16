import 'package:flutter/material.dart';
import 'package:monitor_site_weellu/models/comenters.dart';
import 'package:monitor_site_weellu/rotas/apiservice.dart';

import '../screens/integracao/modelIntegration.dart';

class ProviderComment extends ChangeNotifier {
  List<Comment> newComments = [];
  List<IntegrationRequest> newIntergration = [];

  loadCommtent() async {
    newComments =
        await ApiService(baseUrl: 'https://api.painel.weellu.com').fetchComments();
    notifyListeners();
  }

  loadintegrations() async {
    newIntergration = await ApiService(
            baseUrl: 'https://api.weellu.com/api/v1/admin-panel/users/api')
        .fetchIntegrationRequests();
    notifyListeners();
  }
}
