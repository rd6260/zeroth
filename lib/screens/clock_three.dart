import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'dart:math' as math;

class ClockThree extends StatefulWidget {
  const ClockThree({super.key});

  @override
  State<ClockThree> createState() => _ClockThreeState();
}

class _ClockThreeState extends State<ClockThree> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late DateTime _currentTime;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Set system UI to be transparent and fullscreen
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Initialize time
    _currentTime = DateTime.now();
    
    // Setup timer to update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    
    // Animation controller for pulsing effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background subtle gradient
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7,
                  colors: [
                    Colors.blueGrey.withValues(alpha: 0.06),
                    Colors.black,
                  ],
                ),
              ),
            ),
            
            // Glowing dots for hour markers
            ...List.generate(12, (index) {
              final angle = index * (math.pi * 2 / 12);
              final radius = screenSize.width * 0.35;
              final isHourMarker = _currentTime.hour % 12 == index;
              
              return Positioned(
                left: screenSize.width / 2 + radius * math.cos(angle - math.pi / 2),
                top: screenSize.height / 2 + radius * math.sin(angle - math.pi / 2),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: isHourMarker ? 5.0 : 3.0,
                      height: isHourMarker ? 5.0 : 3.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isHourMarker 
                          ? Color.lerp(Colors.cyan.withValues(alpha: 0.5), Colors.cyan, _pulseAnimation.value)
                          : Colors.blueGrey.withValues(alpha: 0.3),
                        boxShadow: isHourMarker 
                          ? [
                              BoxShadow(
                                color: Colors.cyan.withValues(alpha: 0.3 * _pulseAnimation.value),
                                blurRadius: 8.0 * _pulseAnimation.value,
                                spreadRadius: 1.0 * _pulseAnimation.value,
                              )
                            ] 
                          : null,
                      ),
                    );
                  }
                ),
              );
            }),
            
            // Center circle
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.cyan.withValues(alpha: 0.6 * _pulseAnimation.value),
                          Colors.blue.withValues(alpha: 0.01),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withValues(alpha: 0.2 * _pulseAnimation.value),
                          blurRadius: 15.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Digital time display
            Positioned(
              top: screenSize.height * 0.55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Digital time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formatHour(_currentTime.hour),
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 2,
                        ),
                      ),
                      _buildBlinkingColon(),
                      Text(
                        _formatMinute(_currentTime.minute),
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  
                  // Seconds indicator - a horizontal line that grows
                  SizedBox(height: 10),
                  Container(
                    width: 100,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan.withValues(alpha: 0.8),
                          Colors.blue.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100 * (_currentTime.second / 60),
                          color: Colors.cyan,
                        ),
                      ],
                    ),
                  ),
                  
                  // Date
                  SizedBox(height: 30),
                  Text(
                    _formatDate(_currentTime),
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            
            // Additional futuristic elements
            CustomPaint(
              size: Size(screenSize.width, screenSize.height),
              painter: FuturisticElementsPainter(
                timeAngle: _currentTime.second / 60 * 2 * math.pi,
                pulseValue: _pulseAnimation.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBlinkingColon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Text(
          ":",
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 60,
            fontWeight: FontWeight.w300,
            color: _currentTime.second % 2 == 0 
                ? Colors.white.withValues(alpha: 0.85) 
                : Colors.white.withValues(alpha: 0.3),
          ),
        );
      },
    );
  }
  
  String _formatHour(int hour) {
    // 24-hour to 12-hour format
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return h.toString().padLeft(2, '0');
  }
  
  String _formatMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }
  
  String _formatDate(DateTime dateTime) {
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = months[dateTime.month - 1];
    return '$day · $month · ${dateTime.year}';
  }
}

// Custom painter for futuristic elements
class FuturisticElementsPainter extends CustomPainter {
  final double timeAngle;
  final double pulseValue;
  
  FuturisticElementsPainter({
    required this.timeAngle,
    required this.pulseValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw arc
    final arcPaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.15 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
      
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      timeAngle, // Progress based on seconds
      false,
      arcPaint,
    );
    
    // Draw small decorative lines
    final linePaint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;
      
    for (int i = 0; i < 60; i++) {
      // Skip positions where we have hour markers
      if (i % 5 == 0) continue;
      
      final angle = i * (math.pi * 2 / 60);
      final outerPoint = Offset(
        center.dx + (radius - 5) * math.cos(angle - math.pi / 2),
        center.dy + (radius - 5) * math.sin(angle - math.pi / 2),
      );
      final innerPoint = Offset(
        center.dx + (radius - 15) * math.cos(angle - math.pi / 2),
        center.dy + (radius - 15) * math.sin(angle - math.pi / 2),
      );
      
      canvas.drawLine(innerPoint, outerPoint, linePaint);
    }
    
    // Draw decorative segments
    final segmentPaint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 20),
      math.pi / 4,
      math.pi / 2,
      false,
      segmentPaint,
    );
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 20),
      math.pi * 1.25,
      math.pi / 3,
      false,
      segmentPaint,
    );
  }
  
  @override
  bool shouldRepaint(FuturisticElementsPainter oldDelegate) {
    return oldDelegate.timeAngle != timeAngle || 
           oldDelegate.pulseValue != pulseValue;
  }
}
