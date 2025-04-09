import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;



class ClockFour extends StatefulWidget {
  final List<String> textList;

  const ClockFour({
    super.key,
    this.textList = const ["Swipe up to unlock", "Battery optimization enabled"],
  });

  @override
  State<ClockFour> createState() => _ClockFourState();
}

class _ClockFourState extends State<ClockFour> with TickerProviderStateMixin {
  late Timer _timer;
  late DateTime _currentTime;
  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;
  int _currentTextIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Set system UI to be completely hidden
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // Initialize time
    _currentTime = DateTime.now();
    
    // Set up timer to update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    
    // Set up text fade animation
    _textFadeController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _textFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _textFadeController,
        curve: Curves.easeInOut,
      ),
    );
    
    _textFadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % widget.textList.length;
        });
        _textFadeController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _textFadeController.forward();
      }
    });
    
    _textFadeController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _textFadeController.dispose();
    // Restore system UI when widget is disposed
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              // Subtle hexagonal pattern for futuristic background
              CustomPaint(
                size: Size.infinite,
                painter: HexGridPainter(),
              ),
              
              // Main content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Digital time display
                    Text(
                      _formatTime(_currentTime),
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 80,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -2,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                    
                    // Date display
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatDate(_currentTime),
                        style: TextStyle(
                          color: Colors.cyan.withValues(alpha: 0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    
                    // Progress bar for seconds
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.cyan.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _currentTime.second / 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    
                    // Circular elements for decoration
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCircularElement(6),
                          const SizedBox(width: 20),
                          buildCircularElement(8),
                          const SizedBox(width: 20),
                          buildCircularElement(6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom fading text
              Positioned(
                left: 0,
                right: 0,
                bottom: 60,
                child: Center(
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      widget.textList[_currentTextIndex],
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget buildCircularElement(double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.cyan.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime date) {
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    
    return '${days[date.weekday % 7]} ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// Custom painter for hexagonal background pattern
class HexGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    const double hexSize = 30;
    final double width = size.width;
    final double height = size.height;
    
    for (double y = 0; y < height + hexSize; y += hexSize * 1.5) {
      double offset = (y / (hexSize * 1.5)).floor() % 2 == 0 ? 0 : hexSize * 0.866;
      
      for (double x = -hexSize; x < width + hexSize; x += hexSize * 1.732) {
        final Path hexPath = Path();
        for (int i = 0; i < 6; i++) {
          final double angle = (i * 60 - 30) * (math.pi / 180);
          final double hx = x + offset + hexSize * math.cos(angle);
          final double hy = y + hexSize * math.sin(angle);
          
          if (i == 0) {
            hexPath.moveTo(hx, hy);
          } else {
            hexPath.lineTo(hx, hy);
          }
        }
        hexPath.close();
        canvas.drawPath(hexPath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}