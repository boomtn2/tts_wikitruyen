import 'dart:ffi';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/models_export.dart';
import 'package:tts_wikitruyen/repositories/audio_handle/singleton_audiohanle.dart';
import 'package:tts_wikitruyen/repositories/bookinfo_repository/local_bookinfor_repository.dart';

import 'package:tts_wikitruyen/repositories/bookinfo_repository/webview_bookinfor_repository.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/i_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/local_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/network_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/chapter_repository/i_chapter_repository.dart';
import 'package:tts_wikitruyen/repositories/chapter_repository/local_chapter_repository.dart';
import 'package:tts_wikitruyen/repositories/chapter_repository/network_chapter_repository.dart';
import 'package:tts_wikitruyen/repositories/data_push.dart';
import 'package:tts_wikitruyen/repositories/website_repository/i_website_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/website_repository.dart';
import 'package:tts_wikitruyen/services/tts/enum_state.dart';

import '../../services/tts/handler_tts.dart';

enum UIPlayStatus { play, pause, loading, error }

enum UIDownloadStatus { download, stop, error }

class BookInforPresenter extends GetxController {
  Rx<BookInfoModel> bookInfoModel = BookInfoModel.none().obs;
  RxList<BookModel> listBookSame = <BookModel>[].obs;
  RxMap<String, String> chiMuc = {'': ''}.obs;
  RxMap<String, String> chapters = {'': ''}.obs;
  RxInt currentIndexTab = 0.obs;
  RxBool isFavorite = false.obs;
  RxBool isLoadingData = false.obs;
  final IBookModelReporitory _bookModelReporitory =
      NetWorkBookModelRepository();
  final IBookModelReporitory _localBookModelReporitory =
      LocalBookModelRepository();
  final IWebsiteRepository _websiteRepository = WebsiteRepository();
  final WebviewBookInforRepositoru _networkBookinforRepository =
      WebviewBookInforRepositoru();
  final LocalBookinforRepository _localBookinforRepository =
      LocalBookinforRepository();
  final IChapterRepository _netWorkChapterRepo = NetWorkChapterRepository();
  final IChapterRepository _localChapterRepo = LocalChapterRepository();
  late String imgTag;

  late String titleTag;

  late String authorTag;

  //TTS
  final HandlerTTS _controllerHandlerTTS =
      SingletonAudiohanle.controllerHandlerTTS;
  Rx<UIPlayStatus> uiPlayStatus = UIPlayStatus.loading.obs;
  Rx<TTSModel> ttsModel = TTSModel().obs;

  Rx<ChapterModel> chapter = ChapterModel.none().obs;

  Rx<UIDownloadStatus> uiDownloadStatus = UIDownloadStatus.stop.obs;
  Rx<ChapterModel> chapterDownload = ChapterModel.none().obs;
  RxMap<String, String> chaptersDownloaded = {'': ''}.obs;
  bool autoloading = false;
  final String nameDescription = 'Văn án';

  RxBool isModeOffline = false.obs;

  void _statePlayLoading() {
    uiPlayStatus.value = UIPlayStatus.loading;
  }

  void _statePlayPause() {
    uiPlayStatus.value = UIPlayStatus.pause;
  }

  void _statePlaySucces() {
    uiPlayStatus.value = UIPlayStatus.play;
  }

  void _statePlayError() {
    uiPlayStatus.value = UIPlayStatus.error;
  }

  //Funtion
  void getTag() {
    Map<String, String> tags = DataPush.getTagHero();
    imgTag = tags['imgTag'] ?? 'imgTag';
    titleTag = tags['titleTag'] ?? 'titleTag';
    authorTag = tags['authorTag'] ?? 'authorTag';
  }

  BookInforPresenter() {
    getTag();
    _init();
  }
  _init() async {
    _getMode();
    isLoadingData.value = true;
    _statePlayLoading();
    bookInfoModel.value.book = DataPush.getBook();

    Future.delayed(const Duration(microseconds: 100));
    if (isModeOffline.value) {
      _initOffline();
    } else {
      _initOnline();
    }
    isLoadingData.value = false;
  }

  void _initOffline() async {
    final bookinfo = await _localBookinforRepository.getBookInfo(
        bookInfoModel.value.book,
        idOrLink: bookInfoModel.value.book!.bookPath);
    bookinfo.book = bookInfoModel.value.book;
    bookInfoModel.value = bookinfo;
    setMotaChapter();
    checkFavorite();
    _statePlaySucces();
    _dataChapterOffline();
  }

  void _dataChapterOffline() {
    chapters.value = bookInfoModel.value.dsChuong;
  }

  void _initOnline() async {
    final bookinfo = await _networkBookinforRepository.getBookInfo(null,
        idOrLink: bookInfoModel.value.book!.bookPath);
    bookinfo.book = bookInfoModel.value.book;
    bookInfoModel.value = bookinfo;
    setMotaChapter();
    checkFavorite();
    _statePlaySucces();
    _dataChapterOnline();

    _dataBookSame();
  }

  void _getMode() {
    isModeOffline.value = DataPush.getModeIsOffline();
  }

  void setMotaChapter() {
    _controllerHandlerTTS.stop();
    chapter.value = ChapterModel(
        text: bookInfoModel.value.moTa,
        title: nameDescription,
        linkChapter: '',
        linkNext: '',
        linkPre: '');
  }

  _dataChapterOnline() {
    chiMuc.value = _networkBookinforRepository.chiMuc;
    chapters.value = _networkBookinforRepository.listChuong;
  }

  _dataBookSame() async {
    try {
      String link = bookInfoModel.value.book!.bookPath;
      final website = await _websiteRepository.findWebsite(link: link);
      if (website != null) {
        TagSearch tag = website.grsearchname.tags.first;
        tag.codetag = bookInfoModel.value.book!.bookName;
        link = website.grsearchname.linkSearch(chooseTags: [tag]);
        final data = await _bookModelReporitory.getListBookModel(
            tableOption: TableOption.booksame, link: link);
        if (data != null) {
          listBookSame.value = data;
        }
      }
    } catch (e) {}
  }

  void _inintTTS() {
    TTSModel temp = TTSModel();
    temp.voiceList(_controllerHandlerTTS.listVoices());
    temp.voiceNow(_controllerHandlerTTS.voiceNow());
    temp.speedNow(_controllerHandlerTTS.speech());
    temp.maxInputTTS(_controllerHandlerTTS.maxSpeechInputLength());

    ttsModel.value = temp;

    SingletonAudiohanle().voidCallbackAuto = () {
      if (_controllerHandlerTTS.ttsStatus() == TtsStatus.complate &&
          uiPlayStatus.value != UIPlayStatus.loading) {
        if (autoloading == true) {
          _autoPlay();
        } else {
          pause();
          stop();
          _audioThongBaoChonMucLuc();
        }
      }
    };

    SingletonAudiohanle().voidCallUIPause = () {
      if (_controllerHandlerTTS.ttsStatus() == TtsStatus.resumed &&
          uiPlayStatus.value != UIPlayStatus.pause) {
        _statePlayPause();
      }
    };

    SingletonAudiohanle().voidCallUIPlay = () {
      if (_controllerHandlerTTS.ttsStatus() == TtsStatus.paused &&
          uiPlayStatus.value != UIPlayStatus.play) {
        _statePlaySucces();
      }
    };
  }

  void selectChiMuc(String stChimuc) async {
    await _networkBookinforRepository.selectChiMuc(stChimuc: stChimuc);
    _dataChapterOnline();
    if (uiPlayStatus.value == UIPlayStatus.pause) {
      _controllerHandlerTTS.stop();
      _statePlaySucces();
      chapters.listen((p0) {
        if (p0.isNotEmpty) {
          setChapter(p0.entries.first.value, p0.entries.first.key);
        }
      });
    }
  }

  void selectBookSame(BookModel book) async {
    final temp = BookInfoModel.none();
    temp.book = book;
    bookInfoModel.value = temp;
    Future.delayed(const Duration(microseconds: 100));
    final bookinfo = await _networkBookinforRepository.getBookInfo(null,
        idOrLink: bookInfoModel.value.book!.bookPath);
    bookinfo.book = bookInfoModel.value.book;
    bookInfoModel.value = bookinfo;
    chapter.value = ChapterModel(
        text: bookinfo.moTa,
        title: nameDescription,
        linkChapter: '',
        linkNext: '',
        linkPre: '');
    _dataChapterOnline();
  }

  void selectTab(int index) {
    currentIndexTab.value = index;
    switch (index) {
      case 1:
        _inintTTS();
    }
  }

  String getStringUIPlayState(UIPlayStatus status) {
    switch (status) {
      case UIPlayStatus.play:
        return 'Chưa bấm nút play';
      case UIPlayStatus.pause:
        return 'Đang nghe';
      case UIPlayStatus.error:
        return 'Có lỗi vui long thử chương khác!';
      case UIPlayStatus.loading:
        return 'Đang tải chương';
      default:
        return 'Trạng thái chưa xác định';
    }
  }

  void play() async {
    _setDataTTS();
    await _controllerHandlerTTS.play();
    _statePlayPause();
    if (chapter.value.linkChapter.contains(chapters.entries.last.key) &&
        chapter.value.title.contains(nameDescription) == false) {
      autoloading = false;
    } else {
      autoloading = true;
    }
  }

  void _autoPlay() async {
    await skip();
    play();
  }

  void _setDataTTS() {
    ttsModel.value.dataListText(
        ttsModel.value.splitTextIntoSentences(chapter.value.text));
    _controllerHandlerTTS.setTexts(
        index: 0,
        texts: ttsModel.value.getDataList(),
        title: chapter.value.title);
  }

  void pause() {
    _controllerHandlerTTS.pause();
    _statePlaySucces();
    autoloading = false;
  }

  void stop() {
    _controllerHandlerTTS.stop();
    _statePlaySucces();
    autoloading = false;
  }

  Future skip() async {
    _controllerHandlerTTS.loadingPlayState();
    if (chapter.value.title == nameDescription) {
      chapter.value = ChapterModel(
          text: '',
          title: chapters.entries.first.value,
          linkChapter: chapters.entries.first.key,
          linkNext: '',
          linkPre: '');
    } else {
      int index = 0;
      for (var element in chapters.entries) {
        if (index == 1) {
          chapter.value = ChapterModel(
              text: '',
              title: element.value,
              linkChapter: element.key,
              linkNext: '',
              linkPre: '');
          break;
        }

        if (chapter.value.linkChapter.contains(element.key)) {
          index++;
        }
      }
    }

    await setChapter(chapter.value.title, chapter.value.linkChapter);
  }

  void setSpeed(double speed) async {
    await _controllerHandlerTTS.pause();
    _statePlayLoading();
    final flag = await _controllerHandlerTTS.setSpeech(speed);
    if (flag != null && flag == 1) {
      final temp = TTSModel();
      temp.voiceList(ttsModel.value.getVoiceList());
      temp.dataListText(ttsModel.value.getDataList());
      temp.speedNow(speed);
      temp.voiceNow(ttsModel.value.getVoiceNow());
      temp.maxInputTTS(ttsModel.value.getMaxInput());
      ttsModel.value = temp;
      _statePlaySucces();
    } else {
      _statePlayError();
    }
  }

  void setVoice(Map<dynamic, dynamic> voice) async {
    await _controllerHandlerTTS.pause();
    _statePlayLoading();
    final flag = await _controllerHandlerTTS.setVoice(voice: voice);
    if (flag != null && flag == 1) {
      final temp = TTSModel();
      temp.voiceList(ttsModel.value.getVoiceList());
      temp.dataListText(ttsModel.value.getDataList());
      temp.speedNow(ttsModel.value.getSpeedNow());
      temp.voiceNow(voice);
      temp.maxInputTTS(ttsModel.value.getMaxInput());

      ttsModel.value = temp;
      _statePlaySucces();
    } else {
      _statePlayError();
    }
  }

  Future setChapter(String title, String link) async {
    if (_controllerHandlerTTS.ttsStatus() == TtsStatus.paused ||
        _controllerHandlerTTS.ttsStatus() == TtsStatus.playing) {
      _controllerHandlerTTS.stop();
    }
    if (uiPlayStatus.value != UIPlayStatus.loading) {
      _statePlayLoading();

      chapter.value = ChapterModel(
          text: '', title: title, linkChapter: link, linkNext: '', linkPre: '');
      final _chapterRepo = await _getChapter(
          isModeOffline.value ? _localChapterRepo : _netWorkChapterRepo,
          chapter.value,
          _getIDBook());
      await _netWorkChapterRepo.getChapter(chapterModel: chapter.value);
      if (_chapterRepo != null) {
        _chapterRepo.title = title;

        chapter.value = _chapterRepo;
        _statePlaySucces();
      } else {
        _statePlayError();
      }
    }
  }

  String _getIDBook() {
    if (bookInfoModel.value.book != null) {
      return bookInfoModel.value.book!.id;
    }
    return '';
  }

  Future<ChapterModel?> _getChapter(IChapterRepository chapterRepository,
      ChapterModel chapterModel, String id) async {
    return chapterRepository.getChapter(chapterModel: chapter.value, id: id);
  }

  void setChapterDownload(String title, String link) async {
    chapterDownload.value = ChapterModel(
        text: '', title: title, linkChapter: link, linkNext: '', linkPre: '');
    stateDownloadStop();
  }

  void download() async {
    if (chapterDownload.value.linkChapter.isNotEmpty) {
      stateDownloading();
      await _saveBookOffline();
      _runDownload(bookInfoModel.value.book!.id);
    } else {
      stateDownloadError();
      Get.snackbar(
          'Chưa chọn chapter!', 'Yêu cầu chọn chapter bắt đầu tải về!');
    }
  }

  void _runDownload(String id) async {
    while (uiDownloadStatus.value == UIDownloadStatus.download) {
      ChapterModel? chapter = await _netWorkChapterRepo.getChapter(
          chapterModel: chapterDownload.value);

      if (chapter != null) {
        if (chapter.text.isNotEmpty) {
          String title = chapter.title.trim();
          title = title.replaceAll('\n', ':');
          chapter.title = title;
          await _saveChapterOffline(id, chapter);
          chapter.linkChapter = chapter.linkNext;
          chapterDownload.value = chapter;

          await Future.delayed(const Duration(seconds: 1));
        } else {
          stateDownloadStop();
        }
      } else {
        stateDownloadStop();
      }
    }
  }

  void deleteDownload() async {
    if (bookInfoModel.value.book != null) {
      await _localBookModelReporitory.deleteBookModel(
          tableOption: TableOption.offline,
          bookModel: bookInfoModel.value.book!);
      _localChapterRepo.deleteChapter(id: bookInfoModel.value.book!.id);
      getChaptersDownloaded();
    }
  }

  void getChaptersDownloaded() async {
    if (bookInfoModel.value.book != null) {
      final data = await _localBookinforRepository.getBookInfo(
          bookInfoModel.value.book!,
          idOrLink: bookInfoModel.value.book!.id);

      chaptersDownloaded.value = data.dsChuong;
    }
  }

  Future _saveBookOffline() async {
    if (bookInfoModel.value.book != null) {
      await _localBookModelReporitory.addBookModel(
          tableOption: TableOption.offline,
          bookModel: bookInfoModel.value.book!,
          bookInfoModel: bookInfoModel.value);
    }
  }

  void stateDownloading() {
    uiDownloadStatus.value = UIDownloadStatus.download;
  }

  void stateDownloadStop() {
    uiDownloadStatus.value = UIDownloadStatus.stop;
  }

  void stateDownloadError() {
    uiDownloadStatus.value = UIDownloadStatus.error;
  }

  Future _saveChapterOffline(String id, ChapterModel chapterTemp) async {
    if (bookInfoModel.value.book != null) {
      await _localChapterRepo.saveChapter(chapterModel: chapterTemp, id: id);
    }
  }

  void saveHistory() {
    if (chapter.value.title.isNotEmpty) {
      final history = HistoryModel(
          nameChapter: chapter.value.title,
          chapterPath: chapter.value.linkChapter,
          text: '');
      final book = bookInfoModel.value.book;
      if (book != null &&
          history.nameChapter.contains(nameDescription) == false) {
        book.history = history;
        _localBookModelReporitory.addBookModel(
            tableOption: TableOption.history, bookModel: book);
      }
    }
  }

  void saveFavorite() {
    if (isFavorite.value) {
      if (bookInfoModel.value.book != null) {
        _localBookModelReporitory.deleteBookModel(
            tableOption: TableOption.favorit,
            bookModel: bookInfoModel.value.book!);
      }
    } else {
      final book = bookInfoModel.value.book;
      if (book != null) {
        _localBookModelReporitory.addBookModel(
            tableOption: TableOption.favorit, bookModel: book);
      }
    }

    checkFavorite();
  }

  void checkFavorite() async {
    if (_localBookModelReporitory is LocalBookModelRepository) {
      if (bookInfoModel.value.book != null) {
        isFavorite.value = await _localBookModelReporitory
            .isFavorite(bookInfoModel.value.book!);
      }
    }
  }

  void reloadChapters() async {
    if (bookInfoModel.value.book != null) {
      isLoadingData.value = true;
      await _networkBookinforRepository.getBookInfo(null,
          idOrLink: bookInfoModel.value.book!.bookPath);
      _dataChapterOnline();
      if (chapters.isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        await _networkBookinforRepository.indexingAndChapter();
        _dataChapterOnline();
      }
      isLoadingData.value = false;
    }
  }

  void nhayDoan() {
    ttsModel.value.dataListText(
        ttsModel.value.splitTextIntoSentences(chapter.value.text));
  }

  void selectString(String st, int index) async {
    int indexTTSSelect = index;
    List<String> dataTTS = [];
    final dataListText = ttsModel.value.getDataList();
    //head < index
    for (int i = 0; i < index; ++i) {
      dataTTS.add(dataListText[i]);
    }

    //between == index
    List<String> between = _slipText(stSlip: st, st: dataListText[index]);
    //get firt index list slip
    dataTTS.addAll(between);
    if (between.length > 1) {
      indexTTSSelect += 1;
    }

    //last index + 1
    for (int i = index + 1; i < dataListText.length; ++i) {
      dataTTS.add(dataListText[i]);
    }

    _controllerHandlerTTS.stop();

    _controllerHandlerTTS.setTexts(
        index: indexTTSSelect, texts: dataTTS, title: chapter.value.title);
    await _controllerHandlerTTS.play();
    autoloading = true;
    _statePlayPause();
  }

  List<String> _slipText({required String stSlip, required String st}) {
    List<String> listStringSplit = st.split(stSlip);
    for (int i = 0; i < listStringSplit.length; ++i) {
      if (i == 0) {
      } else {
        String temp = stSlip + listStringSplit[i];
        listStringSplit[i] = temp;
      }
    }

    return listStringSplit;
  }

  void _audioThongBaoChonMucLuc() {
    Get.snackbar('Đã hết chương trong mục lục này!',
        'Hãy chuyển sang mục lục tiếp theo để nghe tiếp');
  }
}
