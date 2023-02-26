import 'package:flutter_api/core/common/data_sources/encrypt_api_data_source.dart';

final encryptedApi = EncryptedApi(
  api: "https://www.mindschoolbd.com/apipoint/api",
  key: "thisIsAverySpecialSecretKey00000",
  iv: "1583288699248111",
  passcode: "31353833323838363939323438313131",
  request: (request, passcode) {
    return {
      "request": request,
      "passphase": passcode,
    };
  },
  response: (data) {
    return data['request']['ct'] as String;
  },
);
