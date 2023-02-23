import 'package:flutter_api/core/common/data_sources/api_data_source.dart';
import 'package:flutter_api/feature/domain/entities/comment.dart';

import '../../../../contents.dart';

class CommentDataSource extends ApiDataSource<Comment> {
  CommentDataSource({
    super.api = ApiPaths.api,
    super.path = ApiPaths.posts,
  });

  @override
  Comment build(source) {
    return Comment.from(source);
  }
}
