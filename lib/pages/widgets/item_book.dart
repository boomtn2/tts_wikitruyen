import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/book.dart';

class ItemBook extends StatelessWidget {
  ItemBook(
      {super.key,
      required this.book,
      required this.nexToPage,
      this.someThings});
  final Book book;
  Function nexToPage;
  Function? someThings;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        nexToPage();
      },
      child: Card(
        color: Color.fromARGB(255, 228, 225, 225),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            height: 170,
            width: Get.size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          book.imgFullPath,
                        ),
                        fit: BoxFit.fill,
                        onError: (exception, stackTrace) {},
                      )),
                  width: Get.size.width / 3,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${book.bookName}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${book.bookAuthor}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 30,
                        child: Text(
                          '🫨${book.bookViews} 👑${book.bookStar} 💬${book.bookComment}',
                          style: TextStyle(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
