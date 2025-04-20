  import 'package:flutter/material.dart';

showSnackBar (String message,BuildContext Context){
    final snackBar = SnackBar( 
      content: Text(message), 
      action: SnackBarAction( 
        label: 'OK', 
        onPressed: () {},
         ),
          ); 
          ScaffoldMessenger.of(Context).showSnackBar(snackBar);
  }