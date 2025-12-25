#import "templates/cs-template.typ": *
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/mitex:0.2.6":*
#import "@preview/oxdraw:0.1.0": oxdraw
#import "@preview/tablem:0.3.0": tablem, three-line-table
#show: setup-lovelace

#let algorithm = algorithm.with(supplement: "算法")


//define user

#let u57u="57U"
#let yyw="YYW"
#let lpj="LPJ"
#let hr="HR"

#show: project.with(
  anonymous: false, 
  title: "南方财富软件",
  author: [#u57u #yyw #lpj #hr],
  school: "计算机学院",
  id: "1145141919810",
  mentor: "郭际香",
  grade: "2023",
  major: "人工智能",
  date: (2025, 12, 17),
  abstract_zh:"南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富南方财富",
  keywords_zh: ("南方财富","南方财富","南方财富"),
  users: u57u+", "+yyw+", "+lpj+", "+hr,
)

#linebreak()
#linebreak()





= 绪论
== 系统开发背景（结合现实可用性）
在互联网金融蓬勃发展的背景下，用户对金融服务的需求呈现出多样化、个性化和社区化的趋势。传统金融机构的服务模式在便捷性、个性化推荐和用户互动等方面已难以完全满足现代用户的需求。在此背景下，Southern Money系统应运而生，旨在构建一个集金融交易、产品展示、社区交流于一体的综合性金融服务平台。

系统主要解决以下核心问题：
- 金融产品信息碎片化，用户难以高效获取和比较各类金融产品
- 缺乏基于用户行为和偏好的个性化金融产品推荐机制
- 缺少专业的金融知识交流和分享社区，用户间互动不足
- 金融交易记录管理分散，用户难以全面追踪和分析个人财务状况

Southern Money系统融合了现代金融科技与互联网社区理念，通过技术创新为用户提供安全、便捷、个性化的金融服务体验，助力提升用户金融素养和投资决策能力。

== 开发环境

#figure(
  three-line-table[
    | 类别 | 技术/工具 | 版本 |
    |------|-----------|------|
    | 后端开发语言 | C\# | 12.0+ |
    | 后端框架 | ASP.NET Core | 10.0+ |
    | 前端开发语言 | Dart | 3.0+ |
    | 前端框架 | Flutter | 3.0+ |
    | 数据库（原型） | SQLite | 3.0+ |
    | 数据库（生产） | PostgreSQL | 17.0+ |
    | ORM框架 | Entity Framework Core | 6.0+ |
    | API文档 | Swagger | 5.0+ |
    | 身份认证 | JWT | - |
  ],
  kind: table,
  caption: "技术栈选择"
)

== 技术路线
Southern Money系统采用前后端分离的现代化架构设计，具体技术路线如下：

=== 后端架构
- 基于ASP.NET Core Web API构建高性能RESTful API服务
- 采用Entity Framework Core实现高效数据库操作和ORM映射
- 集成JWT身份认证与授权机制，保障API安全访问
- 实施分层架构设计：Controller层（请求处理）、Service层（业务逻辑）、Repository层（数据访问）
- 开发中间件组件处理身份验证、异常处理、日志记录等横切关注点

//typst的mermaid不支持classDef 自定义样式
//typst的oxdraw必须以graph开头
#oxdraw("
graph LR
    %% 用户层
    Client[接受HTTP请求]
    
    %% Controller层
    Controller[Controller层<br/>请求处理]
    
    %% Service层
    Service[Service层<br/>业务逻辑]
    
    %% Repository层
    Repository[Repository层<br/>数据访问]
    
    %% 数据层
    Database[(数据库)]
    
    %% 连接关系
    Client --> Controller
    Controller --> Service
    Service --> Repository
    Repository --> Database
")

系统设计如下

#oxdraw("
graph TD
      subgraph 控制器层
         UserController[UserController]
         PostController[PostController]
         StoreController[StoreController]
         ImageBedController[ImageBedController]
         AdminController[AdminController]
         NotificationController[NotificationController]
         TransactionController[TransactionController]
      end

      subgraph 服务层
         UserService[UserService]
         PostService[PostService]
         ProductService[ProductService]
         ImageBedService[ImageBedService]
         AdminService[AdminService]
         NotificationService[NotificationService]
         TransactionService[TransactionService]
         UserAssetService[UserAssetService]
         ProductCategoryService[ProductCategoryService]
         UserFavoriteCategoryService[UserFavoriteCategoryService]
      end

      subgraph 数据访问层
         UserRepository[UserRepository]
         PostRepository[PostRepository]
         ImageRepository[ImageRepository]
         ProductRepository[ProductRepository]
         TransactionRepository[TransactionRepository]
         UserAssetRepository[UserAssetRepository]
         ProductCategoryRepository[ProductCategoryRepository]
         UserFavoriteCategoryRepository[UserFavoriteCategoryRepository]
         NotificationRepository[NotificationRepository]
      end

      subgraph 基础设施层
         AppDbContext[AppDbContext]
         JwtUtils[JwtUtils]
      end

      %% 控制器依赖服务
      UserController --> UserService
      PostController --> PostService
      StoreController --> ProductService
      StoreController --> UserAssetService
      ImageBedController --> ImageBedService
      AdminController --> AdminService
      NotificationController --> NotificationService
      TransactionController --> TransactionService

      %% 服务依赖仓库和其他服务
      AdminService --> UserRepository
      AdminService --> ImageRepository
      AdminService --> PostRepository
      AdminService --> NotificationService
      UserService --> UserRepository
      PostService --> PostRepository
      PostService --> ImageRepository
      PostService --> NotificationService
      PostService --> UserRepository
      ProductService --> ProductRepository
      ImageBedService --> ImageRepository
      TransactionService --> TransactionRepository
      TransactionService --> UserAssetRepository
      TransactionService --> ProductRepository
      UserAssetService --> UserAssetRepository
      ProductCategoryService --> ProductCategoryRepository
      UserFavoriteCategoryService --> UserFavoriteCategoryRepository
      NotificationService --> NotificationRepository

      %% 仓库依赖数据库上下文
      UserRepository --> AppDbContext
      PostRepository --> AppDbContext
      ImageRepository --> AppDbContext
      ProductRepository --> AppDbContext
      TransactionRepository --> AppDbContext
      UserAssetRepository --> AppDbContext
      ProductCategoryRepository --> AppDbContext
      UserFavoriteCategoryRepository --> AppDbContext
      NotificationRepository --> AppDbContext

      %% 服务依赖工具类
      UserService --> JwtUtils
")

=== 前端架构
   - 基于Flutter框架开发跨平台应用，支持Web、Android、iOS、Windows、macOS、Linux六大平台
   - 开发状态管理库实现应用状态的高效管理
   - 使用`get_it`作为依赖注入容器，集中管理`SharedPreferences`、`TokenService`及各类`ApiService`实例，降低页面之间的耦合度（对应`lib/setting/ensure_initialized.dart`）。
   - 通过`AppConfigService`统一管理主题颜色、动画时长、后端`BaseUrl`和会话 Token，配合`ValueNotifier`实现轻量级响应式状态管理（对应`lib/setting/app_config.dart`）。
   - 网络层基于`Dio`与自定义`JwtInterceptor`/`JwtDio`，在拦截器中自动附加`Authorization`头、处理401错误并尝试刷新令牌，简化前端对认证细节的处理（对应`lib/webapi/JwtService.dart`及各`api_xxx.dart`）。

前端页面结构围绕`main.dart`中的`MainScreen`搭建，采用“底部/侧边导航 + 多 Tab 页面”的形式：
- 四个核心 Tab：`HomePage`（首页）、`CommunityPage`（社区）、`MarketPage`（行情）、`ProfilePage`（个人中心）。
- 借助`popupOrNavigate`与`Fragment`组件，在横屏时优先使用弹窗展示子页面，在竖屏时使用路由切换新页面，提升大屏设备上的多任务体验（对应`lib/widgets/router_utils.dart`）。

实施响应式UI设计，自动适配不同屏幕尺寸和设备类型

#figure(
  three-line-table[
    | 项目 | 横屏 | 竖屏 |
    |------|------|------|
    | 导航栏 | 左侧 | 底部 |
    | 新页面 | 作为悬浮窗弹出 | 作为新页面弹出 |
    | 登陆页面 | 在左侧显示占位填充 | 直接显示 |
  ],
  kind: table,
  caption: "响应式布局设计"
)

采用HTTP2库实现高效HTTP请求处理和拦截器机制，简化了认证流程，并实现JWT令牌自动管理与刷新机制，确保持续安全访问
#oxdraw("
graph LR
    Request[发起HTTP请求]-->Interceptor[拦截器：添加访问令牌]
    Interceptor-->Remote[远程资源]
    Remote-->Expire{令牌过期错误？}
    Expire-->|是|TokenRefresh[刷新令牌]
    TokenRefresh-->RefreshResult{刷新成功？}
    RefreshResult-->|成功|Remote
    RefreshResult-->|失败|ErrorHandler[错误处理]
    Expire-->|否|Response[正常响应]
")
设计了这些页面，下图描述了这些页面的切换关系：
#oxdraw("
graph TD
      %% Entry Points
      A[Login Page] -->|Login Success| B[Main App]
      C[Register Page] 
      A <--> C
      
      %% Main App Tab Navigation
      B -->|Tab Switch| D[Home Page]
      B -->|Tab Switch| E[Community Page]
      B -->|Tab Switch| F[Market Page]
      B -->|Tab Switch| G[Profile Page]
      D <--> E <--> F <--> G <--> D
      
      %% Home Page Flow
      D -->|View Post| H[Post Page]
      D -->|View Product| I[CSGO Product Detail Page]
      
      %% Community Page Flow
      E -->|View Post| H
      E -->|Search| J[Community Search Page]
      J -->|View Post| H
      H -->|View User| K[Profile Page]
      H -->|View Author| L[Posts by User]
      
      %% Market Page Flow
      F -->|View Category| M[CSGO Category Page]
      F -->|Search| N[Market Search Page]
      M -->|View Products| O[CSGO Products by Category]
      O -->|View Detail| I
      N -->|View Detail| I
      
      %% Profile Page Flow
      G -->|Edit Profile| P[Profile Edit Page]
      G -->|My Posts| Q[My Posts]
      G -->|My Collection| R[My Collection]
      G -->|My Message| S[My Message]
      G -->|My Selections| T[My Selections]
      G -->|My Transaction| U[My Transaction]
      G -->|Settings| V[Setting]
      G -->|Open an Account| W[Open an Account]
      Q -->|View Post| H
      
      %% Settings Flow
      V -->|Theme Color| X[Theme Color Page]
      V -->|Duration Setting| Y[Setting Duration]
      V -->|API Setting| Z[Set API Page]
      
      %% Admin Flow
      G -->|Admin Access| AA[Admin Page]
      AA -->|Manage Users| AB[Admin Manage User]
      AA -->|Censor Forum| AC[Admin Censor Forum]
      AA -->|Post Block History| AD[Admin Post Block History]
      AA -->|Statistics| AE[Admin Statistics]
      
      %% CSGO Management Flow
      AA -->|Create Category| AF[CSGO Category Create]
      AA -->|Create Product| AG[CSGO Products Create]
      
      %% Debug Flow
      G -->|Debug| AH[Debug Page]
      
      %% About Us
      V -->|About Us| AI[About Us Page]
")
运用依赖注入容器管理应用依赖，实现模块解耦。遵循SOLID原则中的单一职责和依赖倒置，提高系统的可维护性、可测试性和扩展性。
下图依赖关系：
#oxdraw("
graph TD
       subgraph \"核心依赖\"
           SP[SharedPreferences] --> TS[TokenService]
           SP --> PS[PasswordService]
           TS --> ACS[AppConfigService]
           PI[PackageInfo] --> VS[VersionService]
       end
       
       subgraph \"HTTP客户端\"
           DIO[Dio]
           ACS --> JD[JwtDio]
           ALS[ApiLoginService] --> JD
       end
       
       subgraph \"API服务\"
           JD --> APS[ApiPostService]
           JD --> AUS[ApiUserService]
           JD --> ANS[ApiNotificationService]
           JD --> AIS[ApiImageService]
           JD --> ASS[ApiStoreService]
           JD --> ATS[ApiTransactionService]
           JD --> AAdS[ApiAdminService]
           
           DIO --> ALS
           ACS --> ALS
           
           DIO --> ATS2[ApiTestService]
           ACS --> ATS2
           
           DIO --> AUS
           ACS --> AIS
       end
       
")

=== 数据库设计
   - 在开发过程中，采用SQLite数据库进行原型设计和测试；在生产环境中，切换到PostgreSQL数据库以实现高并发和高数据吞吐量。
   - 设计规范化关系型数据模型，优化表结构和关联关系
   - 实现完整的数据完整性约束，确保数据一致性和可靠性
   - 采用 Entity Framework Core Code First 模式并配合`dotnet ef`迁移命令管理表结构，使得从 SQLite 切换到 PostgreSQL 的过程自动化、可回滚。
   - 对所有`DateTime`字段统一使用 UTC 存储，并在`AppDbContext`中通过`UtcDateTimeConverter`约束转换，避免跨时区显示误差。
   - 对`PostFavorite`、`UserFavoriteCategory`等多对多关系表使用复合主键，既防止重复收藏，又提升常用查询性能。

=== 系统安全
   - 采用密码哈希存储技术，保障用户密码安全
   - 开发异常处理中间件，防止敏感信息泄露，提供友好错误提示

实施JWT令牌认证机制，确保API访问安全
   - 认证流程图：
     #oxdraw("
     graph LR
         A[接收API请求] --> D{令牌正确?}
         D -->|否| E[继续处理请求，但无用户信息]
         D -->|是| G[提取token]
         G --> H[验证token有效性]
         H -->|无效| E
         H -->|有效| I[获取用户ID和角色信息]
         I --> J[将用户信息存储在HttpContext中]
         J --> K[继续处理请求]
     ")
   - 授权流程图：
     #oxdraw("
     graph LR
         A[控制器方法开始执行] --> B{是否需要授权?}
         B -->|否| C[继续执行方法逻辑]
         B -->|是| D{HttpContext中是否包含User信息?}
         D -->|否| E[返回401 Unauthorized]
         D -->|是| F{获取用户角色}
         F --> G{用户是否具有所需角色?}
         G -->|否| H[返回403 Forbidden]
         G -->|是| C
     ")
   - 为所有 Web API 统一封装`ApiResponse<T>`响应格式，前端能够通过`Success`、`Message`、`Data`等字段进行一致性错误处理，避免泄露堆栈等敏感信息。
   - 在图片上传接口中限制文件大小、校验 MIME 类型，并将图片数据与元信息分表存储，降低任意文件上传、恶意脚本执行等风险。
   - 通过`ExceptionHandlerMiddleware`拦截未处理异常，在生产环境中隐藏详细错误信息，只返回标准化错误响应，并记录日志便于排查。
   - 开发环境下关闭 JWT 强制校验，便于前端快速联调；上线时只需调整环境配置即可启用完整认证流程。
   - 对关键管理操作（封禁用户、处理举报、封禁帖子等）在数据库中持久化操作记录（如`PostBlock`、`Notification`），便于审计和追踪。


= 概要设计
== 需求概述（囊括需求清单的内容，按角色分析）
Southern Money系统面向两类主要用户：普通用户和管理员。系统需求根据用户角色进行分析如下：

=== 普通用户需求

1. 用户管理：
   - 用户注册、登录、密码修改
   - 个人信息编辑（头像、昵称等）
   - 开户功能
   - 查看个人资产和交易记录

2. 金融产品：
   - 浏览金融产品列表
   - 按分类查看金融产品
   - 搜索金融产品
   - 收藏感兴趣的产品分类
   - 购买金融产品
   - 查看交易记录

3. 社区交流：
   - 浏览社区帖子
   - 发布帖子（支持文字、图片）
   - 点赞、收藏帖子
   - 评论帖子
   - 搜索帖子
   - 查看个人发布的帖子
   - 查看个人收藏的帖子

4. 通知中心：
   - 查看系统通知

== 管理员需求
1. 用户管理：
   - 查看用户列表
   - 封禁/解封用户
   - 查看用户详细信息

2. 内容管理：
   - 审核社区帖子
   - 删除违规帖子
   - 管理帖子分类

3. 系统管理：
   - 查看系统统计数据
   - 管理系统配置
   - 处理用户举报

== 需求与实现对应关系

#figure(
  tablem[
    | 角色 | 需求 | 前端页面/模块 | 后端接口/模块 |
    |------|------|---------------|----------------|
    | 普通用户 | 注册、登录、自动登录 | LoginPage、RegisterPage、AppConfigService | /login/register、/login/loginByPassword、/login/refreshToken (LoginController) |
    | 普通用户 | 浏览行情和金融产品 | MarketPage、CsgoCategoryPage、CsgoProductsByCategory | /store/categories、/store/products、/store/categoryAvgPrice (StoreController) |
    | 普通用户 | 社区发帖、浏览、点赞、收藏 | CommunityPage、PostViewer、MyPosts、MySelections | /posts/create、/posts/page、/posts/like、/posts/favorite、/posts/report 等 (PostController) |
    | 普通用户 | 购买产品与查看交易记录 | CsgoProductDetailPage、MyTransaction、MyYield | /transaction/buy、/transaction/myRecords、用户资产相关接口 (TransactionController、UserAssetService) |
    | 普通用户 | 通知中心与消息提醒 | MyMessage 页面、通知角标 | /notification/my、/notification/unread-count、/notification/read (NotificationController) |
    | 管理员 | 用户管理与封禁 | 管理员入口、用户管理页面 | /admin/users、/admin/handleUser、/admin/setAdmin (AdminController) |
    | 管理员 | 内容审核与系统统计 | 帖子审核页面、统计页面 | /admin/reportedPosts、/admin/handleReport、/admin/statistics (AdminController、PostService) |
  ],
  kind: table,
  caption: "需求与实现对应关系"
)

== 系统功能模块图
#oxdraw("graph TD
    A[Southern Money系统]
    
    %% 主要模块
    B[用户管理模块]
    C[金融产品模块]
    D[交易管理模块]
    E[社区论坛模块]
    F[通知中心模块]
    G[管理员模块]
    
    %% 模块关系
    A --> B
    A --> C
    A --> D
    A --> E
    A --> F
    A --> G
    
    %% 用户管理模块子功能
    B --> B1[用户注册/登录]
    B --> B2[个人信息管理]
    B --> B3[开户管理]
    B --> B4[资产查询]
    
    %% 金融产品模块子功能
    C --> C1[产品分类管理]
    C --> C2[产品列表展示]
    C --> C3[产品搜索]
    C --> C4[产品收藏]
    
    %% 交易管理模块子功能
    D --> D1[产品购买]
    D --> D2[交易记录查询]
    
    %% 社区论坛模块子功能
    E --> E1[帖子发布/浏览]
    E --> E2[帖子点赞/收藏]
    E --> E3[帖子搜索]
    E --> E4[帖子审核]
    
    %% 通知中心模块子功能
    F --> F1[通知发送]
    F --> F2[通知管理]
    
    %% 管理员模块子功能
    G --> G1[用户管理]
    G --> G2[内容审核]
    G --> G3[系统统计]
")

= 详细设计
== UI设计
=== 整体风格：
现代化、简洁美观的金融服务平台风格，支持亮色和暗色主题切换。

=== 主题实现：
通过Flutter的ThemeData实现主题管理，支持动态切换主题颜色和字体样式。

=== 响应式布局
采用MediaQuery和LayoutBuilder实现响应式布局，自动适配不同屏幕尺寸和设备类型。

=== 主要页面设计：
- 登录页面：简洁明了的登录界面，支持用户名密码登录
- 首页：展示热门金融产品和社区帖子
- 市场页面：分类展示各类金融产品
- 社区页面：展示用户发布的帖子
- 个人中心：用户信息管理和功能入口

== 数据库设计
=== ER图设计

PLACEHOLDER typst暂不支持ER图，先不画
//TODO

=== 数据库表结构

#figure(
  tablem[
    | 表名 | 主要字段 | 说明 |
    |------|----------|------|
    | Users | Id, Name, Email, Avatar, Password, IsAdmin, HasAccount, IsBlocked, BlockReason, BlockedAt, CreateTime, IsDeleted, Balance | 用户信息表 |
    | Images | Id, UploaderUserId, CreateTime, Description, ImageType, Data | 图片信息表 |
    | Posts | Id, UploaderUserId, Title, Content, CreateTime, ReportCount, ViewCount, LikeCount, IsBlocked | 帖子信息表 |
    | PostImages | PostId, ImageId | 帖子图片关联表 |
    | PostTags | PostId, Tag | 帖子标签表 |
    | PostLikes | PostId, UserId, CreateTime | 帖子点赞表 |
    | PostFavorites | PostId, UserId, CreateTime | 帖子收藏表 |
    | PostBlocks | Id, PostId, AdminUserId, IsBlock, Reason, ActionTime | 帖子封禁表 |
    | Products | Id, Name, Price, Description, CategoryId, UploaderUserId, CreateTime, IsDeleted | 产品信息表 |
    | ProductCategories | Id, Name, CoverImageId, CreateTime | 产品分类表 |
    | UserFavoriteCategories | UserId, CategoryId, CreateTime | 用户收藏分类表 |
    | TransactionRecords | Id, ProductId, BuyerUserId, Quantity, Price, TotalPrice, PurchaseTime | 交易记录表 |
    | UserAssets | UserId, Total, TodayEarn, AccumulatedEarn, EarnRate, Balance, UpdatedAt | 用户资产表 |
    | Notifications | Id, UserId, SubjectUserId, Content, Type, IsRead, CreateTime | 通知表 |
    | Comments | Id, PostId, UserId, Content, CreateTime | 评论表 |
  ],
  kind: table,
  caption: "数据库表结构"
)

=== 数据库数据样例

#figure(
  tablem[
    | 表名 | 样例数据 |
    |------|----------|
    | Users | (1, 'user1', 'user1\@example.com', 'hash1', '2025-01-01') |
    | Products | (1, 'CSGO饰品', 100.0, '精美饰品', 1, '2025-01-01') |
    | Categories | (1, 'CSGO饰品', '游戏饰品分类') |
  ],
  kind: table,
  caption: "数据库数据样例"
)

=== 用户注册流程
#oxdraw("
graph LR
    A[用户填写注册信息] --> B[前端验证]
    B -->|验证通过| C[发送注册请求]
    C --> D[后端验证]
    D -->|验证通过| E[创建用户]
    E --> F[返回成功]
    D -->|验证失败| G[返回错误]
    B -->|验证失败| H[提示错误]
")

=== 用户登录流程
#oxdraw("
graph LR
    A[用户填写登录信息] --> B[前端验证]
    B -->|验证通过| C[发送登录请求]
    C --> D[后端验证]
    D -->|验证通过| E[生成JWT令牌]
    E --> F[返回令牌]
    D -->|验证失败| G[返回错误]
    B -->|验证失败| H[提示错误]
")

=== 产品购买流程
#oxdraw("
graph LR
    A[用户选择产品] --> B[查看产品详情]
    B --> C[确认购买]
    C --> D[前端验证余额]
    D -->|余额充足| E[发送购买请求]
    E --> F[后端处理交易]
    F --> G[更新用户资产]
    G --> H[生成交易记录]
    H --> I[返回成功]
    D -->|余额不足| J[提示充值]
")

=== 帖子发布流程
#oxdraw("
graph LR
    A[用户填写帖子内容] --> B[前端验证]
    B -->|验证通过| C[发送发布请求]
    C --> D[后端验证]
    D -->|验证通过| E[保存帖子]
    E --> F[返回成功]
    D -->|验证失败| G[返回错误]
    B -->|验证失败| H[提示错误]
")

=== 帖子审核流程
#oxdraw("
graph LR
    A[用户发布帖子] --> B[待审核]
    B --> C[管理员审核]
    C -->|通过| D[帖子上线]
    C -->|不通过| E[帖子驳回]
    E --> F[通知用户]
")

= 系统功能和测试
== 系统功能
=== 典型用户使用场景

下面以"普通用户从注册到完成一笔交易"为例说明系统整体功能协同过程：

1. 用户在登录页选择"注册"，填写昵称和密码，前端调用`/login/register`完成注册。
2. 完成注册后在登录页输入账号密码，调用`/login/loginByPassword`获取 JWT 与刷新令牌，前端通过`TokenService`持久化保存。
3. 进入首页后，在"快速导航"中选择"开户"，进入开户页面并完成开户流程，后端更新`User`及`UserAsset`信息。
4. 用户切换到"行情"栏目浏览各类产品分类，点击某一分类进入产品列表，挑选具体产品并在详情页调用`/transaction/buy`完成购买。
5. 交易完成后，用户可在"我的交易""收益"页面查看交易记录和资产变化，这些数据来自`/transaction/myRecords`及用户资产相关接口。
6. 与此同时，系统会通过`NotificationService`向用户发送交易成功通知，用户可在"我的消息"页面统一查看和管理。

通过这一完整场景展示，可以看出各模块之间在前后端层面的协作关系。

== 系统测试
系统测试包括以下方面：

1. 功能测试：
   - 测试了所有功能模块的基本功能
   - 验证了各个功能之间的交互
   - 测试了边界条件和异常情况

2. 性能测试：
   - 测试了系统在高并发情况下的性能
   - 验证了系统的响应时间和吞吐量
   - 测试了系统的稳定性和可靠性

3. 兼容性测试：
   - 测试了系统在不同设备和平台上的兼容性
   - 验证了系统在不同浏览器和操作系统上的表现
   - 测试了系统在不同网络环境下的可用性

4. 安全性测试：
   - 测试了系统的身份认证和授权机制
   - 验证了系统的输入验证和输出编码
   - 测试了系统的敏感信息保护

代表性测试用例示例：

- 功能测试用例：  
  - 正常登录：输入正确用户名和密码，期望返回有效 Token 并跳转到主界面。  
  - 错误登录：输入错误密码，期望返回错误提示且不下发 Token。  
  - 购买流程：在已开户且余额充足的前提下完成一次购买，校验交易记录与用户资产是否同步更新。
- 接口与异常测试用例：  
  - 未登录访问受保护接口（如`/posts/create`、`/transaction/buy`），期望返回 401。  
  - 使用过期 Token 调用 API，触发前端刷新流程并成功重试或提示重新登录。  
  - 后端抛出未处理异常时，前端收到统一格式的错误响应而非堆栈信息。
- 兼容性测试用例：  
  - 在 Android 模拟器、Windows 桌面和 Web 浏览器上分别运行应用，检查页面布局是否一致、功能是否完整。  
  - 在横屏/竖屏、窄屏/宽屏设备上验证导航栏位置、弹窗/页面切换行为是否符合设计。

== 测试截图
=== 系统主题展示

系统支持亮色和暗色主题切换，用户可以根据个人喜好和使用环境选择合适的主题模式。

#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [*亮色主题*], [*暗色主题*],
    image("lightmode.png"),
    image("darkmode.png"),
  ),
  caption: "亮色和暗色主题"
) 

=== 多平台兼容性展示

系统基于Flutter框架开发，支持多平台运行，包括Android、Web和Windows等平台，确保用户在不同设备上都能获得一致的使用体验。

=== 登录页面

登录页面支持用户名和密码登录，同时提供注册新用户功能。页面采用响应式设计，能够适配不同屏幕尺寸和方向。

#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [*登录页面-横屏*], [*登录页面-竖屏*],
    image("login_page_landscape.png",),
    image("login_page_portrait.png",height: 40%),
  ),
  caption: "登录页面"
)

=== 开户页面

开户页面为用户提供账户创建功能，用户可以填写必要信息完成开户流程，享受完整的金融服务。

#figure(
  image("open_account_page.png"),
  caption: "开户页面"
) 

=== 未开户状态页面

未开户状态页面提示用户需要先开户才能使用完整的金融服务功能。

#figure(
  image("without_open_account.png"),
  caption: "未开户状态页面"
)

=== 首页

首页是用户进入系统后的主要界面，提供了各种金融产品的快捷入口和热门社区帖子展示。

#figure(
  image("home_page.png"),
  caption: "首页"
)

=== 市场页面

市场页面显示各类金融产品的分类和价格信息，用户可以浏览不同类别的产品，查看详情并进行交易。

#figure(
  image("market_page.png"),
  caption: "市场页面"
)

=== CSGO市场页面

CSGO市场页面展示各类CSGO饰品的分类和价格信息，用户可以浏览和购买。

#figure(
  image("csgo_market_page.png"),
  caption: "CSGO市场页面"
)

=== 虚拟货币页面

虚拟货币页面展示各类虚拟货币的价格和趋势信息，用户可以浏览和购买。

#figure(
  image("virtual_money_page.png"),
  caption: "虚拟货币页面"
)

=== 购买页面

购买页面允许用户查看产品详情并进行购买操作。

#figure(
  image("buy_page.png"),
  caption: "购买页面"
)

=== 充值页面

充值页面允许用户向自己的账户充值资金，用于购买金融产品。

#figure(
  image("adding_money.png"),
  caption: "充值页面"
)

=== 收益页面

收益页面展示用户的资产收益情况，包括今日收益、累计收益和收益率等信息。

#figure(
  image("my_yield.png"),
  caption: "收益页面"
)

=== 我收藏的产品页面

我收藏的产品页面展示用户收藏的所有产品，方便用户快速访问感兴趣的金融产品。

#figure(
  image("my_star_product.png"),
  caption: "我收藏的产品页面"
)

=== 我的交易页面

我的交易页面展示用户的所有交易记录，包括购买的产品、交易时间和金额等信息。

#figure(
  image("my_transaction.png"),
  caption: "我的交易页面"
)

=== 社区页面

社区页面展示用户发布的帖子列表，支持帖子浏览、搜索和筛选功能。用户可以查看热门帖子，也可以发布自己的内容。

#figure(
  image("neighborhood_page.png"),
  caption: "社区页面"
)

=== 帖子详情页面

帖子详情页面展示完整的帖子内容，包括文字、图片、评论等信息。

#figure(
  image("post_detail.png"),
  caption: "帖子详情页面"
)

=== 我的帖子页面

我的帖子页面展示用户自己发布的所有帖子，方便用户管理和查看。

#figure(
  image("my_post.png"),
  caption: "我的帖子页面"
)

=== 用户帖子页面

用户帖子页面展示用户自己发布的帖子内容，方便用户管理和查看自己的社区贡献。

#figure(
  image("post_page_by_user.png"),
  caption: "用户帖子页面"
)

=== 我收藏的帖子页面

我收藏的帖子页面展示用户收藏的所有帖子，方便用户快速访问感兴趣的内容。

#figure(
  image("my_star_post.png"),
  caption: "我收藏的帖子页面"
)

=== 我的消息页面

我的消息页面展示系统发送给用户的通知和消息，包括系统通知、活动通知等。

#figure(
  image("my_message.png"),
  caption: "我的消息页面"
)

=== 个人中心页面

个人中心页面展示用户的个人信息和各种功能入口，方便用户管理自己的账户和资产。

#figure(
  image("selfpage.png"),
  caption: "个人中心页面"
)

=== 设置页面

设置页面允许用户自定义系统主题、管理通知偏好、修改密码等。

#figure(
  image("my_setting.png"),
  caption: "设置页面"
)

=== 创建分类页面

创建分类页面允许管理员创建新的产品分类，用于管理金融产品。

#figure(
  image("create_category_page.png"),
  caption: "创建分类页面"
)

=== 管理员用户管理

管理员可以管理系统中的用户，包括查看用户列表、封禁/解封用户等操作。

#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [*用户管理*], [*封禁用户*],
    image("manage_user.png"),
    image("block_user.png"),
  ),
  caption: "管理员用户管理"
)

=== 管理员内容审核

管理员可以审核社区中的帖子，确保内容符合规范。

#figure(
  image("examine_center.png"),
  caption: "内容审核中心"
)

=== 社区帖子举报

用户可以举报违规帖子，管理员会收到举报并进行处理。

#figure(
  image("report_post.png"),
  caption: "帖子举报"
)

=== 管理员统计分析

系统提供统计分析功能，管理员可以查看系统的各项统计数据。

#figure(
  image("statistics_analysis.png"),
  caption: "统计分析"
)

=== API文档界面

系统提供完整的API文档，基于Swagger UI实现。并为swagger集成了javascript脚本，使其支持JWT认证。方便开发者了解和使用系统的API接口。

#figure(
  image("swagger_ui.png"),
  caption: "Swagger UI界面"
)

= 总结与体会
== 总结
Southern Money系统是一个集金融交易、产品展示、社区交流于一体的综合性金融服务平台。系统采用前后端分离架构，后端基于ASP.NET Core Web API构建，前端使用Flutter框架开发，支持跨平台运行。

系统实现了以下核心功能：
- 用户认证和管理
- 金融产品浏览和购买
- 社区交流和内容管理
- 通知中心和消息推送
- 管理员后台管理

系统具有以下特点：
- 现代化的UI设计，支持亮色和暗色主题
- 响应式布局，适配不同屏幕尺寸
- 安全可靠的身份认证机制
- 高性能的API服务
- 完整的错误处理和日志记录
- 良好的可扩展性和维护性

== 体会
通过开发Southern Money系统，我们学到了以下经验和体会：

1. 前后端分离架构的优势：
   - 提高了开发效率，前后端可以并行开发
   - 增强了系统的可扩展性，便于后续功能扩展
   - 提高了系统的可维护性，便于代码管理和测试

2. 跨平台开发的便利性：
   - 使用Flutter框架可以快速开发跨平台应用
   - 减少了开发成本，提高了开发效率
   - 便于应用的推广和使用

3. 安全性设计的重要性：
   - 系统需要考虑各种安全风险，如身份认证、授权、输入验证等
   - 采用JWT令牌认证机制可以提高系统的安全性
   - 实现了完整的错误处理和日志记录，便于系统监控和调试

= 小组分工
== 分工详情

#figure(
  three-line-table[
    | 成员 | 主要负责模块 | 工作量占比 |
    |------|--------------|------------|
    | #u57u  | 系统架构 | 40% |
    | #yyw  | - | % |
    | #lpj  | - | % |
    | #hr  | - | % |
  ],
  kind: table,
  caption: "小组分工"
)

为使分工更清晰，补充说明各成员的代表性工作如下：

#figure(
  tablem[
    | 成员 | 主要负责模块 | 具体工作内容示例 |
    |------|--------------|------------------|
    | #u57u  | 前后端框架、系统架构 | 前后端框架的搭建，实现依赖注入，分层设计，ORM模型，Web API设计 |
    | #yyw  | - | - |
    | #lpj  | - | - |
    | #hr  | - | - |
  ],
  kind: table,
  caption: "分工详情说明"
)

== 分工说明
- 小A：负责ASP.NET Core项目的整体架构设计、控制器与服务层编写、认证/授权中间件、数据库迁移脚本及默认数据初始化等工作。
- 小B：负责Flutter界面设计与实现、页面导航与响应式布局、与后端接口的对接、主要业务流程（发帖、购买、社区交互等）的前端实现与联调。
- 小C：负责数据库表结构与ER模型设计、测试用例设计与执行、性能与兼容性测试、项目文档与本报告撰写整理工作。

通过小组协作，我们成功完成了Southern Money系统的开发。在开发过程中，我们遇到了各种挑战和问题，但通过团队合作和技术学习，我们成功解决了这些问题，提高了系统的质量和性能。

未来，我们将继续优化和扩展系统功能，提高系统的安全性和可靠性，为用户提供更好的服务和体验。

