import 'dart:async';

import 'package:ai_tools_verse/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late AnimationController _progressController ;
  late Animation<double> _progressAnimation;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000)
    );
    _progressAnimation = Tween<double>(begin: 0.0,end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve:Curves.linear)
    );
    _progressController.forward();
    
    // Navigate to main screen after splash
    _timer = Timer(Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              center: Alignment(0, -0.4),
              colors: [
            Color(0xFF26215C),
            Color(0xFF150F28),
            Color(0xFF0D0A14),
          ],stops: [0.0,0.45,1.0])
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientLogo,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Icon(Icons.auto_awesome,color: Colors.white,size: 42,),
              ),
              SizedBox(height: 22),
              Text('AIVerse',style : GoogleFonts.inter(
                color: Colors.white,fontWeight: FontWeight.w500,
                fontSize: 26
              )),
              SizedBox(height: 6),
              Text('Discover the best AI tools for every task',style: GoogleFonts.inter(
                fontSize: 13,color: AppColors.purplePrimary,
                height: 1.5
              ),),
              SizedBox(height: 15),
              SizedBox(
                width: 120,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context,child){
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: AppColors.purpleDark,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.border
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Made for builders, by builders',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
