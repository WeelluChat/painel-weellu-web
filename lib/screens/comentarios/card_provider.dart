import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:monitor_site_weellu/rotas/provider2.dart';
import 'package:provider/provider.dart';

import '../../models/comenters.dart';
import '../../rotas/apiservice.dart';

class CardProvider extends StatelessWidget {
  final Comment comment;
  final ApiService apiService;

  const CardProvider(
      {Key? key, required this.comment, required this.apiService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 650,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comentário',
            style: TextStyle(
              color: Colors.green,
              fontSize: 28,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20),
          _buildInfoRow('Nome:', comment.nome, Colors.green),
          _buildInfoRow('Email:', comment.email, Colors.green),
          _buildInfoRow('Data de envio:', comment.data, Colors.green),
          _buildRatingRow(comment.avaliacao),
          SizedBox(height: 20),
          Text(
            'Comentário:',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            comment.comentario,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton('REPROVAR', Colors.red, () async {
                try {
                  await apiService.inactivateComment(comment.id, false);
                  context.read<ProviderComment>().loadCommtent();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao aprovar comentário')),
                  );
                }
              }),
              _buildActionButton('APROVAR', Colors.green, () async {
                try {
                  await apiService.updateComment(comment.id, true);
                  context.read<ProviderComment>().loadCommtent();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao aprovar comentário')),
                  );
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              color: labelColor,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(num rating) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RatingBar.builder(
        initialRating: rating.toDouble(),
        minRating: 1,
        itemCount: 5,
        itemSize: 30,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {},
        ignoreGestures: true,
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins',
              letterSpacing: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}
