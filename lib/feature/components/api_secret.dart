import 'package:flutter_api/core/utils/providers/api_service.dart';

final service = ApiService(
  api: "https://www.mindschoolbd.com/apipoint/api",
  key: "thisIsAverySpecialSecretKey00000",
  iv: "1583288699248111",
  passcode: "31353833323838363939323438313131",
  body: "data",
  request: (request, passcode) {
    return {
      "request": request,
      "passphase": passcode,
    };
  },
  response: (data) {
    return data['request']['ct'];
  },
);
