import 'package:flutter/material.dart';

class EmptyMessagesIllustration extends StatelessWidget {
  const EmptyMessagesIllustration({super.key});

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
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2

    // Dessin du personnage
    // Corps (robe)
    ..color = Colors.black;
    final bodyPath = Path()
    ..moveTo(size.width * 0.4, size.height * 0.55)
    ..lineTo(size.width * 0.3, size.height * 0.9)
    ..lineTo(size.width * 0.5, size.height * 0.9)
    ..close();
    canvas.drawPath(bodyPath, paint);

    // Haut du corps (chemise)
    paint.color = Colors.white;
    final torso = Rect.fromLTWH(
      size.width * 0.35,
      size.height * 0.35,
      size.width * 0.1,
      size.height * 0.2,
    );
    canvas.drawRect(torso, paint);

    // Tête
    paint.color = const Color(0xFFE8B894);
    final head = Rect.fromLTWH(
      size.width * 0.35,
      size.height * 0.2,
      size.width * 0.1,
      size.height * 0.15,
    );
    canvas.drawOval(head, paint);

    // Cheveux
    paint.color = Colors.black;
    final hairPath = Path()
    ..moveTo(size.width * 0.35, size.height * 0.25)
    ..quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.15,
      size.width * 0.45,
      size.height * 0.25,
    )
    ..lineTo(size.width * 0.45, size.height * 0.3)
    ..lineTo(size.width * 0.35, size.height * 0.3)
    ..close();
    canvas.drawPath(hairPath, paint);

    // Bras
    paint.color = const Color(0xFFE8B894);
    final leftArm = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.38,
      size.width * 0.15,
      size.width * 0.03,
    );
    canvas.drawRect(leftArm, paint);

    // Tableau/Présentation
    paint.color = const Color(0xFF8B4513);
    final board = Rect.fromLTWH(
      size.width * 0.55,
      size.height * 0.35,
      size.width * 0.25,
      size.height * 0.15,
    );
    canvas.drawRect(board, paint);

    // Pied/base
    paint.color = const Color(0xFFD2B48C);
    final ground = Rect.fromLTWH(
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
