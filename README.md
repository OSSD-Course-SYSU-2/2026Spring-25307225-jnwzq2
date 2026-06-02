# 五子棋游戏 (Gomoku Game)

一个基于 HarmonyOS 开发的五子棋游戏，支持跨设备协同和无缝流转体验。

## 项目简介

本项目是一个完整的五子棋游戏应用，集成了 HarmonyOS 的分布式能力，实现了"一次开发多端部署"和"自由流转"两大核心特性。玩家可以在手机、平板、PC 等多种设备上无缝切换游戏，享受一致的游戏体验。

## 核心功能

### 🎮 游戏功能
- **经典五子棋玩法**：双人对战，先连成五子者获胜
- **技能卡牌系统**：
  - 飞沙走石 (4能量)：移除任意棋子
  - 镜花水月 (2能量)：放置幻影棋子
  - 画地为牢 (2能量)：封锁位置3回合
- **能量系统**：每落一子获得1点能量，用于释放技能

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
│       ├── Index.ets              # 主页面
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

## 使用说明

### 环境要求
- HarmonyOS SDK API 12+
- DevEco Studio 4.0+
- 支持的设备：手机、平板、PC/2in1

### 安装运行
1. 使用 DevEco Studio 打开项目
2. 连接 HarmonyOS 设备或启动模拟器
3. 点击运行按钮安装应用

### 跨设备流转
1. 确保两台设备登录同一华为账号
2. 开启设备的 Wi-Fi 和蓝牙
3. 在一台设备上开始游戏
4. 点击设备的流转图标或使用系统流转功能
5. 选择目标设备完成游戏接续

## 更新日志

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

## 贡献指南

欢迎提交 Issue 和 Pull Request 来帮助改进项目。

## 许可证

MIT License

## 联系方式

如有问题或建议，请通过 Issue 与我们联系。
