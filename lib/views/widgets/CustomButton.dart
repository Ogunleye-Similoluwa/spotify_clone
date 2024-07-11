import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CustomButton extends StatefulWidget {
 final  double width;
 final  double height;
 final Widget child;
 final void Function()? onPressed;
 final Color? color;
 final ShapeBorder? shape;
 const CustomButton({super.key, required this.width, this.shape, required this.color,required this.height, required this.child, required this.onPressed});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: widget.shape,
      color: widget.color,
      onPressed: widget.onPressed,
      minWidth:widget.width,
      height: widget.height,
      child: widget.child,
    );
  }
}


class CustomButton2 extends StatelessWidget {

  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  const CustomButton2({super.key, required this.color, required this.child, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return MaterialButton( minWidth: 380, height:60 ,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white,width: 2)),onPressed:onPressed,color: color, child: child);
  }
}
