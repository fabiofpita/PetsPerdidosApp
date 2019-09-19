import 'package:flutter/material.dart';

class PetLoading extends StatefulWidget {
  @override
  _PetLoadingState createState() => _PetLoadingState();
}

class _PetLoadingState extends State<PetLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black12,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
