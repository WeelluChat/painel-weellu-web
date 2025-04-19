import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monitor_site_weellu/rotas/provider2.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'card_provider.dart';
import '../../models/comenters.dart';
import '../../rotas/apiservice.dart';

class CardComenter extends StatefulWidget {
  const CardComenter({super.key});

  @override
  State<CardComenter> createState() => _CardComenterState();
}

class _CardComenterState extends State<CardComenter> {
  List<Comment> comments = [];
  late Timer _timer;
  // bool _loading = true;
  int approvedCount = 0;
  int rejectedCount = 0;
  final ApiService apiService =
      ApiService(baseUrl: 'https://api.painel.weellu.com');

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  @override
  void initState() {
    super.initState();
    // _fetchInitialComments();
    context.read<ProviderComment>().loadCommtent();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateCommentCounts(List<Comment> comments) {
    int approved = comments.where((comment) => comment.approved).length;
    int rejected = comments.where((comment) => !comment.approved).length;
    setState(() {
      approvedCount = approved;
      rejectedCount = rejected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 70.sp, right: 70.sp),
            child: Container(
              color: Color.fromARGB(255, 19, 17, 17),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Aprovados: $approvedCount',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 20.sp),
                            Text(
                              'Reprovados: $rejectedCount',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Consumer<ProviderComment>(builder: (context, controller, _) {
                    if (controller.newComments.isEmpty) {
                      return CircularProgressIndicator();
                    }
                    ;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: controller.newComments.length,
                        itemBuilder: (context, index) {
                          final comment = controller.newComments[index];
                          final color = colors[index % colors.length];
                          return Comentario(
                            nome: comment.nome,
                            comentario: comment.comentario,
                            horario: comment.horario,
                            comment: comment,
                            color: color,
                            apiService: apiService,
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Comentario extends StatelessWidget {
  final String nome;
  final String comentario;
  final String horario;
  final Comment comment;
  final Color color;
  final ApiService apiService;

  const Comentario({
    Key? key,
    required this.nome,
    required this.comentario,
    required this.horario,
    required this.comment,
    required this.color,
    required this.apiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.sp),
      child: InkWell(
        onTap: () {
          showCustomDialog(context, comment, apiService);
        },
        child: Container(
          padding: EdgeInsets.all(20.sp),
          height: 120.sp,
          decoration: BoxDecoration(
              color: Color(0xff292929),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 70.sp,
                width: 70.sp,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.all(
                    Radius.circular(80),
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  height: 100.sp,
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nome,
                        style: TextStyle(
                          color: Color(0xFFEAEAF0),
                          fontSize: 20.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.34,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Opacity(
                        opacity: 0.50,
                        child: Text(
                          comentario,
                          style: TextStyle(
                            color: Color(0xFFEAEAF0),
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100.sp,
                width: 100.sp,
                child: Center(
                  child: Text(
                    horario,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFFEAEAF0),
                      fontSize: 20.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.34,
                    ),
                  ),
                ),
              ),
              Container(
                height: 20.sp,
                width: 20.sp,
                decoration: BoxDecoration(
                  color: comment.approved ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCustomDialog(
    BuildContext context, Comment comment, ApiService apiService) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: CardProvider(
          comment: comment,
          apiService: apiService,
        ),
      );
    },
  );
}
