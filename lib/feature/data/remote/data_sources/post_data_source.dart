import '../../../../contents.dart';
import '../../../../core/common/data_sources/api_data_source.dart';
import '../../../domain/entities/post.dart';

class PostDataSource extends ApiDataSource<Post> {
  PostDataSource({
    super.api = ApiPaths.api,
    super.path = ApiPaths.posts,
  });

  @override
  Post build(source) => Post.from(source);
}
