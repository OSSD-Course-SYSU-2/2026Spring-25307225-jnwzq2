# 技能五子棋 (JNWZQ)

一款基于 HarmonyOS 开发的创新五子棋游戏，融入了独特的技能卡牌系统，为经典五子棋增添了策略深度和趣味性。

## 项目简介

本项目是一个运行在 HarmonyOS 平台上的五子棋对战游戏。除了传统的黑白双方轮流落子玩法外，还引入了**能量系统**和**技能卡牌机制**，让游戏策略更加丰富多变。

### 核心特色

- 🎮 **经典玩法**：15×15 标准棋盘，黑白双方对战
- ⚡ **能量系统**：每落一子获得 1 点能量（上限 5 点）
- 🃏 **技能卡牌**：三种独特技能，扭转战局
- 🎨 **精美界面**：HarmonyOS 原生 UI，流畅交互体验

## 技能卡牌介绍

| 技能名称 | 能量消耗 | 效果描述 |
|---------|---------|---------|
| **镜花水月** | 5 点 | 放置幻影棋子，2 回合后消失，期间参与胜利判定 |
| **飞沙走石** | 4 点 | 移除棋盘上任意一颗棋子 |
| **画地为牢** | 2 点 | 封锁指定空位 3 回合，期间不可落子 |

### 技能使用策略

- **镜花水月**：可用于快速形成连线或干扰对手判断，但需注意幻影棋子会消失
- **飞沙走石**：移除对手关键棋子，破坏其连势，或移除自己的失误落子
- **画地为牢**：封锁战略要地，限制对手落子选择

## 技术架构

### 开发环境

- **开发框架**：HarmonyOS Native (ArkUI)
- **开发语言**：ArkTS (TypeScript 扩展)
- **目标 SDK**：HarmonyOS 6.0.2 (API 22)
- **构建工具**：Hvigor
- **测试框架**：Hypium + Hamock

### 项目结构

```
jnwzq/
├── AppScope/                 # 应用全局配置
│   └── app.json5            # 应用配置（包名、版本等）
├── entry/                   # 主模块
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/
│   │   │   │   ├── entryability/      # 应用入口
│   │   │   │   │   └── EntryAbility.ets
│   │   │   │   └── pages/             # 页面组件
│   │   │   │       ├── Index.ets      # 主页（游戏入口）
│   │   │   │       ├── GomokuGame.ets # 游戏主界面
│   │   │   │       └── TestGomoku.ets # 测试页面
│   │   │   └── module.json5           # 模块配置
│   │   └── test/                      # 测试代码
│   └── build-profile.json5            # 模块构建配置
├── build-profile.json5      # 应用构建配置
├── oh-package.json5         # 依赖管理
└── hvigorfile.ts           # 构建脚本
```

### 核心技术实现

#### 1. 状态管理

使用 `@State` 装饰器实现响应式状态管理：

```typescript
@State chessBoard: number[][] = [];      // 棋盘状态
@State currentPlayer: number = 1;        // 当前玩家
@State energy: number[] = [0, 0];        // 双方能量值
@State gameMode: string = 'normal';      // 游戏模式
```

#### 2. 棋盘渲染

采用 `ForEach` 循环渲染棋盘网格：

```typescript
ForEach([0, 1, 2, ...], (row: number) => {
  Row() {
    ForEach([0, 1, 2, ...], (col: number) => {
      // 渲染棋盘格子
    })
  }
})
```

#### 3. 胜负判定

支持包含幻影棋子的连珠判定，检查四个方向（水平、垂直、两条对角线）。

#### 4. 技能系统

通过 `gameMode` 状态切换不同的点击处理逻辑：

- `normal`：正常落子
- `skill_fly`：飞沙走石（移除棋子）
- `skill_mirror`：镜花水月（放置幻影）
- `skill_prison`：画地为牢（封锁位置）

## 安装与运行

### 前置要求

- DevEco Studio 4.0 或更高版本
- HarmonyOS SDK 6.0.2 (API 22)
- Node.js 14.x 或更高版本

### 构建步骤

1. **克隆项目**
   ```bash
   git clone <项目地址>
   cd jnwzq
   ```

2. **安装依赖**
   ```bash
   ohpm install
   ```

3. **打开项目**
   - 使用 DevEco Studio 打开项目目录
   - 等待项目初始化完成

4. **运行应用**
   - 连接 HarmonyOS 设备或启动模拟器
   - 点击运行按钮或使用快捷键 `Shift + F10`

### 构建命令

```bash
# 调试构建
hvigorw assembleHap --mode module -p product=default

# 发布构建
hvigorw assembleHap --mode module -p product=default -p buildMode=release
```

## 游戏规则

### 基本规则

1. 黑方先手，双方轮流落子
2. 每落一子获得 1 点能量，能量上限为 5 点
3. 先在横、竖、斜方向连成五子者获胜
4. 使用技能会消耗对应能量，并强制结束当前回合

### 特殊规则

- **幻影棋子**：可参与连珠判定，但 2 回合后会消失
- **禁地**：被封锁的位置在 3 回合内无法落子
- **技能使用**：使用技能后立即切换回合，对手获得行动权

## 开发说明

### 扩展技能

如需添加新技能，在 `GomokuGame.ets` 中：

1. 在 `skills` 数组中添加技能定义：
   ```typescript
   { name: '新技能', cost: 3, mode: 'skill_new', desc: '技能描述' }
   ```

2. 在 `onGridClick` 方法中添加处理分支：
   ```typescript
   case 'skill_new':
     this.handleSkillNew(row, col);
     break;
   ```

3. 实现具体的技能处理方法 `handleSkillNew`

### 自定义棋盘

修改以下常量可自定义棋盘：

```typescript
private readonly BOARD_SIZE: number = 15;  // 棋盘大小
private readonly CELL_SIZE: number = 24;   // 格子大小
private readonly BOARD_COLOR: string = '#DEB887'; // 棋盘颜色
```

## 版本历史

### v1.0.0 (当前版本)

- ✅ 实现基础五子棋玩法
- ✅ 集成能量系统
- ✅ 实现三种技能卡牌
- ✅ 添加幻影棋子和禁地机制
- ✅ 优化 UI 交互体验

## 贡献指南

欢迎提交 Issue 和 Pull Request 来改进项目！

### 开发建议

1. 遵循 ArkTS 编码规范
2. 使用 `@State` 管理响应式状态
3. 保持组件职责单一
4. 添加必要的日志输出便于调试

## 许可证

本项目仅供学习和研究使用。

## 联系方式

如有问题或建议，欢迎通过 Issue 与我们交流。

---

**Enjoy the game! 🎮**
