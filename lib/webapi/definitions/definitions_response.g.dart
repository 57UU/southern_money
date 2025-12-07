// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definitions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['Success'] as bool,
  message: json['Message'] as String?,
  data: _$nullableGenericFromJson(json['Data'], fromJsonT),
  timestamp: DateTime.parse(json['Timestamp'] as String),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'Success': instance.success,
  'Message': instance.message,
  'Data': _$nullableGenericToJson(instance.data, toJsonT),
  'Timestamp': instance.timestamp.toIso8601String(),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

PagedResponse<T> _$PagedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PagedResponse<T>(
  totalCount: (json['TotalCount'] as num?)?.toInt(),
  items: (json['Items'] as List<dynamic>).map(fromJsonT).toList(),
  pageSize: (json['PageSize'] as num).toInt(),
  currentPage: (json['CurrentPage'] as num).toInt(),
);

Map<String, dynamic> _$PagedResponseToJson<T>(
  PagedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'TotalCount': instance.totalCount,
  'Items': instance.items.map(toJsonT).toList(),
  'PageSize': instance.pageSize,
  'CurrentPage': instance.currentPage,
};

TestResponse _$TestResponseFromJson(Map<String, dynamic> json) =>
    TestResponse(message: json['Message'] as String);

Map<String, dynamic> _$TestResponseToJson(TestResponse instance) =>
    <String, dynamic>{'Message': instance.message};

LoginByPasswordResponse _$LoginByPasswordResponseFromJson(
  Map<String, dynamic> json,
) => LoginByPasswordResponse(
  token: json['Token'] as String,
  refreshToken: json['RefreshToken'] as String,
);

Map<String, dynamic> _$LoginByPasswordResponseToJson(
  LoginByPasswordResponse instance,
) => <String, dynamic>{
  'Token': instance.token,
  'RefreshToken': instance.refreshToken,
};

RefreshTokenResponse _$RefreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => RefreshTokenResponse(
  token: json['Token'] as String,
  refreshToken: json['RefreshToken'] as String,
);

Map<String, dynamic> _$RefreshTokenResponseToJson(
  RefreshTokenResponse instance,
) => <String, dynamic>{
  'Token': instance.token,
  'RefreshToken': instance.refreshToken,
};

ImageUploadResponse _$ImageUploadResponseFromJson(Map<String, dynamic> json) =>
    ImageUploadResponse(imageId: json['ImageId'] as String);

Map<String, dynamic> _$ImageUploadResponseToJson(
  ImageUploadResponse instance,
) => <String, dynamic>{'ImageId': instance.imageId};

ImageGetResponse _$ImageGetResponseFromJson(Map<String, dynamic> json) =>
    ImageGetResponse(
      id: json['Id'] as String,
      data: json['Data'] as String,
      imageType: json['ImageType'] as String,
      description: json['Description'] as String?,
      CreateTime: DateTime.parse(json['CreateTime'] as String),
    );

Map<String, dynamic> _$ImageGetResponseToJson(ImageGetResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Data': instance.data,
      'ImageType': instance.imageType,
      'Description': instance.description,
      'CreateTime': instance.CreateTime.toIso8601String(),
    };

PostUploaderResponse _$PostUploaderResponseFromJson(
  Map<String, dynamic> json,
) => PostUploaderResponse(
  id: (json['Id'] as num).toInt(),
  name: json['Name'] as String,
  avatar: json['Avatar'] as String,
);

Map<String, dynamic> _$PostUploaderResponseToJson(
  PostUploaderResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Name': instance.name,
  'Avatar': instance.avatar,
};

PostGetResponse _$PostGetResponseFromJson(Map<String, dynamic> json) =>
    PostGetResponse(
      title: json['Title'] as String,
      content: json['Content'] as String,
      createTime: DateTime.parse(json['CreateTime'] as String),
      reportCount: (json['ReportCount'] as num).toInt(),
      viewCount: (json['ViewCount'] as num).toInt(),
      likeCount: (json['LikeCount'] as num).toInt(),
      isBlocked: json['IsBlocked'] as bool,
      isLiked: json['IsLiked'] as bool,
      tags: (json['Tags'] as List<dynamic>).map((e) => e as String).toList(),
      imageIds: (json['ImageIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      uploader: PostUploaderResponse.fromJson(
        json['Uploader'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PostGetResponseToJson(PostGetResponse instance) =>
    <String, dynamic>{
      'Title': instance.title,
      'Content': instance.content,
      'CreateTime': instance.createTime.toIso8601String(),
      'ReportCount': instance.reportCount,
      'ViewCount': instance.viewCount,
      'LikeCount': instance.likeCount,
      'IsBlocked': instance.isBlocked,
      'IsLiked': instance.isLiked,
      'Tags': instance.tags,
      'ImageIds': instance.imageIds,
      'Uploader': instance.uploader,
    };

PostPageItemResponse _$PostPageItemResponseFromJson(
  Map<String, dynamic> json,
) => PostPageItemResponse(
  id: json['Id'] as String,
  title: json['Title'] as String,
  content: json['Content'] as String,
  createTime: DateTime.parse(json['CreateTime'] as String),
  reportCount: (json['ReportCount'] as num).toInt(),
  viewCount: (json['ViewCount'] as num).toInt(),
  likeCount: (json['LikeCount'] as num).toInt(),
  isBlocked: json['IsBlocked'] as bool,
  isLiked: json['IsLiked'] as bool,
  tags: (json['Tags'] as List<dynamic>).map((e) => e as String).toList(),
  imageIds: (json['ImageIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  uploader: PostUploaderResponse.fromJson(
    json['Uploader'] as Map<String, dynamic>,
  ),
  postBlocks: (json['PostBlocks'] as List<dynamic>)
      .map((e) => BlockReason.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PostPageItemResponseToJson(
  PostPageItemResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Title': instance.title,
  'Content': instance.content,
  'CreateTime': instance.createTime.toIso8601String(),
  'ReportCount': instance.reportCount,
  'ViewCount': instance.viewCount,
  'LikeCount': instance.likeCount,
  'IsBlocked': instance.isBlocked,
  'IsLiked': instance.isLiked,
  'Tags': instance.tags,
  'ImageIds': instance.imageIds,
  'Uploader': instance.uploader,
  'PostBlocks': instance.postBlocks,
};

PostLikeResponse _$PostLikeResponseFromJson(Map<String, dynamic> json) =>
    PostLikeResponse(likeCount: (json['LikeCount'] as num).toInt());

Map<String, dynamic> _$PostLikeResponseToJson(PostLikeResponse instance) =>
    <String, dynamic>{'LikeCount': instance.likeCount};

UserAssetResponse _$UserAssetResponseFromJson(Map<String, dynamic> json) =>
    UserAssetResponse(
      total: (json['Total'] as num).toDouble(),
      todayEarn: (json['TodayEarn'] as num).toDouble(),
      accumulatedEarn: (json['AccumulatedEarn'] as num).toDouble(),
      earnRate: (json['EarnRate'] as num).toDouble(),
      balance: (json['Balance'] as num).toDouble(),
    );

Map<String, dynamic> _$UserAssetResponseToJson(UserAssetResponse instance) =>
    <String, dynamic>{
      'Total': instance.total,
      'TodayEarn': instance.todayEarn,
      'AccumulatedEarn': instance.accumulatedEarn,
      'EarnRate': instance.earnRate,
      'Balance': instance.balance,
    };

UserProfileResponse _$UserProfileResponseFromJson(Map<String, dynamic> json) =>
    UserProfileResponse(
      id: (json['Id'] as num).toInt(),
      name: json['Name'] as String,
      email: json['Email'] as String,
      avatar: json['Avatar'] as String,
      isBlocked: json['IsBlocked'] as bool,
      CreateTime: DateTime.parse(json['CreateTime'] as String),
      asset: UserAssetResponse.fromJson(json['Asset'] as Map<String, dynamic>),
      isAdmin: json['IsAdmin'] as bool,
    );

Map<String, dynamic> _$UserProfileResponseToJson(
  UserProfileResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Name': instance.name,
  'Email': instance.email,
  'Avatar': instance.avatar,
  'IsBlocked': instance.isBlocked,
  'CreateTime': instance.CreateTime.toIso8601String(),
  'Asset': instance.asset,
  'IsAdmin': instance.isAdmin,
};

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      id: json['Id'] as String,
      name: json['Name'] as String,
      price: (json['Price'] as num).toDouble(),
      description: json['Description'] as String,
      categoryId: json['CategoryId'] as String,
      categoryName: json['CategoryName'] as String,
      uploaderUserId: (json['UploaderUserId'] as num).toInt(),
      uploaderName: json['UploaderName'] as String,
      CreateTime: DateTime.parse(json['CreateTime'] as String),
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Price': instance.price,
      'Description': instance.description,
      'CategoryId': instance.categoryId,
      'CategoryName': instance.categoryName,
      'UploaderUserId': instance.uploaderUserId,
      'UploaderName': instance.uploaderName,
      'CreateTime': instance.CreateTime.toIso8601String(),
    };

ProductDetailUploaderResponse _$ProductDetailUploaderResponseFromJson(
  Map<String, dynamic> json,
) => ProductDetailUploaderResponse(
  id: (json['Id'] as num).toInt(),
  name: json['Name'] as String,
  avatar: json['Avatar'] as String?,
);

Map<String, dynamic> _$ProductDetailUploaderResponseToJson(
  ProductDetailUploaderResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Name': instance.name,
  'Avatar': instance.avatar,
};

ProductDetailResponse _$ProductDetailResponseFromJson(
  Map<String, dynamic> json,
) => ProductDetailResponse(
  id: json['Id'] as String,
  name: json['Name'] as String,
  price: (json['Price'] as num).toDouble(),
  description: json['Description'] as String,
  categoryId: json['CategoryId'] as String,
  categoryName: json['CategoryName'] as String,
  uploader: json['Uploader'] == null
      ? null
      : ProductDetailUploaderResponse.fromJson(
          json['Uploader'] as Map<String, dynamic>,
        ),
  uploaderUserId: (json['UploaderUserId'] as num?)?.toInt(),
  uploaderName: json['UploaderName'] as String?,
  CreateTime: json['CreateTime'] == null
      ? null
      : DateTime.parse(json['CreateTime'] as String),
);

Map<String, dynamic> _$ProductDetailResponseToJson(
  ProductDetailResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Name': instance.name,
  'Price': instance.price,
  'Description': instance.description,
  'CategoryId': instance.categoryId,
  'CategoryName': instance.categoryName,
  'Uploader': instance.uploader,
  'UploaderUserId': instance.uploaderUserId,
  'UploaderName': instance.uploaderName,
  'CreateTime': instance.CreateTime?.toIso8601String(),
};

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      id: json['Id'] as String,
      name: json['Name'] as String,
      coverImageId: json['CoverImageId'] as String,
      CreateTime: DateTime.parse(json['CreateTime'] as String),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'CoverImageId': instance.coverImageId,
      'CreateTime': instance.CreateTime.toIso8601String(),
    };

TransactionRecordResponse _$TransactionRecordResponseFromJson(
  Map<String, dynamic> json,
) => TransactionRecordResponse(
  id: json['Id'] as String,
  productId: json['ProductId'] as String,
  quantity: (json['Quantity'] as num).toInt(),
  price: (json['Price'] as num).toDouble(),
  totalPrice: (json['TotalPrice'] as num).toDouble(),
  purchaseTime: DateTime.parse(json['PurchaseTime'] as String),
);

Map<String, dynamic> _$TransactionRecordResponseToJson(
  TransactionRecordResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'ProductId': instance.productId,
  'Quantity': instance.quantity,
  'Price': instance.price,
  'TotalPrice': instance.totalPrice,
  'PurchaseTime': instance.purchaseTime.toIso8601String(),
};

AdminStatisticsResponse _$AdminStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => AdminStatisticsResponse(
  totalUsers: (json['TotalUsers'] as num).toInt(),
  totalProducts: (json['TotalProducts'] as num).toInt(),
  totalTransactions: (json['TotalTransactions'] as num).toInt(),
  recentTransactions: (json['RecentTransactions'] as num).toInt(),
  bannedUsers: (json['BannedUsers'] as num).toInt(),
);

Map<String, dynamic> _$AdminStatisticsResponseToJson(
  AdminStatisticsResponse instance,
) => <String, dynamic>{
  'TotalUsers': instance.totalUsers,
  'TotalProducts': instance.totalProducts,
  'TotalTransactions': instance.totalTransactions,
  'RecentTransactions': instance.recentTransactions,
  'BannedUsers': instance.bannedUsers,
};

AdminUserResponse _$AdminUserResponseFromJson(Map<String, dynamic> json) =>
    AdminUserResponse(
      id: (json['Id'] as num).toInt(),
      name: json['Name'] as String,
      avatar: json['Avatar'] as String?,
      email: json['Email'] as String,
      isBlocked: json['IsBlocked'] as bool,
      isAdmin: json['IsAdmin'] as bool,
    );

Map<String, dynamic> _$AdminUserResponseToJson(AdminUserResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Avatar': instance.avatar,
      'Email': instance.email,
      'IsBlocked': instance.isBlocked,
      'IsAdmin': instance.isAdmin,
    };

AvatarUploadResponse _$AvatarUploadResponseFromJson(
  Map<String, dynamic> json,
) => AvatarUploadResponse(avatarId: json['AvatarId'] as String);

Map<String, dynamic> _$AvatarUploadResponseToJson(
  AvatarUploadResponse instance,
) => <String, dynamic>{'AvatarId': instance.avatarId};

CategorySearchResponse _$CategorySearchResponseFromJson(
  Map<String, dynamic> json,
) => CategorySearchResponse(
  categories: (json['Categories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CategorySearchResponseToJson(
  CategorySearchResponse instance,
) => <String, dynamic>{'Categories': instance.categories};

CheckFavoritedResponse _$CheckFavoritedResponseFromJson(
  Map<String, dynamic> json,
) => CheckFavoritedResponse(isFavorited: json['IsFavorited'] as bool);

Map<String, dynamic> _$CheckFavoritedResponseToJson(
  CheckFavoritedResponse instance,
) => <String, dynamic>{'IsFavorited': instance.isFavorited};

AvgPriceResponse _$AvgPriceResponseFromJson(Map<String, dynamic> json) =>
    AvgPriceResponse(avgPrice: (json['AvgPrice'] as num).toDouble());

Map<String, dynamic> _$AvgPriceResponseToJson(AvgPriceResponse instance) =>
    <String, dynamic>{'AvgPrice': instance.avgPrice};

BlockReason _$BlockReasonFromJson(Map<String, dynamic> json) => BlockReason(
  reason: json['Reason'] as String,
  actionTime: DateTime.parse(json['ActionTime'] as String),
  operator: PostUploaderResponse.fromJson(
    json['Operator'] as Map<String, dynamic>,
  ),
  isBlock: json['IsBlock'] as bool,
);

Map<String, dynamic> _$BlockReasonToJson(BlockReason instance) =>
    <String, dynamic>{
      'Reason': instance.reason,
      'ActionTime': instance.actionTime.toIso8601String(),
      'Operator': instance.operator,
      'IsBlock': instance.isBlock,
    };

NotificationResponse _$NotificationResponseFromJson(
  Map<String, dynamic> json,
) => NotificationResponse(
  id: json['Id'] as String,
  userId: (json['UserId'] as num).toInt(),
  content: json['Content'] as String,
  type: json['Type'] as String,
  isRead: json['IsRead'] as bool,
  createTime: DateTime.parse(json['CreateTime'] as String),
);

Map<String, dynamic> _$NotificationResponseToJson(
  NotificationResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'UserId': instance.userId,
  'Content': instance.content,
  'Type': instance.type,
  'IsRead': instance.isRead,
  'CreateTime': instance.createTime.toIso8601String(),
};
