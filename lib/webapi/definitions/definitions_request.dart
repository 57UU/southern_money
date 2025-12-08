import 'package:json_annotation/json_annotation.dart';

part 'definitions_request.g.dart';

@JsonSerializable()
class LoginByPasswordRequest {
  static const String route = "/login/loginByPassword";
  @JsonKey(name: "Name")
  final String username;
  @JsonKey(name: "Password")
  final String password;

  LoginByPasswordRequest({required this.username, required this.password});
  Map<String, dynamic> toJson() => _$LoginByPasswordRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  static const String route = "/login/register";
  @JsonKey(name: "Name")
  final String username;
  @JsonKey(name: "Password")
  final String password;

  RegisterRequest({required this.username, required this.password});
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class RefreshTokenRequest {
  static const String route = "/login/refreshToken";
  @JsonKey(name: "RefreshToken")
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

@JsonSerializable()
class ImageUploadRequest {
  static const String route = "/images/upload";
  // 注意：文件上传使用FormData，不在JSON中序列化
  // @JsonKey(name: "file")
  // final File file;
  @JsonKey(name: "imageType")
  final String imageType;
  @JsonKey(name: "description")
  final String? description;

  ImageUploadRequest({required this.imageType, this.description});
  Map<String, dynamic> toJson() => _$ImageUploadRequestToJson(this);
}

@JsonSerializable()
class ImageGetRequest {
  static const String route = "/images/get";
  @JsonKey(name: "id")
  final String imageId;

  ImageGetRequest({required this.imageId});
  Map<String, dynamic> toJson() => _$ImageGetRequestToJson(this);
}

@JsonSerializable()
class PostCreateRequest {
  static const String route = "/posts/create";
  @JsonKey(name: "Title")
  final String title;
  @JsonKey(name: "Content")
  final String content;
  @JsonKey(name: "Tags")
  final List<String> tags;
  @JsonKey(name: "ImageIds")
  final List<String> imageIds;

  PostCreateRequest({
    required this.title,
    required this.content,
    required this.tags,
    required this.imageIds,
  });
  Map<String, dynamic> toJson() => _$PostCreateRequestToJson(this);
}

@JsonSerializable()
class PostGetRequest {
  static const String route = "/posts/get";
  @JsonKey(name: "id")
  final String postId;

  PostGetRequest({required this.postId});
  Map<String, dynamic> toJson() => _$PostGetRequestToJson(this);
}

@JsonSerializable()
class PostPageRequest {
  static const String route = "/posts/page";
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  PostPageRequest({required this.page, required this.pageSize});
  Map<String, dynamic> toJson() => _$PostPageRequestToJson(this);
}

@JsonSerializable()
class PostSearchRequest {
  static const String route = "/posts/search";
  @JsonKey(name: "query")
  final String? query;
  @JsonKey(name: "tag")
  final String? tag;
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  PostSearchRequest({this.query, this.tag, this.page = 1, this.pageSize = 10});
  Map<String, dynamic> toJson() => _$PostSearchRequestToJson(this);
}

@JsonSerializable()
class PostReportRequest {
  static const String route = "/posts/report";
  @JsonKey(name: "PostId")
  final String postId;
  @JsonKey(name: "Reason")
  final String reason;

  PostReportRequest({required this.postId, required this.reason});
  Map<String, dynamic> toJson() => _$PostReportRequestToJson(this);
}

@JsonSerializable()
class PostLikeRequest {
  static const String route = "/posts/like";
  @JsonKey(name: "id")
  final String postId;

  PostLikeRequest({required this.postId});
  Map<String, dynamic> toJson() => _$PostLikeRequestToJson(this);
}

@JsonSerializable()
class PostDeleteRequest {
  static const String route = "/posts/delete";
  @JsonKey(name: "PostId")
  final String postId;

  PostDeleteRequest({required this.postId});
  Map<String, dynamic> toJson() => _$PostDeleteRequestToJson(this);
}

@JsonSerializable()
class PostEditRequest {
  static const String route = "/posts/edit";
  @JsonKey(name: "PostId")
  final String postId;
  @JsonKey(name: "Title")
  final String title;
  @JsonKey(name: "Content")
  final String content;
  @JsonKey(name: "Tags")
  final List<String> tags;
  @JsonKey(name: "ImageIds")
  final List<String> imageIds;

  PostEditRequest({
    required this.postId,
    required this.title,
    required this.content,
    required this.tags,
    required this.imageIds,
  });
  Map<String, dynamic> toJson() => _$PostEditRequestToJson(this);
}

@JsonSerializable()
class PostMyPostsRequest {
  static const String route = "/posts/myPosts";
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  PostMyPostsRequest({required this.page, required this.pageSize});
  Map<String, dynamic> toJson() => _$PostMyPostsRequestToJson(this);
}

@JsonSerializable()
class UserUpdateRequest {
  static const String route = "/user/update";
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Email")
  final String email;

  UserUpdateRequest({required this.name, required this.email});
  Map<String, dynamic> toJson() => _$UserUpdateRequestToJson(this);
}

@JsonSerializable()
class GetPostsByUserIdRequest {
  static const String route = "/posts/user";
  @JsonKey(name: "userId")
  final String userId;
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  GetPostsByUserIdRequest({
    required this.userId,
    required this.page,
    required this.pageSize,
  });
  Map<String, dynamic> toJson() => _$GetPostsByUserIdRequestToJson(this);
}

@JsonSerializable()
class UserChangePasswordRequest {
  static const String route = "/user/changePassword";
  @JsonKey(name: "CurrentPassword")
  final String currentPassword;
  @JsonKey(name: "NewPassword")
  final String newPassword;

  UserChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });
  Map<String, dynamic> toJson() => _$UserChangePasswordRequestToJson(this);
}

@JsonSerializable()
class UserTopupRequest {
  static const String route = "/user/topup";
  @JsonKey(name: "Amount")
  final double amount;

  UserTopupRequest({required this.amount});
  Map<String, dynamic> toJson() => _$UserTopupRequestToJson(this);
}

@JsonKey(ignore: true)
class UserOpenAccountRequest {
  static const String route = "/user/openAccount";

  UserOpenAccountRequest();
}

@JsonSerializable()
class ProductPublishRequest {
  static const String route = "/store/publish";
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Price")
  final double price;
  @JsonKey(name: "Description")
  final String description;
  @JsonKey(name: "CategoryId")
  final String categoryId;

  ProductPublishRequest({
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
  });
  Map<String, dynamic> toJson() => _$ProductPublishRequestToJson(this);
}

@JsonSerializable()
class ProductDeleteRequest {
  static const String route = "/store/delete";
  @JsonKey(name: "ProductId")
  final String productId;

  ProductDeleteRequest({required this.productId});
  Map<String, dynamic> toJson() => _$ProductDeleteRequestToJson(this);
}

@JsonSerializable()
class ProductDetailRequest {
  static const String route = "/store/detail";
  @JsonKey(name: "productId")
  final String productId;

  ProductDetailRequest({required this.productId});
  Map<String, dynamic> toJson() => _$ProductDetailRequestToJson(this);
}

@JsonSerializable()
class ProductRESTDetailRequest {
  static const String route = "/store/products";
  @JsonKey(name: "id")
  final String id;

  ProductRESTDetailRequest({required this.id});
  Map<String, dynamic> toJson() => _$ProductRESTDetailRequestToJson(this);
}

@JsonSerializable()
class ProductListRequest {
  static const String route = "/store/products";
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;
  @JsonKey(name: "categoryId")
  final String? categoryId;
  @JsonKey(name: "search")
  final String? search;

  ProductListRequest({
    required this.page,
    required this.pageSize,
    this.categoryId,
    this.search,
  });
  Map<String, dynamic> toJson() => _$ProductListRequestToJson(this);
}

@JsonSerializable()
class ProductCategoryListRequest {
  static const String route = "/store/categories";
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  ProductCategoryListRequest({
    required this.id,
    required this.page,
    required this.pageSize,
  });
  Map<String, dynamic> toJson() => _$ProductCategoryListRequestToJson(this);
}

@JsonSerializable()
class ProductSearchRequest {
  static const String route = "/store/search";
  @JsonKey(name: "q")
  final String q;
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  ProductSearchRequest({
    required this.q,
    required this.page,
    required this.pageSize,
  });
  Map<String, dynamic> toJson() => _$ProductSearchRequestToJson(this);
}

@JsonSerializable()
class MyProductsRequest {
  static const String route = "/store/myProducts";
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  MyProductsRequest({required this.page, required this.pageSize});
  Map<String, dynamic> toJson() => _$MyProductsRequestToJson(this);
}

@JsonSerializable()
class CategoryListRequest {
  static const String route = "/store/categories";

  CategoryListRequest();
  Map<String, dynamic> toJson() => _$CategoryListRequestToJson(this);
}

@JsonSerializable()
class CategoryGetRequest {
  static const String route = "/store/categories";
  @JsonKey(name: "id")
  final String id;

  CategoryGetRequest({required this.id});
  Map<String, dynamic> toJson() => _$CategoryGetRequestToJson(this);
}

@JsonSerializable()
class CategorySearchRequest {
  static const String route = "/store/category/search";
  @JsonKey(name: "name")
  final String name;

  CategorySearchRequest({required this.name});
  Map<String, dynamic> toJson() => _$CategorySearchRequestToJson(this);
}

@JsonSerializable()
class CategoryCreateRequest {
  static const String route = "/store/category/create";
  @JsonKey(name: "Category")
  final String category;
  @JsonKey(name: "Cover")
  final String cover;

  CategoryCreateRequest({required this.category, required this.cover});
  Map<String, dynamic> toJson() => _$CategoryCreateRequestToJson(this);
}

@JsonSerializable()
class CategoryFavoriteRequest {
  static const String route = "/store/categories";
  @JsonKey(name: "categoryId")
  final String categoryId;

  CategoryFavoriteRequest({required this.categoryId});
  Map<String, dynamic> toJson() => _$CategoryFavoriteRequestToJson(this);
}

@JsonSerializable()
class CategoryUnfavoriteRequest {
  static const String route = "/store/categories";
  @JsonKey(name: "categoryId")
  final String categoryId;

  CategoryUnfavoriteRequest({required this.categoryId});
  Map<String, dynamic> toJson() => _$CategoryUnfavoriteRequestToJson(this);
}

@JsonSerializable()
class FavoriteCategoriesRequest {
  static const String route = "/store/favoriteCategories";

  FavoriteCategoriesRequest();
  Map<String, dynamic> toJson() => _$FavoriteCategoriesRequestToJson(this);
}

@JsonSerializable()
class CheckFavoritedRequest {
  static const String route = "/store/categories";
  @JsonKey(name: "categoryId")
  final String categoryId;

  CheckFavoritedRequest({required this.categoryId});
  Map<String, dynamic> toJson() => _$CheckFavoritedRequestToJson(this);
}

@JsonSerializable()
class UserUploadAvatarRequest {
  static const String route = "/user/uploadAvatar";
  // 注意：文件上传使用FormData，不在JSON中序列化
  // final File file;

  UserUploadAvatarRequest();
  Map<String, dynamic> toJson() => _$UserUploadAvatarRequestToJson(this);
}

@JsonSerializable()
class TransactionBuyRequest {
  static const String route = "/transaction/buy";
  @JsonKey(name: "ProductId")
  final String productId;

  TransactionBuyRequest({required this.productId});
  Map<String, dynamic> toJson() => _$TransactionBuyRequestToJson(this);
}

@JsonSerializable()
class TransactionMyRecordsRequest {
  static const String route = "/transaction/myRecords";
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  TransactionMyRecordsRequest({required this.page, required this.pageSize});
  Map<String, dynamic> toJson() => _$TransactionMyRecordsRequestToJson(this);
}

@JsonSerializable()
class AdminHandleUserRequest {
  static const String route = "/admin/handleUser";
  @JsonKey(name: "UserId")
  final int userId;
  @JsonKey(name: "IsBlocked")
  final bool isBlocked;
  @JsonKey(name: "HandleReason")
  final String handleReason;

  AdminHandleUserRequest({
    required this.userId,
    required this.isBlocked,
    required this.handleReason,
  });
  Map<String, dynamic> toJson() => _$AdminHandleUserRequestToJson(this);
}

@JsonSerializable()
class AdminSetAdminRequest {
  static const String route = "/admin/setAdmin";
  @JsonKey(name: "UserId")
  final int userId;

  AdminSetAdminRequest({required this.userId});
  Map<String, dynamic> toJson() => _$AdminSetAdminRequestToJson(this);
}

@JsonSerializable()
class AdminUsersRequest {
  static const String route = "/admin/users";
  final int page;
  final int pageSize;
  final bool? isBlocked;
  final bool? isAdmin;
  final String? search;

  AdminUsersRequest({
    required this.page,
    required this.pageSize,
    this.isBlocked,
    this.isAdmin,
    this.search,
  });
  Map<String, dynamic> toJson() => _$AdminUsersRequestToJson(this);
}

@JsonSerializable()
class AdminUserDetailRequest {
  static const String route = "/admin/users";
  @JsonKey(name: "userId")
  final int userId;

  AdminUserDetailRequest({required this.userId});
  Map<String, dynamic> toJson() => _$AdminUserDetailRequestToJson(this);
}

@JsonSerializable()
class AdminReportedPostsRequest {
  static const String route = "/admin/reportedPosts";
  final int page;
  final int pageSize;
  final bool? isBlocked;

  AdminReportedPostsRequest({
    required this.page,
    required this.pageSize,
    required this.isBlocked,
  });
  Map<String, dynamic> toJson() => _$AdminReportedPostsRequestToJson(this);
}

@JsonSerializable()
class AdminHandleReportRequest {
  static const String route = "/admin/handleReport";
  @JsonKey(name: "PostId")
  final String postId;
  @JsonKey(name: "IsBlocked")
  final bool isBlocked;
  @JsonKey(name: "HandleReason")
  final String handleReason;

  AdminHandleReportRequest({
    required this.postId,
    required this.isBlocked,
    required this.handleReason,
  });
  Map<String, dynamic> toJson() => _$AdminHandleReportRequestToJson(this);
}

@JsonSerializable()
class AdminPostsRequest {
  static const String route = "/admin/posts";
  @JsonKey(name: "userId")
  final int userId;
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  AdminPostsRequest({
    required this.userId,
    required this.page,
    required this.pageSize,
  });
  Map<String, dynamic> toJson() => _$AdminPostsRequestToJson(this);
}

@JsonSerializable()
class CategoryAvgPriceRequest {
  static const String route = "/store/categories/avgPrice";
  @JsonKey(name: "categoryId")
  final String categoryId;

  CategoryAvgPriceRequest({required this.categoryId});
  Map<String, dynamic> toJson() => _$CategoryAvgPriceRequestToJson(this);
}

@JsonSerializable()
class SetAdminRequest {
  static const String route = "/admin/setAdmin";
  @JsonKey(name: "UserId")
  final int userId;
  @JsonKey(name: "IsAdmin")
  final bool isAdmin;

  SetAdminRequest({required this.userId, required this.isAdmin});
  Map<String, dynamic> toJson() => _$SetAdminRequestToJson(this);
}

@JsonSerializable()
class NotificationMyRequest {
  static const String route = "/notification/my";
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  NotificationMyRequest({this.page = 1, this.pageSize = 10});
  Map<String, dynamic> toJson() => _$NotificationMyRequestToJson(this);
}

@JsonSerializable()
class NotificationUnreadCountRequest {
  static const String route = "/notification/unreadCount";

  NotificationUnreadCountRequest();
  Map<String, dynamic> toJson() => _$NotificationUnreadCountRequestToJson(this);
}

@JsonSerializable()
class NotificationMarkReadRequest {
  static const String route = "/notification/read";
  @JsonKey(name: "NotificationIds")
  final List<String> notificationIds;

  NotificationMarkReadRequest({required this.notificationIds});
  Map<String, dynamic> toJson() => _$NotificationMarkReadRequestToJson(this);
}

@JsonSerializable()
class NotificationReadAllRequest {
  static const String route = "/notification/readAll";

  NotificationReadAllRequest();
  Map<String, dynamic> toJson() => _$NotificationReadAllRequestToJson(this);
}

@JsonSerializable()
class PostFavoriteRequest {
  static const String route = "/posts/favorite";
  @JsonKey(name: "id")
  final String postId;

  PostFavoriteRequest({required this.postId});
  Map<String, dynamic> toJson() => _$PostFavoriteRequestToJson(this);
}

@JsonSerializable()
class PostUnfavoriteRequest {
  static const String route = "/posts/unfavorite";
  @JsonKey(name: "id")
  final String postId;

  PostUnfavoriteRequest({required this.postId});
  Map<String, dynamic> toJson() => _$PostUnfavoriteRequestToJson(this);
}

@JsonSerializable()
class PostFavoritesRequest {
  static const String route = "/posts/favorites";
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "pageSize")
  final int pageSize;

  PostFavoritesRequest({required this.page, required this.pageSize});
  Map<String, dynamic> toJson() => _$PostFavoritesRequestToJson(this);
}
