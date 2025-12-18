# 报告
- [报告](#报告)
  - [1、绪论](#1绪论)
    - [1.1 系统开发背景（结合现实的可用性）](#11-系统开发背景结合现实的可用性)
    - [1.2 开发环境](#12-开发环境)
    - [1.3 技术路线](#13-技术路线)
      - [后端架构](#后端架构)
      - [前端架构](#前端架构)
      - [数据库设计](#数据库设计)
      - [系统安全](#系统安全)
  - [2、概要设计](#2概要设计)
    - [2.1 需求概述（囊括需求清单的内容，按角色分析）](#21-需求概述囊括需求清单的内容按角色分析)
      - [2.1.1 普通用户需求](#211-普通用户需求)
      - [2.1.2 管理员需求](#212-管理员需求)
    - [2.2 系统功能模块图](#22-系统功能模块图)
  - [3、详细设计](#3详细设计)
    - [3.1 UI设计](#31-ui设计)
      - [**整体风格**：](#整体风格)
      - [**主题实现**：](#主题实现)
      - [响应式布局](#响应式布局)
      - [**主要页面设计**：](#主要页面设计)
    - [3.2 数据库设计](#32-数据库设计)
      - [3.2.1 ER图设计](#321-er图设计)
      - [3.2.2 数据库表结构](#322-数据库表结构)
      - [3.2.3 数据库数据样例](#323-数据库数据样例)
    - [3.3 功能模块流程图or时序图（对2.2中的系统功能模块图中的子功能展开分析）](#33-功能模块流程图or时序图对22中的系统功能模块图中的子功能展开分析)
      - [3.3.1 用户注册流程](#331-用户注册流程)
      - [3.3.2 用户登录流程](#332-用户登录流程)
      - [3.3.3 产品购买流程](#333-产品购买流程)
      - [3.3.4 帖子发布流程](#334-帖子发布流程)
      - [3.3.5 帖子审核流程](#335-帖子审核流程)
  - [4、系统功能和测试(截图+描述)](#4系统功能和测试截图描述)
    - [4.1 系统功能](#41-系统功能)
    - [4.2 系统测试](#42-系统测试)
    - [4.3 测试截图](#43-测试截图)
      - [4.3.1 系统主题展示](#431-系统主题展示)
      - [4.3.2 多平台兼容性展示](#432-多平台兼容性展示)
      - [4.3.3 登录页面](#433-登录页面)
      - [4.3.4 开户页面](#434-开户页面)
      - [4.3.5 未开户状态页面](#435-未开户状态页面)
      - [4.3.6 首页](#436-首页)
      - [4.3.7 市场页面](#437-市场页面)
      - [4.3.8 CSGO市场页面](#438-csgo市场页面)
      - [4.3.9 虚拟货币页面](#439-虚拟货币页面)
      - [4.3.10 购买页面](#4310-购买页面)
      - [4.3.11 社区页面](#4311-社区页面)
      - [4.3.12 帖子详情页面](#4312-帖子详情页面)
      - [4.3.13 个人中心页面](#4313-个人中心页面)
      - [4.3.14 我的帖子页面](#4314-我的帖子页面)
      - [4.3.15 用户帖子页面](#4315-用户帖子页面)
      - [4.3.16 我收藏的帖子页面](#4316-我收藏的帖子页面)
      - [4.3.17 充值页面](#4317-充值页面)
      - [4.3.18 收益页面](#4318-收益页面)
      - [4.3.19 我收藏的产品页面](#4319-我收藏的产品页面)
      - [4.3.20 我的交易页面](#4320-我的交易页面)
      - [4.3.21 我的消息页面](#4321-我的消息页面)
      - [4.3.22 设置页面](#4322-设置页面)
      - [4.3.23 创建分类页面](#4323-创建分类页面)
      - [4.3.24 API文档界面](#4324-api文档界面)
  - [5、总结与体会](#5总结与体会)
    - [5.1 总结](#51-总结)
    - [5.2 体会](#52-体会)
  - [6、小组分工(写明每位同学承担的工作，按工作量排序，给出占比。例：小A完成需求分析，概要设计和后端编写，（40%）)](#6小组分工写明每位同学承担的工作按工作量排序给出占比例小a完成需求分析概要设计和后端编写40)


## 1、绪论

### 1.1 系统开发背景（结合现实的可用性）

在互联网金融蓬勃发展的背景下，用户对金融服务的需求呈现出多样化、个性化和社区化的趋势。传统金融机构的服务模式在便捷性、个性化推荐和用户互动等方面已难以完全满足现代用户的需求。在此背景下，Southern Money系统应运而生，旨在构建一个集金融交易、产品展示、社区交流于一体的综合性金融服务平台。

系统主要解决以下核心问题：
- 金融产品信息碎片化，用户难以高效获取和比较各类金融产品
- 缺乏基于用户行为和偏好的个性化金融产品推荐机制
- 缺少专业的金融知识交流和分享社区，用户间互动不足
- 金融交易记录管理分散，用户难以全面追踪和分析个人财务状况

Southern Money系统融合了现代金融科技与互联网社区理念，通过技术创新为用户提供安全、便捷、个性化的金融服务体验，助力提升用户金融素养和投资决策能力。

### 1.2 开发环境

| 类别 | 技术/工具 | 版本 |
|------|-----------|------|
| 后端开发语言 | C# | 12.0+ |
| 后端框架 | ASP.NET Core | 10.0+ |
| 前端开发语言 | Dart | 3.0+ |
| 前端框架 | Flutter | 3.0+ |
| 数据库（原型） | SQLite | 3.0+ |
| 数据库（生产） | PostgreSQL | 17.0+ |
| ORM框架 | Entity Framework Core | 6.0+ |
| API文档 | Swagger | 5.0+ |
| 身份认证 | JWT | - |

### 1.3 技术路线

Southern Money系统采用前后端分离的现代化架构设计，具体技术路线如下：

#### 后端架构
   - 基于ASP.NET Core Web API构建高性能RESTful API服务
   - 采用Entity Framework Core实现高效数据库操作和ORM映射
   - 集成JWT身份认证与授权机制，保障API安全访问
   - 实施分层架构设计：Controller层（请求处理）、Service层（业务逻辑）、Repository层（数据访问）
   - 开发中间件组件处理身份验证、异常处理、日志记录等横切关注点
```mermaid
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
    
    %% 样式定义
    classDef controller fill:#e1f5fe
    classDef service fill:#f3e5f5
    classDef repository fill:#e8f5e8
    classDef database fill:#fff3e0
    classDef client fill:#fce4ec
    
    class Controller controller
    class Service service
    class Repository repository
    class Database database
    class Client client
```
系统设计如下
```mermaid
flowchart TD
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
```

#### 前端架构
   - 基于Flutter框架开发跨平台应用，支持Web、Android、iOS、Windows、macOS、Linux六大平台
   - 开发状态管理库实现应用状态的高效管理

实施响应式UI设计，自动适配不同屏幕尺寸和设备类型
||横屏|竖屏|
|:---:|:---:|:---:|
|导航栏|左侧|底部|
|新页面|作为悬浮窗弹出|作为新页面弹出|
|登陆页面|在左侧显示占位填充|直接显示|

采用HTTP2库实现高效HTTP请求处理和拦截器机制，简化了认证流程，并实现JWT令牌自动管理与刷新机制，确保持续安全访问
``` mermaid
graph LR
    Request[发起HTTP请求]-->Interceptor[拦截器：添加访问令牌]
    Interceptor-->Remote[远程资源]
    Remote-->Expire{令牌过期错误？}
    Expire-->|是|TokenRefresh[刷新令牌]
    TokenRefresh-->RefreshResult{刷新成功？}
    RefreshResult-->|成功|Remote
    RefreshResult-->|失败|ErrorHandler[错误处理]
    Expire-->|否|Response[正常响应]
    
    classDef requestNode fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef interceptorNode fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef remoteNode fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef decisionNode fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef refreshNode fill:#e3f2fd,stroke:#0d47a1,stroke-width:2px
    classDef responseNode fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef errorNode fill:#ffebee,stroke:#c62828,stroke-width:2px
    
    class Request requestNode
    class Interceptor interceptorNode
    class Remote remoteNode
    class Expire,RefreshResult decisionNode
    class TokenRefresh refreshNode
    class Response responseNode
    class ErrorHandler errorNode
    
    
```
设计了这些页面，下图描述了这些页面的切换关系：
```mermaid
flowchart LR
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
```
运用依赖注入容器管理应用依赖，实现模块解耦。遵循SOLID原则中的单一职责和依赖倒置，提高系统的可维护性、可测试性和扩展性。
下图依赖关系：
```mermaid
graph TD
       subgraph "核心依赖"
           SP[SharedPreferences] --> TS[TokenService]
           SP --> PS[PasswordService]
           TS --> ACS[AppConfigService]
           PI[PackageInfo] --> VS[VersionService]
       end
       
       subgraph "HTTP客户端"
           DIO[Dio]
           ACS --> JD[JwtDio]
           ALS[ApiLoginService] --> JD
       end
       
       subgraph "API服务"
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
       
```
#### 数据库设计
   - 在开发过程中，采用SQLite数据库进行原型设计和测试；在生产环境中，切换到PostgreSQL数据库以实现高并发和高数据吞吐量。
   - 设计规范化关系型数据模型，优化表结构和关联关系
   - 实现完整的数据完整性约束，确保数据一致性和可靠性

#### 系统安全
   - 采用密码哈希存储技术，保障用户密码安全
   - 开发异常处理中间件，防止敏感信息泄露，提供友好错误提示

实施JWT令牌认证机制，确保API访问安全
   - **认证流程图**：
     ```mermaid
     flowchart LR
         A[接收API请求] --> D{令牌正确?}
         D -->|否| E[继续处理请求，但无用户信息]
         D -->|是| G[提取token]
         G --> H[验证token有效性]
         H -->|无效| E
         H -->|有效| I[获取用户ID和角色信息]
         I --> J[将用户信息存储在HttpContext中]
         J --> K[继续处理请求]
         style A fill:#f9f,stroke:#333,stroke-width:2px
         style H fill:#fc9,stroke:#333,stroke-width:2px
         style I fill:#cfc,stroke:#333,stroke-width:2px
     ```
   - **授权流程图**：
     ```mermaid
     flowchart LR
         A[控制器方法开始执行] --> B{是否需要授权?}
         B -->|否| C[继续执行方法逻辑]
         B -->|是| D{HttpContext中是否包含User信息?}
         D -->|否| E[返回401 Unauthorized]
         D -->|是| F{获取用户角色}
         F --> G{用户是否具有所需角色?}
         G -->|否| H[返回403 Forbidden]
         G -->|是| C
         style A fill:#f9f,stroke:#333,stroke-width:2px
         style E fill:#fcc,stroke:#333,stroke-width:2px
         style H fill:#fcc,stroke:#333,stroke-width:2px
         style C fill:#cfc,stroke:#333,stroke-width:2px
     ```
## 2、概要设计

### 2.1 需求概述（囊括需求清单的内容，按角色分析）

Southern Money系统面向两类主要用户：普通用户和管理员。系统需求根据用户角色进行分析如下：

#### 2.1.1 普通用户需求

1. **用户管理**：
   - 用户注册、登录、密码修改
   - 个人信息编辑（头像、昵称等）
   - 开户功能
   - 查看个人资产和交易记录

2. **金融产品**：
   - 浏览金融产品列表
   - 按分类查看金融产品
   - 搜索金融产品
   - 收藏感兴趣的产品分类
   - 购买金融产品
   - 查看交易记录

3. **社区交流**：
   - 浏览社区帖子
   - 发布帖子（支持文字、图片）
   - 点赞、收藏帖子
   - 评论帖子
   - 搜索帖子
   - 查看个人发布的帖子
   - 查看个人收藏的帖子

4. **通知中心**：
   - 查看系统通知
   - 查看活动通知
   - 标记通知为已读

#### 2.1.2 管理员需求

1. **用户管理**：
   - 查看用户列表
   - 封禁/解封用户
   - 查看用户详情

2. **内容管理**：
   - 审核社区帖子
   - 封禁/解封帖子
   - 查看帖子封禁历史

3. **产品管理**：
   - 查看产品列表
   - 查看产品分类

4. **系统统计**：
   - 查看系统统计数据

### 2.2 系统功能模块图

```mermaid
    graph LR
        A[Southern Money系统] --> B[用户管理模块]
        A --> C[金融产品模块]
        A --> D[交易管理模块]
        A --> E[社区论坛模块]
        A --> F[通知中心模块]
        A --> G[管理员模块]
        
        B --> B1[用户注册/登录]
        B --> B2[个人信息管理]
        B --> B3[开户管理]
        B --> B4[资产查询]
        
        C --> C1[产品分类管理]
        C --> C2[产品列表展示]
        C --> C3[产品搜索]
        C --> C4[产品收藏]
        
        D --> D1[产品购买]
        D --> D2[交易记录查询]
        
        E --> E1[帖子发布/浏览]
        E --> E2[帖子点赞/收藏]
        E --> E3[帖子搜索]
        E --> E4[帖子审核]
        
        F --> F1[通知发送]
        F --> F2[通知管理]
        
        G --> G1[用户管理]
        G --> G2[内容审核]
        G --> G3[系统统计]
```

## 3、详细设计

### 3.1 UI设计

Southern Money系统采用Material Design 3设计风格，这是Google推出的现代化设计语言，主要特点如下：

#### **整体风格**：
   - 基于Material Design 3规范，提供现代化的视觉体验
   - 支持亮色和暗色主题，用户可以根据喜好切换
   - 采用动态颜色系统，基于用户选择的颜色种子生成完整的色彩方案
   - 界面简洁、专业，符合金融应用的视觉需求

#### **主题实现**：
   - 在`main.dart`中通过`ThemeData(colorSchemeSeed: colorSeed, useMaterial3: true)`实现Material Design 3主题
   - 支持动态切换主题颜色，用户可以在设置中选择不同的主题色
   - 自动适配系统的亮色/暗色模式，同时允许用户手动切换

#### 响应式布局

|横屏|竖屏|
|:-:|:-:|
|![登录页面-横屏](login_page_landscape.png)|![登录页面-竖屏](login_page_portrait.png)|



#### **主要页面设计**：
   - **首页**：
     - 顶部显示应用标题和导航栏
     - 中部包含快速导航区，提供开户、CSGO饰品、期货、黄金、虚拟货币等快捷入口
     - 底部显示热门社区帖子，支持下拉刷新
   - **社区页**：
     - 顶部显示社区标题和操作按钮（刷新、搜索、发布）
     - 中部显示帖子列表，支持分页加载和下拉刷新
     - 帖子卡片包含标题、内容摘要、作者、头像等信息
   - **市场页**：
     - 顶部显示行情标题和刷新按钮
     - 中部显示各个分类的行情卡片，包含分类名称、均价和趋势图
     - 支持点击分类进入产品列表
   - **个人中心**：
     - 顶部显示用户头像、昵称和账号状态
     - 中部包含个人菜单，如我的收藏、我的帖子、我的消息、我的交易等
     - 底部显示设置和关于我们等链接
   - **管理员页**：
     - 顶部显示管理员标题
     - 中部包含管理菜单，如用户管理、内容审核、系统统计等
     - 底部显示相关操作按钮

2. **组件设计**：
   - 采用Material 3组件，如NavigationBar、NavigationRail、AppBar、Card、FloatingActionButton等
   - 自定义组件设计，如PostCard、CategoryCard、StockCard等，保持界面一致性
   - 组件支持响应式布局，适配不同屏幕尺寸

3. **交互设计**：
   - 遵循Material Design的交互规范，提供一致的用户体验
   - 流畅的动画效果，如页面切换、按钮点击、下拉刷新等
   - 清晰的导航结构，便于用户快速找到所需功能
   - 友好的错误提示，帮助用户解决问题
   - 支持手势操作，如滑动、长按、捏合等

### 3.2 数据库设计

#### 3.2.1 ER图设计

系统的主要实体及其关系如下：

- **用户（User）**：与帖子（Post）、产品（Product）、交易记录（TransactionRecord）、通知（Notification）、用户资产（UserAsset）、用户收藏分类（UserFavoriteCategory）等实体存在关联
- **帖子（Post）**：与用户（User）、帖子图片（PostImage）、帖子标签（PostTags）、帖子点赞（PostLike）、帖子收藏（PostFavorite）、帖子封禁（PostBlock）等实体存在关联
- **产品（Product）**：与产品分类（ProductCategory）、用户（User）、交易记录（TransactionRecord）等实体存在关联
- **产品分类（ProductCategory）**：与产品（Product）、用户收藏分类（UserFavoriteCategory）等实体存在关联
- **交易记录（TransactionRecord）**：与用户（User）、产品（Product）等实体存在关联
- **通知（Notification）**：与用户（User）等实体存在关联
- **图片（Image）**：与用户（User）、帖子图片（PostImage）等实体存在关联
- **用户资产（UserAsset）**：与用户（User）等实体存在关联
- **用户收藏分类（UserFavoriteCategory）**：与用户（User）、产品分类（ProductCategory）等实体存在关联
- **帖子图片（PostImage）**：与帖子（Post）、图片（Image）等实体存在关联
- **帖子标签（PostTags）**：与帖子（Post）等实体存在关联
- **帖子点赞（PostLike）**：与帖子（Post）、用户（User）等实体存在关联
- **帖子收藏（PostFavorite）**：与帖子（Post）、用户（User）等实体存在关联
- **帖子封禁（PostBlock）**：与帖子（Post）、用户（User）等实体存在关联

```mermaid
erDiagram
     %% 基础实体
     User {
         long Id PK
         string Name
         string Email
         Guid Avatar FK
         decimal Balance
         bool IsAdmin
         bool HasAccount
         DateTime AccountOpenedAt
         bool IsBlocked
         string BlockReason
         DateTime BlockedAt
         DateTime CreateTime
         bool IsDeleted
     }
     
     Post {
         Guid Id PK
         long UploaderUserId FK
         string Title
         string Content
         DateTime CreateTime
         int ReportCount
         int ViewCount
         int LikeCount
         bool IsBlocked
     }
     
     Image {
         Guid Id PK
         long UploaderUserId FK
         string Description
         string ImageType
         byte[] Data
         DateTime CreateTime
     }
     
     Product {
         Guid Id PK
         string Name
         decimal Price
         string Description
         Guid CategoryId FK
         long UploaderUserId FK
         DateTime CreateTime
         bool IsDeleted
     }
     
     ProductCategory {
         Guid Id PK
         string Name
         Guid CoverImageId FK
         DateTime CreateTime
     }
     
     TransactionRecord {
         Guid Id PK
         Guid ProductId FK
         long BuyerUserId FK
         int Quantity
         decimal Price
         decimal TotalPrice
         DateTime PurchaseTime
     }
     
     UserAsset {
         long UserId PK
         decimal Total
         decimal TodayEarn
         decimal AccumulatedEarn
         decimal EarnRate
         decimal Balance
         DateTime UpdatedAt
     }
     
     Notification {
         Guid Id PK
         long UserId FK
         long SubjectUserId FK
         string Content
         string Type
         bool IsRead
         DateTime CreateTime
     }
     
     PostBlock {
         Guid Id PK
         Guid PostId FK
         long AdminUserId FK
         bool IsBlock
         string Reason
         DateTime ActionTime
     }
     PostTag{
         string Tag
     }
     
     %% 外键关系
     Post }o--|| User : "发布者"
     Post }o--|| User : "PostFavorite(收藏帖子)"
     Image }o--|| User : "上传者"
     Product }o--|| User : "上传者"
     Product }o--|| ProductCategory : "分类"
     ProductCategory }o--|| Image : "封面图片"
     TransactionRecord }o--|| User : "购买者"
     TransactionRecord |o--|| Product : "产品"
     UserAsset |o--|| User : ""
     Notification ||--|| User : ""
     PostBlock }o--|| User : "操作管理员"
     PostBlock }o--|| Post : "被封禁帖子"

     User ||--|| Image : "用户头像"
     
     %% 多对多关系（关联表在线上）
     Post ||--o{ Image : "PostImage(帖子包含图片)"
     Post }o--o{ PostTag : ""
     User ||--o{ ProductCategory : "UserFavoriteCategory(用户收藏种类)"
```

#### 3.2.2 数据库表结构

| 表名 | 描述 | 主要字段 |
|------|------|----------|
| Users | 用户信息表 | Id, Name, Email, Avatar, Password, IsAdmin, HasAccount, IsBlocked, BlockReason, BlockedAt, CreateTime, IsDeleted, Balance |
| Images | 图片信息表 | Id, UploaderUserId, CreateTime, Description, ImageType, Data |
| Posts | 帖子信息表 | Id, UploaderUserId, Title, Content, CreateTime, ReportCount, ViewCount, LikeCount, IsBlocked |
| PostImages | 帖子图片关联表 | PostId, ImageId |
| PostTags | 帖子标签表 | PostId, Tag |
| PostLikes | 帖子点赞表 | PostId, UserId, CreateTime |
| PostFavorites | 帖子收藏表 | PostId, UserId, CreateTime |
| PostBlocks | 帖子封禁表 | Id, PostId, AdminUserId, IsBlock, Reason, ActionTime |
| Products | 产品信息表 | Id, Name, Price, Description, CategoryId, UploaderUserId, CreateTime, IsDeleted |
| ProductCategories | 产品分类表 | Id, Name, CoverImageId, CreateTime |
| UserFavoriteCategories | 用户收藏分类表 | UserId, CategoryId, CreateTime |
| TransactionRecords | 交易记录表 | Id, ProductId, BuyerUserId, Quantity, Price, TotalPrice, PurchaseTime |
| UserAssets | 用户资产表 | UserId, Total, TodayEarn, AccumulatedEarn, EarnRate, Balance, UpdatedAt |
| Notifications | 通知表 | Id, UserId, SubjectUserId, Content, Type, IsRead, CreateTime |

#### 3.2.3 数据库数据样例

1. **Users表样例数据**：

| Id | Name | Email | IsAdmin | HasAccount | CreateTime |
|----|------|-------|---------|------------|------------|
| 1 | admin | admin@example.com | 1 | 1 | 2023-01-01 00:00:00 |
| 2 | user1 | user1@example.com | 0 | 1 | 2023-01-02 00:00:00 |
| 3 | user2 | user2@example.com | 0 | 0 | 2023-01-03 00:00:00 |

2. **Products表样例数据**：

| Id | Name | Price | Description | CategoryId | UploaderUserId | CreateTime |
|----|------|-------|-------------|------------|----------------|------------|
| 1 | 黄金产品 | 1800.00 | 投资黄金产品 | 1 | 1 | 2023-01-01 00:00:00 |
| 2 | 原油产品 | 65.50 | 投资原油产品 | 2 | 1 | 2023-01-02 00:00:00 |
| 3 | 美元产品 | 7.20 | 投资美元产品 | 3 | 1 | 2023-01-03 00:00:00 |

3. **ProductCategories表样例数据**：

| Id | Name | CoverImageId | CreateTime |
|----|------|--------------|------------|
| 1 | 黄金 | image_guid_1 | 2023-01-01 00:00:00 |
| 2 | 原油 | image_guid_2 | 2023-01-01 00:00:00 |
| 3 | 外汇 | image_guid_3 | 2023-01-01 00:00:00 |

### 3.3 功能模块流程图or时序图（对2.2中的系统功能模块图中的子功能展开分析）

#### 3.3.1 用户注册流程

```mermaid
flowchart LR
    A[开始] --> B[输入注册信息]
    B --> C[前端验证]
    C --> D{验证通过?}
    D -->|是| E[调用注册API]
    D -->|否| B
    E --> F[后端验证]
    F --> G{验证通过?}
    G -->|是| H[创建用户]
    G -->|否| I[返回错误信息]
    H --> J[返回结果]
    I --> K[结束]
    J --> K[结束]
```

#### 3.3.2 用户登录流程

```mermaid
flowchart LR
    A[开始] --> B[输入登录信息]
    B --> C[前端验证]
    C --> D{验证通过?}
    D -->|是| E[调用登录API]
    D -->|否| B
    E --> F[后端验证]
    F --> G{验证通过?}
    G -->|是| H[生成JWT令牌]
    G -->|否| I[返回错误信息]
    H --> J[返回结果]
    J --> K[存储令牌]
    I --> L[结束]
    K --> L[结束]
```

#### 3.3.3 产品购买流程
针对产品购买这种涉及多个操作的流程，我们需要考虑事务的一致性和并发性。以下是一个基于Mermaid语法的流程图，展示了产品购买的详细流程：
```mermaid
flowchart LR
   A[开始事务] --> B{验证商品存在?}
   B -->|是| C{验证购买者不是所有者?}
   B -->|否| Z[抛出异常]
   C -->|是| D[计算总价]
   C -->|否| Z
   D --> E{检查购买者余额?}
   E -->|足够| Node{执行}
   E -->|不足| Z
   Node --> F[扣除购买者余额]
   Node --> G[增加销售者余额]
   Node --> H[更新销售者收益]
   Node --> I[标记商品为已删除]
   Node --> J[创建交易记录]
   F --> L
   G --> L
   H --> L
   I --> L
   J --> L[提交事务]
   L --> M{修改成功？}
   M --是--> N[成功]
   M --否--> roll[回滚事务]

   Z --> O[终止]

   style A fill:#f9f,stroke:#333,stroke-width:2px
   style N fill:#cfc,stroke:#333,stroke-width:2px
   style roll fill:#fcc,stroke:#333,stroke-width:2px
```

#### 3.3.4 帖子发布流程

```mermaid
flowchart LR
    A[开始] --> B[输入帖子内容]
    B --> C[选择图片（可选）]
    C --> D[输入标签（可选）]
    D --> E[前端验证]
    E --> F{验证通过?}
    F -->|是| G[调用发布API]
    F -->|否| B
    G --> H[后端验证]
    H --> I{验证通过?}
    I -->|是| J[创建帖子]
    I -->|否| K[返回错误信息]
    J --> L{有图片?}
    L -->|是| M[处理图片]
    L -->|否| N{有标签?}
    M --> N
    N -->|是| O[处理标签]
    N -->|否| P[返回结果]
    O --> P
    K --> Q[结束]
    P --> Q[结束]
```

#### 3.3.5 帖子审核流程

```mermaid
flowchart LR
    A[开始] --> B[管理员查看待审核帖子]
    B --> C[审核帖子内容]
    C --> D{决定通过或封禁?}
    D -->|通过| E[调用审核API - 通过]
    D -->|封禁| F[调用审核API - 封禁]
    E --> G[后端处理]
    F --> G
    G --> H[更新帖子状态]
    H --> I[记录审核历史]
    I --> J[发送通知]
    J --> K[返回结果]
    K --> L[结束]
```

## 4、系统功能和测试(截图+描述)

### 4.1 系统功能

1. **用户认证功能**：
   - 支持用户注册、登录、密码修改
   - 实现了JWT令牌认证机制，确保API访问安全
   - 支持自动登录和令牌刷新

2. **金融产品功能**：
   - 支持产品浏览、分类查看、搜索等功能
   - 实现了产品购买和交易记录管理
   - 支持产品收藏和分类收藏

3. **社区交流功能**：
   - 支持帖子发布、浏览、点赞、收藏等功能
   - 实现了帖子搜索和分类筛选
   - 支持帖子评论和管理

4. **通知中心功能**：
   - 支持系统通知和活动通知
   - 实现了通知的标记和管理

5. **管理员功能**：
   - 支持用户管理和内容审核
   - 实现了系统统计和监控

### 4.2 系统测试

1. **功能测试**：
   - 测试了所有功能模块的基本功能
   - 验证了各个功能之间的交互
   - 测试了边界条件和异常情况

2. **性能测试**：
   - 测试了系统在高并发情况下的性能
   - 验证了系统的响应时间和吞吐量
   - 测试了系统的稳定性和可靠性

3. **兼容性测试**：
   - 测试了系统在不同设备和平台上的兼容性
   - 验证了系统在不同浏览器和操作系统上的表现
   - 测试了系统在不同网络环境下的可用性

4. **安全性测试**：
   - 测试了系统的身份认证和授权机制
   - 验证了系统的输入验证和输出编码
   - 测试了系统的敏感信息保护

### 4.3 测试截图

#### 4.3.1 系统主题展示

系统支持亮色和暗色主题切换，用户可以根据个人喜好和使用环境选择合适的主题模式。

<table>
  <tr>
    <td style="text-align: center;">
      <img src="lightmode.png" alt="亮色主题" width="400"/>
      <br>亮色主题
    </td>
    <td style="text-align: center;">
      <img src="darkmode.png" alt="暗色主题" width="400"/>
      <br>暗色主题
    </td>
  </tr>
</table>

#### 4.3.2 多平台兼容性展示

系统基于Flutter框架开发，支持多平台运行，包括Android、Web和Windows等平台，确保用户在不同设备上都能获得一致的使用体验。

<table>
  <tr>
    <td style="text-align: center;">
      <img src="devices/android.jpg" alt="Android平台展示" width="300"/>
      <br>Android平台展示
    </td>
    <td style="text-align: center;">
      <img src="devices/web.png" alt="Web平台展示" width="300"/>
      <br>Web平台展示
    </td>
    <td style="text-align: center;">
      <img src="devices/windows.png" alt="Windows平台展示" width="300"/>
      <br>Windows平台展示
    </td>
  </tr>
</table>

#### 4.3.3 登录页面

登录页面支持用户名和密码登录，同时提供注册新用户功能。页面采用响应式设计，能够适配不同屏幕尺寸和方向。

|横屏|竖屏|
|:-:|:-:|
|![登录页面-横屏](login_page_landscape.png)|![登录页面-竖屏](login_page_portrait.png)|

#### 4.3.4 开户页面

开户页面为用户提供账户创建功能，用户可以填写必要信息完成开户流程，享受完整的金融服务。

![开户页面](open_account_page.png)

#### 4.3.5 未开户状态页面

未开户状态页面提示用户需要先开户才能使用完整的金融服务功能。

![未开户状态页面](without_open_account.png)

#### 4.3.6 首页

首页是用户进入系统后的主要界面，提供了各种金融产品的快捷入口和热门社区帖子展示。

![首页](home_page.png)

#### 4.3.7 市场页面

市场页面显示各类金融产品的分类和价格信息，用户可以浏览不同类别的产品，查看详情并进行交易。

![市场页面](market_page.png)

#### 4.3.8 CSGO市场页面

CSGO市场页面展示各类CSGO饰品的分类和价格信息，用户可以浏览和购买。

![CSGO市场页面](csgo_market_page.png)

#### 4.3.9 虚拟货币页面

虚拟货币页面展示各类虚拟货币的价格和趋势信息，用户可以浏览和购买。

![虚拟货币页面](virtual_money_page.png)

#### 4.3.10 购买页面

购买页面允许用户查看产品详情并进行购买操作。

![购买页面](buy_page.png)

#### 4.3.11 社区页面

社区页面展示用户发布的帖子列表，支持帖子浏览、搜索和筛选功能。用户可以查看热门帖子，也可以发布自己的内容。

![社区页面](neighborhood_page.png)

#### 4.3.12 帖子详情页面

帖子详情页面展示完整的帖子内容，包括文字、图片、评论等信息。

![帖子详情页面](post_detail.png)

#### 4.3.13 个人中心页面

个人中心页面展示用户的个人信息和各种功能入口，方便用户管理自己的账户和资产。

![个人中心页面](selfpage.png)

#### 4.3.14 我的帖子页面

我的帖子页面展示用户自己发布的所有帖子，方便用户管理和查看。

![我的帖子页面](my_post.png)

#### 4.3.15 用户帖子页面

用户帖子页面展示用户自己发布的帖子内容，方便用户管理和查看自己的社区贡献。

![用户帖子页面](post_page_by_user.png)

#### 4.3.16 我收藏的帖子页面

我收藏的帖子页面展示用户收藏的所有帖子，方便用户快速访问感兴趣的内容。

![我收藏的帖子页面](my_star_post.png)

#### 4.3.17 充值页面

充值页面允许用户向自己的账户充值资金，用于购买金融产品。

![充值页面](adding_money.png)

#### 4.3.18 收益页面

收益页面展示用户的资产收益情况，包括今日收益、累计收益和收益率等信息。

![收益页面](my_yield.png)

#### 4.3.19 我收藏的产品页面

我收藏的产品页面展示用户收藏的所有产品，方便用户快速访问感兴趣的金融产品。

![我收藏的产品页面](my_star_product.png)

#### 4.3.20 我的交易页面

我的交易页面展示用户的所有交易记录，包括购买的产品、交易时间和金额等信息。

![我的交易页面](my_transaction.png)

#### 4.3.21 我的消息页面

我的消息页面展示系统发送给用户的通知和消息，包括系统通知、活动通知等。

![我的消息页面](my_message.png)

#### 4.3.22 设置页面

设置页面允许用户自定义系统主题、管理通知偏好、修改密码等。

![设置页面](my_setting.png)

#### 4.3.23 创建分类页面

创建分类页面允许管理员创建新的产品分类，用于管理金融产品。

![创建分类页面](create_category_page.png)

#### 4.3.24 API文档界面

系统提供完整的API文档，基于Swagger UI实现。并为swagger集成了javascript脚本，使其支持JWT认证。方便开发者了解和使用系统的API接口。

![Swagger UI界面](swagger_ui.png)

## 5、总结与体会

### 5.1 总结

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

### 5.2 体会

通过开发Southern Money系统，我们学到了以下经验和体会：

1. **前后端分离架构的优势**：
   - 提高了开发效率，前后端可以并行开发
   - 增强了系统的可扩展性，便于后续功能扩展
   - 提高了系统的可维护性，便于代码管理和测试

2. **跨平台开发的便利性**：
   - 使用Flutter框架可以快速开发跨平台应用
   - 减少了开发成本，提高了开发效率
   - 便于应用的推广和使用

3. **安全性设计的重要性**：
   - 系统需要考虑各种安全风险，如身份认证、授权、输入验证等
   - 采用JWT令牌认证机制可以提高系统的安全性
   - 实现了完整的错误处理和日志记录，便于系统监控和调试

4. **性能优化的必要性**：
   - 系统需要考虑性能问题，如响应时间、吞吐量、并发处理等
   - 采用缓存机制和异步处理可以提高系统的性能
   - 优化数据库查询和索引设计可以提高数据访问效率

5. **用户体验设计的重要性**：
   - 系统需要考虑用户体验，如界面设计、交互流程、响应速度等
   - 采用现代化的UI设计可以提高用户体验
   - 实现了响应式布局，适配不同屏幕尺寸，便于用户使用

## 6、小组分工(写明每位同学承担的工作，按工作量排序，给出占比。例：小A完成需求分析，概要设计和后端编写，（40%）)

- 小A：完成需求分析，概要设计和后端编写，（40%）
- 小B：完成详细设计，前端实现和测试，（40%）
- 小C：完成数据库设计，系统测试和文档编写，（20%）

通过小组协作，我们成功完成了Southern Money系统的开发。在开发过程中，我们遇到了各种挑战和问题，但通过团队合作和技术学习，我们成功解决了这些问题，提高了系统的质量和性能。

未来，我们将继续优化和扩展系统功能，提高系统的安全性和可靠性，为用户提供更好的服务和体验。

