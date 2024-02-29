class AppStringNetWork {
  static String success = 'success';
  static String bad_request_error = 'bad_request_error';
  static String no_content = 'no_content';
  static String forbidden_error = 'forbidden_error';
  static String unauthorized_error = 'unauthorized_error';
  static String not_found_error = 'not_found_error';
  static String conflict_error = 'conflict_error';
  static String internal_server_error = 'internal_server_error';
  static String unknown = 'unauthorized_error';
  static String timeout_error = 'timeout_error';
  static String default_error = 'default_error';
  static String cache_error = 'cache_error';
  static String no_internet_error = 'no_internet_error';
  static String bad_certificate = 'bad_certificate';
  static String connection_error = 'connection_error';
}

Map<String, String> messageErrorNetWork = {
  "success": "success",
  "bad_request_error": "bad request. try again later",
  "no_content": "success with not content",
  "forbidden_error": "forbidden request. try again later",
  "unauthorized_error": "user unauthorized, try again later",
  "not_found_error": "url not found, try again later",
  "conflict_error": "conflict found, try again later",
  "internal_server_error": "some thing went wrong, try again later",
  "unknown": "some thing went wrong, try again later",
  "timeout_error": "time out, try again late",
  "default_error": "some thing went wrong, try again later",
  "cache_error": "cache error, try again later",
  "no_internet_error": "Please check your internet connection",
  "bad_certificate": "Lỗi chứng chỉ SSL",
  "connection_error": "Lỗi Host hoặc Url"
};
