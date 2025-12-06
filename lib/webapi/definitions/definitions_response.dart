import 'package:json_annotation/json_annotation.dart';

part 'definitions_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: "Success")
  final bool success;
  @JsonKey(name: "Message")
  final String? message;
  @JsonKey(name: "Data")
  final T? data;
  @JsonKey(name: "Timestamp")
  final DateTime timestamp;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    required this.timestamp,
  });
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
  factory ApiResponse.fail({String? message}) => ApiResponse<T>(
    success: false,
    message: message,
    timestamp: DateTime.now(),
  );
}

@JsonSerializable(genericArgumentFactories: true)
class PagedResponse<T> {
  @JsonKey(name: "TotalCount")
  final int? totalCount;
  @JsonKey(name: "Items")
  final List<T> items;
  @JsonKey(name: "PageSize")
  final int pageSize;
  @JsonKey(name: "CurrentPage")
  final int currentPage;

  PagedResponse({
    this.totalCount,
    required this.items,
    required this.pageSize,
    required this.currentPage,
  });
  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return _$PagedResponseFromJson(json, fromJsonT);
  }
}

@JsonSerializable()
class TestResponse {
  @JsonKey(name: "Message")
  final String message;

  TestResponse({required this.message});
  factory TestResponse.fromJson(Map<String, dynamic> json) =>
      _$TestResponseFromJson(json);
}

@JsonSerializable()
class LoginByPasswordResponse {
  @JsonKey(name: "Token")
  final String token;
  @JsonKey(name: "RefreshToken")
  final String refreshToken;

  LoginByPasswordResponse({required this.token, required this.refreshToken});
  factory LoginByPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginByPasswordResponseFromJson(json);
}

@JsonSerializable()
class RefreshTokenResponse {
  @JsonKey(name: "Token")
  final String token;
  @JsonKey(name: "RefreshToken")
  final String refreshToken;

  RefreshTokenResponse({required this.token, required this.refreshToken});
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}

@JsonSerializable()
class ImageUploadResponse {
  @JsonKey(name: "ImageId")
  final String imageId;

  ImageUploadResponse({required this.imageId});
  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResponseFromJson(json);
}

@JsonSerializable()
class ImageGetResponse {
  // 根据API文档，返回Image对象，包含图片数据和元信息
  @JsonKey(name: "Id")
  final String id;
  @JsonKey(name: "Data")
  final String data;
  @JsonKey(name: "ImageType")
  final String imageType;
  @JsonKey(name: "Description")
  final String? description;
  @JsonKey(name: "CreateTime")
  final DateTime CreateTime;

  ImageGetResponse({
    required this.id,
    required this.data,
    required this.imageType,
    this.description,
    required this.CreateTime,
  });
  factory ImageGetResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageGetResponseFromJson(json);
}

@JsonSerializable()
class PostUploaderResponse {
  @JsonKey(name: "Id")
  final int id;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Avatar")
  final String? avatar;

  PostUploaderResponse({required this.id, required this.name, this.avatar});
  factory PostUploaderResponse.fromJson(Map<String, dynamic> json) =>
      _$PostUploaderResponseFromJson(json);
}

@JsonSerializable()
class PostGetResponse {
  @JsonKey(name: "Title")
  final String title;
  @JsonKey(name: "Content")
  final String content;
  @JsonKey(name: "CreateTime")
  final DateTime createTime;
  @JsonKey(name: "ReportCount")
  final int reportCount;
  @JsonKey(name: "ViewCount")
  final int viewCount;
  @JsonKey(name: "LikeCount")
  final int likeCount;
  @JsonKey(name: "IsBlocked")
  final bool isBlocked;
  @JsonKey(name: "IsLiked")
  final bool isLiked;
  @JsonKey(name: "Tags")
  final List<String> tags;
  @JsonKey(name: "ImageIds")
  final List<String> imageIds;
  @JsonKey(name: "Uploader")
  final PostUploaderResponse uploader;

  PostGetResponse({
    required this.title,
    required this.content,
    required this.createTime,
    required this.reportCount,
    required this.viewCount,
    required this.likeCount,
    required this.isBlocked,
    required this.isLiked,
    required this.tags,
    required this.imageIds,
    required this.uploader,
  });
  factory PostGetResponse.fromJson(Map<String, dynamic> json) =>
      _$PostGetResponseFromJson(json);
}

@JsonSerializable()
class PostPageItemResponse {
  // 与PostGetResponse结构相同，复用该类
  @JsonKey(name: "Id")
  final String id;
  @JsonKey(name: "Title")
  final String title;
  @JsonKey(name: "Content")
  final String content;
  @JsonKey(name: "CreateTime")
  final DateTime createTime;
  @JsonKey(name: "ReportCount")
  final int reportCount;
  @JsonKey(name: "ViewCount")
  final int viewCount;
  @JsonKey(name: "LikeCount")
  final int likeCount;
  @JsonKey(name: "IsBlocked")
  final bool isBlocked;
  @JsonKey(name: "IsLiked")
  bool isLiked;
  @JsonKey(name: "Tags")
  final List<String> tags;
  @JsonKey(name: "ImageIds")
  final List<String> imageIds;
  @JsonKey(name: "Uploader")
  final PostUploaderResponse uploader;
  @JsonKey(name: "PostBlocks")
  final List<BlockReason> postBlocks;

  PostPageItemResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.createTime,
    required this.reportCount,
    required this.viewCount,
    required this.likeCount,
    required this.isBlocked,
    required this.isLiked,
    required this.tags,
    required this.imageIds,
    required this.uploader,
    required this.postBlocks,
  });
  factory PostPageItemResponse.fromJson(Map<String, dynamic> json) =>
      _$PostPageItemResponseFromJson(json);
}

@JsonSerializable()
class PostLikeResponse {
  @JsonKey(name: "LikeCount")
  final int likeCount;

  PostLikeResponse({required this.likeCount});
  factory PostLikeResponse.fromJson(Map<String, dynamic> json) =>
      _$PostLikeResponseFromJson(json);
}

@JsonSerializable()
class UserAssetResponse {
  @JsonKey(name: "Total")
  final double total;
  @JsonKey(name: "TodayEarn")
  final double todayEarn;
  @JsonKey(name: "AccumulatedEarn")
  final double accumulatedEarn;
  @JsonKey(name: "EarnRate")
  final double earnRate;
  @JsonKey(name: "Balance")
  final double balance;

  UserAssetResponse({
    required this.total,
    required this.todayEarn,
    required this.accumulatedEarn,
    required this.earnRate,
    required this.balance,
  });
  factory UserAssetResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAssetResponseFromJson(json);
}

@JsonSerializable()
class UserProfileResponse {
  @JsonKey(name: "Id")
  final int id;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Email")
  final String email;
  @JsonKey(name: "Avatar")
  final String avatar;
  @JsonKey(name: "IsBlocked")
  final bool isBlocked;
  @JsonKey(name: "CreateTime")
  final DateTime CreateTime;
  @JsonKey(name: "Asset")
  final UserAssetResponse asset;
  @JsonKey(name: "IsAdmin")
  final bool isAdmin;

  UserProfileResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.isBlocked,
    required this.CreateTime,
    required this.asset,
    required this.isAdmin,
  });
  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);
}

@JsonSerializable()
class ProductResponse {
  @JsonKey(name: "Id")
  final String id;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Price")
  final double price;
  @JsonKey(name: "Description")
  final String description;
  @JsonKey(name: "CategoryId")
  final String categoryId;
  @JsonKey(name: "CategoryName")
  final String categoryName;
  @JsonKey(name: "UploaderUserId")
  final int uploaderUserId;
  @JsonKey(name: "UploaderName")
  final String uploaderName;
  @JsonKey(name: "CreateTime")
  final DateTime CreateTime;

  ProductResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.uploaderUserId,
    required this.uploaderName,
    required this.CreateTime,
  });
  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
}

@JsonSerializable()
class ProductDetailUploaderResponse {
  @JsonKey(name: "Id")
  final int id;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Avatar")
  final String? avatar;

  ProductDetailUploaderResponse({
    required this.id,
    required this.name,
    this.avatar,
  });
  factory ProductDetailUploaderResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailUploaderResponseFromJson(json);
}

@JsonSerializable()
class ProductDetailResponse {
  @JsonKey(name: "Id")
  final String id;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Price")
  final double price;
  @JsonKey(name: "Description")
  final String description;
  @JsonKey(name: "CategoryId")
  final String categoryId;
  @JsonKey(name: "CategoryName")
  final String categoryName;
  @JsonKey(name: "Uploader")
  final ProductDetailUploaderResponse? uploader;
  @JsonKey(name: "UploaderUserId")
  final int? uploaderUserId;
  @JsonKey(name: "UploaderName")
  final String? uploaderName;
  @JsonKey(name: "CreateTime")
  final DateTime? CreateTime;

  ProductDetailResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    this.uploader,
    this.uploaderUserId,
    this.uploaderName,
    this.CreateTime,
  });
  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailResponseFromJson(json);
}

@JsonSerializable()
class CategoryResponse {
  @JsonKey(name: "Id")
  final String id;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "CoverImageId")
  final String coverImageId;
  @JsonKey(name: "CreateTime")
  final DateTime CreateTime;

  CategoryResponse({
    required this.id,
    required this.name,
    required this.coverImageId,
    required this.CreateTime,
  });
  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}

@JsonSerializable()
class TransactionRecordResponse {
  @JsonKey(name: "Id")
  final String id;
  @JsonKey(name: "ProductId")
  final String productId;
  @JsonKey(name: "Quantity")
  final int quantity;
  @JsonKey(name: "Price")
  final double price;
  @JsonKey(name: "TotalPrice")
  final double totalPrice;
  @JsonKey(name: "PurchaseTime")
  final DateTime purchaseTime;

  TransactionRecordResponse({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.purchaseTime,
  });
  factory TransactionRecordResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionRecordResponseFromJson(json);
}

@JsonSerializable()
class AdminStatisticsResponse {
  @JsonKey(name: "TotalUsers")
  final int totalUsers;
  @JsonKey(name: "TotalProducts")
  final int totalProducts;
  @JsonKey(name: "TotalTransactions")
  final int totalTransactions;
  @JsonKey(name: "RecentTransactions")
  final int recentTransactions;
  @JsonKey(name: "BannedUsers")
  final int bannedUsers;

  AdminStatisticsResponse({
    required this.totalUsers,
    required this.totalProducts,
    required this.totalTransactions,
    required this.recentTransactions,
    required this.bannedUsers,
  });
  factory AdminStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminStatisticsResponseFromJson(json);
}

@JsonSerializable()
class AdminUserResponse {
  @JsonKey(name: "Id")
  final int id;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "Avatar")
  final String? avatar;
  @JsonKey(name: "Email")
  final String email;
  @JsonKey(name: "IsBlocked")
  final bool isBlocked;
  @JsonKey(name: "IsAdmin")
  final bool isAdmin;

  AdminUserResponse({
    required this.id,
    required this.name,
    this.avatar,
    required this.email,
    required this.isBlocked,
    required this.isAdmin,
  });
  factory AdminUserResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminUserResponseFromJson(json);
}

@JsonSerializable()
class AvatarUploadResponse {
  @JsonKey(name: "AvatarId")
  final String avatarId;

  AvatarUploadResponse({required this.avatarId});
  factory AvatarUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarUploadResponseFromJson(json);
}

@JsonSerializable()
class CategorySearchResponse {
  @JsonKey(name: "Categories")
  final List<String> categories;

  CategorySearchResponse({required this.categories});
  factory CategorySearchResponse.fromJson(Map<String, dynamic> json) =>
      _$CategorySearchResponseFromJson(json);
}

@JsonSerializable()
class CheckFavoritedResponse {
  @JsonKey(name: "IsFavorited")
  final bool isFavorited;

  CheckFavoritedResponse({required this.isFavorited});
  factory CheckFavoritedResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckFavoritedResponseFromJson(json);
}

@JsonSerializable()
class AvgPriceResponse {
  @JsonKey(name: "AvgPrice")
  final double avgPrice;

  AvgPriceResponse({required this.avgPrice});
  factory AvgPriceResponse.fromJson(Map<String, dynamic> json) =>
      _$AvgPriceResponseFromJson(json);
}

@JsonSerializable()
class BlockReason {
  @JsonKey(name: "Reason")
  final String reason;
  @JsonKey(name: "ActionTime")
  final DateTime actionTime;
  @JsonKey(name: "Operator")
  final PostUploaderResponse operator;
  @JsonKey(name: "IsBlock")
  final bool isBlock;

  BlockReason({
    required this.reason,
    required this.actionTime,
    required this.operator,
    required this.isBlock,
  });
  factory BlockReason.fromJson(Map<String, dynamic> json) =>
      _$BlockReasonFromJson(json);
}

@JsonSerializable()
class NotificationResponse {
  @JsonKey(name: "Id")
  final String id;
  @JsonKey(name: "UserId")
  final int userId;
  @JsonKey(name: "Content")
  final String content;
  @JsonKey(name: "Type")
  final String type;
  @JsonKey(name: "IsRead")
  final bool isRead;
  @JsonKey(name: "CreateTime")
  final DateTime createTime;

  NotificationResponse({
    required this.id,
    required this.userId,
    required this.content,
    required this.type,
    required this.isRead,
    required this.createTime,
  });
  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}
