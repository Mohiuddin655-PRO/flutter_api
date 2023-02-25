import 'package:flutter_api/core/common/data_sources/encrypt_api_data_source.dart';

import '../../../domain/entities/post.dart';

class PostDataSource extends EncryptApiDataSource<Post> {
  PostDataSource({
    required super.service,
    super.path = "allInstructors",
  });

  @override
  Post build(source) {
    return Post.from(source);
  }
}
