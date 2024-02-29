import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget bottomSheetCustom(
    {required dynamic indexChoose,
    required List<dynamic> data,
    required Function function}) {
  return Card(
    color: Colors.black,
    child: SizedBox(
      width: double.infinity,
      child: ListView(
          children: data
              .map(
                (e) => ListTile(
                    title: Text(
                      '${e}',
                      style: TextStyle(
                          color: indexChoose == e ? Colors.red : Colors.white),
                    ),
                    onTap: () {
                      function(e);
                      Get.back();
                    }),
              )
              .toList()),
    ),
  );
}

Widget bottomSheetChapter(
    {required dynamic indexChoose,
    required List<Map<dynamic, dynamic>> data,
    required Function function}) {
  return Card(
    color: Colors.black,
    child: SizedBox(
      width: double.infinity,
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2 / 0.5,
          children: data
              .map(
                (e) => InkWell(
                    child: Card(
                      color: Colors.brown,
                      child: Center(
                        child: Text(
                          '${e.keys}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color:
                                  indexChoose == e ? Colors.red : Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      function(e);
                      Get.back();
                    }),
              )
              .toList()),
    ),
  );
}
