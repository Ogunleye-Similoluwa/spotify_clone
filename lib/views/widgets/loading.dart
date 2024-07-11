import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
  final Color? color;
  const Loading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return  CircularProgressIndicator(
      color: color??Colors.black,
    );
  }
}
