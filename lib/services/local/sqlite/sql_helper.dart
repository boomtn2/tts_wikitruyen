import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/book.dart';
import '../../../models/bookinfor.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  final String nameDB = 'dbttswikitruyen.db';
  // Tên của bảng và các cột
  final String tableBookFavorite = 'book_favorite';
  final String tableBookHistory = 'book_history';
  final String tableBook = 'book_offline';
  final String columnId = 'id';
  final String imgPath = 'imgPath';
  final String bookName = 'bookName';
  final String bookAuthor = 'bookAuthor';
  final String bookPath = 'bookPath';
  final String theLoai = 'theLoai';
  final String moTa = 'moTa';

  final String tableChapter = 'chapter_offline';
  final String nameChapter = 'nameChapter';
  final String textChapter = 'textChapter';

  final String tableHistory = 'history';
  //nameChapter

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, nameDB);
    var myDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableBook($columnId TEXT PRIMARY KEY ,$imgPath TEXT,$bookName TEXT,$bookAuthor TEXT,$moTa TEXT, $theLoai TEXT, $bookPath TEXT)');
    await db.execute(
        'CREATE TABLE $tableBookFavorite($columnId TEXT PRIMARY KEY ,$imgPath TEXT,$bookName TEXT,$bookAuthor TEXT,$moTa TEXT, $theLoai TEXT, $bookPath TEXT)');

    await db.execute(
        'CREATE TABLE $tableBookHistory($columnId TEXT PRIMARY KEY ,$imgPath TEXT,$bookName TEXT,$bookAuthor TEXT,$moTa TEXT, $theLoai TEXT, $bookPath TEXT)');

    await db.execute(
        'CREATE TABLE $tableChapter($columnId TEXT,$nameChapter TEXT,$textChapter TEXT )');
    await db.execute(
        'CREATE TABLE $tableHistory($columnId TEXT,$nameChapter TEXT)');
  }

  // Thêm dữ liệu
  Future<int> insertBook({required BookInfo item}) async {
    var dbClient = await db;
    if (item.book != null) {
      final book = item.book!;

      try {
        var result = await dbClient!.insert(tableBook, {
          columnId: book.bookName + book.bookAuthor,
          imgPath: book.imgPath,
          bookName: book.bookName,
          bookAuthor: book.bookAuthor,
          theLoai: jsonEncode(item.theLoai),
          moTa: item.moTa
        });
        return result;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  Future<int> insertChapter(
      {required BookInfo item,
      required String nameChapter,
      required String text}) async {
    var dbClient = await db;
    if (item.book != null) {
      final book = item.book!;
      try {
        var result = await dbClient!.insert(tableChapter, {
          columnId: book.bookName + book.bookAuthor,
          this.nameChapter: nameChapter,
          textChapter: text,
        });

        return result;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  // Xóa dữ liệu
  Future<int> deleteBook(String id) async {
    var dbClient = await db;
    return await dbClient!
        .delete(tableBook, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteChapter(String id) async {
    var dbClient = await db;
    return await dbClient!
        .delete(tableChapter, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Book>> getListBook() async {
    var dbClient = await db;
    List<Book> lsBook = [];
    try {
      final List<Map<String, dynamic>> dataList =
          await dbClient!.query(tableBook);

      for (var element in dataList) {
        lsBook.add(Book(
            imgPath: element[imgPath],
            bookPath: '',
            bookName: element[bookName],
            bookAuthor: element[bookAuthor],
            bookPublisher: '',
            bookViews: 'Đã Tải Về',
            bookStar: '',
            bookComment: ''));
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }

    return lsBook;
  }

  Future<BookInfo> getBookInfo({required Book book}) async {
    BookInfo bookInfo = BookInfo(theLoai: [], moTa: moTa, dsChuong: []);
    bookInfo.book = book;
    try {
      var dbClient = await db;

      final List<Map<String, dynamic>> dataList = await dbClient!.query(
          tableBook,
          columns: [moTa, theLoai],
          where: '$columnId = ?',
          whereArgs: [book.bookName + book.bookAuthor]);

      final List<Map<String, dynamic>> listNameChuong = await dbClient.query(
          tableChapter,
          columns: [nameChapter],
          where: '$columnId = ?',
          whereArgs: [book.bookName + book.bookAuthor]);

      if (dataList.isNotEmpty) {
        List listTheMoai = jsonDecode(dataList.first[theLoai].toString());

        for (Map element in listTheMoai) {
          String key = element.keys.first.toString();
          String value = element.values.first.toString();
          bookInfo.theLoai.add({key: value});
        }

        for (var chapter in listNameChuong) {
          bookInfo.dsChuong.add({chapter[nameChapter]: ''});
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }

    return bookInfo;
  }

  Future<String> getTextChapter(
      {required String id, required String nChapter}) async {
    try {
      var dbClient = await db;
      final List<Map<String, dynamic>> dataList = await dbClient!.query(
          tableChapter,
          columns: [textChapter],
          where: '$columnId = ? AND $nameChapter = ?',
          whereArgs: [id, nChapter]);
      String text = dataList.first[textChapter];
      return text;
    } catch (e) {
      return e.toString();
    }
  }
}
