#import "templates/cs-template.typ": *
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/mitex:0.2.6": *
#import "@preview/oxdraw:0.1.0": oxdraw
#import "@preview/tablem:0.3.0": tablem, three-line-table
#import "pages/data.typ": *
#show: setup-lovelace

#let algorithm = algorithm.with(supplement: "算法")


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
  abstract_zh: "在互联网金融快速发展的背景下，为解决金融产品信息分散、交易管理不便及用户互动不足等问题，本文设计并实现了一个集金融产品展示、交易管理与社区交流于一体的综合性金融服务平台——Southern Money 系统。系统采用前后端分离架构，后端基于 ASP.NET Core Web API 构建，前端使用 Flutter 框架实现跨平台开发，支持多终端运行；在数据层面结合 SQLite 与 PostgreSQL 数据库，在安全性方面引入 JWT 认证与权限控制机制。系统实现了用户管理、金融产品交易、社区互动、通知中心及管理员后台等功能，并通过功能、性能、兼容性和安全性测试验证了系统的稳定性与可行性，能够为用户提供安全、便捷且统一的金融服务体验。",
  keywords_zh: ("互联网金融", "数据库", "ASP.NET Core", "Flutter", "JWT 认证"),
  users: u57u + ", " + yyw + ", " + lpj + ", " + hr,
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
  caption: "技术栈选择",
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
#oxdraw(
  "
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
",
)

系统设计如下

#oxdraw(
  "
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
",
)

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
  caption: "响应式布局设计",
)

采用HTTP2库实现高效HTTP请求处理和拦截器机制，简化了认证流程，并实现JWT令牌自动管理与刷新机制，确保持续安全访问
#oxdraw(
  "
graph LR
    Request[发起HTTP请求]-->Interceptor[拦截器：添加访问令牌]
    Interceptor-->Remote[远程资源]
    Remote-->Expire{令牌过期错误？}
    Expire-->|是|TokenRefresh[刷新令牌]
    TokenRefresh-->RefreshResult{刷新成功？}
    RefreshResult-->|成功|Remote
    RefreshResult-->|失败|ErrorHandler[错误处理]
    Expire-->|否|Response[正常响应]
",
)
设计了这些页面，下图描述了这些页面的切换关系：
#oxdraw(
  "
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
",
)
运用依赖注入容器管理应用依赖，实现模块解耦。遵循SOLID原则中的单一职责和依赖倒置，提高系统的可维护性、可测试性和扩展性。
下图依赖关系：
#oxdraw(
  "
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

",
)

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
  #oxdraw(
    "
     graph LR
         A[接收API请求] --> D{令牌正确?}
         D -->|否| E[继续处理请求，但无用户信息]
         D -->|是| G[提取token]
         G --> H[验证token有效性]
         H -->|无效| E
         H -->|有效| I[获取用户ID和角色信息]
         I --> J[将用户信息存储在HttpContext中]
         J --> K[继续处理请求]
     ",
  )
- 授权流程图：
  #oxdraw(
    "
     graph LR
         A[控制器方法开始执行] --> B{是否需要授权?}
         B -->|否| C[继续执行方法逻辑]
         B -->|是| D{HttpContext中是否包含User信息?}
         D -->|否| E[返回401 Unauthorized]
         D -->|是| F{获取用户角色}
         F --> G{用户是否具有所需角色?}
         G -->|否| H[返回403 Forbidden]
         G -->|是| C
     ",
  )
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
#figure(
  tablem[
    | 功能 | 具体描述 |
    |------|----------|
    | 用户注册、登录、密码修改 | 用户可以通过手机号或邮箱注册账号，支持密码登录，后续可修改密码 |
    | 个人信息编辑 | 用户可以编辑头像、昵称等个人信息，支持头像上传和预览 |
    | 开户功能 | 用户可以选择开通金融账户，完成实名认证和风险评估 |
    | 查看个人资产和交易记录 | 用户可以查看当前资产余额、历史交易记录、收益情况等 |
  ],
  kind: table,
  caption: "用户管理功能列表",
)

2. 金融产品：
#figure(
  tablem[
    | 功能 | 具体描述 |
    |------|----------|
    | 浏览金融产品列表 | 用户可以在市场页面浏览所有可购买的金融产品，支持滑动查看 |
    | 按分类查看金融产品 | 产品按类型分类（如CSGO饰品、虚拟货币等），用户可快速筛选 |
    | 搜索金融产品 | 支持按名称、价格范围等条件搜索产品，快速定位目标商品 |
    | 收藏感兴趣的产品分类 | 用户可以收藏感兴趣的分类，方便下次快速访问 |
    | 购买金融产品 | 用户可以选择产品、数量，确认后完成购买，自动生成交易记录 |
    | 查看交易记录 | 用户可以查看历史购买记录，包括购买时间、价格、数量等信息 |
  ],
  kind: table,
  caption: "金融产品功能列表",
)

3. 社区交流：
#figure(
  tablem[
    | 功能 | 具体描述 |
    |------|----------|
    | 浏览社区帖子 | 用户可以浏览其他用户发布的帖子，支持按最新、热门等排序 |
    | 发布帖子 | 支持发布文字、图片内容，支持添加话题标签 |
    | 点赞、收藏帖子 | 用户可以对喜欢的帖子点赞或收藏，便于后续查看 |
    | 评论帖子 | 用户可以在帖子下方发表评论，支持多级回复 |
    | 搜索帖子 | 支持按关键词搜索帖子，快速找到感兴趣的内容 |
    | 查看个人发布的帖子 | 用户可以管理自己发布的所有帖子，支持编辑和删除 |
    | 查看个人收藏的帖子 | 用户可以查看所有收藏的帖子，快速访问感兴趣的内容 |
  ],
  kind: table,
  caption: "社区交流功能列表",
)

4. 通知中心：
#figure(
  tablem[
    | 功能 | 具体描述 |
    |------|----------|
    | 查看系统通知 | 用户可以接收系统推送的通知消息，了解最新动态 |
    | 标记已读通知 | 用户可以标记已读通知，避免重复查看 |
  ],
  kind: table,
  caption: "通知中心功能列表",
)

== 管理员需求
1. 用户管理：
#figure(
  tablem[
    | 功能 | 具体描述 |
    |------|----------|
    | 查看用户列表 | 管理员可以查看所有注册用户的列表，支持搜索和筛选 |
    | 封禁/解封用户 | 管理员可以对违规用户进行封禁或解封操作 |
    | 查看用户详细信息 | 管理员可以查看用户的详细信息，包括资产、交易记录等 |
  ],
  kind: table,
  caption: "管理员用户管理功能列表",
)

2. 内容管理：
#figure(
  tablem[
    | 功能 | 具体描述 |
    |------|----------|
    | 审核社区帖子 | 管理员可以查看被举报的帖子，进行审核处理 |
    | 删除违规帖子 | 管理员可以删除违规或不当内容，维护社区秩序 |
    | 管理帖子分类 | 管理员可以添加、编辑、删除帖子分类 |
  ],
  kind: table,
  caption: "管理员内容管理功能列表",
)

3. 系统管理：
#figure(
  tablem[
    | 功能 | 具体描述 |
    |------|----------|
    | 查看系统统计数据 | 管理员可以查看用户数、交易额、帖子数等统计数据 |
    | 管理系统配置 | 管理员可以修改系统配置参数，如开关、功能限制等 |
    | 处理用户举报 | 管理员可以处理用户提交的其他用户或内容的举报 |
  ],
  kind: table,
  caption: "管理员系统管理功能列表",
)

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
  caption: "需求与实现对应关系",
)

== 系统功能模块图
#oxdraw(
  "graph TD
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
",
)

= 详细设计
== UI 设计
=== 整体风格
界面整体采用符合 Material Design 3 (Material You) 规范的现代化设计语言。设计目标旨在为金融应用构建兼具专业感、安全感与个性化的视觉体验。通过清晰的视觉层次、一致的圆角与间距系统，以及克制的动效，引导用户聚焦于核心内容与操作，避免不必要的视觉干扰。系统全面支持亮色 (Light) 与暗色 (Dark) 主题模式，可依据用户偏好或系统设置自动切换。

=== 主题实现
主题系统是设计的核心，由 Color Seed（颜色种子） 驱动。用户可从预置色板或通过拾色器选择任一颜色作为种子色，提供三种选择模式（Block、Material、Advanced）。底层算法（基于 Material 3 色彩规范）将以此种子色为源，动态生成一套包含 primary, secondary, tertiary, error, neutral, neutral-variant 等完整色调的、和谐且具备足够对比度的调色板。

此调色板将自动应用于所有 Material 组件（如 AppBar, Button, Card, Dialog）及自定义组件，确保全局色彩的一致性。通过 Flutter 的 `ThemeData` (特别是 `useMaterial3: true` 与 `colorSchemeSeed`) 进行统一管理，并配合 `ValueNotifier` 状态管理和依赖注入（`getIt`）实现主题色的动态实时切换。配置数据（包括主题色、动画时间等）通过 `SharedPreferences` 持久化存储，确保用户偏好的一致性。

=== 响应式布局
为适配手机、平板及折叠屏等多种设备，采用了分层的响应式策略：
1. 基础适配：使用 `MediaQuery` 获取屏幕尺寸、像素密度和安全区域，配合 `LayoutBuilder` 实现基于父容器约束的流体布局。
2. 横竖屏自适应：主屏幕 `MainScreen` 实现了完整的横竖屏适配
  - 竖屏模式：采用 `NavigationBar`（底部导航栏）配合 `PageView` 管理页面切换
  - 横屏模式：自动切换为 `NavigationRail`（左侧导航栏），与内容区域并排布局
3. 页面状态保持：关键页面（如首页）使用 `AutomaticKeepAliveClientMixin` 实现页面状态持久化，提升用户体验
4. 组件适配：关键组件（如产品卡片、帖子列表）具备自适应能力，其内部信息密度与排列方式会根据可用空间动态调整。

=== 主要页面设计
- 登录/注册页面：采用分层设计，包含 `BrandHeader` 组件（渐变背景+圆形logo）和简洁表单。通过 `FilledButton` 与 `OutlinedButton` 区分主次操作，并利用 `InputDecoration` 的现代样式提升输入体验。登录后通过 `PageView` 平滑过渡至首页。

- 首页 (Home)：采用模块化设计，包含快速导航和发现模块。使用 `SingleChildScrollView` 实现垂直滚动，页面状态通过 `AutomaticKeepAliveClientMixin` 持久化。热门内容通过自定义 `PostCard` 组件展示，支持下拉刷新。

- 市场页面 (Market)：采用网格 (`GridView`) 与列表 (`ListView`) 混合布局。顶部提供分类筛选器（`FilterChip`），商品卡片清晰展示价格、收益率与风险等级图标，点击卡片通过 `PageView` 过渡至详情页。

- 社区页面 (Community)：核心为帖子时间线。每个帖子项 (`PostCard`) 包含作者头像、内容预览、互动按钮（点赞、评论、收藏）。支持富文本与多图展示 (`PageView`)。

- 个人中心 (Profile)：通过底部导航栏入口访问。页面分为信息头（展示头像与昵称）、资产卡片、功能列表（设置、收藏、历史记录）等区域。设置项中提供主题选择器页面 `ChangeThemeColorPage`，允许用户实时预览并切换 Color Seed。

- 主题设置页面：提供三种颜色选择模式（Block、Material、Advanced），支持实时预览主题色效果，通过 `ValueNotifier` 实现主题色的动态切换与持久化存储。

=== 自定义组件与配置管理

==== 自定义组件
为确保UI风格的一致性和开发效率，系统实现了一系列自定义组件：
- `BasicCard`：基础卡片组件，包含圆角、阴影和背景色
- `commonCard`：带标题和图标的卡片组件，用于信息展示
- `PostCard`：帖子卡片组件，展示帖子内容、作者信息和互动按钮
- `BrandHeader`：品牌头部组件，包含渐变背景和圆形logo

==== 配置管理
系统通过 `AppConfigService` 统一管理应用配置，包括：
- 主题色配置：通过 `SharedPreferences` 持久化存储，支持动态切换
- 动画时间配置：可调整应用内动画过渡时长
- API基础URL配置：支持动态切换后端服务地址
- 会话管理：统一管理JWT令牌，实现自动登录和登出

配置变更通过 `ValueNotifier` 实现实时响应，确保UI元素及时更新。所有配置项均可在应用内通过设置页面进行调整。

== 数据库设计
=== ER图设计

由于这个项目比较复杂，表与表之间的关系难以通过陈氏ER图展示，因此改作乌鸦脚图(crown-foot)描述数据库的实体关系图。

在乌鸦脚ER图里：实体用矩形框表示，关系用连接线表示。其中，单条短竖线“|”代表“一”，三叉的“乌鸦脚”（}）代表“多”，小圆圈“o”则表示“可选”（零）。这些符号的组合明确定义了关系的基数：例如“
”对“} ”表示经典的一对多关系，“} ”对“}
”表示多对多关系。

除开联结表，整个系统中的实体使用了10个表。由于属性过于复杂，这里显示了两个ER图，一个是简化版，一个是详细版：
#figure(
  image("./er-simple.png"),
  caption: "系统实体关系图",
)

本系统ER图以用户（User） 为核心实体构建数据模型，完整定义了业务关系：在内容社区层面，一个用户可以发布多篇帖子（Post），一篇帖子仅属于一个发布者，同时帖子可被多个用户收藏（PostFavorite），并可包含多张图片（PostImage，多对多）及关联多个标签（PostTag，多对多），而内容管理通过封禁记录（PostBlock）关联管理员与被封帖子；在电商层面，用户可以上传多个商品（Product），商品必须属于一个分类（ProductCategory），而用户可以收藏多个商品分类（UserFavoriteCategory，多对多），交易记录（TransactionRecord）则唯一关联购买者与所购商品；此外，用户还拥有一对一或一对多的附属关系，包括头像图片、个人资产（UserAsset）、系统通知（Notification），以及作为上传者与图片（Image）的关系。商品分类与封面图片、帖子封禁与操作者等管理性关系也被明确限定。

更详细的ER图如下，其还包括了实体的各种属性：

#figure(
  image("./er.jpg"),
  caption: "系统实体关系图(详细)",
)

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
  caption: "数据库表结构",
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
  caption: "数据库数据样例",
)

=== 用户注册流程
#oxdraw(
  "
graph LR
    A[用户填写注册信息] --> B[前端验证]
    B -->|验证通过| C[发送注册请求]
    C --> D[后端验证]
    D -->|验证通过| E[创建用户]
    E --> F[返回成功]
    D -->|验证失败| G[返回错误]
    B -->|验证失败| H[提示错误]
",
)

=== 用户登录流程
#oxdraw(
  "
graph LR
    A[用户填写登录信息] --> B[前端验证]
    B -->|验证通过| C[发送登录请求]
    C --> D[后端验证]
    D -->|验证通过| E[生成JWT令牌]
    E --> F[返回令牌]
    D -->|验证失败| G[返回错误]
    B -->|验证失败| H[提示错误]
",
)

=== 产品购买流程
#oxdraw(
  "
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
",
)

=== 帖子发布流程
#oxdraw(
  "
graph LR
    A[用户填写帖子内容] --> B[前端验证]
    B -->|验证通过| C[发送发布请求]
    C --> D[后端验证]
    D -->|验证通过| E[保存帖子]
    E --> F[返回成功]
    D -->|验证失败| G[返回错误]
    B -->|验证失败| H[提示错误]
",
)

=== 帖子审核流程
#oxdraw(
  "
graph LR
    A[用户发布帖子] --> B[帖子上线]
    B --> C[用户浏览帖子]
    C -->|发现违规内容| D[用户举报帖子]
    D --> E[系统记录举报信息]
    E --> F[帖子举报计数+1]
    F --> G[管理员查看举报列表<br/>(/admin/reportedPosts)]
    G --> H[管理员审核帖子内容]
    H --> I{审核结果?}
    I -->|通过| J[保持帖子上线]
    I -->|不通过| K[封禁帖子<br/>(/admin/handleReport)]
    K --> L[系统记录封禁信息<br/>(PostBlocks表)]
    L --> M[通知帖子作者]
    J --> N[更新举报状态]
    N --> O[结束]
    M --> O
",
)

=== 用户资产更新流程
#oxdraw(
  "
graph LR
    A[用户资产触发事件] --> B{事件类型?}
    B -->|充值| C[用户发起充值请求<br/>(/user/topup)]
    B -->|购买产品| D[用户购买产品<br/>(/transaction/buy)]
    B -->|收益计算| E[系统定时计算收益]

    C --> F[系统处理充值]
    F --> G[更新用户余额]

    D --> H[系统验证余额]
    H -->|余额充足| I[处理交易]
    H -->|余额不足| J[交易失败]
    I --> K[扣除产品费用]
    K --> L[生成交易记录]

    E --> M[计算用户收益]
    M --> N[更新收益数据]

    G --> O[更新UserAsset表]
    L --> O
    N --> O
    O --> P[返回最新资产数据]
    J --> Q[返回错误信息]
",
)

=== 通知发送流程
#oxdraw(
  "
graph LR
    A[触发通知事件] --> B{事件类型?}
    B -->|交易事件| C[交易完成]
    B -->|系统事件| D[系统公告]
    B -->|审核事件| E[内容审核结果]
    B -->|其他事件| F[其他通知]

    C --> G[创建通知记录]
    D --> G
    E --> G
    F --> G

    G --> H[保存到Notifications表]
    H --> I[推送通知]
    I --> J{推送方式?}
    J -->|系统内| K[更新未读计数]
    J -->|其他方式| L[外部推送服务]

    K --> M[用户接收通知]
    L --> M
    M --> N[用户查看通知<br/>(/notification/my)]
    N --> O[标记通知已读<br/>(/notification/read)]
    O --> P[更新通知状态]
    P --> Q[结束]
",
)

=== 管理员处理用户流程
#oxdraw(
  "
graph LR
    A[管理员登录系统] --> B[进入管理后台]
    B --> C[查看用户列表<br/>(/admin/users)]
    C --> D[搜索/筛选用户]
    D --> E[查看用户详情<br/>(/admin/users/{userId})]
    E --> F{处理操作?}
    F -->|封禁/解封| G[处理用户状态<br/>(/admin/handleUser)]
    F -->|设置管理员| H[设置管理员权限<br/>(/admin/setAdmin)]
    F -->|返回列表| C

    G --> I[更新用户IsBlocked状态]
    I --> J[记录处理原因]

    H --> K[更新用户IsAdmin状态]

    J --> L[发送通知给用户]
    K --> L

    L --> M[返回操作结果]
    M --> N[结束]
",
)

=== 商品分类管理流程
#oxdraw(
  "
graph LR
    A[管理员登录系统] --> B[进入管理后台]
    B --> C[查看分类列表<br/>(/store/categories)]
    C --> D{分类操作?}
    D -->|创建分类| E[创建新分类<br/>(/store/category/create)]
    D -->|编辑分类| F[选择分类]
    D -->|删除分类| G[选择分类]
    D -->|查看分类商品| H[查看分类商品<br/>(/store/categories/{id}/products)]

    E --> I[填写分类信息]
    I --> J[上传分类封面]
    J --> K[保存分类数据]

    F --> L[修改分类信息]
    L --> K

    G --> M[确认删除]
    M --> N{是否有商品关联?}
    N -->|是| O[提示有商品关联]
    N -->|否| P[删除分类]

    K --> Q[更新分类列表]
    P --> Q
    O --> C

    Q --> R[返回操作结果]
    R --> S[结束]
    H --> T[返回商品列表]
    T --> S
",
)

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
  - 在 Android 设备、Windows 桌面和 Web 浏览器上分别运行应用，检查页面布局是否一致、功能是否完整。
  - 在横屏/竖屏、窄屏/宽屏设备上验证导航栏位置、弹窗/页面切换行为是否符合设计。

== 测试截图
=== 系统主题展示

系统支持亮色和暗色主题切换。且支持随这系统主题自动切换。

#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [*亮色主题*], [*暗色主题*],
    image("lightmode.png"), image("darkmode.png"),
  ),
  caption: "亮色和暗色主题",
)

除了内置的亮色与暗色主题之外，系统也支持自定义主题颜色，方便用户根据个人偏好自由选择。
值得一提的是，当用户选取自定义颜色后，系统会基于颜色种子（Color Seed）通过算法自动生成一套和谐的主题配色，从而在不同色彩下都能保持协调的视觉体验。
#figure(
  table(
    columns: 2,
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [绿色主题], [橙色主题],
    image("theme_green.png"), image("theme_orange.png"),
  ),
  caption: "自定义主题颜色",
)
=== 多平台兼容性展示

系统基于Flutter框架开发，支持多平台运行，包括Android、Web和Windows等平台，确保用户在不同设备上都能获得一致的使用体验。

#figure(
  table(
    columns: 3,
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [移动平台], [桌面平台], [Web平台],
    image("./devices/android.jpg"), image("./devices/windows.png"), image("./devices/web.png"),
  ),
  caption: "多平台兼容性展示",
)
=== 响应式设计

针对不同大小的屏幕设备，系统采用响应式设计，能够自动调整布局和元素大小，确保在不同屏幕尺寸下都能正常显示和操作。
#figure(
  table(
    columns: 2,
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [大屏幕], [小屏幕],
    image("big-screen.png"), image("small-screen.png", width: 60%),
  ),
  caption: "响应式设计",
)
在大屏幕上，新页面会作为弹窗显示，而在小屏幕上则会作为独立页面展示。

=== 登录页面

登录页面支持用户名和密码登录，同时提供注册新用户功能。页面采用响应式设计，能够适配不同屏幕尺寸和方向。

#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: 0.7pt,
    align: horizon,
    [*登录页面-横屏*], [*登录页面-竖屏*],
    image("login_page_landscape.png"), image("login_page_portrait.png", height: 40%),
  ),
  caption: "登录页面",
)

=== 开户页面

开户页面为用户提供账户创建功能，用户可以填写必要信息完成开户流程，享受完整的金融服务。

#figure(
  image("open_account_page.png"),
  caption: "开户页面",
)

=== 未开户状态页面

未开户状态页面提示用户需要先开户才能使用完整的金融服务功能。

#figure(
  image("without_open_account.png"),
  caption: "未开户状态页面",
)

=== 首页

首页是用户进入系统后的主要界面，提供了各种金融产品的快捷入口和热门社区帖子展示。

#figure(
  image("home_page.png"),
  caption: "首页",
)

=== 市场页面

市场页面显示各类金融产品的分类和价格信息，用户可以浏览不同类别的产品，查看详情并进行交易。

#figure(
  image("market_page.png"),
  caption: "市场页面",
)

=== CSGO市场页面

CSGO市场页面展示各类CSGO饰品的分类和价格信息，用户可以浏览和购买。

#figure(
  image("csgo_market_page.png"),
  caption: "CSGO市场页面",
)

=== 虚拟货币页面

虚拟货币页面展示各类虚拟货币的价格和趋势信息，用户可以浏览和购买。

#figure(
  image("virtual_money_page.png"),
  caption: "虚拟货币页面",
)

=== 购买页面

购买页面允许用户查看产品详情并进行购买操作。

#figure(
  image("buy_page.png"),
  caption: "购买页面",
)

=== 充值页面

充值页面允许用户向自己的账户充值资金，用于购买金融产品。

#figure(
  image("adding_money.png"),
  caption: "充值页面",
)

=== 收益页面

收益页面展示用户的资产收益情况，包括今日收益、累计收益和收益率等信息。

#figure(
  image("my_yield.png"),
  caption: "收益页面",
)

=== 我收藏的产品页面

我收藏的产品页面展示用户收藏的所有产品，方便用户快速访问感兴趣的金融产品。

#figure(
  image("my_star_product.png"),
  caption: "我收藏的产品页面",
)

=== 我的交易页面

我的交易页面展示用户的所有交易记录，包括购买的产品、交易时间和金额等信息。

#figure(
  image("my_transaction.png"),
  caption: "我的交易页面",
)

=== 社区页面

社区页面展示用户发布的帖子列表，支持帖子浏览、搜索和筛选功能。用户可以查看热门帖子，也可以发布自己的内容。

#figure(
  image("neighborhood_page.png"),
  caption: "社区页面",
)

=== 帖子详情页面

帖子详情页面展示完整的帖子内容，包括文字、图片、评论等信息。

#figure(
  image("post_detail.png"),
  caption: "帖子详情页面",
)

=== 我的帖子页面

我的帖子页面展示用户自己发布的所有帖子，方便用户管理和查看。

#figure(
  image("my_post.png"),
  caption: "我的帖子页面",
)

=== 用户帖子页面

用户帖子页面展示用户自己发布的帖子内容，方便用户管理和查看自己的社区贡献。

#figure(
  image("post_page_by_user.png"),
  caption: "用户帖子页面",
)

=== 我收藏的帖子页面

我收藏的帖子页面展示用户收藏的所有帖子，方便用户快速访问感兴趣的内容。

#figure(
  image("my_star_post.png"),
  caption: "我收藏的帖子页面",
)

=== 我的消息页面

我的消息页面展示系统发送给用户的通知和消息，包括系统通知、活动通知等。

#figure(
  image("my_message.png"),
  caption: "我的消息页面",
)

=== 个人中心页面

个人中心页面展示用户的个人信息和各种功能入口，方便用户管理自己的账户和资产。

#figure(
  image("selfpage.png"),
  caption: "个人中心页面",
)

=== 设置页面

设置页面是应用的核心配置中心，允许用户自定义系统行为和偏好设置。基于实际代码实现，设置页面包含以下功能模块：

#let t1 = table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  [*功能名称*], [*功能描述*],
  [主题颜色设置], [允许用户自定义应用主题色，通过取色算法生成主题颜色，并持久化保存],
  [动画时长设置], [允许用户调整应用内动画过渡的时长，通过调用 `SettingDuration` 组件实现],
  [API地址设置],
  [动态配置后端服务地址，支持实时切换API环境，通过调用 `SetApiUrlPage` 组件并使用 `ValueNotifier` 实现配置变更的实时响应],

  [关于我们], [展示应用的基本信息、开发者信息和版权声明，通过调用 `AboutUsPage` 组件实现],
  [测试页面], [提供开发调试工具和测试功能，用于内部测试和问题排查，通过调用 `DebugPage` 组件实现],
  [清除全部数据],
  [清除所有应用数据（包括主题设置、API配置等），操作前显示确认对话框，通过 `appConfigService.clearAllData()` 实现],

  [退出登录],
  [清除JWT令牌和用户会话信息，返回登录页面，操作前显示确认对话框，通过 `appConfigService.tokenService.clearTokens()` 实现],

  [版本信息], [显示当前应用版本号，点击可查看详细版本信息，版本信息由 `VersionService` 管理],
)

#figure(t1, caption: "设置页面功能模块")


#figure(
  image("my_setting.png"),
  caption: "设置页面",
)

=== 创建分类页面

创建分类页面允许管理员创建新的产品分类，用于管理金融产品。

#figure(
  image("create_category_page.png"),
  caption: "创建分类页面",
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
    image("manage_user.png"), image("block_user.png"),
  ),
  caption: "管理员用户管理",
)

=== 管理员内容审核

管理员可以审核社区中的帖子，确保内容符合规范。

#figure(
  image("examine_center.png"),
  caption: "内容审核中心",
)

=== 社区帖子举报

用户可以举报违规帖子，管理员会收到举报并进行处理。

#figure(
  image("report_post.png"),
  caption: "帖子举报",
)

=== 管理员统计分析

系统提供统计分析功能，管理员可以查看系统的各项统计数据。

#figure(
  image("statistics_analysis.png"),
  caption: "统计分析",
)

=== API文档界面

系统提供完整的API文档，基于Swagger UI实现。并为swagger集成了javascript脚本，使其支持JWT认证。方便开发者了解和使用系统的API接口。

#figure(
  image("swagger_ui.png"),
  caption: "Swagger UI界面",
)

=== 后端压测

为了评估系统的性能和稳定性，我们进行了后端压测。测试环境模拟了1000个并发用户，对系统的API接口进行了压力测试。测试结果显示，系统在高并发下能够正常运行，响应时间在毫秒级。

#figure(
  image("./api-test.png"),
  caption: "后端压测结果",
)

#figure(
  image("./load-test.png"),
  caption: "负载测试结果",
)
该图展示了通过 JMeter 工具对南方财富软件（Southern Money 系统）进行 HTTP 请求性能测试后的汇总报告界面。测试共执行 1000 次 HTTP 请求样本，结果显示：异常率仅 0.30%；系统吞吐率达 45.5 次 / 秒，接收与发送数据速率分别为 14.93KB/sec、30.12KB/sec。

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
    | #u57u  | 系统整体架构 | 40% |
    | #yyw  | - | % |
    | #lpj  | - | % |
    | #hr  | - | % |
  ],
  kind: table,
  caption: "小组分工",
)

为使分工更清晰，补充说明各成员的代表性工作如下：

#figure(
  tablem[
    | 成员 | 主要负责模块 | 具体工作内容示例 |
    |------|--------------|------------------|
    | #u57u  | 前后端框架、系统架构 | 前后端框架的搭建，实现依赖注入，分层设计，ORM模型，Web API设计。实现整个系统的基础设施。 |
    | #yyw  | - | - |
    | #lpj  | - | - |
    | #hr  | - | - |
  ],
  kind: table,
  caption: "分工详情说明",
)

== 分工说明
- #u57u : 负责系统整体架构设计、控制器与服务层编写、认证/授权中间件、数据库迁移脚本及默认数据初始化等工作。
- #yyw  : -
- #lpj  : -
- #hr   : -


通过小组协作，我们成功完成了Southern Money系统的开发。在开发过程中，我们遇到了各种挑战和问题，但通过团队合作和技术学习，我们成功解决了这些问题，提高了系统的质量和性能。

未来，我们将继续优化和扩展系统功能，提高系统的安全性和可靠性，为用户提供更好的服务和体验。

