import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ClockSeven extends StatefulWidget {
  const ClockSeven({super.key});

  @override
  State<ClockSeven> createState() => _ClockSevenState();
}

class _ClockSevenState extends State<ClockSeven> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detect orientation
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size =
                isPortrait ? constraints.maxWidth : constraints.maxHeight * 0.9;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size,
                    height: size,
                    child: CustomPaint(painter: ClockPainter(datetime: _now)),
                  ),
                  const SizedBox(height: 16),
                  // Time display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        intl.DateFormat('HH:mm').format(_now),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Day display
                      Text(
                        intl.DateFormat(' EEEE, ').format(_now),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Date display
                      Text(
                        intl.DateFormat('MMMM d').format(_now),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime datetime;

  ClockPainter({required this.datetime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Define colors for futuristic AMOLED look
    final dotColor = Colors.yellow;
    final hourHandColor = Colors.white;
    final minuteHandColor = Colors.white;
    final secondHandColor = Colors.red;
    final textColor = Colors.white;

    // Draw dotted outer markers (not a full circle)
    final outerDotPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.2)
          ..style = PaintingStyle.fill;

    for (int i = 0; i < 60; i++) {
      final angle = i * (2 * pi / 60);

      // Skip drawing dots in certain areas to avoid a complete circle
      if ((i >= 15 && i <= 20) || (i >= 40 && i <= 45)) {
        continue;
      }

      final dotRadius = i % 5 == 0 ? 1.5 : 0.8;
      final dotOffset = Offset(
        center.dx + (radius * 0.92) * cos(angle),
        center.dy + (radius * 0.92) * sin(angle),
      );
      canvas.drawCircle(dotOffset, dotRadius, outerDotPaint);
    }

    // Draw timezone text and markers with x/y alignment
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Helper function for drawing text
    void drawText(
      String text,
      Offset position,
      double fontSize, {
      TextAlign align = TextAlign.center,
    }) {
      final textStyle = TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        letterSpacing: 1,
      );

      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.textAlign = align;
      textPainter.layout();

      double x = position.dx;
      double y = position.dy;

      if (align == TextAlign.center) {
        x -= textPainter.width / 2;
      } else if (align == TextAlign.right) {
        x -= textPainter.width;
      }

      textPainter.paint(canvas, Offset(x, y));
    }

    // Top text section
    drawText(
      'IAAB\nST™',
      Offset(center.dx, center.dy - radius * 0.7),
      radius * 0.05,
    );
    drawText(
      '-\n-\n-\n>',
      Offset(center.dx, center.dy - radius * 0.4),
      radius * 0.05,
    );
    drawText(
      'WORLDWIDE\nTIMEZONE',
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.4),
      radius * 0.05,
    );

    // Right text section
    drawText(
      'NY T.\nEAST TIME\n> PET',
      Offset(center.dx + radius * 0.6, center.dy),
      radius * 0.05,
    );

    // Bottom text section
    drawText(
      '-\n-\nSOUTH A.',
      Offset(center.dx, center.dy + radius * 0.7),
      radius * 0.05,
    );

    // Left text section
    drawText(
      'PACIFIC',
      Offset(center.dx - radius * 0.6, center.dy),
      radius * 0.05,
    );

    // Draw timezone numbers
    drawText(
      '+9',
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.06,
    );
    drawText(
      '+10',
      Offset(center.dx - radius * 0.6, center.dy - radius * 0.1),
      radius * 0.06,
    );
    drawText(
      '{+}8',
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.1),
      radius * 0.06,
    );
    drawText(
      '{+}5',
      Offset(center.dx + radius * 0.4, center.dy),
      radius * 0.06,
    );
    drawText(
      '{+}3',
      Offset(center.dx + radius * 0.6, center.dy + radius * 0.1),
      radius * 0.06,
    );

    // Draw center dot
    final centerDotPaint = Paint()..color = dotColor;
    canvas.drawCircle(center, radius * 0.02, centerDotPaint);

    // Draw hour hand
    final hourHandLength = radius * 0.4;
    final hourAngle =
        (datetime.hour % 12 + datetime.minute / 60) * (2 * pi / 12) - pi / 2;
    final hourHandEnd = Offset(
      center.dx + hourHandLength * cos(hourAngle),
      center.dy + hourHandLength * sin(hourAngle),
    );

    final hourHandPaint =
        Paint()
          ..color = hourHandColor
          ..strokeWidth = radius * 0.02
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, hourHandEnd, hourHandPaint);

    // Draw minute hand
    final minuteHandLength = radius * 0.6;
    final minuteAngle = datetime.minute * (2 * pi / 60) - pi / 2;
    final minuteHandEnd = Offset(
      center.dx + minuteHandLength * cos(minuteAngle),
      center.dy + minuteHandLength * sin(minuteAngle),
    );

    final minuteHandPaint =
        Paint()
          ..color = minuteHandColor
          ..strokeWidth = radius * 0.015
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, minuteHandEnd, minuteHandPaint);

    // Draw second hand
    final secondHandLength = radius * 0.75;
    final secondAngle = datetime.second * (2 * pi / 60) - pi / 2;
    final secondHandEnd = Offset(
      center.dx + secondHandLength * cos(secondAngle),
      center.dy + secondHandLength * sin(secondAngle),
    );

    final secondHandPaint =
        Paint()
          ..color = secondHandColor
          ..strokeWidth = radius * 0.01
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, secondHandEnd, secondHandPaint);

    // Draw subtle decorative lines
    final decorPaint =
        Paint()
          ..color = Colors.blue.withValues(alpha: 0.7)
          ..strokeWidth = radius * 0.008
          ..strokeCap = StrokeCap.round;

    final decorAngle1 = -pi / 6;
    final decorLine1End = Offset(
      center.dx + radius * 0.9 * cos(decorAngle1),
      center.dy + radius * 0.9 * sin(decorAngle1),
    );
    canvas.drawLine(center, decorLine1End, decorPaint);

    final decorAngle2 = pi * 0.7;
    final decorLine2End = Offset(
      center.dx + radius * 0.9 * cos(decorAngle2),
      center.dy + radius * 0.9 * sin(decorAngle2),
    );
    decorPaint.color = Colors.blue.withValues(alpha: 0.5);
    canvas.drawLine(center, decorLine2End, decorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
