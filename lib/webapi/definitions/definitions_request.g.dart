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

CategoryCreateRequest _$CategoryCreateRequestFromJson(
  Map<String, dynamic> json,
) => CategoryCreateRequest(
  category: json['Category'] as String,
  cover: json['Cover'] as String,
);

Map<String, dynamic> _$CategoryCreateRequestToJson(
  CategoryCreateRequest instance,
) => <String, dynamic>{'Category': instance.category, 'Cover': instance.cover};

TransactionBuyRequest _$TransactionBuyRequestFromJson(
  Map<String, dynamic> json,
) => TransactionBuyRequest(productId: json['ProductId'] as String);

Map<String, dynamic> _$TransactionBuyRequestToJson(
  TransactionBuyRequest instance,
) => <String, dynamic>{'ProductId': instance.productId};

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
