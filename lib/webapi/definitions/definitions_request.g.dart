// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definitions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginByPasswordRequest _$LoginByPasswordRequestFromJson(
  Map<String, dynamic> json,
) => LoginByPasswordRequest(
  username: json['Name'] as String,
  password: json['Password'] as String,
);

Map<String, dynamic> _$LoginByPasswordRequestToJson(
  LoginByPasswordRequest instance,
) => <String, dynamic>{
  'Name': instance.username,
  'Password': instance.password,
};

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      username: json['Name'] as String,
      password: json['Password'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{'Name': instance.username, 'Password': instance.password};

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(refreshToken: json['RefreshToken'] as String);

Map<String, dynamic> _$RefreshTokenRequestToJson(
  RefreshTokenRequest instance,
) => <String, dynamic>{'RefreshToken': instance.refreshToken};

ImageUploadRequest _$ImageUploadRequestFromJson(Map<String, dynamic> json) =>
    ImageUploadRequest(
      imageType: json['imageType'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ImageUploadRequestToJson(ImageUploadRequest instance) =>
    <String, dynamic>{
      'imageType': instance.imageType,
      'description': instance.description,
    };

ImageGetRequest _$ImageGetRequestFromJson(Map<String, dynamic> json) =>
    ImageGetRequest(imageId: json['id'] as String);

Map<String, dynamic> _$ImageGetRequestToJson(ImageGetRequest instance) =>
    <String, dynamic>{'id': instance.imageId};

PostCreateRequest _$PostCreateRequestFromJson(Map<String, dynamic> json) =>
    PostCreateRequest(
      title: json['Title'] as String,
      content: json['Content'] as String,
      tags: (json['Tags'] as List<dynamic>).map((e) => e as String).toList(),
      imageIds: (json['ImageIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PostCreateRequestToJson(PostCreateRequest instance) =>
    <String, dynamic>{
      'Title': instance.title,
      'Content': instance.content,
      'Tags': instance.tags,
      'ImageIds': instance.imageIds,
    };

PostGetRequest _$PostGetRequestFromJson(Map<String, dynamic> json) =>
    PostGetRequest(postId: json['id'] as String);

Map<String, dynamic> _$PostGetRequestToJson(PostGetRequest instance) =>
    <String, dynamic>{'id': instance.postId};

PostPageRequest _$PostPageRequestFromJson(Map<String, dynamic> json) =>
    PostPageRequest(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$PostPageRequestToJson(PostPageRequest instance) =>
    <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};

PostSearchRequest _$PostSearchRequestFromJson(Map<String, dynamic> json) =>
    PostSearchRequest(query: json['query'] as String);

Map<String, dynamic> _$PostSearchRequestToJson(PostSearchRequest instance) =>
    <String, dynamic>{'query': instance.query};

PostReportRequest _$PostReportRequestFromJson(Map<String, dynamic> json) =>
    PostReportRequest(
      postId: json['PostId'] as String,
      reason: json['Reason'] as String,
    );

Map<String, dynamic> _$PostReportRequestToJson(PostReportRequest instance) =>
    <String, dynamic>{'PostId': instance.postId, 'Reason': instance.reason};

PostLikeRequest _$PostLikeRequestFromJson(Map<String, dynamic> json) =>
    PostLikeRequest(postId: json['id'] as String);

Map<String, dynamic> _$PostLikeRequestToJson(PostLikeRequest instance) =>
    <String, dynamic>{'id': instance.postId};

PostDeleteRequest _$PostDeleteRequestFromJson(Map<String, dynamic> json) =>
    PostDeleteRequest(postId: json['PostId'] as String);

Map<String, dynamic> _$PostDeleteRequestToJson(PostDeleteRequest instance) =>
    <String, dynamic>{'PostId': instance.postId};

PostEditRequest _$PostEditRequestFromJson(Map<String, dynamic> json) =>
    PostEditRequest(
      postId: json['PostId'] as String,
      title: json['Title'] as String,
      content: json['Content'] as String,
      tags: (json['Tags'] as List<dynamic>).map((e) => e as String).toList(),
      imageIds: (json['ImageIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PostEditRequestToJson(PostEditRequest instance) =>
    <String, dynamic>{
      'PostId': instance.postId,
      'Title': instance.title,
      'Content': instance.content,
      'Tags': instance.tags,
      'ImageIds': instance.imageIds,
    };

PostMyPostsRequest _$PostMyPostsRequestFromJson(Map<String, dynamic> json) =>
    PostMyPostsRequest(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$PostMyPostsRequestToJson(PostMyPostsRequest instance) =>
    <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};

UserUpdateRequest _$UserUpdateRequestFromJson(Map<String, dynamic> json) =>
    UserUpdateRequest(
      name: json['Name'] as String,
      email: json['Email'] as String,
    );

Map<String, dynamic> _$UserUpdateRequestToJson(UserUpdateRequest instance) =>
    <String, dynamic>{'Name': instance.name, 'Email': instance.email};

UserChangePasswordRequest _$UserChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => UserChangePasswordRequest(
  currentPassword: json['CurrentPassword'] as String,
  newPassword: json['NewPassword'] as String,
);

Map<String, dynamic> _$UserChangePasswordRequestToJson(
  UserChangePasswordRequest instance,
) => <String, dynamic>{
  'CurrentPassword': instance.currentPassword,
  'NewPassword': instance.newPassword,
};

UserTopupRequest _$UserTopupRequestFromJson(Map<String, dynamic> json) =>
    UserTopupRequest(amount: (json['Amount'] as num).toDouble());

Map<String, dynamic> _$UserTopupRequestToJson(UserTopupRequest instance) =>
    <String, dynamic>{'Amount': instance.amount};

ProductPublishRequest _$ProductPublishRequestFromJson(
  Map<String, dynamic> json,
) => ProductPublishRequest(
  name: json['Name'] as String,
  price: (json['Price'] as num).toDouble(),
  description: json['Description'] as String,
  categoryId: json['CategoryId'] as String,
);

Map<String, dynamic> _$ProductPublishRequestToJson(
  ProductPublishRequest instance,
) => <String, dynamic>{
  'Name': instance.name,
  'Price': instance.price,
  'Description': instance.description,
  'CategoryId': instance.categoryId,
};

ProductDeleteRequest _$ProductDeleteRequestFromJson(
  Map<String, dynamic> json,
) => ProductDeleteRequest(productId: json['ProductId'] as String);

Map<String, dynamic> _$ProductDeleteRequestToJson(
  ProductDeleteRequest instance,
) => <String, dynamic>{'ProductId': instance.productId};

ProductDetailRequest _$ProductDetailRequestFromJson(
  Map<String, dynamic> json,
) => ProductDetailRequest(productId: json['productId'] as String);

Map<String, dynamic> _$ProductDetailRequestToJson(
  ProductDetailRequest instance,
) => <String, dynamic>{'productId': instance.productId};

ProductRESTDetailRequest _$ProductRESTDetailRequestFromJson(
  Map<String, dynamic> json,
) => ProductRESTDetailRequest(id: json['id'] as String);

Map<String, dynamic> _$ProductRESTDetailRequestToJson(
  ProductRESTDetailRequest instance,
) => <String, dynamic>{'id': instance.id};

ProductListRequest _$ProductListRequestFromJson(Map<String, dynamic> json) =>
    ProductListRequest(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      categoryId: json['categoryId'] as String?,
      search: json['search'] as String?,
    );

Map<String, dynamic> _$ProductListRequestToJson(ProductListRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'categoryId': instance.categoryId,
      'search': instance.search,
    };

ProductCategoryListRequest _$ProductCategoryListRequestFromJson(
  Map<String, dynamic> json,
) => ProductCategoryListRequest(
  id: json['id'] as String,
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$ProductCategoryListRequestToJson(
  ProductCategoryListRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'page': instance.page,
  'pageSize': instance.pageSize,
};

ProductSearchRequest _$ProductSearchRequestFromJson(
  Map<String, dynamic> json,
) => ProductSearchRequest(
  q: json['q'] as String,
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$ProductSearchRequestToJson(
  ProductSearchRequest instance,
) => <String, dynamic>{
  'q': instance.q,
  'page': instance.page,
  'pageSize': instance.pageSize,
};

MyProductsRequest _$MyProductsRequestFromJson(Map<String, dynamic> json) =>
    MyProductsRequest(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$MyProductsRequestToJson(MyProductsRequest instance) =>
    <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};

CategoryListRequest _$CategoryListRequestFromJson(Map<String, dynamic> json) =>
    CategoryListRequest();

Map<String, dynamic> _$CategoryListRequestToJson(
  CategoryListRequest instance,
) => <String, dynamic>{};

CategoryGetRequest _$CategoryGetRequestFromJson(Map<String, dynamic> json) =>
    CategoryGetRequest(id: json['id'] as String);

Map<String, dynamic> _$CategoryGetRequestToJson(CategoryGetRequest instance) =>
    <String, dynamic>{'id': instance.id};

CategorySearchRequest _$CategorySearchRequestFromJson(
  Map<String, dynamic> json,
) => CategorySearchRequest(name: json['name'] as String);

Map<String, dynamic> _$CategorySearchRequestToJson(
  CategorySearchRequest instance,
) => <String, dynamic>{'name': instance.name};

CategoryCreateRequest _$CategoryCreateRequestFromJson(
  Map<String, dynamic> json,
) => CategoryCreateRequest(
  category: json['Category'] as String,
  cover: json['Cover'] as String,
);

Map<String, dynamic> _$CategoryCreateRequestToJson(
  CategoryCreateRequest instance,
) => <String, dynamic>{'Category': instance.category, 'Cover': instance.cover};

CategoryFavoriteRequest _$CategoryFavoriteRequestFromJson(
  Map<String, dynamic> json,
) => CategoryFavoriteRequest(categoryId: json['categoryId'] as String);

Map<String, dynamic> _$CategoryFavoriteRequestToJson(
  CategoryFavoriteRequest instance,
) => <String, dynamic>{'categoryId': instance.categoryId};

CategoryUnfavoriteRequest _$CategoryUnfavoriteRequestFromJson(
  Map<String, dynamic> json,
) => CategoryUnfavoriteRequest(categoryId: json['categoryId'] as String);

Map<String, dynamic> _$CategoryUnfavoriteRequestToJson(
  CategoryUnfavoriteRequest instance,
) => <String, dynamic>{'categoryId': instance.categoryId};

FavoriteCategoriesRequest _$FavoriteCategoriesRequestFromJson(
  Map<String, dynamic> json,
) => FavoriteCategoriesRequest();

Map<String, dynamic> _$FavoriteCategoriesRequestToJson(
  FavoriteCategoriesRequest instance,
) => <String, dynamic>{};

CheckFavoritedRequest _$CheckFavoritedRequestFromJson(
  Map<String, dynamic> json,
) => CheckFavoritedRequest(categoryId: json['categoryId'] as String);

Map<String, dynamic> _$CheckFavoritedRequestToJson(
  CheckFavoritedRequest instance,
) => <String, dynamic>{'categoryId': instance.categoryId};

UserUploadAvatarRequest _$UserUploadAvatarRequestFromJson(
  Map<String, dynamic> json,
) => UserUploadAvatarRequest();

Map<String, dynamic> _$UserUploadAvatarRequestToJson(
  UserUploadAvatarRequest instance,
) => <String, dynamic>{};

TransactionBuyRequest _$TransactionBuyRequestFromJson(
  Map<String, dynamic> json,
) => TransactionBuyRequest(productId: json['ProductId'] as String);

Map<String, dynamic> _$TransactionBuyRequestToJson(
  TransactionBuyRequest instance,
) => <String, dynamic>{'ProductId': instance.productId};

TransactionMyRecordsRequest _$TransactionMyRecordsRequestFromJson(
  Map<String, dynamic> json,
) => TransactionMyRecordsRequest(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$TransactionMyRecordsRequestToJson(
  TransactionMyRecordsRequest instance,
) => <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};

AdminHandleUserRequest _$AdminHandleUserRequestFromJson(
  Map<String, dynamic> json,
) => AdminHandleUserRequest(
  userId: (json['UserId'] as num).toInt(),
  isBlocked: json['IsBlocked'] as bool,
  handleReason: json['HandleReason'] as String,
);

Map<String, dynamic> _$AdminHandleUserRequestToJson(
  AdminHandleUserRequest instance,
) => <String, dynamic>{
  'UserId': instance.userId,
  'IsBlocked': instance.isBlocked,
  'HandleReason': instance.handleReason,
};

AdminSetAdminRequest _$AdminSetAdminRequestFromJson(
  Map<String, dynamic> json,
) => AdminSetAdminRequest(userId: (json['UserId'] as num).toInt());

Map<String, dynamic> _$AdminSetAdminRequestToJson(
  AdminSetAdminRequest instance,
) => <String, dynamic>{'UserId': instance.userId};

AdminUsersRequest _$AdminUsersRequestFromJson(Map<String, dynamic> json) =>
    AdminUsersRequest(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      isBlocked: json['isBlocked'] as bool?,
      isAdmin: json['isAdmin'] as bool?,
      search: json['search'] as String?,
    );

Map<String, dynamic> _$AdminUsersRequestToJson(AdminUsersRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'isBlocked': instance.isBlocked,
      'isAdmin': instance.isAdmin,
      'search': instance.search,
    };

AdminUserDetailRequest _$AdminUserDetailRequestFromJson(
  Map<String, dynamic> json,
) => AdminUserDetailRequest(userId: (json['userId'] as num).toInt());

Map<String, dynamic> _$AdminUserDetailRequestToJson(
  AdminUserDetailRequest instance,
) => <String, dynamic>{'userId': instance.userId};

AdminReportedPostsRequest _$AdminReportedPostsRequestFromJson(
  Map<String, dynamic> json,
) => AdminReportedPostsRequest(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  isBlocked: json['isBlocked'] as bool?,
);

Map<String, dynamic> _$AdminReportedPostsRequestToJson(
  AdminReportedPostsRequest instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'isBlocked': instance.isBlocked,
};

AdminHandleReportRequest _$AdminHandleReportRequestFromJson(
  Map<String, dynamic> json,
) => AdminHandleReportRequest(
  postId: json['PostId'] as String,
  isBlocked: json['IsBlocked'] as bool,
  handleReason: json['HandleReason'] as String,
);

Map<String, dynamic> _$AdminHandleReportRequestToJson(
  AdminHandleReportRequest instance,
) => <String, dynamic>{
  'PostId': instance.postId,
  'IsBlocked': instance.isBlocked,
  'HandleReason': instance.handleReason,
};

AdminPostsRequest _$AdminPostsRequestFromJson(Map<String, dynamic> json) =>
    AdminPostsRequest(
      userId: (json['userId'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$AdminPostsRequestToJson(AdminPostsRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

CategoryAvgPriceRequest _$CategoryAvgPriceRequestFromJson(
  Map<String, dynamic> json,
) => CategoryAvgPriceRequest(categoryId: json['categoryId'] as String);

Map<String, dynamic> _$CategoryAvgPriceRequestToJson(
  CategoryAvgPriceRequest instance,
) => <String, dynamic>{'categoryId': instance.categoryId};

SetAdminRequest _$SetAdminRequestFromJson(Map<String, dynamic> json) =>
    SetAdminRequest(
      userId: (json['UserId'] as num).toInt(),
      isAdmin: json['IsAdmin'] as bool,
    );

Map<String, dynamic> _$SetAdminRequestToJson(SetAdminRequest instance) =>
    <String, dynamic>{'UserId': instance.userId, 'IsAdmin': instance.isAdmin};

NotificationMyRequest _$NotificationMyRequestFromJson(
  Map<String, dynamic> json,
) => NotificationMyRequest(
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$NotificationMyRequestToJson(
  NotificationMyRequest instance,
) => <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};

NotificationUnreadCountRequest _$NotificationUnreadCountRequestFromJson(
  Map<String, dynamic> json,
) => NotificationUnreadCountRequest();

Map<String, dynamic> _$NotificationUnreadCountRequestToJson(
  NotificationUnreadCountRequest instance,
) => <String, dynamic>{};

NotificationMarkReadRequest _$NotificationMarkReadRequestFromJson(
  Map<String, dynamic> json,
) => NotificationMarkReadRequest(
  notificationIds: (json['NotificationIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$NotificationMarkReadRequestToJson(
  NotificationMarkReadRequest instance,
) => <String, dynamic>{'NotificationIds': instance.notificationIds};

NotificationReadAllRequest _$NotificationReadAllRequestFromJson(
  Map<String, dynamic> json,
) => NotificationReadAllRequest();

Map<String, dynamic> _$NotificationReadAllRequestToJson(
  NotificationReadAllRequest instance,
) => <String, dynamic>{};
