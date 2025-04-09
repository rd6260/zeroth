import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ClockSix extends StatefulWidget {
  const ClockSix({super.key});

  @override
  State<ClockSix> createState() => _ClockSixState();
}

class _ClockSixState extends State<ClockSix> with SingleTickerProviderStateMixin {
  late Timer _timer;
  DateTime _dateTime = DateTime.now();
  bool _isPlaying = false;
  String _currentSong = "Lost in the Echo";
  final String _artist = "Linkin Park";
  String _currentTime = "1:25";
  String _totalTime = "3:21";
  
  // Animation controller for pulsing effect
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
    
    // Setup pulsing animation for the play indicator
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _skipNext() {
    // This would connect to the MediaSession API to skip to next track
    // For demo, just showing the function
    setState(() {
      // Simulated song change
      if (_currentSong == "Lost in the Echo") {
        _currentSong = "In The End";
        _currentTime = "0:00";
        _totalTime = "3:36";
      } else {
        _currentSong = "Lost in the Echo";
        _currentTime = "1:25";
        _totalTime = "3:21";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Left side - Clock
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Digital time with futuristic font
                      Text(
                        DateFormat('HH:mm').format(_dateTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Display seconds with a different style
                      Text(
                        DateFormat('ss').format(_dateTime),
                        style: TextStyle(
                          color: Colors.blueAccent.withValues(alpha: 0.7),
                          fontSize: 36,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Date display
                      Text(
                        DateFormat('E, MMM d').format(_dateTime),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right side - Music Widget
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Song info
                      Text(
                        _currentSong,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        _artist,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 20),
                      
                      // Album art that acts as play/pause button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Album art
                            Container(
                              width: size.width * 0.3,
                              height: size.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: AssetImage('assets/album_cover.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            
                            // Play/Pause indicator
                            if (_isPlaying)
                              ScaleTransition(
                                scale: _pulseAnimation,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Music progress and controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Current time / Total time
                          Text(
                            '$_currentTime / $_totalTime',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 20),
                          
                          // Next button
                          GestureDetector(
                            onTap: _skipNext,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blueAccent.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}