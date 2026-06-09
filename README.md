# 五子棋游戏 (Gomoku Game)

一个基于 HarmonyOS 开发的五子棋游戏，支持跨设备协同和无缝流转体验。

## 项目简介

本项目是一个完整的五子棋游戏应用，集成了 HarmonyOS 的分布式能力，实现了"一次开发多端部署"和"自由流转"两大核心特性。玩家可以在手机、平板、PC 等多种设备上无缝切换游戏，享受一致的游戏体验。

## 核心功能

### 🎮 游戏模式

#### ♟️ 普通版
- **经典五子棋玩法**：双人对战，先连成五子者获胜
- 简洁的界面设计
- 专注于纯粹的策略对战

#### ✨ 技能版
- **技能卡牌系统**：三种独特技能，增加策略深度
- **能量系统**：每落一子获得1点能量（上限5点）
- **战术组合**：合理搭配技能扭转战局

### 🃏 技能卡牌详解

#### 🌪️ 飞沙走石 (4能量)
- **类型**：战术技能
- **效果**：移除棋盘上任意一颗棋子（包括对手的）
- **策略**：破坏对手的连珠布局，创造新的机会
- **使用场景**：对手即将连成五子时紧急防守，或移除阻挡己方的棋子

#### 🔮 镜花水月 (5能量)
- **类型**：策略技能
- **效果**：在空位放置幻影棋子，3回合后消失
- **特性**：幻影棋子参与胜利判定
- **策略**：虚张声势，迷惑对手，创造假象
- **使用场景**：制造虚假威胁，迫使对手防守，实则另有布局

#### 🔒 画地为牢 (2能量)
- **类型**：防守技能
- **效果**：封锁任意空位3回合
- **特性**：期间双方都无法在该位置落子
- **策略**：限制对手的落子选择，保护关键位置
- **使用场景**：封锁对手的必胜点，或保护己方的连珠延伸点

### 📱 一次开发多端部署

本项目实现了完整的"一次开发多端部署"能力，支持以下设备类型：
- **手机 (Phone)**：优化的移动端体验
- **平板 (Tablet)**：适配大屏幕显示
- **PC/2in1**：桌面级交互体验

#### 技术实现
1. **多设备配置**
   - 在 `module.json5` 中配置支持多种设备类型
   - 使用响应式布局适配不同屏幕尺寸

2. **断点系统**
   - 实现了完整的断点机制（SM/MD/LG）
   - 根据屏幕宽度自动调整UI布局
   - 文件：`entry/src/main/ets/common/BreakpointSystem.ets`

3. **设备适配**
   - 自动检测设备类型
   - 根据设备特性调整棋盘大小、字体大小等
   - 文件：`entry/src/main/ets/common/DeviceAdapter.ets`

### 🔄 自由流转

实现了 HarmonyOS 的分布式流转能力，支持跨设备无缝游戏体验：

#### 应用接续
- **游戏状态保存**：自动保存当前游戏进度
- **跨设备恢复**：在其他设备上继续当前游戏
- **无缝切换**：游戏进度、棋盘状态完整同步

#### 技术实现
1. **应用接续配置**
   - 在 `module.json5` 中启用 `continuable: true`
   - 实现 `onContinue` 方法保存游戏状态
   - 在 `onCreate` 中处理接续恢复逻辑

2. **分布式权限**
   - 配置 `ohos.permission.DISTRIBUTED_DATASYNC` 权限
   - 支持跨设备数据同步

3. **流转管理**
   - 设备发现与管理
   - 游戏状态同步
   - 文件：`entry/src/main/ets/common/DistributedGameManager.ets`

## 项目结构

```
entry/src/main/
├── ets/
│   ├── common/                    # 公共工具类
│   │   ├── BreakpointSystem.ets   # 断点系统
│   │   ├── DeviceAdapter.ets      # 设备适配工具
│   │   └── DistributedGameManager.ets  # 分布式流转管理
│   ├── entryability/
│   │   └── EntryAbility.ets       # 应用入口（含接续逻辑）
│   └── pages/
│       ├── Index.ets              # 主页面（游戏模式选择）
│       ├── GomokuGame.ets         # 游戏主界面
│       └── TestGomoku.ets         # 测试页面
├── resources/                      # 资源文件
└── module.json5                   # 模块配置（含多设备支持）
```

## 技术特性

### 1. 响应式布局
- 使用 `GridRow` / `GridCol` 实现栅格布局
- 断点范围：
  - SM: 320vp - 600vp (手机)
  - MD: 600vp - 840vp (折叠屏/小平板)
  - LG: 840vp+ (平板/PC)

### 2. 设备能力适配
- 自动检测设备类型
- 动态调整UI元素尺寸
- 优化不同设备的交互体验

### 3. 分布式能力
- **应用接续**：跨设备无缝切换
- **设备发现**：自动发现组网设备
- **状态同步**：游戏进度实时同步

### 4. UI/UX 优化
- **下拉滚动**：主页面支持滚动浏览
- **技能介绍**：详细的技能说明和使用提示
- **视觉反馈**：当前玩家指示、能量条动画
- **模式切换**：流畅的游戏模式选择体验

## 使用说明

### 环境要求
- HarmonyOS SDK API 12+
- DevEco Studio 4.0+
- 支持的设备：手机、平板、PC/2in1

### 安装运行
1. 使用 DevEco Studio 打开项目
2. 连接 HarmonyOS 设备或启动模拟器
3. 点击运行按钮安装应用

### 游戏操作

#### 选择游戏模式
1. 启动应用后，在主页面选择游戏模式
   - **普通版**：经典五子棋，无技能系统
   - **技能版**：包含技能卡牌和能量系统
2. 点击"开始游戏"按钮进入游戏

#### 普通版玩法
- 点击棋盘空位落子
- 黑方先行，双方轮流落子
- 先连成五子者获胜

#### 技能版玩法
1. **落子**：点击棋盘空位落子，获得1点能量
2. **使用技能**：
   - 点击技能按钮（能量足够时高亮）
   - 再点击棋盘目标位置完成技能施放
3. **技能效果**：
   - 飞沙走石：点击要移除的棋子
   - 镜花水月：点击空位放置幻影
   - 画地为牢：点击空位进行封锁

### 跨设备流转
1. 确保两台设备登录同一华为账号
2. 开启设备的 Wi-Fi 和蓝牙
3. 在一台设备上开始游戏
4. 点击设备的流转图标或使用系统流转功能
5. 选择目标设备完成游戏接续

## 更新日志

### v1.2.0 (2026-06-09)
#### 新增功能
- ✨ 游戏模式选择系统
  - 新增普通版模式（经典五子棋）
  - 新增技能版模式（技能卡牌对战）
  - 主页面支持模式切换
  
- 📝 技能系统优化
  - 镜花水月能量消耗调整为5点
  - 幻影棋子持续时间改为3回合
  - 新增详细的技能介绍和使用提示
  
- 🎨 UI/UX 改进
  - 主页面支持下拉滚动
  - 技能卡片展示优化，增加技能类型标签
  - 游戏规则根据模式动态调整
  - 模式选择卡片增加视觉反馈

#### 技术改进
- 🔧 游戏状态管理优化，支持模式参数传递
- 🎨 使用 Scroll 组件实现页面滚动
- 💄 优化技能介绍布局和信息展示
- 🚀 改进路由参数传递机制

### v1.1.0 (2026-06-02)
#### 新增功能
- ✨ 实现一次开发多端部署能力
  - 支持手机、平板、PC 三种设备类型
  - 实现响应式布局和断点系统
  - 添加设备自动适配功能
  
- ✨ 实现自由流转功能
  - 支持应用接续，跨设备无缝切换游戏
  - 实现游戏状态自动保存和恢复
  - 添加分布式设备发现和管理
  
- 📝 完善项目文档
  - 新增详细的 README 文档
  - 说明多端部署和流转功能使用方法

#### 技术改进
- 🔧 优化 module.json5 配置，支持多设备类型
- 🔧 添加分布式数据同步权限
- 🎨 实现断点系统和设备适配工具类
- 🚀 集成 HarmonyOS 分布式能力

### v1.0.0 (初始版本)
- 基础五子棋游戏功能
- 技能卡牌系统
- 能量系统

## 开发指南

### 扩展断点系统
```typescript
import { BreakpointSystem, BreakpointType } from '../common/BreakpointSystem';

// 创建断点系统实例
const breakpointSystem = new BreakpointSystem();
breakpointSystem.register();

// 监听断点变化
breakpointSystem.onBreakpointChange((breakpoint: BreakpointType) => {
  // 根据断点调整布局
});
```

### 使用设备适配
```typescript
import { DeviceAdapter, DeviceType } from '../common/DeviceAdapter';

const deviceAdapter = DeviceAdapter.getInstance();

// 获取推荐的棋盘大小
const boardSize = deviceAdapter.getRecommendedBoardSize();

// 判断设备类型
if (deviceAdapter.isTablet()) {
  // 平板特定逻辑
}
```

### 实现流转功能
```typescript
// 在 Ability 中实现接续
onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
  // 保存游戏状态
  wantParam['gameState'] = JSON.stringify(currentGameState);
  return AbilityConstant.OnContinueResult.AGREE;
}
```

### 添加新技能
```typescript
// 在 GomokuGame.ets 中添加新技能
interface SkillCard {
  name: string;
  cost: number;
  mode: string;
  desc: string;
}

// 在 skills 数组中添加新技能
private readonly skills: SkillCard[] = [
  // ... 现有技能
  { name: '新技能', cost: 3, mode: 'skill_new', desc: '技能描述' }
];

// 实现技能处理函数
handleSkillNew(row: number, col: number): void {
  // 技能逻辑实现
}
```

## 游戏策略建议

### 普通版策略
- **开局**：占据中心位置，控制棋盘
- **进攻**：创造双活三、活四等必胜棋型
- **防守**：及时堵截对手的连珠

### 技能版策略
- **能量管理**：合理规划能量使用，关键时刻有技能可用
- **飞沙走石**：
  - 破坏对手的活四、冲四
  - 移除阻挡己方连珠的棋子
- **镜花水月**：
  - 制造假象迷惑对手
  - 配合真实棋子形成威胁
- **画地为牢**：
  - 封锁对手的必胜点
  - 保护己方的延伸方向

## 贡献指南

欢迎提交 Issue 和 Pull Request 来帮助改进项目。

## 许可证

MIT License

## 联系方式

如有问题或建议，请通过 Issue 与我们联系。
