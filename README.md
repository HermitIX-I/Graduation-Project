# Health Management System

基于 Android 的个人健康管理应用系统，包含移动端 APP、管理后台和后端服务。

## 🏗️ 技术栈

### 后端服务 (HealthManager)
| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.3.8 | 后端框架 |
| Kotlin | 1.9.22 | 开发语言 |
| MyBatis-Plus | 3.5.9 | ORM 框架 |
| MySQL | 8.0+ | 关系型数据库 |
| Redis | 7.0+ | 缓存数据库 |
| JWT | 0.11.5 | 身份认证 |
| Knife4j | 4.4.0 | API 文档 |
| Hutool | 5.8.28 | 工具类库 |

### 移动端 APP (HealthManage)
| 技术 | 说明 |
|------|------|
| Android SDK | API 23+ |
| Kotlin | 开发语言 |
| Navigation Component | 页面导航 |
| Retrofit | 网络请求 |
| Room | 本地数据库 |
| MPAndroidChart | 图表展示 |

### 管理后台 (Backend Management System)
| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5+ | 前端框架 |
| Element Plus | 2.13+ | UI 组件库 |
| Vite | 8.0+ | 构建工具 |
| Pinia | 3.0+ | 状态管理 |
| Vue Router | 4.6+ | 路由管理 |
| ECharts | 6.0+ | 数据可视化 |
| Axios | 1.15+ | HTTP 客户端 |

## 📁 项目结构

```
Graduation-Project/
├── Project/
│   ├── Backend Management System/    # 管理后台 (Vue 3)
│   │   ├── src/
│   │   │   ├── api/                  # API 接口
│   │   │   ├── components/           # 组件
│   │   │   ├── router/               # 路由配置
│   │   │   ├── stores/               # 状态管理
│   │   │   ├── utils/                # 工具函数
│   │   │   └── views/                # 页面视图
│   │   └── package.json
│   │
│   ├── HealthManage/                 # Android 移动端
│   │   ├── app/
│   │   │   └── src/main/
│   │   │       ├── java/com/rql/healthmanage/
│   │   │       │   ├── common/       # 公共模块
│   │   │       │   ├── recommend/    # 推荐算法
│   │   │       │   └── util/         # 工具类
│   │   │       └── res/              # 资源文件
│   │   └── build.gradle.kts
│   │
│   ├── HealthManager/                # 后端服务 (Spring Boot)
│   │   ├── src/main/kotlin/com/rql/healthmanage/
│   │   │   ├── controller/           # 控制器
│   │   │   ├── service/              # 服务层
│   │   │   ├── mapper/               # 数据访问层
│   │   │   ├── entity/               # 实体类
│   │   │   ├── dto/                  # 数据传输对象
│   │   │   ├── config/               # 配置类
│   │   │   └── util/                 # 工具类
│   │   └── pom.xml
│   │
│   └── healthmanage.sql              # 数据库初始化脚本
└── README.md
```

## 🎯 功能模块

### 用户端功能
- **用户注册/登录** - 手机号注册、登录认证
- **健康数据管理** - 身高体重、血压血糖、心率等数据记录
- **运动计划** - 运动类型选择、计划制定、打卡记录
- **健康评估** - 中医体质辨识、健康状态评估
- **社交互动** - 动态发布、评论、关注
- **AI 健康建议** - 基于 DeepSeek 的智能健康建议
- **食谱推荐** - 个性化食谱推荐
- **视频学习** - 健康知识视频

### 管理端功能
- **用户管理** - 用户列表、信息查看、状态管理
- **内容管理** - 食谱审核、视频审核、规则配置
- **社交管理** - 动态审核、评论管理
- **系统管理** - 公告管理、操作日志
- **数据统计** - 用户活跃度、健康数据分析

## 🚀 快速开始

### 环境要求
- JDK 17+
- Node.js 18+
- MySQL 8.0+
- Redis 7.0+
- Android Studio 2023+

### 1. 后端服务启动

```bash
# 进入后端目录
cd Project/HealthManager

# 创建数据库
mysql -u root -p
CREATE DATABASE healthmanage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 导入数据
mysql -u root -p healthmanage < ../healthmanage.sql

# 配置环境变量
export DB_USERNAME=root
export DB_PASSWORD=your_password
export JWT_SECRET=your_jwt_secret
export DEEPSEEK_API_KEY=your_api_key (可选)

# 启动服务
mvn spring-boot:run
```

**服务访问地址**：
- API 接口：http://localhost:8081
- API 文档：http://localhost:8081/doc.html

### 2. 管理后台启动

```bash
# 进入管理后台目录
cd Project/Backend Management System

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

**访问地址**：http://localhost:5173

### 3. 移动端运行

1. 打开 Android Studio
2. 导入 `Project/HealthManage` 项目
3. 等待 Gradle 同步完成
4. 配置后端 API 地址
5. 运行到模拟器或真机

## 🔧 配置说明

### 后端配置 (application.properties)

后端配置文件已排除敏感信息，请通过环境变量配置：

| 环境变量 | 默认值 | 说明 |
|----------|--------|------|
| DB_USERNAME | root | 数据库用户名 |
| DB_PASSWORD | - | 数据库密码 |
| JWT_SECRET | - | JWT 密钥 |
| DEEPSEEK_API_KEY | - | DeepSeek API Key (可选) |

### 前端代理配置

管理后台通过 Vite 代理转发请求到后端：

```javascript
// vite.config.js
server: {
  proxy: {
    '/api': {
      target: 'http://localhost:8081',
      changeOrigin: true
    }
  }
}
```

## 📋 API 接口

### 认证接口
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/user/register` | 用户注册 |
| POST | `/api/user/login` | 用户登录 |
| POST | `/api/admin/login` | 管理员登录 |

### 健康数据接口
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/health-data` | 新增健康数据 |
| GET | `/api/health-data/list` | 查询健康数据列表 |
| GET | `/api/health-data/trend` | 获取健康趋势 |

### 运动接口
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/sport/plan` | 创建运动计划 |
| GET | `/api/sport/plan/list` | 查询运动计划 |
| POST | `/api/sport/record` | 记录运动打卡 |

### 社交接口
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/social/post` | 发布动态 |
| GET | `/api/social/post/list` | 查询动态列表 |
| POST | `/api/social/comment` | 发表评论 |

### AI 建议接口
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/ai/advice` | 获取 AI 健康建议 |

**完整 API 文档**：http://localhost:8081/doc.html

## 🧪 测试

### 后端测试

```bash
cd Project/HealthManager
mvn test
```

### 前端测试

```bash
cd Project/Backend Management System
npm test
```

## 📦 构建

### 后端构建

```bash
cd Project/HealthManager
mvn clean package
```

### 前端构建

```bash
cd Project/Backend Management System
npm run build
```

### Android 构建

通过 Android Studio 构建 APK 或 App Bundle。

## 📄 许可证

MIT License

## 📧 联系方式

如有问题，请联系开发者。
