import 'dart:math';
import 'package:flutter/material.dart';



class ClockOne extends StatefulWidget {
  const ClockOne({super.key});

  @override
  State<ClockOne> createState() => _ClockOneState();
}

class _ClockOneState extends State<ClockOne> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final DateTime _currentDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(190),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Date top left
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentDate.day.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _getMonthName(_currentDate.month),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Year top right
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Text(
                      _currentDate.year.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  // Outer ring
                  CustomPaint(
                    size: const Size(380, 380),
                    painter: CircleDialPainter(progress: _controller.value),
                  ),
                  
                  // Inner colored circle
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF5252),
                            Color(0xFFFF7043),
                            Color(0xFF1565C0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Clock display
                  Positioned(
                    top: 155,
                    left: 110,
                    child: Column(
                      children: [
                        const Text(
                          '01.07B',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '05:${((_controller.value * 60).floor()).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom elements
                  Positioned(
                    bottom: 60,
                    left: 120,
                    child: Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: i == 1 ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Bottom ID
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: Colors.black,
                      child: const Text(
                        '096',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
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
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class CircleDialPainter extends CustomPainter {
  final double progress;
  
  CircleDialPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final innerRadius = radius * 0.7;
    final outerRadius = radius * 0.9;
    
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw the outer circle
    canvas.drawCircle(center, outerRadius, paint);
    
    // Draw the inner circle
    canvas.drawCircle(center, innerRadius, paint);
    
    // Draw the circular ticks
    for (int i = 0; i < 60; i++) {
      final angle = 2 * pi * i / 60;
      final bool isMajor = i % 15 == 0;
      final bool isMinor = i % 5 == 0;
      
      final outerPoint = Offset(
        center.dx + cos(angle) * outerRadius,
        center.dy + sin(angle) * outerRadius,
      );
      
      final innerPoint = Offset(
        center.dx + cos(angle) * (outerRadius - (isMajor ? 15 : isMinor ? 10 : 5)),
        center.dy + sin(angle) * (outerRadius - (isMajor ? 15 : isMinor ? 10 : 5)),
      );
      
      paint.color = isMajor ? Colors.black : Colors.grey.shade600;
      paint.strokeWidth = isMajor ? 2 : 1;
      
      canvas.drawLine(innerPoint, outerPoint, paint);
      
      if (isMajor) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: (i ~/ 15 * 90).toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        
        final textPoint = Offset(
          center.dx + cos(angle) * (outerRadius - 25) - textPainter.width / 2,
          center.dy + sin(angle) * (outerRadius - 25) - textPainter.height / 2,
        );
        
        textPainter.paint(canvas, textPoint);
      }
    }
    
    // Draw progress arc
    final progressPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius - 20),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
    
    // Draw the progress indicator
    final indicatorAngle = 2 * pi * progress - pi / 2;
    final indicatorPoint = Offset(
      center.dx + cos(indicatorAngle) * (outerRadius - 20),
      center.dy + sin(indicatorAngle) * (outerRadius - 20),
    );
    
    final indicatorPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(indicatorPoint, 5, indicatorPaint);
    
    // Draw some data points at specific angles
    final dataPointPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 3; i++) {
      final angle = 2 * pi * i / 10 + pi / 6;
      final point = Offset(
        center.dx + cos(angle) * (innerRadius + 30),
        center.dy + sin(angle) * (innerRadius + 30),
      );
      
      canvas.drawCircle(point, 10, dataPointPaint);
      
      // Draw mini pie chart
      final piePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: point, radius: 8),
        0,
        pi * 1.2,
        true,
        piePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}