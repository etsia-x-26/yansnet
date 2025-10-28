import 'package:flutter/material.dart';

class EmptyMessagesIllustration extends StatelessWidget {
  const EmptyMessagesIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: EmptyMessagesPainter(),
    );
  }
}

class EmptyMessagesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Dessin du personnage
    // Corps (robe)
    paint.color = Colors.black;
    final Path bodyPath = Path();
    bodyPath.moveTo(size.width * 0.4, size.height * 0.55);
    bodyPath.lineTo(size.width * 0.3, size.height * 0.9);
    bodyPath.lineTo(size.width * 0.5, size.height * 0.9);
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);

    // Haut du corps (chemise)
    paint.color = Colors.white;
    final Rect torso = Rect.fromLTWH(
      size.width * 0.35,
      size.height * 0.35,
      size.width * 0.1,
      size.height * 0.2,
    );
    canvas.drawRect(torso, paint);

    // Tête
    paint.color = const Color(0xFFE8B894);
    final Rect head = Rect.fromLTWH(
      size.width * 0.35,
      size.height * 0.2,
      size.width * 0.1,
      size.height * 0.15,
    );
    canvas.drawOval(head, paint);

    // Cheveux
    paint.color = Colors.black;
    final Path hairPath = Path();
    hairPath.moveTo(size.width * 0.35, size.height * 0.25);
    hairPath.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.15,
      size.width * 0.45,
      size.height * 0.25,
    );
    hairPath.lineTo(size.width * 0.45, size.height * 0.3);
    hairPath.lineTo(size.width * 0.35, size.height * 0.3);
    hairPath.close();
    canvas.drawPath(hairPath, paint);

    // Bras
    paint.color = const Color(0xFFE8B894);
    final Rect leftArm = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.38,
      size.width * 0.15,
      size.width * 0.03,
    );
    canvas.drawRect(leftArm, paint);

    // Tableau/Présentation
    paint.color = const Color(0xFF8B4513);
    final Rect board = Rect.fromLTWH(
      size.width * 0.55,
      size.height * 0.35,
      size.width * 0.25,
      size.height * 0.15,
    );
    canvas.drawRect(board, paint);

    // Pied/base
    paint.color = const Color(0xFFD2B48C);
    final Rect ground = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.9,
      size.width * 0.6,
      size.height * 0.02,
    );
    canvas.drawOval(ground, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}