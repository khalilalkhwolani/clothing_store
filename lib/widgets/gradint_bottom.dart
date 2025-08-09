import 'package:flutter/material.dart';
import 'package:myprojectshop/theme/theme.dart';

class GradintBottom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>gradint;
  final double height;
  final double? width;
  final bool isLoading;
 
  const GradintBottom({
   
   required this.text, 
   required this.onPressed,
    this.height=56,
    this.width,
    this.isLoading=false,
    this.gradint=AppTheme.primaryGradient,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradint,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradint.first.withOpacity(0.4), // Color.fromARGB(255, 209, 215, 198).withOpacity(0.2),
            blurRadius: 20,
            offset:Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton( onPressed:isLoading?null:onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius:
          BorderRadius.circular(16)),
          padding: EdgeInsets.zero),
        child: isLoading? SizedBox(
          height: 24,
          width: 24,
          
       child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
          ),
        ):Text(text,
        style: 
        TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,

        ),
        ),
      
    ),
    );
  }
}
