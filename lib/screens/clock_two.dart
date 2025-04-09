import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ClockTwoScreen extends StatefulWidget {
  const ClockTwoScreen({super.key});

  @override
  State<ClockTwoScreen> createState() => _ClockTwoScreenState();
}

class _ClockTwoScreenState extends State<ClockTwoScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late DateTime _currentTime;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Sets app to fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    _currentTime = DateTime.now();

    // Animation for pulsating effect
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format time and date
    final hourFormat = DateFormat('HH');
    final minuteFormat = DateFormat('mm');
    final secondsFormat = DateFormat('ss');
    final dateFormat = DateFormat('EEE, d MMM');

    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Digital clock display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hours
                  Text(
                    hourFormat.format(_currentTime),
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 80,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Orbitron',
                      letterSpacing: 2,
                    ),
                  ),

                  // Separator
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _pulseAnimation.value,
                        child: const Text(
                          ":",
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 80,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    },
                  ),

                  // Minutes
                  Text(
                    minuteFormat.format(_currentTime),
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 80,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Orbitron',
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),

              // Seconds display with horizontal line effect
              Container(
                width: 150,
                margin: const EdgeInsets.only(top: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 1,
                      color: Colors.cyanAccent.withValues(alpha: 0.3),
                    ),
                    Text(
                      secondsFormat.format(_currentTime),
                      style: TextStyle(
                        color: Colors.cyanAccent.withValues(alpha: 0.7),
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Orbitron',
                        letterSpacing: 5,
                      ),
                    ),
                  ],
                ),
              ),

              // Date display
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  dateFormat.format(_currentTime).toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  ),
                ),
              ),

              // Futuristic decorative elements
              Container(
                margin: const EdgeInsets.only(top: 50),
                width: 200,
                height: 40,
                child: CustomPaint(
                  painter: FuturisticLinePainter(_currentTime.second / 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for futuristic effect
class FuturisticLinePainter extends CustomPainter {
  final double progress;

  FuturisticLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Base line
    final basePaint =
        Paint()
          ..color = Colors.cyanAccent.withValues(alpha: 0.2)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    // Progress line
    final progressPaint =
        Paint()
          ..color = Colors.cyanAccent
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw base horizontal line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      basePaint,
    );

    // Draw progress line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width * progress, size.height / 2),
      progressPaint,
    );

    // Draw decorative vertical lines
    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      final linePaint =
          Paint()
            ..color = Colors.cyanAccent.withValues(alpha: i % 3 == 0 ? 0.5 : 0.2)
            ..strokeWidth = i % 3 == 0 ? 1 : 0.5;

      final height = i % 3 == 0 ? size.height / 2 : size.height / 4;
      canvas.drawLine(
        Offset(x, (size.height - height) / 2),
        Offset(x, (size.height + height) / 2),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
