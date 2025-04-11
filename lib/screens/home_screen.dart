import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HomeScreen extends StatefulWidget {
  final List<Widget> screens;
  final int initialIndex;

  const HomeScreen({super.key, required this.screens, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Set the app to landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _currentIndex = widget.initialIndex.clamp(0, widget.screens.length - 1);
    
    // Enable wakelock to prevent the screen from turning off
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Reset to default orientations when the widget is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Disable wakelock when the widget is disposed
    WakelockPlus.disable();
    super.dispose();
  }

  void _goToPrevious() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = widget.screens.length - 1;
      }
    });
  }

  void _goToNext() {
    setState(() {
      if (_currentIndex < widget.screens.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Current screen
          widget.screens[_currentIndex],

          // Previous button (bottom left)
          Positioned(
            left: 16,
            bottom: 16,
            child: Opacity(
              opacity: 0.1, // Very subtle opacity
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                // onPressed: _currentIndex > 0 ? _goToPrevious : null,
                onPressed: _goToPrevious,
              ),
            ),
          ),

          // Next button (bottom right)
          Positioned(
            right: 16,
            bottom: 16,
            child: Opacity(
              opacity: 0.1, // Very subtle opacity
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                // onPressed:
                //     _currentIndex < widget.screens.length - 1
                //         ? _goToNext
                //         : null,
                onPressed: _goToNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}