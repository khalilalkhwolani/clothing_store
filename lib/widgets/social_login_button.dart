import 'package:flutter/material.dart';
import 'package:myprojectshop/theme/theme.dart';

class SocialLoginButton extends StatelessWidget {

final String text;
final String image;
final VoidCallback onPressed;   
final Color?backgroundColor;
final Color? textColor;
  const SocialLoginButton({
    super.key,
    required this.text,
    required this.image,
    required this.onPressed,
    this.backgroundColor,
    this.textColor, required String iconPath,
  });
  


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:  Colors.grey.withOpacity(0.1),
            // Color.fromARGB(255, 209, 215, 198).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset:Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.textsecandery.withOpacity(0.1),
          width: 1,
        ),
      ),
      child:Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            
        
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Image.asset(
                    image,
                    height: 24,
                    width: 24,
                  ),
                  SizedBox(width: 12,),
                  Text(
                    text,
                    style: TextStyle(
                    color: textColor ?? AppTheme.textsecandery,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]
              ),
            
          ),
        ),
      ) ,
    );
  }
}