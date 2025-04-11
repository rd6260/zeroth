import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockFive extends StatefulWidget {
  const ClockFive({super.key});

  @override
  State<ClockFive> createState() => _ClockFiveState();
}

class _ClockFiveState extends State<ClockFive>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late DateTime _currentTime;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final String _sleepDuration = "8H 32M";
  final double _temp = 27.0;
  final bool _wifiConnected = true;
  final bool _bluetoothConnected = true;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();

    // Set up timer to update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });

    // Set up pulsing animation for the active elements
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDateDisplay(),
              _buildTimeDisplay(),
              const SizedBox(height: 20),
              _buildSleepData(),
              const SizedBox(height: 20),
              _buildBottomRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateDisplay() {
    String dayName = DateFormat('EEEE').format(_currentTime);
    String day = DateFormat('d').format(_currentTime);

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$dayName $day',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    String hours = DateFormat('HH').format(_currentTime);
    String minutes = DateFormat('mm').format(_currentTime);
    String seconds = DateFormat('ss').format(_currentTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Text(
              '$hours:$minutes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w200,
                letterSpacing: 2,
                height: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.cyan.withValues(
                      alpha: 0.3 * _pulseAnimation.value,
                    ),
                    blurRadius: 12 * _pulseAnimation.value,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        Text(
          seconds,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 24,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sleep',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _sleepDuration,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.deepOrange.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.deepOrange.shade900,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'REM',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '10:32',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'REM',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '03:32',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Temperature
        Text(
          '$_temp°C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w300,
          ),
        ),

        // WiFi and Bluetooth icons
        Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Icon(
                  Icons.wifi,
                  color:
                      _wifiConnected
                          ? Colors.white.withValues(
                            alpha: _pulseAnimation.value,
                          )
                          : Colors.white.withValues(alpha: 0.3),
                  size: 24,
                );
              },
            ),
            const SizedBox(width: 12),
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Icon(
                  Icons.bluetooth,
                  color:
                      _bluetoothConnected
                          ? Colors.white.withValues(
                            alpha: _pulseAnimation.value,
                          )
                          : Colors.white.withValues(alpha: 0.3),
                  size: 24,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
