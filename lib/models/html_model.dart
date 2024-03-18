// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuerryGetListBookHTML {
  String querryList;
  String queryText;
  String queryScr;
  String queryAuthor;
  String queryview;
  String queryHref;
  String domain;
  QuerryGetListBookHTML({
    required this.querryList,
    required this.queryText,
    required this.queryScr,
    required this.queryAuthor,
    required this.queryview,
    required this.queryHref,
    required this.domain,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'querryList': querryList,
      'queryText': queryText,
      'queryScr': queryScr,
      'queryAuthor': queryAuthor,
      'queryview': queryview,
      'queryHref': queryHref,
      'domain': domain,
    };
  }

  factory QuerryGetListBookHTML.fromMap(Map<String, dynamic> map) {
    return QuerryGetListBookHTML(
      querryList: '${map['querryList']}',
      queryText: '${map['queryText']}',
      queryScr: '${map['queryScr']}',
      queryAuthor: '${map['queryAuthor']}',
      queryview: '${map['queryview']}',
      queryHref: '${map['queryHref']}',
      domain: '${map['domain']}',
    );
  }

  factory QuerryGetListBookHTML.none() {
    return QuerryGetListBookHTML(
      querryList: '',
      queryText: '',
      queryScr: '',
      queryAuthor: '',
      queryview: '',
      queryHref: '',
      domain: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QuerryGetListBookHTML.fromJson(String source) =>
      QuerryGetListBookHTML.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuerryGetListBookHTML(querryList: $querryList, queryText: $queryText, queryScr: $queryScr, queryAuthor: $queryAuthor, queryview: $queryview, queryHref: $queryHref, domain: $domain)';
  }
}

class QuerryGetChapterHTML {
  String querryLinkNext;
  String querryLinkPre;
  String querryTextChapter;
  String querryTitle;
  String domain;
  QuerryGetChapterHTML({
    required this.querryLinkNext,
    required this.querryLinkPre,
    required this.querryTextChapter,
    required this.querryTitle,
    required this.domain,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'querryLinkNext': querryLinkNext,
      'querryLinkPre': querryLinkPre,
      'querryTextChapter': querryTextChapter,
      'querryTitle': querryTitle,
      'domain': domain,
    };
  }

  factory QuerryGetChapterHTML.fromMap(Map<String, dynamic> map) {
    return QuerryGetChapterHTML(
      querryLinkNext: '${map['querryLinkNext']}',
      querryLinkPre: '${map['querryLinkPre']}',
      querryTextChapter: '${map['querryTextChapter']}',
      querryTitle: '${map['querryTitle']}',
      domain: '${map['domain']}',
    );
  }

  factory QuerryGetChapterHTML.none() {
    return QuerryGetChapterHTML(
      querryLinkNext: '',
      querryLinkPre: '',
      querryTextChapter: '',
      querryTitle: '',
      domain: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QuerryGetChapterHTML.fromJson(String source) =>
      QuerryGetChapterHTML.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuerryGetChapterHTML(querryLinkNext: $querryLinkNext, querryLinkPre: $querryLinkPre, querryTextChapter: $querryTextChapter, querryTitle: $querryTitle, domain: $domain)';
  }
}

class Website {
  String website;
  String domain;
  QuerryGetListBookHTML listbookhtml;
  QuerryGetChapterHTML chapterhtml;
  List<TagHot> listtaghot;
  List<GroupTagSearch> listgrtag;
  GroupTagSearch grsearchname;
  JSLeak jsleak;
  Website({
    required this.website,
    required this.domain,
    required this.listbookhtml,
    required this.chapterhtml,
    required this.listtaghot,
    required this.listgrtag,
    required this.grsearchname,
    required this.jsleak,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'website': website,
      'domain': domain,
      'listbookhtml': listbookhtml.toMap(),
      'chapterhtml': chapterhtml.toMap(),
      'listtaghot': listtaghot.map((x) => x.toMap()).toList(),
      'listgrtag': listgrtag.map((x) => x.toMap()).toList(),
      'grsearchname': grsearchname.toMap(),
      'jsleak': jsleak.toMap(),
    };
  }

  factory Website.fromMap(Map<String, dynamic> map) {
    return Website(
      website: '${map['website']}',
      domain: '${map['domain']}',
      listbookhtml: QuerryGetListBookHTML.fromMap(
          map['listbookhtml'] as Map<String, dynamic>),
      chapterhtml: QuerryGetChapterHTML.fromMap(
          map['chapterhtml'] as Map<String, dynamic>),
      listtaghot: List<TagHot>.from(
        (map['listtaghot'] as List<dynamic>).map<TagHot>(
          (x) => TagHot.fromMap(x as Map<String, dynamic>),
        ),
      ),
      listgrtag: List<GroupTagSearch>.from(
        (map['listgrtag'] as List<dynamic>).map<GroupTagSearch>(
          (x) => GroupTagSearch.fromMap(x as Map<String, dynamic>),
        ),
      ),
      grsearchname:
          GroupTagSearch.fromMap(map['grsearchname'] as Map<String, dynamic>),
      jsleak: JSLeak.fromMap(map['jsleak'] as Map<String, dynamic>),
    );
  }

  factory Website.none() {
    return Website(
      listtaghot: [],
      chapterhtml: QuerryGetChapterHTML.none(),
      website: '',
      domain: '',
      listbookhtml: QuerryGetListBookHTML.none(),
      listgrtag: [],
      grsearchname: GroupTagSearch.none(),
      jsleak: JSLeak.none(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Website.fromJson(String source) =>
      Website.fromMap(json.decode(source) as Map<String, dynamic>);
}

class TagHot {
  String link;
  String linkquerry;
  String nametag;
  String replace;
  int count;
  TagHot({
    required this.link,
    required this.linkquerry,
    required this.nametag,
    required this.replace,
    required this.count,
  });

  String linkLoadMore({required int countInt}) {
    String linkTemp = linkquerry.replaceAll(replace, '$countInt');
    return linkTemp;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'link': link,
      'linkquerry': linkquerry,
      'nametag': nametag,
      'replace': replace,
      'count': count,
    };
  }

  factory TagHot.fromMap(Map<String, dynamic> map) {
    return TagHot(
      link: '${map['link']}',
      linkquerry: '${map['linkquerry']}',
      nametag: '${map['nametag']}',
      replace: '${map['replace']}',
      count: int.tryParse(map['count'].toString()) ?? 0,
    );
  }
  factory TagHot.none() {
    return TagHot(
      link: '',
      linkquerry: '',
      nametag: '',
      replace: '',
      count: 0,
    );
  }
  String toJson() => json.encode(toMap());

  factory TagHot.fromJson(String source) =>
      TagHot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TagHot(link: $link, linkquerry: $linkquerry, nametag: $nametag, replace: $replace, count: $count)';
  }
}

class GroupTagSearch {
  // 1: true 0:false

  String multiselect;
  String namegroup;
  List<TagSearch> tags;
  String linksearch;
  String linkquerry;
  String querry;
  int count;
  GroupTagSearch({
    required this.multiselect,
    required this.namegroup,
    required this.tags,
    required this.linksearch,
    required this.linkquerry,
    required this.querry,
    required this.count,
  });

  String linkSearch({required List<TagSearch> chooseTags}) {
    String link = '';

    final uri = Uri.parse(linksearch);
    final Map<String, dynamic> param = {};
    param.addAll(uri.queryParametersAll);
    param.addAll(forMatListTag(chooseTags: chooseTags));

    final linkURI = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: param);
    link = '$linkURI';

    return link;
  }

  String getMoreLink(
      {required int count, required List<TagSearch> chooseTags}) {
    String link = '';
    String linkQuerry = linkquerry.replaceAll(querry, '$count');
    final uri = Uri.parse(linkQuerry);
    final Map<String, dynamic> param = {};
    param.addAll(uri.queryParametersAll);
    param.addAll(forMatListTag(chooseTags: chooseTags));

    final linkURI = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: param);
    link = '$linkURI';

    return link;
  }

  Map<String, dynamic> forMatListTag({required List<TagSearch> chooseTags}) {
    Map<String, List<String>> listTags = {};
    try {
      for (var element in chooseTags) {
        List<String>? getKey = listTags[element.tag];
        if (getKey != null) {
          getKey.add(element.codetag);
          listTags.addAll({element.tag: getKey});
        } else {
          listTags.addAll({
            element.tag: [element.codetag]
          });
        }
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('formatListTagToMap {class GroupTagSearch}: $listTags');
      // }
    }

    return listTags;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'multiselect': multiselect,
      'namegroup': namegroup,
      'tags': tags.map((x) => x.toMap()).toList(),
      'linksearch': linksearch,
      'linkquerry': linkquerry,
      'querry': querry,
      'count': count,
    };
  }

  factory GroupTagSearch.fromMap(Map<String, dynamic> map) {
    return GroupTagSearch(
      multiselect: '${map['multiselect']}',
      namegroup: '${map['namegroup']}',
      tags: List<TagSearch>.from(
        (map['tags'] as List<dynamic>).map<TagSearch>(
          (x) => TagSearch.fromMap(x as Map<String, dynamic>),
        ),
      ),
      linksearch: '${map['linksearch']}',
      linkquerry: '${map['linkquerry']}',
      querry: '${map['querry']}',
      count: int.tryParse(map['count'].toString()) ?? 0,
    );
  }

  factory GroupTagSearch.none() {
    return GroupTagSearch(
      multiselect: '',
      namegroup: '',
      tags: [],
      linksearch: '',
      linkquerry: '',
      querry: '',
      count: 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupTagSearch.fromJson(String source) =>
      GroupTagSearch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupTagSearch(multiselect: $multiselect, namegroup: $namegroup, tags: $tags, linksearch: $linksearch, linkquerry: $linkquerry, querry: $querry, count: $count)';
  }
}

class TagSearch {
  String tag;
  String nametag;
  String codetag;
  TagSearch({
    required this.tag,
    required this.nametag,
    required this.codetag,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tag': tag,
      'nametag': nametag,
      'codetag': codetag,
    };
  }

  Map<String, dynamic> toParam() {
    return <String, dynamic>{
      tag: codetag,
    };
  }

  factory TagSearch.fromMap(Map<String, dynamic> map) {
    return TagSearch(
      tag: '${map['tag']}',
      nametag: '${map['nametag']}',
      codetag: '${map['codetag']}',
    );
  }

  factory TagSearch.none() {
    return TagSearch(
      tag: '',
      nametag: '',
      codetag: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TagSearch.fromJson(String source) =>
      TagSearch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TagSearch(tag: $tag, nametag: $nametag, codetag: $codetag)';
}

class JSLeak {
  String jsIndexing;
  String jsListChapter;
  String jsActionNext;
  String jsDescription;
  String jsCategory;
  String jsOther;
  JSLeak({
    required this.jsIndexing,
    required this.jsListChapter,
    required this.jsActionNext,
    required this.jsDescription,
    required this.jsCategory,
    required this.jsOther,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jsIndexing': jsIndexing,
      'jsListChapter': jsListChapter,
      'jsActionNext': jsActionNext,
      'jsDescription': jsDescription,
      'jsCategory': jsCategory,
      'jsOther': jsOther,
    };
  }

  factory JSLeak.fromMap(Map<String, dynamic> map) {
    return JSLeak(
      jsIndexing: '${map['jsIndexing']}',
      jsListChapter: '${map['jsListChapter']}',
      jsActionNext: '${map['jsActionNext']}',
      jsDescription: '${map['jsDescription']}',
      jsCategory: '${map['jsCategory']}',
      jsOther: '${map['jsOther']}',
    );
  }

  factory JSLeak.none() {
    return JSLeak(
      jsIndexing: '',
      jsListChapter: '',
      jsActionNext: '',
      jsDescription: '',
      jsCategory: '',
      jsOther: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JSLeak.fromJson(String source) =>
      JSLeak.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ListWebsite {
  String version;
  List<Website> listWebsite;
  ListWebsite({
    required this.version,
    required this.listWebsite,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'listWebsite': listWebsite.map((x) => x.toMap()).toList(),
    };
  }

  factory ListWebsite.none() {
    return ListWebsite(
      version: '',
      listWebsite: [],
    );
  }

  factory ListWebsite.fromMap(Map<String, dynamic> map) {
    return ListWebsite(
      version: map['version'] as String,
      listWebsite: List<Website>.from(
        (map['listWebsite'] as List<dynamic>).map<Website>(
          (x) => Website.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListWebsite.fromJson(String source) =>
      ListWebsite.fromMap(json.decode(source) as Map<String, dynamic>);
}
