# 南方财富 (Southern Money)

一个功能丰富的金融投资移动应用，提供股票行情、社区讨论、投资组合管理等核心功能。

## 📱 应用截图

*（请在此处添加应用截图）*

## ✨ 主要功能

### 🏠 首页
- 投资概览和快速入口
- 个性化推荐内容
- 实时市场动态

### 💬 社区
- 投资交流社区
- 用户发帖和讨论
- 社区搜索功能
- 消息通知系统

### 📈 行情中心
- 实时股票行情
- 加密货币价格
- 期货市场数据
- 黄金价格监控
- 珠宝行情信息
- 市场搜索功能

### 👤 个人中心
- 用户资料管理
- 我的收藏
- 我的选择
- 交易记录
- 应用设置

## 🛠️ 技术特性

- **跨平台**: 基于Flutter开发，支持iOS、Android、Web、macOS、Windows、Linux
- **响应式设计**: 支持横屏和竖屏模式自适应布局
- **主题定制**: 支持自定义主题色彩
- **本地存储**: 使用SharedPreferences进行数据持久化
- **Material Design 3**: 采用最新的Material You设计规范

## 🚀 快速开始

### 环境要求

- Flutter SDK
- Dart SDK

### 安装步骤

1. **克隆项目**
```bash
git clone <项目仓库地址>
cd southern_money
```

2. **安装依赖**
```bash
flutter pub get
```

3. **运行应用**
```bash
# 运行到模拟器/设备
flutter run

# 构建Web版本
flutter build web

# 构建Android APK
flutter build apk

# 构建iOS应用
flutter build ios
```

## 📁 项目结构

```
lib/
├── main.dart              # 应用入口
├── pages/                 # 页面文件
│   ├── home_page.dart     # 首页
│   ├── community_page.dart # 社区页
│   ├── market_page.dart   # 行情页
│   ├── profile_page.dart  # 个人中心
│   ├── login_page.dart    # 登录页
│   └── ...               # 其他功能页面
├── widgets/              # 通用组件
│   ├── common_widget.dart # 公共组件
│   ├── index_card.dart    # 指数卡片
│   ├── post_card.dart     # 帖子卡片
│   └── ...               # 其他组件
└── setting/              # 应用配置
    ├── app_config.dart    # 应用配置
    ├── ensure_initialized.dart # 初始化逻辑
    └── version.dart       # 版本信息
```

## 🎨 功能特性

### 界面设计
- 现代化的Material Design 3界面
- 深色/浅色主题支持
- 自定义主题色彩
- 响应式布局适配

### 导航体验
- 底部导航栏（移动端）
- 侧边导航栏（横屏模式）
- 流畅的页面切换动画

### 用户体验
- 登录认证系统
- 本地数据缓存
- 流畅的操作体验
- 适配多种屏幕尺寸

## 📱 支持平台

- ✅ Android (API 21+)
- ✅ iOS (iOS 11.0+)
- ✅ Web浏览器
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🤝 贡献指南

欢迎提交Issue和Pull Request来帮助改进项目！

### 开发规范

1. 遵循Dart代码规范
2. 使用flutter_lints进行代码检查
3. 编写有意义的提交信息
4. 确保所有测试通过

---

*Made with ❤️ using Flutter*