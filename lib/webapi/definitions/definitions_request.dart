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
  final String query;

  PostSearchRequest({required this.query});
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

@JsonKey(ignore: true)
class PostMyPostsRequest {
  static const String route = "/posts/myPosts";
  final int page;
  final int pageSize;

  PostMyPostsRequest({required this.page, required this.pageSize});
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

@JsonKey(ignore: true)
class ProductDetailRequest {
  static const String route = "/store/detail";
  final String productId;

  ProductDetailRequest({required this.productId});
}

@JsonKey(ignore: true)
class ProductRESTDetailRequest {
  static const String route = "/store/products";
  final String id;

  ProductRESTDetailRequest({required this.id});
}

@JsonKey(ignore: true)
class ProductListRequest {
  static const String route = "/store/products";
  final int page;
  final int pageSize;
  final String? categoryId;
  final String? search;

  ProductListRequest({
    required this.page,
    required this.pageSize,
    this.categoryId,
    this.search,
  });
}

@JsonKey(ignore: true)
class ProductCategoryListRequest {
  static const String route = "/store/categories";
  final String id;
  final int page;
  final int pageSize;

  ProductCategoryListRequest({
    required this.id,
    required this.page,
    required this.pageSize,
  });
}

@JsonKey(ignore: true)
class ProductSearchRequest {
  static const String route = "/store/search";
  final String q;
  final int page;
  final int pageSize;

  ProductSearchRequest({
    required this.q,
    required this.page,
    required this.pageSize,
  });
}

@JsonKey(ignore: true)
class MyProductsRequest {
  static const String route = "/store/myProducts";
  final int page;
  final int pageSize;

  MyProductsRequest({required this.page, required this.pageSize});
}

@JsonKey(ignore: true)
class CategoryListRequest {
  static const String route = "/store/categories";

  CategoryListRequest();
}

@JsonKey(ignore: true)
class CategoryGetRequest {
  static const String route = "/store/categories";
  final String id;

  CategoryGetRequest({required this.id});
}

@JsonKey(ignore: true)
class CategorySearchRequest {
  static const String route = "/store/category/search";
  final String name;

  CategorySearchRequest({required this.name});
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

@JsonKey(ignore: true)
class CategoryFavoriteRequest {
  static const String route = "/store/categories";
  final String categoryId;

  CategoryFavoriteRequest({required this.categoryId});
}

@JsonKey(ignore: true)
class CategoryUnfavoriteRequest {
  static const String route = "/store/categories";
  final String categoryId;

  CategoryUnfavoriteRequest({required this.categoryId});
}

@JsonKey(ignore: true)
class FavoriteCategoriesRequest {
  static const String route = "/store/favoriteCategories";

  FavoriteCategoriesRequest();
}

@JsonKey(ignore: true)
class CheckFavoritedRequest {
  static const String route = "/store/categories";
  final String categoryId;

  CheckFavoritedRequest({required this.categoryId});
}

@JsonKey(ignore: true)
class UserUploadAvatarRequest {
  static const String route = "/user/uploadAvatar";
  // 注意：文件上传使用FormData，不在JSON中序列化
  // final File file;

  UserUploadAvatarRequest();
}

@JsonSerializable()
class TransactionBuyRequest {
  static const String route = "/transaction/buy";
  @JsonKey(name: "ProductId")
  final String productId;

  TransactionBuyRequest({required this.productId});
  Map<String, dynamic> toJson() => _$TransactionBuyRequestToJson(this);
}

@JsonKey(ignore: true)
class TransactionMyRecordsRequest {
  static const String route = "/transaction/myRecords";
  final int page;
  final int pageSize;

  TransactionMyRecordsRequest({required this.page, required this.pageSize});
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

@JsonKey(ignore: true)
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
}

@JsonKey(ignore: true)
class AdminUserDetailRequest {
  static const String route = "/admin/users";
  final int userId;

  AdminUserDetailRequest({required this.userId});
}

@JsonKey(ignore: true)
class AdminReportedPostsRequest {
  static const String route = "/admin/reportedPosts";
  final int page;
  final int pageSize;

  AdminReportedPostsRequest({required this.page, required this.pageSize});
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

@JsonKey(ignore: true)
class AdminPostsRequest {
  static const String route = "/admin/posts";
  final int page;
  final int pageSize;

  AdminPostsRequest({required this.page, required this.pageSize});
}

@JsonKey(ignore: true)
class CategoryAvgPriceRequest {
  static const String route = "/store/avgPrice";
  final String categoryId;

  CategoryAvgPriceRequest({required this.categoryId});
}
