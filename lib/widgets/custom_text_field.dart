import 'package:flutter/material.dart';
import 'package:myprojectshop/theme/theme.dart';

class CustomTextField extends StatelessWidget {
final String label;
final IconData prefixIcon; 
final bool isPassword;
final TextInputType? keyboardType;
final String? Function(String?)? validator;
final TextEditingController controller;
final Widget? suffixIcon;


  const CustomTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    required this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        validator: validator,
        style: TextStyle(
          color: AppTheme.textsecandery,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppTheme.textsecandery.withOpacity(0.5),
            fontSize: 16,
          ),
          prefixIcon: Icon(prefixIcon, 
          color: AppTheme.primaryColor,),
          suffixIcon: suffixIcon??(isPassword?IconButton(
            icon: Icon(isPassword?Icons.visibility:Icons.visibility_off),
            color: AppTheme.primaryColor,
            onPressed: () {
              // Toggle password visibility
            },
          ):null),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}