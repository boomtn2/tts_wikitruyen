import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard(
      {super.key,
      required this.title,
      required this.isChoose,
      required this.voidcallback});
  final String title;
  final bool isChoose;
  final Function voidcallback;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        voidcallback();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isChoose ? Colors.white : Colors.black,
            border: Border.all(
              color: isChoose ? Colors.blue : Colors.white30,
              width: isChoose ? 1 : 2,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: isChoose ? Colors.black : Colors.white60,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
