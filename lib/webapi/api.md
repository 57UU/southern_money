# 南方财富后端
- 程序入口是`Program.cs`
- 控制器在`SouthernMoneyBackend/Controllers`目录下
- 数据库的服务层位于`Database/xxxService.cs`

依赖通过依赖注入实现，无需手动管理依赖。

# 数据库迁移命令
- 安装dotnet-ef 工具: `dotnet tool install --global dotnet-ef`
- 生成迁移（在仓库根目录执行:
```bash
dotnet ef migrations add AddPostsAndLikes \
  --project Database/Database.csproj \
  --startup-project SouthernMoneyBackend/SouthernMoneyBackend.csproj \
  --output-dir Migrations
```
- 应用迁移到数据库：
```bash
dotnet ef database update \
  --project Database/Database.csproj \
  --startup-project SouthernMoneyBackend/SouthernMoneyBackend.csproj
```

# 项目运行命令
```bash
dotnet run --project SouthernMoneyBackend/SouthernMoneyBackend.csproj
```

# API可视化
访问`/swagger`即可查看API可视化文档

# API细节
为了简化模型，需要数据就用GET，执行动作就用POST

通用准则：所有接口均返回`ApiResponse<T>`对象，其中`T`是具体的响应数据类型。
格式如下：
```json
{
    "Success": bool,
    "Message": "错误信息", //optional
    "Data": {  },//optional
    "Timestamp": "2023-10-01T12:00:00Z"
}
```
下文提到的响应返回对象指的是"Data"字段对应的内容。例如`/login/loginByPassword`的完整响应如下：
```json
{
    "Success": true,
    "Data": {
        "Token": "登录令牌",
        "RefreshToken": "刷新令牌"
    },
    "Timestamp": "2023-10-01T12:00:00Z"
}
```

分页：所有分页接口都返回`ApiResponse<PagedResult<T>>`对象，其中`T`是具体的响应数据类型。
格式如下：
```json
{
    "Success": bool,
    "Message": "错误信息", //optional
    "Data": {
        "Items": [  ],//optional
        "TotalCount": 0,
        "PageSize": 0,
        "CurrentPage": 0
    },
    "Timestamp": "2023-10-01T12:00:00Z"
}
```
## Test 检查server是否运行
- **路径**: `/test`
- **方法**: `GET`
- **成功响应**:
```json
{
    "message": "Server is running"
}
```

## login
### 注册用户
- **路径**: `/login/register`
- **方法**: `POST`
- **参数**:
```json
{
    "Name": "用户名",
    "Password": "密码"
}
```

### 密码登录
- **路径**: `/login/loginByPassword`
- **方法**: `POST`
- **参数**:
```json
{
    "Name": "用户名",
    "Password": "密码"
}
```
- **成功响应**:
```json
{
    "Token": "登录令牌",
    "RefreshToken": "刷新令牌"
}
```

### Token登录(刷新令牌)
- **路径**: `/login/refreshToken`
- **方法**: `POST`
- **参数**:
```json
{
    "RefreshToken": "刷新令牌"
}
```
- **成功响应**:
```json
{
    "Token": "登录令牌",
    "RefreshToken": "刷新令牌"
}
```

## images
### 上传图片
- **路径**: `/images/upload`
- **方法**: `POST`
- **参数**(form):
  - `file`: 图片文件（必填，最大2MB）
  - `imageType`: 图片类型（必填）
  - `description`: 图片描述（可选）
- **成功响应**:
  - `200 OK`: 返回`{ "ImageId": "图片ID" }`
- **错误响应**:
  - `400 Bad Request`: 包含错误信息（如文件为空、文件大小超过限制）
  - `401 Unauthorized`: 认证失败

### 获取图片
- **路径**: `/images/get?id={imageId}`
- **方法**: `GET`
- **参数**:
  - `imageId`: 图片ID（必填，Guid格式）
- **成功响应**:
  - `200 OK`: 返回Image对象，包含图片数据和元信息
- **错误响应**:
  - `404 Not Found`: 图片不存在
  - `401 Unauthorized`: 认证失败

## posts
### 创建帖子
- **路径**: `/posts/create`
- **方法**: `POST`
- **参数**:
```json
{
    "Title": "帖子标题",
    "Content": "帖子内容",
    "Tags": [
        "标签1",
        "标签2"
    ],
    "ImageIds": [
        "图片ID1",
        "图片ID2"
    ]
}
```

### 获取帖子
- **路径**: `/posts/get?id={postId}`
- **方法**: `GET`
- **参数**:
  - `postId`: 帖子ID（必填，Guid格式）
- **成功响应**:
```json
{
    "Title": "帖子标题",
    "Content": "帖子内容",
    "CreateTime": "2023-01-01T00:00:00Z", //datetime
    "ReportCount": 0, //int
    "ViewCount": 0, //int
    "LikeCount": 0, //int
    "IsBlocked": false, //bool
    "IsLiked": false, //bool
    "Tags": [
        "标签1",
        "标签2"
    ],
    "ImageIds": [
        "图片ID1",
        "图片ID2"
    ],
    "Uploader":{
        "Id":123123,
        "Name":"用户名",
        "Avatar":"图片ID"
    }
}
```

### 帖子分页
- **路径**: `/posts/page?page={page}&pageSize={pageSize}`
- **方法**: `GET`
- **参数**:
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页帖子数量（必填，整数，默认值为10）
- **成功响应**:
```json
{
    "TotalCount": 10,
    "CurrentPage": 1,
    "PageSize": 10,
    "Posts": [
        {
            ...
        },
    ]
}
```
### 搜索帖子
- **路径**: `/posts/search?query={query}`
- **方法**: `GET`
- **参数**:
  - `query`: 搜索关键词（必填）
- **成功响应**:
```json
{
    "TotalCount": 10,
    "CurrentPage": 1,
    "PageSize": 10,
    "Posts": [
        {
            ...
        },
    ]
}
```

### 举报帖子
- **路径**: `/posts/report`
- **方法**: `POST`
- **参数**:
```json
{
    "PostId": "帖子ID",
    "Reason": "举报原因"
}
```
- **成功响应**:
  - `200 OK`

### 点赞
- **路径**: `/posts/like?id={postId}`
- **方法**: `POST`
- **参数**:
  - `postId`: 帖子ID（必填，Guid格式）
- **成功响应**:
```json
{
    "LikeCount": 1, //int
}
```

### 删除帖子
- **路径**: `/posts/delete`
- **方法**: `POST`
- **参数**:
```json
{
    "PostId": "帖子ID"
}
```
- **成功响应**:
  - `200 OK`
- **错误响应**:
  - `404 Not Found`: 帖子不存在
  - `403 Forbidden`: 无权限删除（非帖子作者或管理员）
### 编辑帖子
- **路径**: `/posts/edit`
- **方法**: `POST`
- **参数**:
```json
{
    "PostId": "帖子ID",
    "Title": "新标题",
    "Content": "新内容",
    "Tags": [
        "新标签1",
        "新标签2"
    ],
    "ImageIds": [
        "新图片ID1",
        "新图片ID2"
    ]
}
```
- **成功响应**:
  - `200 OK`


### 我的贴子
- **路径**: `/posts/myPosts?page={page}&pageSize={pageSize}`
- **方法**: `GET`
- **参数**:
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页帖子数量（必填，整数，默认值为10）
- **成功响应**:
```json
{
    "TotalCount": 10,
    "CurrentPage": 1,
    "PageSize": 10,
    "Posts": [
        {
            ...
        },
    ]
}
```

## user
### 获取用户信息
- **路径**: `/user/profile`
- **方法**: `GET`
- **成功响应**:
```json
{
    "Id": 123123,
    "Name": "用户名",
    "Email": "用户邮箱",
    "Avatar": "图片ID",
    "IsBlocked": false, //bool
    "CreatedAt": "2023-01-01T00:00:00Z", //datetime
    "Asset": {
        "Total":10000,
        "TodayEarn":100,
        "AccumulatedEarn":1000000,
        "EarnRate":0.01,
        "Balance":10000
    }
}
```

### 更新用户信息
- **路径**: `/user/update`
- **方法**: `POST`
- **参数**:
```json
{
    "Name": "用户名",
    "Email": "用户邮箱"
}
```
- **成功响应**:
  - `200 OK`

### 修改密码
- **路径**: `/user/changePassword`
- **方法**: `POST`
- **参数**:
```json
{
    "CurrentPassword": "当前密码",
    "NewPassword": "新密码"
}
```
- **成功响应**:
  - `200 OK`


### 上传头像
- **路径**: `/user/uploadAvatar`
- **方法**: `POST`
- **参数**(form):
  - `file`: 图片文件（必填，最大2MB）
- **成功响应**:
  - `200 OK`: 返回`{ "AvatarId": "头像图片ID" }`
- **错误响应**:
  - `400 Bad Request`: 包含错误信息（如文件为空、文件大小超过限制）
  - `401 Unauthorized`: 认证失败

### topup
- **路径**: `/user/topup`
- **方法**: `POST`
- **参数**:
```json
{
    "Amount": 100.00 //decimal
}
```
- **成功响应**:
  - `200 OK`

### 开户
- **路径**: `/user/openAccount`
- **方法**: `POST`
- **参数**:
无
- **成功响应**:
  - `200 OK`

## store
### 我发布的商品
- **路径**: `/store/myProducts?page={page}&pageSize={pageSize}`
- **方法**: `GET`
- **参数**:
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页商品数量（必填，整数，默认值为10）
- **成功响应**:
```json
{
    "TotalCount": 100,
    "CurrentPage": 1,
    "PageSize": 10,
    "Items": [
        {
            "Id": "商品ID",
            "Name": "商品名称",
            "Price": 100.00,
            "Description": "商品描述",
            "CategoryId": "分类ID",
            "CategoryName": "分类名称",
            "UploaderUserId": 123,
            "UploaderName": "用户名",
            "CreatedAt": "创建时间"
        },
    ]
}
```

### 商品列表
- **路径**: `/store/products?page={page}&pageSize={pageSize}&categoryId={categoryId}&search={search}`
- **方法**: `GET`
- **参数**:
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页商品数量（必填，整数，默认值为10）
  - `categoryId`: 分类ID（可选，Guid格式）
  - `search`: 搜索关键词（可选）
- **成功响应**:
```json
{
    "TotalCount": 100,
    "CurrentPage": 1,
    "PageSize": 10,
    "Items": [
        {
            "Id": "商品ID",
            "Name": "商品名称",
            "Price": 100.00,
            "Description": "商品描述",
            "CategoryId": "分类ID",
            "CategoryName": "分类名称",
            "UploaderUserId": 123,
            "UploaderName": "用户名",
            "CreatedAt": "创建时间"
        },
    ]
}
```

### 根据分类ID获取商品列表
- **路径**: `/store/categories/{id}/products?page={page}&pageSize={pageSize}`
- **方法**: `GET`
- **参数**:
  - `id`: 分类ID（必填，Guid格式）
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页商品数量（必填，整数，默认值为10）
- **成功响应**:
```json
{
    "TotalCount": 100,
    "CurrentPage": 1,
    "PageSize": 10,
    "Items": [
        {
            "Id": "商品ID",
            "Name": "商品名称",
            "Price": 100.00,
            "Description": "商品描述",
            "CategoryId": "分类ID",
            "CategoryName": "分类名称",
            "UploaderUserId": 123,
            "UploaderName": "用户名",
            "CreatedAt": "创建时间"
        },
    ]
}
```

### 搜索商品
- **路径**: `/store/search?q={query}&page={page}&pageSize={pageSize}`
- **方法**: `GET`
- **参数**:
  - `q`: 搜索关键词（必填）
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页商品数量（必填，整数，默认值为10）
- **成功响应**:
```json
{
    "TotalCount": 100,
    "CurrentPage": 1,
    "PageSize": 10,
    "Items": [
        {
            "Id": "商品ID",
            "Name": "商品名称",
            "Price": 100.00,
            "Description": "商品描述",
            "CategoryId": "分类ID",
            "CategoryName": "分类名称",
            "UploaderUserId": 123,
            "UploaderName": "用户名",
            "CreatedAt": "创建时间"
        },
    ]
}
```

### 发布商品
- post: `/store/publish`
- parameter
```json
{
    "Name": "商品名称",
    "Price": 100.00, //decimal
    "Description": "商品描述",
    "CategoryId": "分类ID", //Guid格式
}
```
### 删除商品
- **路径**: `/store/delete`
- **方法**: `POST`
- **参数**:
```json
{
    "ProductId": "商品ID"
}
```
- **成功响应**:
  - `200 OK`

### 获取商品detail
- **路径**: `/store/detail?id={productId}`
- **方法**: `GET`
- **参数**:
  - `productId`: 商品ID（必填，Guid格式）
- **成功响应**:
```json
{
    "Id": "qweqwe",//guid
    "Price": 100.00, //decimal
    "Description": "商品描述",
    "CategoryId": "分类ID", //Guid格式
    "CategoryName": "商品分类名称",
    "Uploader":{
        "Id":123123,
        "Name":"用户名",
        "Avatar":"图片ID"
    }
}
```

### 获取商品详情（RESTful风格）
- **路径**: `/store/products/{id}`
- **方法**: `GET`
- **参数**:
  - `id`: 商品ID（必填，Guid格式）
- **成功响应**:
```json
{
    "Id": "qweqwe",//guid
    "Price": 100.00, //decimal
    "Description": "商品描述",
    "CategoryId": "分类ID", //Guid格式
    "CategoryName": "商品分类名称",
    "UploaderUserId": 123123,
    "UploaderName": "用户名",
    "CreatedAt": "创建时间"
}
```

### 商品类别均价
- **路径**: `/store/avgPrice?categoryId={categoryId}`
- **方法**: `GET`
- **参数**:
  - `categoryId`: 商品分类ID（必填，Guid格式）
- **成功响应**:
```json
{
    "AvgPrice": 100.00 //decimal
}
```

### 获取所有分类
- **路径**: `/store/categories`
- **方法**: `GET`
- **成功响应**:
```json
{
    "Success": true,
    "Message": null,
    "Data": [
        {
            "Id": "分类ID",
            "Name": "分类名称",
            "CoverImageId": "封面图片ID",
            "CreatedAt": "创建时间"
        },
        ...
    ],
    "Timestamp": "时间戳"
}
```

### 根据ID获取分类
- **路径**: `/store/categories/{id}`
- **方法**: `GET`
- **参数**:
  - `id`: 分类ID（必填，Guid格式）
- **成功响应**:
```json
{
    "Success": true,
    "Message": null,
    "Data": {
        "Id": "分类ID",
        "Name": "分类名称",
        "CoverImageId": "封面图片ID",
        "CreatedAt": "创建时间"
    },
    "Timestamp": "时间戳"
}
```

### 获取category
- **路径**: `/store/category/search?name={name}`
- **方法**: `GET`
- **成功响应**:
```json
{
    "Categories": [
        "商品分类1",
        "商品分类2"
    ]//最多10个分类
}
```

### 添加category
- Post: `/store/category/create`
- parameter
```json
{
    "Category": "商品分类",
    "Cover": "图片ID"
}
```

### 收藏分类
- **路径**: `/store/categories/{categoryId}/favorite`
- **方法**: `POST`
- **参数**:
  - `categoryId`: 分类ID（必填，Guid格式）
- **成功响应**:
  - `200 OK`

### 取消收藏分类
- **路径**: `/store/categories/{categoryId}/unfavorite`
- **方法**: `POST`
- **参数**:
  - `categoryId`: 分类ID（必填，Guid格式）
- **成功响应**:
  - `200 OK`

### 获取用户收藏分类
- **路径**: `/store/favoriteCategories`
- **方法**: `GET`
- **成功响应**:
```json
{
    "Success": true,
    "Data": [
        {
            "Id": "分类ID", //Guid格式
            "Name": "分类名称",
            "CoverImageId": "封面图片ID", //Guid格式
            "CreatedAt": "创建时间"
        }
    ]
}
```

### 检查分类是否已收藏
- **路径**: `/store/categories/{categoryId}/isFavorited`
- **方法**: `GET`
- **参数**:
  - `categoryId`: 分类ID（必填，Guid格式）
- **成功响应**:
```json
{
    "Success": true,
    "Data": {
        "IsFavorited": true
    }
}
```

## transaction
### 购买商品
- **路径**: `/transaction/buy`
- **方法**: `POST`
- **参数**:
```json
{
    "ProductId": "商品ID",
}
```
- **成功响应**:
  - `200 OK`

### 我的购买记录
- **路径**: `/transaction/myRecords?page={page}&pageSize={pageSize}`
- **方法**: `GET`
- **参数**:
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页记录数量（必填，整数，默认值为10）
- **成功响应**:
```json
{
    "TotalCount": 10,
    "CurrentPage": 1,
    "PageSize": 10,
    "Records": [
        {
            "Id": "qweqwe",//guid
            "ProductId": "商品ID",//guid
            "Quantity": 1, //int
            "Price": 100.00, //decimal
            "TotalPrice": 100.00, //decimal
            "PurchaseTime": "2023-01-01T00:00:00Z" //datetime
        },
    ]
}
```

## admin
### 处理用户
- **路径**: `/admin/handleUser`
- **方法**: `POST`
- **参数**:
```json
{
    "UserId": 123, //int
    "IsBlocked": true, //bool
    "HandleReason": "处理原因"
}
```
- **成功响应**:
  - `200 OK`

### 设置用户为管理员
- **路径**: `/admin/setAdmin`
- **方法**: `POST`
- **参数**:
```json
{
    "UserId": 123 //int
}
```
- **成功响应**:
  - `200 OK`

### 获取用户列表
- **路径**: `/admin/users?page={page}&pageSize={pageSize}&isBlocked={isBlocked}&isAdmin={isAdmin}&search={search}`
- **方法**: `GET`
- **参数**:
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页记录数量（必填，整数，默认值为10）
  - `isBlocked`: 是否被封禁（可选，bool）
  - `isAdmin`: 是否是管理员（可选，bool）
  - `search`: 搜索关键词（可选，用于搜索用户名或邮箱）
- **成功响应**:
```json
{
    "TotalCount": 100,
    "CurrentPage": 1,
    "PageSize": 10,
    "Items": [
        {
            "Id": 123123,
            "Name": "用户名",
            "Avatar": "图片ID",
            "Email": "用户邮箱",
            "IsBlocked": false, //bool
            "IsAdmin": false //bool
        },
    ]
}
```

### 获取用户详情
- **路径**: `/admin/users/{userId}`
- **方法**: `GET`
- **参数**:
  - `userId`: 用户ID（必填，整数）
- **成功响应**:
```json
{
    "Id": 123123,
    "Name": "用户名",
    "Avatar": "图片ID",
    "Email": "用户邮箱",
    "IsBlocked": false, //bool
    "IsAdmin": false //bool
}
```

### 获取系统统计信息
- **路径**: `/admin/statistics`
- **方法**: `GET`
- **成功响应**:
```json
{
    "TotalUsers": 1000,
    "TotalProducts": 500,
    "TotalTransactions": 2000,
    "RecentTransactions": 150,
    "BannedUsers": 10
}
```

### 查看被举报的帖子
- **路径**: `/admin/reportedPosts?page={page}&pageSize={pageSize}`
- **方法**: `GET`
- **参数**:
  - `page`: 页码（必填，整数，默认值为1）
  - `pageSize`: 每页记录数量（必填，整数，默认值为10）
- **成功响应**:
```json
{
    "TotalCount": 10,
    "CurrentPage": 1,
    "PageSize": 10,
    "Items": [
        {
            "Id": "帖子ID",
            "Title": "帖子标题",
            "Content": "帖子内容",
            "CreatedAt": "2023-01-01T00:00:00Z",
            "ReportCount": 3,
            "ViewCount": 100,
            "LikeCount": 10,
            "IsBlocked": false,
            "IsLiked": false,
            "Tags": ["标签1", "标签2"],
            "ImageIds": ["图片ID1", "图片ID2"],
            "Uploader": {
                "Id": 123123,
                "Name": "用户名"
            }
        },
    ]
}
```

### 处理举报帖子
- **路径**: `/admin/handleReport`
- **方法**: `POST`
- **参数**:
```json
{
    "PostId": "帖子ID",
    "IsBlocked": true, //bool
    "HandleReason": "处理原因"
}
```
- **成功响应**:
  - `200 OK`

## 认证方式

### JWT认证
*：在development环境下，禁用了JWT认证

所有非登录相关的API（即非`/login/*`,`/test`路径）都需要在请求头中提供以下认证信息：

```
Authorization: Bearer <jwt_token>
```

其中`<jwt_token>`是通过登录接口（`/login/loginByPassword`）获取的JWT令牌。

### 认证失败处理
- 认证失败时，API将返回`401 Unauthorized`状态码
- 响应将包含标准化的错误信息，格式为：
  ```json
  {
    "success": false,
    "message": "认证失败原因",
    "timestamp": "时间戳"
  }
  ```

### 令牌刷新
- 可以通过`/login/refreshToken`端点使用refresh token刷新过期的令牌(一般来说,refresh token的过期时间要比jwt token长)
