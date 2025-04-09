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
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = isPortrait 
                ? constraints.maxWidth 
                : constraints.maxHeight * 0.9;
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size,
                    height: size,
                    child: CustomPaint(
                      painter: ClockPainter(
                        datetime: _now,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    intl.DateFormat('EEEE, MMMM d').format(_now),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
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
    final markerColor = Colors.white.withOpacity(0.6);
    final textColor = Colors.white;
    
    // Draw clock circle
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawCircle(center, radius * 0.98, paint);
    
    // Draw dotted outer ring
    final outerDotPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
      
    for (int i = 0; i < 60; i++) {
      final angle = i * (2 * pi / 60);
      final dotRadius = i % 5 == 0 ? 1.5 : 0.8;
      final dotOffset = Offset(
        center.dx + (radius * 0.92) * cos(angle),
        center.dy + (radius * 0.92) * sin(angle),
      );
      canvas.drawCircle(dotOffset, dotRadius, outerDotPaint);
    }
    
    // Draw timezone text and markers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    // Draw timezone markers
    void drawText(String text, double angle, double distance) {
      final textStyle = TextStyle(
        color: textColor,
        fontSize: radius * 0.05,
        fontWeight: FontWeight.w300,
        letterSpacing: 1,
      );
      
      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.layout();
      
      final x = center.dx + distance * cos(angle) - textPainter.width / 2;
      final y = center.dy + distance * sin(angle) - textPainter.height / 2;
      
      textPainter.paint(canvas, Offset(x, y));
    }

    // Draw cardinal text markers
    drawText('IAAB\nST™', -pi/2, radius * 0.65);
    drawText('>\nWORLDWIDE\nTIMEZONE', -pi/2 + pi/8, radius * 0.65);
    
    drawText('NY T.\nEAST TIME\n> PET', 0, radius * 0.65);
    
    drawText('SOUTH A.', pi/2, radius * 0.65);
    
    drawText('PACIFIC', -pi, radius * 0.65);

    // Draw timezone numbers
    void drawTimezone(String text, double angle) {
      final textStyle = TextStyle(
        color: textColor,
        fontSize: radius * 0.05,
        fontWeight: FontWeight.w400,
      );
      
      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.layout();
      
      final distance = radius * 0.8;
      final x = center.dx + distance * cos(angle) - textPainter.width / 2;
      final y = center.dy + distance * sin(angle) - textPainter.height / 2;
      
      textPainter.paint(canvas, Offset(x, y));
    }

    drawTimezone('+9', -pi/4);
    drawTimezone('+10', -pi * 0.9);
    drawTimezone('{+}8', -pi * 0.75);
    drawTimezone('{+}5', pi * 0.25);
    drawTimezone('{+}3', pi * 0.4);

    // Draw center dot
    final centerDotPaint = Paint()..color = dotColor;
    canvas.drawCircle(center, radius * 0.02, centerDotPaint);
    
    // Draw hour hand
    final hourHandLength = radius * 0.4;
    final hourAngle = (datetime.hour % 12 + datetime.minute / 60) * (2 * pi / 12) - pi / 2;
    final hourHandEnd = Offset(
      center.dx + hourHandLength * cos(hourAngle),
      center.dy + hourHandLength * sin(hourAngle),
    );
    
    final hourHandPaint = Paint()
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
    
    final minuteHandPaint = Paint()
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
    
    final secondHandPaint = Paint()
      ..color = secondHandColor
      ..strokeWidth = radius * 0.01
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(center, secondHandEnd, secondHandPaint);
    
    // Draw subtle decorative lines
    final decorPaint = Paint()
      ..color = Colors.blue.withOpacity(0.7)
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
    decorPaint.color = Colors.blue.withOpacity(0.5);
    canvas.drawLine(center, decorLine2End, decorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

