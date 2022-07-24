import 'package:flutter/material.dart';
import 'package:vitalinea/main.dart';

class MyWidget extends StatelessWidget {
  final Widget child;
  final bool controller;
  const MyWidget({Key? key, required this.child, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
      left: controller ? 0 : -250,
      child: Container(
        padding: const EdgeInsets.only(left: 8),
        height: MediaQuery.of(context).size.height,
        width: 250,
        decoration: BoxDecoration(
          color: MyApp.myColor.shade50,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
