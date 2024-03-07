class ResponseCode {
  // ignore: constant_identifier_names
  static const int SUCCESS = 200; // success with data
  // ignore: constant_identifier_names
  static const int NO_CONTENT = 201; // success with no data (no content)
  // ignore: constant_identifier_names
  static const int BAD_REQUEST = 400; // failure, API rejected request
  // ignore: constant_identifier_names
  static const int UNAUTORISED = 401; // failure, user is not authorised
  // ignore: constant_identifier_names
  static const int FORBIDDEN = 403; //  failure, API rejected request
  // ignore: constant_identifier_names
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  // ignore: constant_identifier_names
  static const int NOT_FOUND = 404; // failure, not found
  // ignore: constant_identifier_names
  static const int CONNECT_TIMEOUT = -1;

  // local status code
  // ignore: constant_identifier_names
  static const int CANCEL = -2;
  // ignore: constant_identifier_names
  static const int RECIEVE_TIMEOUT = -3;
  // ignore: constant_identifier_names
  static const int SEND_TIMEOUT = -4;
  // ignore: constant_identifier_names
  static const int CACHE_ERROR = -5;
  // ignore: constant_identifier_names
  static const int NO_INTERNET_CONNECTION = -6;
  // ignore: constant_identifier_names
  static const int DEFAULT = -7;
  // ignore: constant_identifier_names
  static const int BadCertificate = -8;
}
