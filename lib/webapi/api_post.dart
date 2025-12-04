import 'package:southern_money/webapi/JwtService.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';

class ApiPostService {
  final JwtDio jwtDio;
  ApiPostService(this.jwtDio);

  /// 创建新帖子
  Future<ApiResponse<Map<String, dynamic>>> createPost({
    required String title,
    required String content,
    required List<String> tags,
    required List<String> imageIds,
  }) async {
    try {
      final request = PostCreateRequest(
        title: title,
        content: content,
        tags: tags,
        imageIds: imageIds,
      );

      final response = await jwtDio.post(
        PostCreateRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "创建帖子失败: $e");
    }
  }

  /// 获取帖子详情
  Future<ApiResponse<PostGetResponse>> getPost(String postId) async {
    try {
      final request = PostGetRequest(postId: postId);

      final response = await jwtDio.post(
        PostGetRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            PostGetResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取帖子详情失败: $e");
    }
  }

  /// 分页获取帖子列表
  Future<ApiResponse<PagedResponse<PostPageItemResponse>>> getPostPage({
    required int page,
    required int pageSize,
  }) async {
    try {
      final request = PostPageRequest(page: page, pageSize: pageSize);

      final response = await jwtDio.get(
        PostPageRequest.route,
        queryParameters: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => PostPageItemResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取帖子列表失败: $e");
    }
  }

  /// 搜索帖子
  Future<ApiResponse<PagedResponse<PostPageItemResponse>>> searchPosts(String query) async {
    try {
      final request = PostSearchRequest(query: query);

      final response = await jwtDio.post(
        PostSearchRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => PostPageItemResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "搜索帖子失败: $e");
    }
  }

  /// 举报帖子
  Future<ApiResponse<Map<String, dynamic>>> reportPost({
    required String postId,
    required String reason,
  }) async {
    try {
      final request = PostReportRequest(postId: postId, reason: reason);

      final response = await jwtDio.post(
        PostReportRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "举报帖子失败: $e");
    }
  }

  /// 点赞帖子
  Future<ApiResponse<PostLikeResponse>> likePost(String postId) async {
    try {
      final request = PostLikeRequest(postId: postId);

      final response = await jwtDio.post(
        PostLikeRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) =>
            PostLikeResponse.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.fail(message: "点赞帖子失败: $e");
    }
  }

  /// 删除帖子
  Future<ApiResponse<Map<String, dynamic>>> deletePost(String postId) async {
    try {
      final request = PostDeleteRequest(postId: postId);

      final response = await jwtDio.post(
        PostDeleteRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "删除帖子失败: $e");
    }
  }

  /// 编辑帖子
  Future<ApiResponse<Map<String, dynamic>>> editPost({
    required String postId,
    required String title,
    required String content,
    required List<String> tags,
    required List<String> imageIds,
  }) async {
    try {
      final request = PostEditRequest(
        postId: postId,
        title: title,
        content: content,
        tags: tags,
        imageIds: imageIds,
      );

      final response = await jwtDio.post(
        PostEditRequest.route,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => dataJson as Map<String, dynamic>,
      );
    } catch (e) {
      return ApiResponse.fail(message: "编辑帖子失败: $e");
    }
  }

  /// 获取我的帖子
  Future<ApiResponse<PagedResponse<PostPageItemResponse>>> getMyPosts({
    required int page,
    required int pageSize,
  }) async {
    try {
      final request = PostMyPostsRequest(page: page, pageSize: pageSize);

      final response = await jwtDio.post(
        PostMyPostsRequest.route,
        queryParameters: {'page': request.page, 'pageSize': request.pageSize},
      );

      return ApiResponse.fromJson(
        response.data,
        (dataJson) => PagedResponse.fromJson(
          dataJson as Map<String, dynamic>,
          (itemJson) => PostPageItemResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse.fail(message: "获取我的帖子失败: $e");
    }
  }
}
