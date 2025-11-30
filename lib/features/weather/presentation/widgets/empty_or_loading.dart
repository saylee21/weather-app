import 'package:flutter/material.dart';
import 'package:weatherapp/core/constant/string_constants.dart';

class EmptyOrLoading extends StatelessWidget {
  const EmptyOrLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }
}
