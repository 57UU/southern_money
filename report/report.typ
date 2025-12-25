#import "templates/cs-template.typ": *
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/mitex:0.2.6": *
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/tablem:0.3.0": tablem, three-line-table
#import "pages/data.typ": *
#import "@preview/oxdraw:0.1.0": *
#import "@preview/pintorita:0.1.4"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text, style: "default")

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
  major: "人工智能、计算机科学与技术",
  date: (2025, 12, 17),
  abstract_zh: "在互联网金融快速发展背景下，针对金融产品信息分散、交易管理不便及用户互动不足等问题，本文设计并实现了Southern Money系统，这是一个集金融产品展示、交易管理与社区交流于一体的综合性金融服务平台。系统采用前后端分离架构，后端基于ASP.NET Core Web API构建高性能服务，前端使用Flutter实现跨平台开发，支持多终端运行；数据层面结合SQLite与PostgreSQL数据库，安全性方面引入JWT认证与权限控制机制。系统实现了用户管理、金融产品交易、社区互动、通知中心及管理员后台等核心功能，并通过全面测试验证了稳定性与可行性，能够为用户提供安全、便捷且统一的金融服务体验。",
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

== 开发工具

#figure(
  three-line-table[
    | 类别 | 工具名称 | 用途 |
    |------|----------|------|
    | 后端开发工具 | Visual Studio 2026 / VS Code | 后端应用开发、调试和部署 |
    | 前端开发工具 | VS Code + Flutter插件 | 前端应用开发、热重载调试 |
    | 数据库管理工具 | pgAdmin 4 | PostgreSQL数据库管理和维护 |
    | API测试工具 | Postman | API接口测试和调试 |
    | 性能测试工具 | JMeter | 系统性能和负载测试 |
    | 版本控制工具 | Git | 代码版本管理和团队协作 |
    | 构建工具 | dotnet CLI, Flutter CLI | 项目构建、测试和部署 |
  ],
  kind: table,
  caption: "开发工具列表",
)

== 技术路线
Southern Money系统采用前后端分离的现代化架构设计，具体技术路线如下：

=== 后端架构

Southern Money系统后端采用分层架构设计，遵循单一职责原则和依赖倒置原则，实现了高度的模块化和可扩展性。后端架构主要包括以下几个核心部分：

==== 分层设计原则与职责边界

1. Controller层：
  Controller层作为系统的请求入口，负责处理HTTP请求、接收和验证请求参数，并调用Service层完成业务逻辑处理，然后格式化响应数据返回HTTP响应。该层不包含业务逻辑，仅负责请求路由和响应处理，确保了职责的单一性。例如，`UserController`专门处理用户注册、登录等请求。

2. Service层：
  Service层实现核心业务逻辑，处理复杂业务规则，协调多个Repository完成数据操作，并实现事务管理以确保数据一致性。该层还负责业务验证和权限检查，确保系统的安全性。例如，`UserService`实现了用户认证、密码加密等关键逻辑。

3. Repository层：
  Repository层负责数据访问操作，封装数据库操作细节，实现数据的CRUD（创建、读取、更新、删除）操作。该层不包含业务逻辑，仅处理数据持久化，基于Entity Framework Core实现，支持多种数据库。例如，`UserRepository`专门处理用户数据的存储和查询。

4. Domain层：
  Domain层定义核心业务实体和值对象，实现领域模型的业务规则和约束。该层不依赖任何外部框架，保持领域模型的纯净性。例如，`User`、`Product`、`Transaction`等实体类定义了系统的核心业务对象。

5. Infrastructure层：
  Infrastructure层提供基础设施支持，包括数据库配置、依赖注入、中间件等，并实现与外部系统的集成，如文件存储、邮件发送等。
  - 封装通用工具类和辅助方法
  - 示例：`JwtUtils`、`AppDbContext`等

==== 中间件实现细节

系统开发了多个自定义中间件组件，处理身份验证、异常处理、日志记录等横切关注点：

1. 身份验证中间件：
  - 拦截所有API请求，检查Authorization头中的JWT令牌
  - 验证令牌的有效性和过期时间
  - 解析令牌中的用户信息，存储到HttpContext中
  - 处理令牌刷新逻辑，自动更新过期令牌

2. 异常处理中间件：
  - 捕获系统中发生的所有未处理异常
  - 根据异常类型生成统一格式的错误响应
  - 隐藏敏感错误信息，防止信息泄露
  - 记录异常日志，便于系统监控和调试


3. CORS中间件：
  - 配置跨域资源共享策略，允许前端应用访问API
  - 支持多种域名和HTTP方法
  - 实现安全的跨域通信

==== 依赖注入配置

系统采用ASP.NET Core内置的依赖注入容器，实现组件之间的解耦和依赖管理：

在`Program.cs`中配置所有服务的依赖关系，支持不同生命周期的服务注册（单例、作用域、瞬时）
#sourcecode(```csharp
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddDbContext<AppDbContext>();
```)



==== 核心技术实现

- 基于ASP.NET Core Web API构建高性能RESTful API服务
- 采用Entity Framework Core实现高效数据库操作和ORM映射
- 集成JWT身份认证与授权机制，保障API安全访问
- 实现完整的事务管理，确保数据一致性
- 支持数据库迁移，便于系统升级和维护

==== 架构优势

该架构设计高度模块化，便于系统扩展和维护，同时通过清晰的职责边界降低组件之间的耦合度。这种设计便于进行单元测试和集成测试，支持横向扩展以提高系统的并发处理能力，并具有良好的安全性设计，有效保护系统和用户数据。

#let simplified_arch = diagram(
  node-stroke: .1em,
  spacing: 10pt,
  node-fill: blue.lighten(95%),
  node((0, 0), [HTTP请求], label: "Client", fill: green.lighten(95%)),
  node((1, 0), [Controller处理请求], label: "Controller", fill: orange.lighten(95%)),
  node((2, 0), [Service业务逻辑], label: "Service", fill: purple.lighten(95%)),
  node((3, 0), [Repo数据访问], label: "Repository", fill: red.lighten(95%)),
  node((4, 0), [数据库], label: "Database", shape: "rect", fill: gray.lighten(90%)),
  edge((0, 0), (1, 0), "->"),
  edge((1, 0), (2, 0), "->"),
  edge((2, 0), (3, 0), "->"),
  edge((3, 0), (4, 0), "->"),
)
#figure(simplified_arch, caption: "后端层次图")

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

Southern Money系统前端基于Flutter框架开发，采用现代化的架构设计，实现了跨平台支持、高效状态管理和响应式UI设计。

==== 核心架构设计

1. 跨平台支持：
  系统基于Flutter框架，一套代码可运行在Web、Android、iOS、Windows、macOS和Linux六大平台，采用Flutter的Widget系统实现高性能、跨平台的UI渲染，并支持原生插件集成，实现与平台特定功能的无缝对接。

2. 依赖注入设计：
  系统使用`get_it`作为依赖注入容器，集中管理应用级服务，统一管理`SharedPreferences`、`TokenService`及各类`ApiService`实例，降低页面之间的耦合度，提高代码的可测试性和可维护性，对应文件：`lib/setting/ensure_initialized.dart`。

3. 配置管理：
  系统通过`AppConfigService`统一管理应用配置，包括主题颜色、动画时长、后端`BaseUrl`和会话Token等，配合`ValueNotifier`实现轻量级响应式状态管理，配置变更实时更新UI，提升用户体验，对应文件：`lib/setting/app_config.dart`。

==== 状态管理机制

系统采用多种状态管理方案，根据不同场景选择合适的实现方式：

1. 轻量级状态管理：
  系统使用`ValueNotifier`和`ChangeNotifier`实现简单状态管理，适用于全局配置、主题设置等简单状态，并配合`Consumer`和`Provider`组件实现UI响应式更新。

2. 依赖注入 + 服务模式：
  系统通过`get_it`注册和获取服务实例，服务内部管理自身状态，通过回调或流通知UI更新，适用于复杂业务逻辑和跨页面状态共享。

3. 页面级状态管理：
  系统使用`StatefulWidget`的`setState()`方法管理页面内部状态，适用于单个页面内部的状态变化，并配合`AutomaticKeepAliveClientMixin`实现页面状态持久化。

==== 路由管理机制

系统实现了灵活的路由管理机制，支持不同设备尺寸和方向的自适应：

1. 核心路由结构：
  系统基于Flutter的`Navigator`组件实现页面导航，主路由包括登录页、注册页、主屏幕，子路由涵盖各功能模块页面。

2. 响应式路由策略：
  系统借助`popupOrNavigate`与`Fragment`组件实现响应式路由，横屏时优先使用弹窗展示子页面，提升大屏设备的多任务体验，竖屏时使用标准路由切换新页面，保持移动端的操作习惯，对应文件：`lib/widgets/router_utils.dart`。

3. 路由导航模式：
  系统提供多种导航方式，底部导航栏（竖屏）包括`HomePage`、`CommunityPage`、`MarketPage`、`ProfilePage`，左侧导航栏（横屏）与底部导航栏功能一致，布局适配大屏，模态弹窗用于显示临时信息或简单表单，抽屉菜单用于个人中心和设置页面的导航。

==== 网络请求处理

系统实现了强大的网络请求处理机制，确保API调用的安全性和可靠性：

#figure(
  three-line-table[
    | 处理机制 | 具体说明 |
    | 网络层架构 | 基于`Dio`库实现HTTP请求，封装`JwtDio`类，集成JWT认证机制，实现自定义`JwtInterceptor`，自动处理令牌管理，对应文件：`lib/webapi/JwtService.dart`及各`api_xxx.dart` |
    | 认证流程处理 | 在拦截器中自动附加`Authorization`头，处理401错误，自动尝试刷新令牌，刷新失败时跳转至登录页面，简化前端对认证细节的处理，提高开发效率 |
    | 统一响应处理 | 封装统一的API响应格式，自动解析响应数据，转换为实体类，统一处理错误信息，提供友好的用户提示 |
  ],
  kind: table,
  caption: "网络请求处理机制",
)

==== 响应式UI设计

系统实施了全面的响应式UI设计，自动适配不同屏幕尺寸和设备类型：

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

系统通过 MediaQuery 与 LayoutBuilder 实现流体布局，关键组件依可用空间自动调整信息密度与样式，并针对移动、桌面、Web 三端分别优化触控、键鼠及加载体验，完成全场景响应式适配。

==== 组件设计原则

系统实现了一系列自定义组件，遵循以下设计原则：

#figure(
  three-line-table[
    | 设计原则 | 具体说明 |
    | 单一职责原则 | 每个组件只负责一个特定功能，降低组件复杂度，提高可维护性 |
    | 可复用性 | 设计通用组件，支持多种场景使用，提供灵活的配置选项，适应不同需求，示例：`BasicCard`、`PostCard`、`BrandHeader`等 |
    | 主题一致性 | 所有组件遵循统一的主题设计，支持主题色动态切换，保持UI一致性，基于Material Design 3规范实现 |
  ],
  kind: table,
  caption: "组件设计原则",
)

==== 页面结构设计

前端页面结构围绕`main.dart`中的`MainScreen`搭建：

1. 核心页面：
  - `HomePage`（首页）：展示热门内容和快速导航
  - `CommunityPage`（社区）：帖子浏览、发布和互动
  - `MarketPage`（行情）：金融产品展示和交易
  - `ProfilePage`（个人中心）：用户信息和功能入口

2. 页面状态管理：
  - 关键页面使用`AutomaticKeepAliveClientMixin`实现状态持久化
  - 避免页面切换时重新加载数据，提高用户体验
  - 支持下拉刷新和上拉加载更多功能

==== 性能优化策略

系统采用多种性能优化策略，确保应用流畅运行：

#figure(
  table(
    columns: 2,
    stroke: 0.5pt + gray,
    [*优化类别*], [*具体措施*],
    [UI渲染优化],
    [使用`const`构造函数创建不可变组件\ 避免不必要的重建和重绘\ 优化列表渲染，使用`ListView.builder`实现懒加载],

    [网络请求优化],
    [实现请求缓存，减少重复请求\ 支持请求取消，避免无用请求消耗资源\ 优化图片加载，支持缩略图和渐进式加载],

    [内存管理], [及时释放不再使用的资源\ 优化大对象的创建和销毁\ 使用`WeakReference`避免内存泄漏],
    [启动性能优化],
    [实现懒加载，延迟初始化非关键组件\ 优化资源加载顺序，优先加载核心功能\ 支持预加载，提前获取常用数据],
  ),
  kind: table,
  caption: "性能优化策略",
)

==== 代码组织规范

系统遵循清晰的代码组织规范，按功能模块分层组织，UI、业务与数据分离，并集中管理图片字体等资源。提高代码的可维护性和可读性。


下图展示了客户端的请求API抽象层设计，该层实现了智能的令牌管理和错误处理机制。系统采用HTTP请求的拦截器架构，在`JwtInterceptor`中自动处理所有认证相关逻辑，包括：在每次请求前自动附加Bearer令牌到Authorization请求头；当服务器返回401未授权错误时，自动触发令牌刷新流程；使用refresh token获取新的访问令牌对；刷新成功后自动重试原始请求，对业务代码完全透明；刷新失败时触发登录页面跳转，引导用户重新认证。此外，拦截器还实现了请求队列机制，当多个请求同时遇到令牌过期时，只执行一次刷新操作，其他请求排队等待，避免并发刷新导致的资源浪费。


#let graph_client_api = diagram(
  spacing: 2em,
  node-stroke: .1em,
  edge-stroke: .1em,
  node-fill: blue.lighten(95%),
  node((0, 0), [发起HTTP请求], label: "Request"),
  node((0, 1), [拦截器：添加访问令牌], label: "Interceptor", fill: orange.lighten(95%)),
  node((0, 2), [访问远程资源], label: "Remote", fill: purple.lighten(95%)),
  node((0, 3), [令牌过期错误？], label: "Expire", shape: shapes.diamond, fill: red.lighten(95%)),
  node((0, 4), [正常响应], label: "Response", fill: olive.lighten(95%)),
  node((1, 4), [刷新令牌], label: "TokenRefresh", fill: green.lighten(95%)),
  node((1, 5), [刷新成功？], label: "RefreshResult", shape: shapes.diamond, fill: teal.lighten(95%)),
  node((1, 6), [错误处理], label: "ErrorHandler", fill: gray.lighten(90%)),
  edge((0, 0), (0, 1), "->"),
  edge((0, 1), (0, 2), "->"),
  edge((0, 2), (0, 3), [], "->"),
  edge((0, 3), (0, 4), [否], "->", stroke: green),
  edge((0, 3), "r,d", [是], "->", label-pos: .5, stroke: red),
  edge((1, 4), (1, 5), "->"),
  edge((1, 5), "r,r,u,u,u,l,l,l", [成功], "->", label-pos: .8, stroke: green),
  edge((1, 5), (1, 6), [失败], "->", label-pos: .5, stroke: red),
)

#figure(
  graph_client_api,
  caption: "请求API抽象层设计",
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

Southern Money系统采用关系型数据库设计，支持SQLite和PostgreSQL两种数据库，实现了数据模型的规范化和高性能。

==== 数据库设计原则

1. 规范化设计：
  - 遵循数据库设计的第一、第二和第三范式
  - 减少数据冗余，提高数据一致性
  - 清晰的表结构和关系定义

2. 灵活性：
  - 基于Entity Framework Core Code First模式，便于数据库schema管理
  - 使用`dotnet ef`迁移命令实现自动化、可回滚的数据库迁移

3. 性能优化：
  - 合理的索引设计，提高查询效率
  - 针对高频查询优化表结构
  - 支持分区表和分库分表扩展

4. 数据完整性：
  - 完整的外键约束，确保数据一致性
  - 适当的字段约束（如非空、唯一、检查约束等）
  - 事务管理，确保数据操作的原子性、一致性、隔离性和持久性

==== 数据模型设计考虑

1. DateTime字段处理：
  - 所有`DateTime`字段统一使用UTC存储，避免跨时区显示误差
  - 在`AppDbContext`中通过`UtcDateTimeConverter`实现自动转换
  - 示例：
    ```csharp
    protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
    {
        configurationBuilder.Properties<DateTime>()
            .HaveConversion<UtcDateTimeConverter>();
    }
    ```

2. 多对多关系设计：
  - 对`PostFavorite`、`UserFavoriteCategory`等多对多关系表使用复合主键
  - 既防止重复记录，又提升常用查询性能
  - 示例：`PostFavorite`表使用`(PostId, UserId)`作为复合主键

3. 软删除实现：
  - 对核心实体实现软删除机制，通过`IsDeleted`字段标记
  - 避免数据永久丢失，便于数据恢复和审计
  - 在查询时自动过滤已删除的记录

4. 数据类型选择：
  - 选择合适的数据类型，优化存储空间和查询性能
  - 例如：使用`decimal`类型存储金额，避免精度丢失
  - 使用`varchar`类型存储可变长度字符串，节省空间

==== 索引优化策略

系统设计了合理的索引方案，提高查询效率和系统性能：

1. 主键索引：
  - 所有表都定义了主键，自动创建主键索引
  - 使用自增整数（`int`）作为主键，提高插入性能

2. 外键索引：
  - 为外键字段创建索引，提高关联查询性能
  - 例如：`Posts`表的`UploaderUserId`字段创建索引，优化"查询用户发布的帖子"查询

3. 复合索引：
  - 为频繁一起查询的字段组合创建复合索引
  - 例如：`TransactionRecords`表的`BuyerUserId`和`PurchaseTime`字段创建复合索引
  - 优化"查询用户最近交易记录"等常用查询

4. 唯一索引：
  - 为需要唯一约束的字段创建唯一索引
  - 例如：`Users`表的`Email`字段创建唯一索引，确保邮箱唯一性

5. 全文索引：
  - 为需要全文搜索的字段创建全文索引
  - 例如：`Posts`表的`Title`和`Content`字段创建全文索引
  - 优化帖子搜索功能的性能

==== 数据库安全设计

1. 数据加密：
  敏感数据（如用户密码）采用哈希加密存储，并使用强哈希算法（如SHA-256）并添加盐值

2. 访问控制：
  系统遵循最小权限原则，数据库用户仅拥有必要的权限，分离读写权限以提高安全性，并定期轮换数据库密码，降低安全风险。

3. 数据备份：
  系统定期备份数据库以防止数据丢失，支持增量备份和全量备份，备份数据存储在安全位置，防止未授权访问。

==== 数据库性能优化

1. 查询优化：
  系统避免全表扫描，使用索引覆盖查询，优化复杂查询并使用适当的连接方式，实现分页查询以避免一次性返回大量数据。

2. 缓存策略：
  系统实现查询结果缓存以减少数据库访问，并采用缓存过期策略确保数据一致性。

3. 连接池管理：
  系统使用数据库连接池以减少连接创建和销毁开销，优化连接池配置并根据系统负载调整，及时释放数据库连接以避免连接泄漏。

4. 分区表设计：
  系统对大表进行分区设计以提高查询和维护性能，例如按时间分区`TransactionRecords`表，便于数据归档和清理。

通过以上数据库设计，Southern Money系统实现了高性能、高可靠性和高安全性的数据存储和管理，支持系统的稳定运行和未来扩展。

=== 系统安全
- 采用密码哈希存储技术，保障用户密码安全
- 开发异常处理中间件，防止敏感信息泄露，提供友好错误提示

==== JWT 访问令牌
实施JWT令牌认证机制，确保API访问安全

JWT（JSON Web Token）是一种基于令牌的无状态认证机制，本系统采用JWT实现API的安全访问控制。

#figure(
  tablem[
    | 组成部分 | 说明 |
    |----------|------|
    | Header（头部） | 包含令牌类型和签名算法信息 |
    | Payload（载荷） | 包含用户ID、角色、过期时间等声明信息 |
    | Signature（签名） | 使用密钥对Header和Payload进行签名，确保令牌完整性 |
  ],
  kind: table,
  caption: "JWT令牌结构",
)


系统采用标准的JWT认证流程，具体设计逻辑如下：

1. 令牌生成：
  用户登录成功后，后端根据用户ID、角色、过期时间等信息生成JWT令牌，并使用密钥进行签名。令牌有效期设置比较短（24小时），平衡安全性和用户体验。
2. 令牌传递：
  前端在每次API请求的HTTP头中携带JWT令牌（Authorization: Bearer <token>），实现无状态的身份认证。令牌存储在客户端本地，避免每次请求都重新登录，同时也减少密码泄露风险。
3. 令牌验证：
  后端中间件拦截所有API请求，提取并验证JWT令牌的有效性。验证内容包括：签名完整性、令牌格式、过期时间等。验证通过后，将用户信息存储在HttpContext中，供后续业务逻辑使用。
4. 令牌刷新：
  为提升用户体验，系统实现令牌刷新机制。当访问令牌即将过期时，前端使用刷新令牌获取新的访问令牌，避免用户频繁登录。刷新令牌具有更长的有效期，但仅用于获取新的访问令牌，不能直接访问API。

JWT认证流程在设计中充分考虑了安全性：

1. 密钥管理：使用强密钥对JWT令牌进行签名，密钥存储在安全位置，防止密钥泄露。
2. 令牌过期：设置合理的令牌过期时间，避免令牌长期有效带来的安全风险。过期令牌自动失效，需要重新登录或刷新。

JWT认证流程在设计中兼顾了性能优化：

1. 无状态设计：JWT令牌本身包含所有必要信息，后端无需存储令牌状态，减少数据库查询（以往需要使用token池，其存储在数据库中），提升系统性能。
2. 并发处理：令牌验证过程是去中心化的，且计算量小，支持高并发请求，不影响系统响应速度。

==== 认证流程图：

认证流程图展示了JWT令牌认证的完整执行过程：系统首先接收API请求并检查是否包含有效令牌，若包含则提取并验证令牌的签名、格式和过期时间，验证通过后解析JWT载荷获取用户ID和角色信息，将其存储到HttpContext中供后续业务逻辑使用，最终继续处理请求；若请求中无令牌或令牌无效，则继续处理请求但无法获取用户信息，这种设计支持公开接口和认证接口并存，通过多层验证确保安全性，同时无需查询数据库即可获取用户信息，提升了认证效率和用户体验。

#diagram(
  spacing: 2em,
  node-stroke: .1em,
  edge-stroke: .1em,
  node-fill: blue.lighten(95%),
  node((0, 0), [接收API请求], label: "Request"),
  node((0, 1), [令牌正确?], label: "TokenCheck?", shape: shapes.diamond, fill: yellow.lighten(95%)),
  node((2, 1), [继续处理请求，但无用户信息], label: "NoUser", fill: gray.lighten(90%)),
  node((0, 2), [提取token], label: "Extract"),
  node((0, 3), [验证token有效性], label: "Validate", shape: shapes.diamond, fill: yellow.lighten(95%)),
  node((2, 3), [继续处理请求，但无用户信息], label: "NoUser", fill: gray.lighten(90%)),
  node((0, 4), [获取用户ID和角色信息], label: "GetUserInfo", fill: green.lighten(95%)),
  node((0, 5), [将用户信息存储在Http上下文中], label: "StoreContext"),
  node((0, 6), [继续处理请求], label: "Continue", fill: olive.lighten(95%)),
  edge((0, 0), (0, 1), "->"),
  edge((0, 1), (2, 1), [否], "->", stroke: red),
  edge((0, 1), (0, 2), [是], "->"),
  edge((0, 2), (0, 3), "->"),
  edge((0, 3), (2, 3), [无效], "->", stroke: red),
  edge((0, 3), (0, 4), [有效], "->", stroke: green),
  edge((0, 4), (0, 5), "->"),
  edge((0, 5), (0, 6), "->"),
  edge((2.2, 1), "ddddd,ll", "->"),
  edge((1.8, 3), "ddd,ll", "->"),
)

==== 授权流程图：

授权流程图展示了基于角色的访问控制（RBAC）执行过程：控制器方法开始执行后，首先判断是否需要授权，若不需要则直接执行业务逻辑；若需要授权则检查HttpContext中是否包含用户信息，不包含则返回401 Unauthorized错误，包含则获取用户角色并验证是否具有所需角色权限，具有则继续执行方法逻辑，不具有则返回403 Forbidden错误，这种设计通过声明式授权属性实现了灵活的权限控制，确保只有具备相应角色的用户才能访问受保护的资源。

#diagram(
  spacing: 2em,
  node-stroke: .1em,
  edge-stroke: .1em,
  node-fill: blue.lighten(95%),
  node((0, 0), [控制器方法开始执行], label: "Start"),
  node((0, 1), [需要授权?], label: "NeedAuth?", shape: shapes.diamond, fill: yellow.lighten(95%)),
  node((0, 3), [继续执行方法逻辑], label: "Execute", fill: green.lighten(95%)),
  node((2, 1), [上下文中是否包含User?], label: "HasUser?", shape: shapes.diamond, fill: yellow.lighten(95%)),
  node((4, 1), [返回401 Unauthorized], label: "401", fill: red.lighten(95%)),
  node((2, 2), [获取用户角色], label: "GetRole"),
  node((2, 3), [用户具有所需角色?], label: "HasRole?", shape: shapes.diamond, fill: yellow.lighten(95%)),
  node((4, 3), [返回403 Forbidden], label: "403", fill: red.lighten(95%)),
  edge((0, 0), (0, 1), "->"),
  edge((0, 1), (0, 3), [否], "->", stroke: green),
  edge((0, 1), (2, 1), [是], "->"),
  edge((2, 1), (4, 1), [否], "->", stroke: red),
  edge((2, 1), (2, 2), [是], "->"),
  edge((2, 2), (2, 3), "->"),
  edge((2, 3), (4, 3), [否], "->", stroke: red),
  edge((2, 3), (0, 3), [是], "->", stroke: green),
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
    | 搜索金融产品 | 支持按名称、价格范围等条件搜索产品，快速定位目标产品 |
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

本节通过表格形式详细展示了系统需求与具体实现之间的映射关系。表格按照用户角色（普通用户、管理员）进行分类，列出了每个角色的功能需求、对应的前端页面/模块以及后端接口/模块。这种对应关系清晰地呈现了从需求分析到技术实现的完整路径，便于理解系统各功能的实现方式和技术架构，同时也为后续的系统维护和功能扩展提供了重要参考。

#figure(
  tablem[
    | 角色 | 需求 | 前端页面/模块 | 后端接口/模块 |
    |------|------|---------------|----------------|
    | 普通用户 | 注册、登录、自动登录 | LoginPage、RegisterPage、AppConfigService | /login/register、/login/loginByPassword、/login/refreshToken (LoginController) |
    | 普通用户 | 修改密码、忘记密码 | LoginPage、ProfileEditPage | /user/changePassword、/user/resetPassword (UserController) |
    | 普通用户 | 个人信息编辑、头像上传 | ProfileEditPage | /user/updateInfo、/user/uploadAvatar (UserController) |
    | 普通用户 | 浏览行情和金融产品 | MarketPage、CsgoCategoryPage、CsgoProductsByCategory | /store/categories、/store/products、/store/categoryAvgPrice (StoreController) |
    | 普通用户 | 搜索金融产品 | MarketSearchPage | /store/search (StoreController) |
    | 普通用户 | 收藏金融产品分类 | MarketPage | /store/favoriteCategory、/store/myFavoriteCategories (StoreController) |
    | 普通用户 | 购买产品与查看交易记录 | CsgoProductDetailPage、MyTransaction、MyYield | /transaction/buy、/transaction/myRecords、用户资产相关接口 (TransactionController、UserAssetService) |
    | 普通用户 | 账户充值 | AddingMoneyPage | /user/topup (UserController) |
    | 普通用户 | 社区发帖、浏览、点赞、收藏 | CommunityPage、PostViewer、MyPosts、MySelections | /posts/create、/posts/page、/posts/like、/posts/favorite、/posts/report (PostController) |
    | 普通用户 | 社区帖子搜索 | CommunitySearchPage | /posts/search (PostController) |
    | 普通用户 | 帖子评论、回复 | PostViewer | /comments/create、/comments/page (CommentController) |
    | 普通用户 | 帖子举报 | PostViewer | /posts/report (PostController) |
    | 普通用户 | 通知中心与消息提醒 | MyMessage 页面、通知角标 | /notification/my、/notification/unread-count、/notification/read (NotificationController) |
    | 普通用户 | 系统设置（主题、动画时长） | SettingPage、ChangeThemeColorPage、SettingDuration | 本地存储 (AppConfigService) |
    | 普通用户 | API地址设置 | SetApiUrlPage | 本地存储 (AppConfigService) |
  ],
  kind: table,
  caption: "普通用户需求与实现对应关系",
)

#figure(
  tablem[
    | 角色 | 需求 | 前端页面/模块 | 后端接口/模块 |
    |------|------|---------------|----------------|
    | 管理员 | 用户管理与封禁 | 管理员入口、用户管理页面 | /admin/users、/admin/handleUser、/admin/setAdmin (AdminController) |
    | 管理员 | 内容审核与系统统计 | 帖子审核页面、统计页面 | /admin/reportedPosts、/admin/handleReport、/admin/statistics (AdminController、PostService) |
    | 管理员 | 产品分类管理 | CreateCategoryPage | /store/category/create、/store/category/update、/store/category/delete (StoreController) |
    | 管理员 | 产品管理 | AdminProductPage | /store/product/create、/store/product/update、/store/product/delete (StoreController) |
  ],
  kind: table,
  caption: "管理员需求与实现对应关系",
)

== 系统功能模块图

Southern Money 系统采用模块化设计思想，将整个平台划分为六大核心功能模块，各模块之间通过清晰的接口进行数据交互与功能协作。用户管理模块负责用户身份认证与个人信息维护；金融产品模块提供产品展示与分类服务；交易管理模块处理购买流程与交易记录；社区论坛模块支持用户内容创作与互动；通知中心模块实现消息推送与管理；管理员模块提供系统运营与内容审核功能。这种模块化架构有效降低了系统耦合度，提升了可维护性与扩展性。

#let system_diagram = ```pintora
mindmap
@param layoutDirection LR
+ Southern Money 系统
++  [ 用户管理模块 ]
+++ [ 用户注册/登录 ]
+++ [ 个人信息管理 ]
+++ [ 开户管理 ]
+++ [ 资产查询 ]
++ [ 金融产品模块 ]
+++ [ 产品分类管理 ]
+++ [ 产品列表展示 ]
+++ [ 产品搜索 ]
+++ [ 产品收藏 ]
++ [ 交易管理模块 ]
+++ [ 产品购买 ]
+++ [ 交易记录查询 ]
++ [ 社区论坛模块 ]
+++ [ 帖子发布/浏览 ]
+++ [ 帖子点赞/收藏 ]
+++ [ 帖子搜索 ]
+++ [ 帖子审核 ]
++ [ 通知中心模块 ]
+++ [ 通知发送 ]
+++ [ 通知管理 ]
++ [ 管理员模块 ]
+++ [ 用户管理 ]
+++ [ 内容审核 ]
+++ [ 系统统计 ]
```
#figure(
  system_diagram,
  caption: "Southern Money 系统功能模块图",
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

- 市场页面 (Market)：采用网格 (`GridView`) 与列表 (`ListView`) 混合布局。顶部提供分类筛选器（`FilterChip`），产品卡片清晰展示价格、收益率与风险等级图标，点击卡片通过 `PageView` 过渡至详情页。

- 社区页面 (Community)：核心为帖子时间线。每个帖子项 (`PostCard`) 包含作者头像、内容预览、互动按钮（点赞、评论、收藏）。支持富文本与多图展示 (`PageView`)。

- 个人中心 (Profile)：通过底部导航栏入口访问。页面分为信息头（展示头像与昵称）、资产卡片、功能列表（设置、收藏、历史记录）等区域。设置项中提供主题选择器页面 `ChangeThemeColorPage`，允许用户实时预览并切换 Color Seed。

- 主题设置页面：提供三种颜色选择模式（Block、Material、Advanced），支持实时预览主题色效果，通过 `ValueNotifier` 实现主题色的动态切换与持久化存储。


=== 组件设计原则

系统实现了一系列自定义组件，遵循以下设计原则：

1. 单一职责原则：
  每个组件只负责一个特定功能，降低组件复杂度，提高可维护性。

2. 可复用性：
  设计通用组件，支持多种场景使用，提供灵活的配置选项以适应不同需求，示例包括`BasicCard`、`PostCard`、`BrandHeader`等。

3. 可测试性：
  组件设计便于单元测试和集成测试，分离UI渲染和业务逻辑，便于测试。

4. 主题一致性：
  所有组件遵循统一的主题设计，支持主题色动态切换，保持UI一致性，基于Material Design 3规范实现。

5. 性能优化：
  组件设计考虑性能因素，避免不必要的重建，使用`const`构造函数创建不可变组件，实现懒加载和缓存机制，提高渲染性能。

=== 自定义组件与配置管理

==== 自定义组件
为确保UI风格的一致性和开发效率，系统实现了一系列自定义组件：

#figure(
  three-line-table[
    | 组件名称 | 功能描述 |
    | `BasicCard` | 基础卡片组件，包含圆角、阴影和背景色 |
    | `commonCard` | 带标题和图标的卡片组件，用于信息展示 |
    | `PostCard` | 帖子卡片组件，展示帖子内容、作者信息和互动按钮 |
    | `BrandHeader` | 品牌头部组件，包含渐变背景和圆形logo |
  ],
  kind: table,
  caption: "自定义组件列表",
)

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

在乌鸦脚ER图里：实体用矩形框表示，关系用连接线表示。其中，单条短竖线“|”代表“一”，三叉的“乌鸦脚”（}）代表“多”，小圆圈“o”则表示“可选”（零）。这些符号的组合明确定义了关系的基数：例如“|”对“{”表示经典的一对多关系，“}”对“{”表示多对多关系。



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

==== ER设计逻辑阐述

本系统的ER设计遵循了关系型数据库的规范化原则，同时结合业务需求进行了合理的反规范化优化，具体设计逻辑如下：

===== 核心实体设计

系统以用户实体为核心，所有业务活动都围绕用户展开。用户实体包含以下关键属性：
- 基础信息：Id、Name、Email、Avatar
- 账户状态：IsAdmin、HasAccount、IsBlocked、IsDeleted
- 时间信息：CreateTime、BlockedAt、AccountOpenedAt
- 安全信息：Password（哈希存储）

用户实体的设计体现了单一职责原则，将用户的基本信息、状态信息、权限信息集中管理，便于统一认证和授权。

===== 一对多关系设计

系统中的主要一对多关系设计如下：

1. 用户与帖子：一个用户可以发布多篇帖子，一篇帖子只能属于一个用户。这种设计符合现实世界的业务逻辑，明确了内容的归属关系，便于追踪内容发布者，实现用户内容管理和权限控制。

2. 用户与商品：一个用户可以上传多个商品，一个商品只能属于一个上传用户。这种设计确保了商品来源的可追溯性，便于商品管理和交易纠纷处理。

3. 用户与通知：一个用户可以接收多条通知，每条通知只能发送给一个接收用户。这种设计实现了个性化通知推送，确保通知的精准送达。

4. 用户与资产：一个用户只能拥有一条资产记录，资产记录属于一个用户。这种一对一关系的设计确保了用户资产的唯一性和一致性，避免了数据冗余。

5. 商品与分类：一个分类可以包含多个商品，一个商品只能属于一个分类。这种设计实现了商品的层级管理，便于商品检索和分类展示。

===== 多对多关系设计

系统中的多对多关系通过关联表实现，具体设计如下：

1. 帖子与图片：通过PostImages关联表实现，一个帖子可以包含多张图片，一张图片也可以被多个帖子使用（如封面图）。这种设计实现了图片资源的复用，减少了存储空间占用，同时保持了内容的灵活性。

2. 帖子与标签：通过PostTags关联表实现，一个帖子可以关联多个标签，一个标签也可以关联多个帖子。这种设计实现了内容的灵活分类和检索，便于用户通过标签发现相关内容。

3. 帖子与用户互动：通过PostLikes和PostFavorites关联表分别实现点赞和收藏功能。一个帖子可以被多个用户点赞或收藏，一个用户也可以点赞或收藏多个帖子。这种设计实现了用户与内容的互动，增强了社区活跃度。

4. 用户与分类收藏：通过UserFavoriteCategories关联表实现，一个用户可以收藏多个分类，一个分类也可以被多个用户收藏。这种设计实现了个性化推荐的基础，便于系统根据用户偏好推送相关内容。

===== 业务约束设计

系统在ER设计中充分考虑了业务约束，主要体现在：

1. 软删除机制：通过IsDeleted字段实现软删除，保留数据历史，便于数据恢复和审计。

2. 封禁管理：通过IsBlocked、BlockReason、BlockedAt字段实现用户和帖子的封禁管理，支持封禁原因记录和时间追踪。

3. 事务完整性：TransactionRecord记录交易详情，包含ProductId、BuyerUserId、Quantity、Price、PurchaseTime等字段，确保交易的可追溯性和完整性。

4. 权限控制：通过IsAdmin字段区分管理员和普通用户，配合PostBlock表实现内容审核和管理功能。

===== 性能优化设计

ER设计在规范化基础上进行了性能优化：


1. 索引设计：主要外键字段（如UploaderUserId、CategoryId、BuyerUserId）建立索引，加速关联查询。

2. 计算属性：TransactionRecord中的TotalPrice作为计算属性，通过Price和Quantity计算得出，避免数据不一致，以及减少冗余字段。

===== 数据一致性保障

ER设计通过以下机制保障数据一致性：

1. 外键约束：所有关联表都通过外键约束保证引用完整性，防止孤立数据的产生。

2. 级联操作：合理设置级联删除和更新规则，确保相关数据的一致性。

3. 事务管理：关键业务操作（如交易、内容发布）通过事务保证原子性，要么全部成功，要么全部回滚。

===== 扩展性设计

ER设计充分考虑了系统的扩展性：

1. 灵活的标签系统：PostTags表采用字符串存储标签，便于新增标签类型，无需修改表结构。

2. 可扩展的通知类型：Notification表的Type字段采用字符串存储，便于扩展新的通知类型。

3. 图片类型区分：Image表的ImageType字段区分不同类型的图片（头像、内容图、封面图等），便于统一管理和复用。

本系统的ER设计在满足业务需求的同时，兼顾了数据规范性、查询性能、一致性和扩展性，为系统的稳定运行和功能扩展提供了坚实的数据基础。

=== 数据库表结构

系统采用关系型数据库设计，共包含15个核心数据表（10个实体以及5个关联表），覆盖用户管理、内容发布、产品交易、资产管理等业务领域。下表详细列出了各表的名称、主要字段及功能说明，这些表通过外键关联形成完整的数据关系网络，支撑系统的各项业务功能。

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

以下展示了系统中各数据库表的样例数据，这些数据反映了系统在实际运行中的典型数据形态。样例数据涵盖了用户、帖子、产品、交易等核心业务场景，帮助理解各表之间的关联关系和数据存储格式。

#figure(
  tablem[
    | 表名 | 样例数据 |
    |------|----------|
    | Users | (1, '张三', 'zhangsan\@example.com', 'avatar_guid_1', 'hashed_password_1', false, true, false, null, null, '2025-01-01 08:00:00', false) |
    | Images | ('img_guid_1', 1, '2025-01-01 08:00:00', '用户头像', 'avatar', [binary_data]) |
    | Posts | ('post_guid_1', 1, '2025-01-01 09:00:00', 'CSGO饰品交易心得', '今天分享一下我的交易经验...', 0, 150, 25, false) |
    | PostImages | ('post_guid_1', 'img_guid_2') |
    | PostTags | ('post_guid_1', 'CSGO') |
    | PostLikes | ('post_guid_1', 2, '2025-01-01 10:00:00') |
    | PostFavorites | ('post_guid_1', 2, '2025-01-01 10:00:00') |
    | PostBlocks | ('block_guid_1', 'post_guid_2', true, '违规内容', '2025-01-02 14:00:00', 1) |
    | Products | ('prod_guid_1', 'AK-47 红线', 1800.00, '崭新出厂', 'cat_guid_1', 1, '2025-01-01 08:00:00', false) |
    | ProductCategories | ('cat_guid_1', 'CSGO饰品', 'cover_img_guid_1', '2025-01-01 00:00:00') |
    | UserFavoriteCategories | (2, 'cat_guid_1', '2025-01-01 12:00:00') |
    | TransactionRecords | ('trans_guid_1', 'prod_guid_1', 2, 1, 1800.00, 1800.00, '2025-01-01 15:00:00') |
    | UserAssets | (2, 50000.00, 1200.00, 15000.00, 0.024, 48200.00, '2025-01-01 23:59:59') |
    | Notifications | ('notif_guid_1', 2, 1, '用户1赞了你的帖子', 'activity', false, '2025-01-01 10:00:00') |
  ],
  kind: table,
  caption: "数据库数据样例",
)

== 功能模块流程图

本节通过流程图的形式详细展示了系统各核心功能模块的执行流程，包括用户注册、用户登录、产品购买等关键业务流程。每个流程图都清晰地描绘了从前端用户操作到后端处理再到结果返回的完整过程，展示了各环节之间的逻辑关系和判断条件。这些流程图有助于理解系统的工作机制，为系统开发、测试和维护提供了直观的参考。

=== 用户注册流程

用户注册流程包含前端和后端两层验证机制。前端验证主要负责检查用户输入的格式正确性，包括用户名长度、邮箱格式等基本规则，确保数据格式符合要求后再发送请求，减少不必要的网络传输。后端验证则进行更严格的数据校验，包括检查用户名和邮箱是否已被注册、密码哈希处理、数据完整性验证等，确保数据安全性和业务规则的正确性。双重验证机制有效提升了系统的安全性和用户体验。

#let register_chart = diagram(
  spacing: 2em,
  node-stroke: .1em,
  edge-stroke: .1em,
  node-fill: blue.lighten(95%),
  node((0, 0), [用户填写注册信息], label: "FillInfo"),
  node((0, 1), [前端验证], label: "FrontendValidate"),
  node((0, 2), [发送注册请求], label: "SendRequest"),
  node((0, 3), [后端验证], label: "BackendValidate"),
  node((0, 4), [创建用户], label: "CreateUser"),
  node((0, 5), [返回成功], label: "Success", fill: green.lighten(95%)),
  node((0, 6), [返回错误], label: "Error", fill: red.lighten(95%)),
  node((1, 1), [提示错误], label: "ShowError", fill: red.lighten(95%)),
  edge((0, 0), (0, 1), "->"),
  edge((0, 1), (0, 2), [验证通过], "->", stroke: green),
  edge((0, 1), (1, 1), [验证失败], "->", stroke: red),
  edge((0, 2), (0, 3), "->"),
  edge((0, 3), (0, 4), [验证通过], "->", stroke: green),
  edge((0, 3), (0, 6), [验证失败], "->", stroke: red),
  edge((0, 4), (0, 5), "->"),
)
#figure(register_chart, caption: "用户注册流程")

=== 用户登录流程

用户登录流程同样采用前后端双重验证机制。前端验证主要检查用户输入的完整性，确保用户名和密码字段不为空，并验证输入格式是否符合基本要求。后端验证则负责查询数据库验证用户身份，包括比对用户名是否存在、验证密码哈希是否匹配、检查用户账户状态（是否被封禁）等。验证通过后，后端生成JWT令牌并返回给前端，前端将令牌存储用于后续的身份认证，确保系统安全访问。

#let login_chart = diagram(
  spacing: 2em,
  node-stroke: .1em,
  edge-stroke: .1em,
  node-fill: blue.lighten(95%),
  node((0, 0), [用户填写登录信息], label: "FillInfo"),
  node((0, 1), [前端验证], label: "FrontendValidate"),
  node((0, 2), [发送登录请求], label: "SendRequest"),
  node((0, 3), [后端验证], label: "BackendValidate"),
  node((0, 4), [生成JWT令牌], label: "GenerateToken"),
  node((0, 5), [返回令牌], label: "ReturnToken", fill: green.lighten(95%)),
  node((0, 6), [返回错误], label: "ReturnError", fill: red.lighten(95%)),
  node((1, 1), [提示错误], label: "ShowError", fill: red.lighten(95%)),
  edge((0, 0), (0, 1), "->"),
  edge((0, 1), (0, 2), [验证通过], "->", stroke: green),
  edge((0, 1), (1, 1), [验证失败], "->", stroke: red),
  edge((0, 2), (0, 3), "->"),
  edge((0, 3), (0, 4), [验证通过], "->", stroke: green),
  edge((0, 3), (0, 6), [验证失败], "->", stroke: red),
  edge((0, 4), (0, 5), "->"),
)

#figure(
  login_chart,
  caption: "用户登录流程",
)

=== 产品购买流程

产品购买流程涉及复杂的业务逻辑和事务处理，前后端验证机制确保交易的安全性和数据一致性。前端验证主要检查购买数量是否为正整数、是否超过单次购买上限、用户余额是否充足等基本条件，提前拦截无效请求。后端验证则进行更全面的业务规则检查，包括验证产品是否存在且未下架、检查用户账户状态、验证用户余额是否足够支付、检查产品库存是否充足等。验证通过后，系统使用数据库事务确保交易的原子性，同时执行扣减用户余额、扣减产品库存、生成交易记录等操作，任何步骤失败都会触发事务回滚，确保数据一致性。交易成功后，系统会向用户发送购买通知。

#figure(
  diagram(
    spacing: 2em,
    node-stroke: .1em,
    edge-stroke: .1em,
    node-fill: blue.lighten(95%),
    node((0, 0), [用户选择产品], label: "Select"),
    node((0, 1), [填写购买数量], label: "Quantity"),
    node((0, 2), [前端验证], label: "FrontendValid?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 2), [提示错误], label: "Error", fill: red.lighten(95%)),
    node((0, 3), [发送购买请求], label: "SendRequest"),
    node((0, 4), [后端验证], label: "BackendValid?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((0, 5), [执行交易事务], label: "Transaction"),
    node((0, 6), [扣余额+扣库存+生成记录], label: "Update"),
    node((0, 7), [事务成功?], label: "Success?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 7), [回滚事务], label: "Rollback", fill: red.lighten(95%)),
    node((2, 8), [返回失败], label: "Fail", fill: red.lighten(95%)),
    node((0, 8), [提交事务], label: "Commit", fill: green.lighten(95%)),
    node((0, 9), [发送通知], label: "Notify"),
    node((0, 10), [返回成功], label: "Success", fill: green.lighten(95%)),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (2, 2), [失败], "->", stroke: red),
    edge((0, 2), (0, 3), [通过], "->", stroke: green),
    edge((0, 3), (0, 4), "->"),
    edge((0, 4), (2, 2), [失败], "->", stroke: red),
    edge((0, 4), (0, 5), [通过], "->", stroke: green),
    edge((0, 5), (0, 6), "->"),
    edge((0, 6), (0, 7), "->"),
    edge((0, 7), (2, 7), [否], "->", stroke: red),
    edge((0, 7), (0, 8), [是], "->", stroke: green),
    edge((2, 7), (2, 8), "->"),
    edge((0, 8), (0, 9), "->"),
    edge((0, 9), (0, 10), "->"),
  ),
  caption: "产品购买流程",
)

=== 帖子发布流程

帖子发布流程包含多层验证机制，确保内容质量和系统安全。前端验证主要检查用户输入的基本格式，包括标题长度、内容长度、图片格式和大小等，确保数据符合基本要求后再上传。图片验证包括检查图片类型是否支持、文件大小是否在限制范围内。后端验证则进行更全面的检查，包括验证用户账户状态是否正常（是否被封禁或删除）、检查内容长度是否符合系统规定等。验证通过后，系统保存帖子及其图片关联关系，确保数据完整性。如果保存失败，系统会自动清理已创建的数据，避免产生脏数据。

#figure(
  diagram(
    spacing: 2em,
    node-stroke: .1em,
    edge-stroke: .1em,
    node-fill: blue.lighten(95%),
    node((0, 0), [用户填写帖子内容], label: "FillContent"),
    node((0, 1), [上传图片(可选)], label: "UploadImage"),
    node((0, 2), [图片验证通过?], label: "ImageValid?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 2), [提示图片错误], label: "ImageError", fill: red.lighten(95%)),
    node((0, 3), [前端内容验证], label: "FrontendValid?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 3), [提示内容错误], label: "ContentError", fill: red.lighten(95%)),
    node((0, 4), [发送发布请求], label: "SendRequest"),
    node((0, 5), [用户状态正常?], label: "UserValid?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 5), [提示用户异常], label: "UserError", fill: red.lighten(95%)),
    node((0, 6), [后端内容验证], label: "BackendValid"),
    node((2, 6), [返回错误], label: "Error", fill: red.lighten(95%)),
    node((0, 7), [保存帖子], label: "SavePost"),
    node((0, 8), [保存成功?], label: "Saved?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 8), [返回保存失败], label: "SaveFail", fill: red.lighten(95%)),
    node((0, 9), [保存帖子图片关联], label: "SaveImageRelation"),
    node((0, 10), [关联成功?], label: "Linked?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 10), [删除已保存帖子], label: "DeletePost", fill: red.lighten(95%)),
    node((0, 11), [更新帖子统计], label: "UpdateStats"),
    node((0, 12), [返回发布成功], label: "Success", fill: green.lighten(95%)),
    node((2, 11), [返回发布失败], label: "Fail", fill: red.lighten(95%)),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (2, 2), [否], "->", stroke: red),
    edge((0, 2), (0, 3), [是], "->", stroke: green),
    edge((0, 3), (2, 3), [验证失败], "->", stroke: red),
    edge((0, 3), (0, 4), [验证通过], "->", stroke: green),
    edge((0, 4), (0, 5), "->"),
    edge((0, 5), (2, 5), [否], "->", stroke: red),
    edge((0, 5), (0, 6), [是], "->", stroke: green),
    edge((0, 6), (2, 6), [验证失败], "->", stroke: red),
    edge((0, 6), (0, 7), [验证通过], "->", stroke: green),
    edge((0, 7), (0, 8), "->"),
    edge((0, 8), (2, 8), [否], "->", stroke: red),
    edge((0, 8), (0, 9), [是], "->", stroke: green),
    edge((0, 9), (0, 10), "->"),
    edge((0, 10), (2, 10), [否], "->", stroke: red),
    edge((0, 10), (0, 11), [是], "->", stroke: green),
    edge((0, 11), (0, 12), "->"),
    edge((2, 10), (2, 11), "->"),
  ),
  caption: "帖子发布流程",
)

=== 帖子审核流程

帖子审核流程主要依赖用户举报机制来维护社区内容的安全性和合规性。用户在浏览帖子时，如发现违规内容可以发起举报。系统会记录举报信息并通知管理员介入处理。管理员审核通过后，帖子清除举报记录；审核不通过则封禁帖子，系统会在PostBlocks表中记录封禁信息并通知帖子作者。

#figure(
  diagram(
    spacing: 2em,
    node-stroke: .1em,
    edge-stroke: .1em,
    node-fill: blue.lighten(95%),
    node((0, 0), [用户发布帖子], label: "Publish"),
    node((0, 1), [帖子上线], label: "Online"),
    node((0, 2), [用户浏览帖子], label: "Browse"),
    node((0, 3), [用户举报帖子], label: "Report"),
    node((0, 4), [系统记录举报信息，并通知管理员审核], label: "Record"),
    node((0, 5), [审核结果?], label: "Result?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((0, 6), [清除举报记录], label: "ClearRecord", fill: green.lighten(95%)),
    node((1, 5), [封禁帖子], label: "Block", fill: red.lighten(95%)),
    node((1, 6), [系统记录封禁信息], label: "RecordBlock"),
    node((1, 7), [通知帖子作者], label: "NotifyAuthor"),
    node((0, 7), [结束], label: "End"),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (0, 3), [发现违规内容], "->", stroke: red),
    edge((0, 3), (0, 4), "->"),
    edge((0, 4), (0, 5), "->"),
    edge((0, 5), (0, 6), [通过], "->", stroke: green),
    edge((0, 5), (1, 5), [不通过], "->", stroke: red),
    edge((0, 6), (0, 7), "->"),
    edge((1, 5), (1, 6), "->"),
    edge((1, 6), (1, 7), "->"),
    edge((1, 7), (0, 7), "->"),
  ),
  caption: "帖子审核流程",
)

=== 用户资产更新流程

用户资产更新流程涉及多种业务场景，包括充值、购买产品和收益计算，每种场景都有严格的验证机制确保资产安全。充值场景中，前端验证充值金额是否为正数、是否在允许范围内，后端验证充值请求的合法性和支付渠道的可靠性。购买产品场景中，前端验证购买数量是否合法、用户余额是否充足，后端验证产品状态、库存情况以及用户账户状态，确保交易安全。收益计算场景由系统定时任务触发，后端根据产品价格波动计算用户收益，更新UserAsset表中的各项资产数据。所有资产更新操作都使用数据库事务确保数据一致性，任何异常都会触发回滚，避免资产数据错误。

#figure(
  diagram(
    spacing: 2em,
    node-stroke: .1em,
    edge-stroke: .1em,
    node-fill: blue.lighten(95%),
    node((0, 0), [用户资产触发事件], label: "Trigger"),
    node((0, 1), [事件类型?], label: "EventType?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((0, 2), [用户发起充值请求], label: "Topup"),
    node((0, 3), [系统处理充值], label: "ProcessTopup"),
    node((0, 4), [更新用户余额], label: "UpdateBalance"),
    node((1, 2), [用户购买产品], label: "BuyProduct"),
    node((1, 3), [系统验证余额], label: "CheckBalance", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((1, 4), [处理交易], label: "ProcessTrans"),
    node((1, 5), [扣除产品费用], label: "DeductFee"),
    node((1, 6), [生成交易记录], label: "CreateRecord"),
    node((2, 3), [交易失败], label: "Fail", fill: red.lighten(95%)),
    node((2, 4), [返回错误信息], label: "Error", fill: red.lighten(95%)),
    node((3, 2), [系统定时计算收益], label: "CalcProfit"),
    node((3, 3), [计算用户收益], label: "Calculate"),
    node((3, 4), [更新收益数据], label: "UpdateProfit"),
    node((0, 5), [更新UserAsset表], label: "UpdateAsset"),
    node((0, 6), [返回最新资产数据], label: "Success", fill: green.lighten(95%)),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), [充值], "->", stroke: green),
    edge((0, 1), (1, 2), [购买产品], "->", stroke: green),
    edge((0, 1), "rrr,d", [收益计算], "->", stroke: green),
    edge((0, 2), (0, 3), "->"),
    edge((0, 3), (0, 4), "->"),
    edge((0, 4), (0, 5), "->"),
    edge((1, 2), (1, 3), "->"),
    edge((1, 3), (1, 4), [余额充足], "->", stroke: green),
    edge((1, 3), (2, 3), [余额不足], "->", stroke: red),
    edge((1, 4), (1, 5), "->"),
    edge((1, 5), (1, 6), "->"),
    edge((1, 6), (0, 5), "->"),
    edge((2, 3), (2, 4), "->"),
    edge((3, 2), (3, 3), "->"),
    edge((3, 3), (3, 4), "->"),
    edge((3, 4), (0, 5), "->"),
    edge((0, 5), (0, 6), "->"),
  ),
  caption: "用户资产更新流程",
)

=== 通知发送流程

通知发送流程负责将各类业务事件及时推送给相关用户，确保用户能够及时获取重要信息。系统支持多种通知类型，包括交易事件（如购买成功、收益到账）、系统事件（如系统公告、维护通知）、审核事件（如帖子审核结果）以及其他自定义通知。前端验证主要检查通知请求的合法性，包括验证接收用户ID是否存在、通知内容长度是否在限制范围内等。后端验证则进行更全面的检查，包括验证通知类型是否合法、检查用户通知权限、验证通知内容是否包含敏感信息等。通知保存到Notifications表后，系统会根据推送方式进行分发，系统内通知通过更新未读计数提醒用户，同时支持外部推送服务扩展。用户查看通知后，系统会标记通知为已读状态。

#figure(
  diagram(
    spacing: 2em,
    node-stroke: .1em,
    edge-stroke: .1em,
    node-fill: blue.lighten(95%),
    node((0, 0), [触发通知事件], label: "Trigger"),
    node((0, 1), [事件类型?], label: "EventType?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((0, 2), [交易完成], label: "Transaction"),
    node((1, 2), [系统公告], label: "System"),
    node((2, 2), [内容审核结果], label: "Audit"),
    node((3, 2), [其他通知], label: "Other"),
    node((0, 3), [创建通知记录], label: "CreateRecord"),
    node((0, 4), [保存到Notifications表], label: "SaveToTable"),
    node((0, 5), [推送通知], label: "Push"),
    node((0, 6), [推送方式?], label: "PushMethod?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((0, 7), [更新未读计数], label: "UpdateUnread"),
    node((1, 7), [外部推送服务], label: "ExternalPush"),
    node((0, 8), [用户接收通知], label: "Receive"),
    node((0, 9), [用户查看通知], label: "View"),
    node((0, 10), [标记通知已读], label: "MarkRead"),
    node((0, 11), [更新通知状态], label: "UpdateStatus"),
    node((0, 12), [结束], label: "End"),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), [交易事件], "->", stroke: green),
    edge((0, 1), "r,d", [系统事件], "->", stroke: green),
    edge((0, 1), "rr,d", [审核事件], "->", stroke: green),
    edge((0, 1), "rrr,d", [其他事件], "->", stroke: green),
    edge((0, 2), (0, 3), "->"),
    edge((1, 2), "d,l", "->"),
    edge((2, 2), "d,ll", "->"),
    edge((3, 2), "d,lll", "->"),
    edge((0, 3), (0, 4), "->"),
    edge((0, 4), (0, 5), "->"),
    edge((0, 5), (0, 6), "->"),
    edge((0, 6), (0, 7), [系统内], "->", stroke: green),
    edge((0, 6), (1, 7), [其他方式], "->", stroke: green),
    edge((0, 7), (0, 8), "->"),
    edge((1, 7), (0, 8), "->"),
    edge((0, 8), (0, 9), "->"),
    edge((0, 9), (0, 10), "->"),
    edge((0, 10), (0, 11), "->"),
    edge((0, 11), (0, 12), "->"),
  ),
  caption: "通知发送流程",
)

=== 管理员处理用户流程

管理员处理用户流程提供了完整的用户管理功能，包括查看用户列表、搜索筛选用户、查看用户详情等基础操作。管理员可以对用户进行多种处理操作：封禁或解封用户账号、设置或取消管理员权限。封禁/解封操作会更新用户的IsBlocked状态，并记录处理原因，同时通过NotificationService向用户发送通知。设置管理员权限操作会更新用户的IsAdmin状态。所有操作完成后，系统会返回操作结果并记录相关日志，确保用户管理过程的可追溯性。

#figure(
  diagram(
    spacing: 2em,
    node-stroke: .1em,
    edge-stroke: .1em,
    node-fill: blue.lighten(95%),
    node((0, 0), [管理员登录系统], label: "Login"),
    node((0, 1), [进入管理后台], label: "Dashboard"),
    node((0, 2), [查看用户列表], label: "UserList"),
    node((0, 3), [搜索/筛选用户], label: "Search"),
    node((0, 4), [查看用户详情], label: "UserDetail"),
    node((0, 5), [处理操作?], label: "Action?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((0, 6), [处理用户状态], label: "HandleStatus"),
    node((0, 7), [更新用户IsBlocked状态], label: "UpdateBlocked"),
    node((0, 8), [记录处理原因], label: "RecordReason"),
    node((1, 6), [设置管理员权限], label: "SetAdmin"),
    node((1, 7), [更新用户IsAdmin状态], label: "UpdateAdmin"),
    node((0, 9), [发送通知给用户], label: "NotifyUser"),
    node((0, 10), [返回操作结果], label: "Result"),
    node((0, 11), [结束], label: "End"),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (0, 3), "->"),
    edge((0, 3), (0, 4), "->"),
    edge((0, 4), (0, 5), "->"),
    edge((0, 5), (0, 6), [封禁/解封], "->", stroke: green),
    edge((0, 5), (1, 6), [设置管理员], "->", stroke: green),
    edge((0, 5), "r,uuu,l", [返回列表], "->", stroke: green, label-pos: .2),
    edge((0, 6), (0, 7), "->"),
    edge((0, 7), (0, 8), "->"),
    edge((0, 8), (0, 9), "->"),
    edge((1, 6), (1, 7), "->"),
    edge((1, 7), (0, 9), "->"),
    edge((0, 9), (0, 10), "->"),
    edge((0, 10), (0, 11), "->"),
  ),
  caption: "管理员处理用户流程",
)

=== 商品分类管理流程

商品分类管理流程为管理员提供了完整的分类管理功能，包括创建新分类、编辑现有分类、删除分类以及查看分类下的商品列表。创建分类时，管理员需要填写分类信息并上传分类封面，系统会保存分类数据并更新分类列表。编辑分类时，管理员可以修改分类信息后保存。删除分类前，系统会检查该分类下是否有关联商品，如果有商品关联则提示无法删除，确保数据完整性。查看分类商品功能可以让管理员快速浏览某个分类下的所有商品。所有操作完成后，系统会返回操作结果，确保管理员能够及时了解操作状态。

#figure(
  diagram(
    spacing: 2em,
    node-stroke: .1em,
    edge-stroke: .1em,
    node-fill: blue.lighten(95%),
    node((0, 0), [管理员登录系统], label: "Login"),
    node((0, 1), [进入管理后台], label: "Dashboard"),
    node((0, 2), [查看分类列表], label: "CategoryList"),
    node((0, 3), [分类操作?], label: "Action?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((0, 4), [创建新分类], label: "Create"),
    node((0, 5), [填写分类信息], label: "FillInfo"),
    node((0, 6), [上传分类封面], label: "UploadCover"),
    node((0, 7), [保存分类数据], label: "Save"),
    node((1, 4), [选择分类], label: "Select"),
    node((1, 5), [修改分类信息], label: "ModifyInfo"),
    node((1, 6), [保存分类数据], label: "Save"),
    node((2, 4), [选择分类], label: "Select"),
    node((2, 5), [确认删除], label: "Confirm"),
    node((2, 6), [是否有商品关联?], label: "HasProducts?", shape: shapes.diamond, fill: yellow.lighten(95%)),
    node((2, 8), [提示有商品关联], label: "HasProducts", fill: red.lighten(95%)),
    node((1, 8), [删除分类], label: "Delete"),
    node((3, 4), [查看分类商品], label: "ViewProducts"),
    node((3, 5), [返回商品列表], label: "ProductList"),
    node((0, 8), [更新分类列表], label: "UpdateList"),
    node((0, 9), [返回操作结果], label: "Result"),
    node((0, 10), [结束], label: "End"),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (0, 3), "->"),
    edge((0, 3), (0, 4), [创建分类], "->", stroke: green),
    edge((0, 3), "r,d", [编辑分类], "->", stroke: green),
    edge((0, 3), "rr,d", [删除分类], "->", stroke: green),
    edge((0, 3), "rrr,d", [查看分类商品], "->", stroke: green),
    edge((0, 4), (0, 5), "->"),
    edge((0, 5), (0, 6), "->"),
    edge((0, 6), (0, 7), "->"),
    edge((0, 7), (0, 8), "->"),
    edge((1, 4), (1, 5), "->"),
    edge((1, 5), (1, 6), "->"),
    edge((1, 6), (0, 8), "->"),
    edge((2, 4), (2, 5), "->"),
    edge((2, 5), (2, 6), "->"),
    edge((2, 6), (2, 8), [是], "->", stroke: red),
    edge((2, 6), (1, 8), [否], "->", stroke: green),
    //edge((2, 7), (0, 2), "->"),
    edge((1, 8), (0, 8), "->"),
    edge((3, 4), (3, 5), "->"),
    edge((3, 5), "ddddd,lll", "->"),
    edge((0, 8), (0, 9), "->"),
    edge((0, 9), (0, 10), "->"),
  ),
  caption: "商品分类管理流程",
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

== 功能测试

功能测试覆盖了系统所有功能模块，包括用户管理、金融产品、交易管理、社区交流和通知中心等。测试了基本功能、功能交互、边界条件和异常情况。

== 测试截图
=== 系统主题展示

系统支持亮色和暗色主题切换，且支持随着系统主题自动切换。

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
  [API地址设置], [动态配置后端服务地址，支持实时切换API环境],

  [关于我们], [展示应用的基本信息、开发者信息和版权声明],
  [测试页面], [提供开发调试工具和测试功能，用于内部测试和问题排查],
  [清除全部数据], [清除所有应用数据（包括主题设置、API配置等），操作前显示确认对话框],

  [退出登录], [清除JWT令牌和用户会话信息，返回登录页面，操作前显示确认对话框],

  [版本信息], [显示当前应用版本号，点击可查看详细版本信息],
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
Southern Money 系统是一款集金融交易、产品展示、社区交流功能于一体的综合性金融服务平台，聚焦为用户提供一体化金融服务解决方案。系统采用前后端分离的主流架构设计，后端基于ASP.NET Core Web API 搭建高性能服务端，前端依托 Flutter 框架开发跨平台应用，可无缝适配多终端运行，兼顾开发效率与用户使用便捷性。


本系统已实现完整的核心功能体系，具体涵盖以下模块：

#figure(
  table(
    columns: 2,
    stroke: 0.5pt + gray,
    [*功能模块*], [*功能描述*],
    [用户全生命周期管理], [含身份认证、信息维护、权限分配等核心能力],
    [金融产品服务], [支持产品分类浏览、详情查询及在线购买操作],
    [社区互动模块], [实现用户交流互动、内容发布与审核管理功能],
    [消息通知体系], [搭建通知中心与实时消息推送机制，保障信息触达],
    [后台管理功能], [支持管理员对系统用户、产品、内容及日志的统一管控],
  ),
  kind: table,
  caption: "核心功能体系",
)

结合金融服务场景需求，系统具备以下核心特性，兼顾实用性、安全性与可扩展性：

#figure(
  table(
    columns: 2,
    stroke: 0.5pt + gray,
    [*核心特性*], [*特性说明*],
    [界面设计现代化], [支持亮色、暗色双主题切换，适配不同使用场景],
    [适配性强], [采用响应式布局设计，可兼容不同尺寸终端屏幕],
    [安全防护可靠], [搭建多层级身份认证与权限管控机制，筑牢安全防线],
    [服务性能优异], [优化 API 接口设计，保障高并发场景下的稳定运行],
    [运维支撑完善], [具备完整的错误处理机制与全链路日志记录功能],
    [可拓展性良好], [架构分层解耦，便于后续功能迭代与系统维护],
  ),
  kind: table,
  caption: "核心特性",
)

== 体会
在参与 Southern Money 系统开发的全过程中，我不仅完成了既定开发任务，更在技术实践与工程思维层面收获诸多成长，形成如下深刻体会：

深刻体会到前后端分离架构的核心价值，其优势在项目落地中得到充分印证。一是大幅提升开发效率，前后端团队可基于接口规范并行推进开发工作，有效规避串行开发的流程阻塞问题；二是显著增强系统可扩展性，分层解耦的架构设计为后续功能迭代、模块新增提供了灵活支撑；三是提升系统整体可维护性，职责清晰的代码结构便于后续的版本迭代、问题排查与自动化测试落地。

切实感受到跨平台开发技术对项目落地的赋能作用，也深化了对技术选型重要性的认知。本次采用 Flutter 框架实现跨平台开发，不仅实现了一套代码适配多终端的开发目标，大幅减少了多端重复开发的成本，更缩短了开发周期、提升了整体开发效率；同时，跨平台特性也为应用后续的多渠道推广与用户触达奠定了基础，让技术选型更好地服务于项目落地需求。

充分认识到安全性是金融类系统的生命线，安全设计贯穿开发全流程的必要性不言而喻。金融场景下的系统需全面规避各类安全风险，从用户身份认证、权限分级授权，到前端输入合法性验证、后端数据校验，均需形成完整安全闭环；本次项目采用 JWT 令牌认证机制，有效保障了接口调用与用户身份的安全性；此外，我们搭建的完整错误处理机制与全链路日志记录体系，既降低了安全隐患排查难度，也为系统日常监控、故障调试提供了可靠支撑，让安全防护既有事前预防，也有事后追溯能力。

= 小组分工
== 分工详情

#figure(
  three-line-table[
    | 成员 | 主要负责模块 | 工作量占比 |
    |------|--------------|------------|
    | #u57u  | 系统整体架构 | 40% |
    | #yyw  | 前端实现 | 20% |
    | #lpj  | - | % |
    | #hr  | 后端实现 | 20% |
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
    | #yyw  | 前后端完善、系统测试 | 前端csgo饰品交易界面和个人主页，后端管理员功能等实现，系统功能测试和演示，软件文档完善 |
    | #lpj  | 前后端设计、系统构件 | 前端帖子发布与功能设计，维护分页等逻辑功能，需求分析，参与原型选择与设计，设计文档完善。 |
    | #hr  | 前后端编写、系统测试 | 负责后端关系实体定义、前端帖子展示与交易展览页面、辅助后端业务逻辑处理，进行系统测试与调试 |
  ],
  kind: table,
  caption: "分工详情说明",
)

== 分工说明
- #u57u : 负责系统整体架构设计、控制器与服务层编写、认证/授权中间件、数据库迁移脚本及默认数据初始化等工作。
- #yyw  : 提供最初软件设计的方向，负责前端具体页面设计、后端部分功能实现、进行系统测试和功能完善等工作。
- #lpj  : 进行前后端功能设计与实现，负责帖子发布功能、分页逻辑等模块开发，参与需求分析与设计文档编写等工作。
- #hr   : 负责前后端编写与系统测试，包括负责后端关系实体、前端帖子展示与交易展览、辅助前后端编写，系统测试等工作。


依托小组高效协作，我们圆满完成 Southern Money 系统的开发任务。开发阶段，围绕数据库核心环节，我们先后遭遇数据模型设计优化、多表关联查询效率瓶颈、并发访问下的数据一致性、前后端数据交互适配等关键挑战；团队通过集中研讨梳理问题根源、分工开展技术攻坚与方案验证，同步补充数据库优化、数据安全防护等相关知识，最终成功攻克各类难题，显著提升了系统的数据处理性能、存储可靠性与整体运行质量。

展望后续，我们将以提升系统核心竞争力为目标持续迭代：一是深化功能优化与扩展，贴合用户需求完善数据查询、统计分析等核心能力；二是重点强化数据库层面的安全性与稳定性，优化权限管控、数据脱敏、故障恢复等机制，全力为用户提供更优质、安全的服务与使用体验。

