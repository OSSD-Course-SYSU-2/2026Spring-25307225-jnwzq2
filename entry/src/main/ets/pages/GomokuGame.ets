import router from '@ohos.router';

// 技能卡牌类型定义
interface SkillCard {
  name: string;
  cost: number;
  mode: string;
  desc: string;
}

// 幻影棋子数据类型定义
interface PhantomData {
  player: number;  // 玩家：1-黑方，2-白方
  timer: number;   // 倒计时
}

// AI落子候选位置
interface AIMoveCandidate {
  row: number;
  col: number;
  score: number;
}

// AI落子结果
interface AIMove {
  row: number;
  col: number;
}

// 连线分析结果
interface LineAnalysis {
  count: number;
  openEnds: number;
}

// 连线计数结果
interface LineCount {
  count: number;
}

// 上一步棋子位置
interface LastMove {
  row: number;
  col: number;
}

@Entry
@Component
struct GomokuGame {
  // 棋盘常量
  private readonly BOARD_SIZE: number = 18; // 18x18 棋盘
  private readonly CELL_SIZE: number = 18;  // 每个格子大小
  private readonly BOARD_COLOR: string = '#DEB887'; // 木纹色
  private readonly GRID_COLOR: string = '#8B4513';  // 棕色网格线
  
  // 游戏状态
  @State chessBoard: number[][] = []; // 棋盘数组 0:空 1:黑棋 2:白棋 3:保留 4:禁地 5:黑方幻影 6:白方幻影
  @State currentPlayer: number = 1; // 1:黑方 2:白方
  @State energy: number[] = [0, 0]; // [黑方能量, 白方能量]
  @State gameMode: string = 'normal'; // 'normal', 'skill_fly', 'skill_mirror', 'skill_prison'
  @State message: string = '黑方落子';
  @State gameOver: boolean = false;
  @State winner: number = 0;
  @State isSkillMode: boolean = true; // 是否为技能模式（true:技能版 false:普通版）
  @State isAIBattle: boolean = false; // 是否为人机对战
  @State aiDifficulty: string = 'medium'; // AI难度: 'easy', 'medium', 'hard'
  @State isAIThinking: boolean = false; // AI是否正在思考
  @State lastMove: LastMove | null = null; // 上一步棋子位置（用于标识）
  
  // 技能卡牌数据
  private readonly skills: SkillCard[] = [
    { name: '镜花水月', cost: 5, mode: 'skill_mirror', desc: '放置幻影棋子，3回合后消失，参与胜利判定' },
    { name: '飞沙走石', cost: 4, mode: 'skill_fly', desc: '移除任意一颗棋子' },
    { name: '画地为牢', cost: 2, mode: 'skill_prison', desc: '封锁空位3回合' }
  ];
  
  // 禁地倒计时记录
  private forbiddenMap: Map<string, number> = new Map();
  // 幻影棋子倒计时记录（包含玩家信息和倒计时）
  private phantomMap: Map<string, PhantomData> = new Map();
  
  // 初始化棋盘
  aboutToAppear(): void {
    console.log('GomokuGame 组件初始化');
    // 获取路由参数
    try {
      const params = router.getParams() as Record<string, Object>;
      if (params && params['mode']) {
        this.isSkillMode = params['mode'] === 'skill';
        console.log('游戏模式:', this.isSkillMode ? '技能版' : '普通版');
      }
      if (params && params['battleType']) {
        this.isAIBattle = params['battleType'] === 'ai';
        console.log('对战模式:', this.isAIBattle ? '人机对战' : '本地对战');
      }
      if (params && params['difficulty']) {
        this.aiDifficulty = params['difficulty'] as string;
        console.log('AI难度:', this.aiDifficulty);
      }
    } catch (e) {
      console.log('获取路由参数失败，使用默认技能模式');
    }
    this.initBoard();
    console.log('棋盘初始化完成，尺寸:', this.BOARD_SIZE, 'x', this.BOARD_SIZE);
  }
  
  // 初始化棋盘数组
  initBoard(): void {
    console.log('初始化棋盘数组...');
    const board: number[][] = [];
    for (let i = 0; i < this.BOARD_SIZE; i++) {
      board[i] = [];
      for (let j = 0; j < this.BOARD_SIZE; j++) {
        board[i][j] = 0;
      }
    }
    this.chessBoard = board;
    this.currentPlayer = 1;
    this.energy = [0, 0];
    this.gameMode = 'normal';
    this.message = '黑方落子';
    this.gameOver = false;
    this.winner = 0;
    this.lastMove = null; // 重置上一步标识
    this.forbiddenMap.clear();
    this.phantomMap.clear();
    console.log('棋盘数组初始化完成，长度:', this.chessBoard.length);
  }
  
  // 绘制棋盘
  build() {
    Column() {
      // 顶部状态栏
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.currentPlayer === 1 ? '#2C3E50' : '#7F8C8D')
        
        if (this.gameMode !== 'normal') {
          Text('点击棋盘完成技能施放')
            .fontSize(12)
            .fontColor('#E74C3C')
            .margin({ top: 4 })
        }
      }
      .margin({ top: 15, bottom: 10 })
      
      // 棋盘区域
      Column() {
        // 棋盘网格
        ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], (row: number) => {
          Row() {
            ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], (col: number) => {
              // 棋盘格子
              Stack() {
                // 棋盘格子背景
                Rect()
                  .width(this.CELL_SIZE)
                  .height(this.CELL_SIZE)
                  .fill(this.BOARD_COLOR)
                  .border({ width: 0.5, color: this.GRID_COLOR })
                
                // 根据棋盘状态显示不同的内容
                if (this.chessBoard[row][col] === 1) {
                  // 黑棋
                  Stack() {
                    Circle()
                      .width(this.CELL_SIZE * 0.85)
                      .height(this.CELL_SIZE * 0.85)
                      .fill('#1a1a1a')
                      .shadow({ radius: 2, color: 'rgba(0, 0, 0, 0.3)', offsetX: 1, offsetY: 1 })
                    // 上一步标识（红色圆点）
                    if (this.lastMove && this.lastMove.row === row && this.lastMove.col === col) {
                      Circle()
                        .width(this.CELL_SIZE * 0.3)
                        .height(this.CELL_SIZE * 0.3)
                        .fill('#E74C3C')
                    }
                  }
                } else if (this.chessBoard[row][col] === 2) {
                  // 白棋
                  Stack() {
                    Circle()
                      .width(this.CELL_SIZE * 0.85)
                      .height(this.CELL_SIZE * 0.85)
                      .fill('#FFFFFF')
                      .border({ width: 1, color: '#CCCCCC' })
                      .shadow({ radius: 2, color: 'rgba(0, 0, 0, 0.2)', offsetX: 1, offsetY: 1 })
                    // 上一步标识（红色圆点）
                    if (this.lastMove && this.lastMove.row === row && this.lastMove.col === col) {
                      Circle()
                        .width(this.CELL_SIZE * 0.3)
                        .height(this.CELL_SIZE * 0.3)
                        .fill('#E74C3C')
                    }
                  }
                } else if (this.chessBoard[row][col] === 5) {
                  // 黑方幻影棋子（镜花水月）
                  Circle()
                    .width(this.CELL_SIZE * 0.85)
                    .height(this.CELL_SIZE * 0.85)
                    .fill('rgba(44, 62, 80, 0.5)')  // 深色半透明
                    .border({ width: 2, color: '#2C3E50' })  // 黑色边框
                    .shadow({ radius: 3, color: 'rgba(44, 62, 80, 0.4)', offsetX: 0, offsetY: 0 })
                } else if (this.chessBoard[row][col] === 6) {
                  // 白方幻影棋子（镜花水月）
                  Circle()
                    .width(this.CELL_SIZE * 0.85)
                    .height(this.CELL_SIZE * 0.85)
                    .fill('rgba(236, 240, 241, 0.7)')  // 浅色半透明
                    .border({ width: 2, color: '#ECF0F1' })  // 白色边框
                    .shadow({ radius: 3, color: 'rgba(236, 240, 241, 0.4)', offsetX: 0, offsetY: 0 })
                } else if (this.chessBoard[row][col] === 4) {
                  // 禁地（画地为牢）
                  Column() {
                    Text('✖')
                      .fontSize(this.CELL_SIZE * 0.6)
                      .fontColor('#E74C3C')
                      .fontWeight(FontWeight.Bold)
                  }
                }
              }
              .width(this.CELL_SIZE)
              .height(this.CELL_SIZE)
              .onClick(() => {
                console.log(`点击格子: row=${row}, col=${col}`);
                this.onGridClick(row, col);
              })
            })
          }
        })
      }
      .border({ width: 2, color: '#8B4513' })
      .backgroundColor(this.BOARD_COLOR)
      .borderRadius(4)
      .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.2)', offsetX: 0, offsetY: 4 })
      .margin({ top: 10, bottom: 15 })
      
      // 游戏控制区域（垂直布局）
      if (this.isSkillMode) {
        Column() {
          // 黑方控制面板
          this.buildPlayerPanel(0, '⬤ 黑方', '#2C3E50')
          
          // 白方控制面板
          this.buildPlayerPanel(1, '⬤ 白方', '#7F8C8D')
        }
        .width('100%')
        .padding({ left: 10, right: 10 })
      } else {
        // 普通模式下的简单玩家信息
        Column() {
          Row() {
            Text('⬤ 黑方')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.currentPlayer === 1 ? '#2C3E50' : '#95A5A6')
            
            if (this.currentPlayer === 1 && !this.gameOver) {
              Text(' ▶')
                .fontSize(14)
                .fontColor('#27AE60')
            }
            
            Blank()
            
            Text('⬤ 白方')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.currentPlayer === 2 ? '#7F8C8D' : '#95A5A6')
            
            if (this.currentPlayer === 2 && !this.gameOver) {
              Text(' ▶')
                .fontSize(14)
                .fontColor('#27AE60')
            }
          }
          .width('85%')
          .padding(15)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .shadow({ radius: 6, color: 'rgba(0, 0, 0, 0.1)', offsetX: 0, offsetY: 2 })
        }
        .width('100%')
        .padding({ left: 10, right: 10 })
      }
      
      // 重新开始按钮
      if (this.gameOver) {
        Column() {
          Text(`🎉 ${this.winner === 1 ? '黑方' : '白方'}获胜！`)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E74C3C')
            .margin({ bottom: 15 })
          
          Button('🔄 重新开始')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .width('70%')
            .height(50)
            .backgroundColor('#4CAF50')
            .fontColor('#FFFFFF')
            .borderRadius(25)
            .shadow({ radius: 6, color: 'rgba(76, 175, 80, 0.4)', offsetX: 0, offsetY: 3 })
            .margin({ bottom: 10 })
            .onClick(() => {
              this.initBoard();
            })
          
          Button('🚪 退出游戏')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .width('70%')
            .height(50)
            .backgroundColor('#95A5A6')
            .fontColor('#FFFFFF')
            .borderRadius(25)
            .shadow({ radius: 6, color: 'rgba(149, 165, 166, 0.4)', offsetX: 0, offsetY: 3 })
            .onClick(() => {
              router.back();
            })
        }
        .margin({ top: 20 })
        .padding(20)
        .backgroundColor('rgba(255, 255, 255, 0.9)')
        .borderRadius(16)
      } else {
        // 游戏进行中的退出按钮
        Button('🚪 退出游戏')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('70%')
          .height(45)
          .backgroundColor('#95A5A6')
          .fontColor('#FFFFFF')
          .borderRadius(22)
          .shadow({ radius: 4, color: 'rgba(149, 165, 166, 0.3)', offsetX: 0, offsetY: 2 })
          .margin({ top: 15 })
          .onClick(() => {
            router.back();
          })
      }
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 180,
      colors: [['#E8F5E9', 0.0], ['#F5F5F5', 1.0]]
    })
    .padding({ left: 5, right: 5, bottom: 10 })
  }
  
  // 构建玩家控制面板
  @Builder
  buildPlayerPanel(playerIndex: number, playerName: string, pieceColor: string) {
    Column() {
      // 玩家标识和能量
      Row() {
        Row() {
          Text(playerName)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(pieceColor)
          
          if (this.currentPlayer === playerIndex + 1 && !this.gameOver) {
            Text(' ▶')
              .fontSize(14)
              .fontColor('#27AE60')
          }
        }
        
        Blank()
        
        // 能量进度条
        Row() {
          Text('⚡')
            .fontSize(14)
            .fontColor('#F39C12')
            .margin({ right: 4 })
          
          ForEach([0, 1, 2, 3, 4], (item: number) => {
            Stack() {
              Circle()
                .width(18)
                .height(18)
                .fill(item < this.energy[playerIndex] ? '#F39C12' : '#ECF0F1')
                .border({ width: 1, color: item < this.energy[playerIndex] ? '#E67E22' : '#BDC3C7' })
              
              if (item < this.energy[playerIndex]) {
                Text('⚡')
                  .fontSize(10)
                  .fontColor('#FFFFFF')
              }
            }
            .margin({ right: 3 })
          })
        }
      }
      .width('100%')
      .margin({ bottom: 10 })
      
      // 技能按钮（横向排列）
      Row() {
        ForEach(this.skills, (skill: SkillCard, index: number) => {
          Column() {
            Text(skill.name)
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.energy[playerIndex] >= skill.cost ? '#FFFFFF' : '#95A5A6')
            
            Text(`${skill.cost}⚡`)
              .fontSize(9)
              .fontColor(this.energy[playerIndex] >= skill.cost ? 'rgba(255, 255, 255, 0.8)' : '#BDC3C7')
          }
          .width(65)
          .height(42)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.energy[playerIndex] >= skill.cost ? 
            (index === 0 ? '#9B59B6' : index === 1 ? '#E74C3C' : '#3498DB') : '#ECF0F1')
          .borderRadius(8)
          .margin({ right: 5 })
          .enabled(this.energy[playerIndex] >= skill.cost && this.currentPlayer === playerIndex + 1 && !this.gameOver)
          .opacity(this.energy[playerIndex] >= skill.cost && this.currentPlayer === playerIndex + 1 ? 1.0 : 0.6)
          .onClick(() => {
            console.log(`点击技能: ${skill.name}, 能量: ${this.energy[playerIndex]}, 需要: ${skill.cost}`);
            this.onSkillClick(skill.mode, skill.cost, skill.name);
          })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12, left: 15, right: 15 })
    .backgroundColor(this.currentPlayer === playerIndex + 1 ? '#FFFFFF' : '#F8F9FA')
    .border({ 
      width: this.currentPlayer === playerIndex + 1 ? 2 : 1, 
      color: this.currentPlayer === playerIndex + 1 ? '#27AE60' : '#E0E0E0' 
    })
    .borderRadius(12)
    .shadow({ 
      radius: this.currentPlayer === playerIndex + 1 ? 8 : 4, 
      color: this.currentPlayer === playerIndex + 1 ? 'rgba(39, 174, 96, 0.2)' : 'rgba(0, 0, 0, 0.05)', 
      offsetX: 0, 
      offsetY: 2 
    })
    .margin({ bottom: 10 })
  }
  
  // 处理棋盘格子点击
  onGridClick(row: number, col: number): void {
    if (this.gameOver) return;
    
    // AI思考时禁止玩家操作
    if (this.isAIThinking) {
      console.log('AI正在思考，请等待...');
      return;
    }
    
    // 根据游戏模式处理点击
    switch (this.gameMode) {
      case 'normal':
        this.handleNormalMove(row, col);
        break;
      case 'skill_fly':
        this.handleSkillFly(row, col);
        break;
      case 'skill_mirror':
        this.handleSkillMirror(row, col);
        break;
      case 'skill_prison':
        this.handleSkillPrison(row, col);
        break;
    }
  }
  
  // 处理正常落子
  handleNormalMove(row: number, col: number): void {
    console.log(`正常落子: row=${row}, col=${col}, currentPlayer=${this.currentPlayer}`);
    
    // 检查位置是否可落子（为空且不是禁地）
    if (this.chessBoard[row][col] !== 0) {
      console.log(`位置(${row},${col})已被占用，值为${this.chessBoard[row][col]}`);
      return;
    }
    
    // 落子 - 创建新数组以触发UI更新
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = this.currentPlayer;
    this.chessBoard = newBoard;
    console.log(`落子成功: 设置(${row},${col})为${this.currentPlayer}`);
    
    // 记录上一步位置
    const move: LastMove = { row, col };
    this.lastMove = move;
    
    // 增加能量（仅在技能模式下，上限为5）
    if (this.isSkillMode) {
      const playerIndex = this.currentPlayer - 1;
      if (this.energy[playerIndex] < 5) {
        const newEnergy = [...this.energy];
        newEnergy[playerIndex] += 1;
        this.energy = newEnergy;
        console.log(`能量更新: 玩家${this.currentPlayer}, 能量${this.energy[playerIndex]}`);
      }
    }
    
    // 检查胜负（包含幻影棋子）
    if (this.checkWinWithPhantom(row, col)) {
      this.gameOver = true;
      this.winner = this.currentPlayer;
      this.message = this.currentPlayer === 1 ? '黑方获胜！' : '白方获胜！';
      return;
    }
    
    // 切换玩家
    this.currentPlayer = this.currentPlayer === 1 ? 2 : 1;
    this.message = this.currentPlayer === 1 ? '黑方落子' : '白方落子';
    
    // 处理幻影棋子和禁地倒计时
    this.processTurnCountdown();
    
    // 如果是人机对战且轮到AI（白方），触发AI落子
    if (this.isAIBattle && this.currentPlayer === 2 && !this.gameOver) {
      this.triggerAIMove();
    }
  }
  
  // 技能按钮点击事件
  onSkillClick(skillMode: string, cost: number, skillName: string): void {
    const playerIndex = this.currentPlayer - 1;
    
    console.log(`技能点击: ${skillName}, 当前能量: ${this.energy[playerIndex]}, 需要: ${cost}`);
    
    // 检查能量是否足够
    if (this.energy[playerIndex] < cost) {
      console.log('能量不足');
      return;
    }
    
    // 扣除能量 - 使用数组拷贝触发响应式更新
    const newEnergy = [...this.energy];
    newEnergy[playerIndex] -= cost;
    this.energy = newEnergy;
    console.log(`能量扣除后: ${this.energy[playerIndex]}`);
    
    // 设置技能模式
    this.gameMode = skillMode;
    this.message = `${this.currentPlayer === 1 ? '黑方' : '白方'}正在施放[${skillName}]...`;
  }
  
  // 处理技能：飞沙走石 - 移除棋子或禁地
  handleSkillFly(row: number, col: number): void {
    const cellValue = this.chessBoard[row][col];
    
    // 可以移除黑棋(1)、白棋(2)或禁地(4)，但不能移除空位(0)或幻影棋子(5,6)
    if (cellValue === 0 || cellValue === 5 || cellValue === 6) {
      return;
    }
    
    // 移除棋子或禁地 - 创建新数组以触发UI更新
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = 0;
    this.chessBoard = newBoard;
    
    // 如果移除的是禁地，需要从forbiddenMap中删除记录
    if (cellValue === 4) {
      const key = `${row},${col}`;
      this.forbiddenMap.delete(key);
    }
    
    // 强制切换回合
    this.currentPlayer = this.currentPlayer === 1 ? 2 : 1;
    this.gameMode = 'normal';
    this.message = this.currentPlayer === 1 ? '黑方落子' : '白方落子';
    
    // 处理幻影棋子和禁地倒计时
    this.processTurnCountdown();
  }
  
  // 处理技能：镜花水月 - 放置幻影棋子
  handleSkillMirror(row: number, col: number): void {
    // 只能放置在空位
    if (this.chessBoard[row][col] !== 0) {
      return;
    }
    
    // 根据当前玩家设置幻影棋子值（黑方为5，白方为6）
    const phantomValue = this.currentPlayer === 1 ? 5 : 6;
    
    // 放置幻影棋子 - 创建新数组以触发UI更新
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = phantomValue;
    this.chessBoard = newBoard;
    
    // 记录幻影棋子，包含玩家信息和倒计时
    const key = `${row},${col}`;
    const phantomData: PhantomData = { player: this.currentPlayer, timer: 3 };
    this.phantomMap.set(key, phantomData);
    
    // 检查是否获胜（幻影棋子参与判定）
    if (this.checkWinWithPhantom(row, col)) {
      this.gameOver = true;
      this.winner = this.currentPlayer;
      this.message = `${this.currentPlayer === 1 ? '黑方' : '白方'}获胜！`;
      return;
    }
    
    // 强制切换回合
    this.currentPlayer = this.currentPlayer === 1 ? 2 : 1;
    this.gameMode = 'normal';
    this.message = this.currentPlayer === 1 ? '黑方落子' : '白方落子';
    
    // 只处理禁地倒计时（幻影刚放置，不立即减）
    this.updateForbiddenMap();
  }
  
  // 处理技能：画地为牢 - 封锁位置
  handleSkillPrison(row: number, col: number): void {
    // 只能封锁空位
    if (this.chessBoard[row][col] !== 0) {
      return;
    }
    
    // 设置禁地 - 创建新数组以触发UI更新
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = 4;
    this.chessBoard = newBoard;
    
    // 记录禁地倒计时（6次落子操作后解封）
    const key = `${row},${col}`;
    this.forbiddenMap.set(key, 6);
    
    // 强制切换回合
    this.currentPlayer = this.currentPlayer === 1 ? 2 : 1;
    this.gameMode = 'normal';
    this.message = this.currentPlayer === 1 ? '黑方落子' : '白方落子';
    
    // 处理幻影棋子和禁地倒计时
    this.processTurnCountdown();
  }
  
  // 更新禁地倒计时
  updateForbiddenMap(): void {
    const keysToRemove: string[] = [];
    let boardUpdated = false;
    let newBoard = [...this.chessBoard];
    
    // 遍历所有禁地，倒计时减1
    this.forbiddenMap.forEach((timer: number, key: string) => {
      const newTimer = timer - 1;
      
      if (newTimer <= 0) {
        // 倒计时结束，移除禁地
        keysToRemove.push(key);
        const coords = key.split(',');
        const row = parseInt(coords[0]);
        const col = parseInt(coords[1]);
        newBoard[row] = [...newBoard[row]];
        newBoard[row][col] = 0;
        boardUpdated = true;
      } else {
        // 更新倒计时
        this.forbiddenMap.set(key, newTimer);
      }
    });
    
    // 移除倒计时结束的禁地
    keysToRemove.forEach((key: string) => {
      this.forbiddenMap.delete(key);
    });
    
    // 如果棋盘有更新，触发UI更新
    if (boardUpdated) {
      this.chessBoard = newBoard;
    }
  }
  
  // ==================== AI 相关方法 ====================
  
  // 触发AI落子（异步延迟，模拟思考时间）
  triggerAIMove(): void {
    this.isAIThinking = true;
    this.message = 'AI思考中...';
    
    // 根据难度设置思考时间
    const thinkTime = this.aiDifficulty === 'easy' ? 300 : 
                      this.aiDifficulty === 'medium' ? 500 : 800;
    
    // 使用setTimeout模拟异步思考
    setTimeout(() => {
      this.performAIMove();
      this.isAIThinking = false;
    }, thinkTime);
  }
  
  // 执行AI落子
  performAIMove(): void {
    if (this.gameOver) return;
    
    // AI决策：先考虑使用技能，再考虑落子
    if (this.isSkillMode && this.shouldAIUseSkill()) {
      return; // 如果使用了技能，直接返回
    }
    
    // AI落子
    const move = this.getBestAIMove();
    if (move) {
      this.executeAIMove(move.row, move.col);
    }
  }
  
  // AI判断是否应该使用技能
  shouldAIUseSkill(): boolean {
    const aiEnergy = this.energy[1]; // AI是白方，索引为1
    
    // 困难模式更积极使用技能
    const useSkillChance = this.aiDifficulty === 'easy' ? 0.1 : 
                           this.aiDifficulty === 'medium' ? 0.3 : 0.5;
    
    // 随机决定是否尝试使用技能
    if (Math.random() > useSkillChance) return false;
    
    // 尝试使用画地为牢（2能量）- 封锁对手的关键位置
    if (aiEnergy >= 2) {
      const blockPos = this.findBestBlockPosition();
      if (blockPos) {
        this.executeAISkillPrison(blockPos.row, blockPos.col);
        return true;
      }
    }
    
    // 尝试使用飞沙走石（4能量）- 移除对手的关键棋子
    if (aiEnergy >= 4) {
      const removePos = this.findBestRemovePosition();
      if (removePos) {
        this.executeAISkillFly(removePos.row, removePos.col);
        return true;
      }
    }
    
    return false;
  }
  
  // 获取最佳AI落子位置
  getBestAIMove(): AIMove | null {
    const candidates: AIMoveCandidate[] = [];
    
    // 遍历所有空位，计算得分
    for (let row = 0; row < this.BOARD_SIZE; row++) {
      for (let col = 0; col < this.BOARD_SIZE; col++) {
        if (this.chessBoard[row][col] === 0) { // 空位
          const score = this.evaluatePosition(row, col);
          candidates.push({ row, col, score });
        }
      }
    }
    
    if (candidates.length === 0) return null;
    
    // 根据难度选择落子
    candidates.sort((a: AIMoveCandidate, b: AIMoveCandidate) => b.score - a.score);
    
    if (this.aiDifficulty === 'easy') {
      // 简单模式：随机选择前5个候选位置
      const topN = Math.min(5, candidates.length);
      const randomIndex = Math.floor(Math.random() * topN);
      const result: AIMove = { row: candidates[randomIndex].row, col: candidates[randomIndex].col };
      return result;
    } else if (this.aiDifficulty === 'medium') {
      // 中等模式：随机选择前3个候选位置
      const topN = Math.min(3, candidates.length);
      const randomIndex = Math.floor(Math.random() * topN);
      const result: AIMove = { row: candidates[randomIndex].row, col: candidates[randomIndex].col };
      return result;
    } else {
      // 困难模式：选择最佳位置
      const result: AIMove = { row: candidates[0].row, col: candidates[0].col };
      return result;
    }
  }
  
  // 评估位置得分
  evaluatePosition(row: number, col: number): number {
    let score = 0;
    
    // 评估AI（白方）在该位置的进攻价值
    score += this.evaluatePositionForPlayer(row, col, 2) * 1.1; // 进攻略优先
    
    // 评估阻挡对手（黑方）的价值
    score += this.evaluatePositionForPlayer(row, col, 1) * 1.0;
    
    // 中心位置加分
    const centerDist = Math.abs(row - 7) + Math.abs(col - 7);
    score += (14 - centerDist) * 2;
    
    return score;
  }
  
  // 评估某位置对特定玩家的价值
  evaluatePositionForPlayer(row: number, col: number, player: number): number {
    let score = 0;
    const directions = [[0, 1], [1, 0], [1, 1], [1, -1]];
    
    for (const dir of directions) {
      const lineInfo = this.analyzeLine(row, col, dir[0], dir[1], player);
      
      // 根据连子数和空位数评分
      if (lineInfo.count >= 4) {
        score += 10000; // 成五
      } else if (lineInfo.count === 3 && lineInfo.openEnds === 2) {
        score += 5000; // 活四
      } else if (lineInfo.count === 3 && lineInfo.openEnds === 1) {
        score += 1000; // 冲四
      } else if (lineInfo.count === 2 && lineInfo.openEnds === 2) {
        score += 500; // 活三
      } else if (lineInfo.count === 2 && lineInfo.openEnds === 1) {
        score += 100; // 眠三
      } else if (lineInfo.count === 1 && lineInfo.openEnds === 2) {
        score += 50; // 活二
      } else if (lineInfo.count === 1 && lineInfo.openEnds === 1) {
        score += 10; // 眠二
      }
    }
    
    return score;
  }
  
  // 分析某方向的连线情况
  analyzeLine(row: number, col: number, dx: number, dy: number, player: number): LineAnalysis {
    let count = 0;
    let openEnds = 0;
    
    // 正向检查
    for (let i = 1; i < 5; i++) {
      const newRow = row + i * dx;
      const newCol = col + i * dy;
      if (this.isOutOfBounds(newRow, newCol)) break;
      
      const cell = this.chessBoard[newRow][newCol];
      if (cell === player || cell === (player === 1 ? 5 : 6)) {
        count++;
      } else if (cell === 0) {
        openEnds++;
        break;
      } else {
        break;
      }
    }
    
    // 反向检查
    for (let i = 1; i < 5; i++) {
      const newRow = row - i * dx;
      const newCol = col - i * dy;
      if (this.isOutOfBounds(newRow, newCol)) break;
      
      const cell = this.chessBoard[newRow][newCol];
      if (cell === player || cell === (player === 1 ? 5 : 6)) {
        count++;
      } else if (cell === 0) {
        openEnds++;
        break;
      } else {
        break;
      }
    }
    
    const result: LineAnalysis = { count, openEnds };
    return result;
  }
  
  // 检查是否越界
  isOutOfBounds(row: number, col: number): boolean {
    return row < 0 || row >= this.BOARD_SIZE || col < 0 || col >= this.BOARD_SIZE;
  }
  
  // 执行AI落子
  executeAIMove(row: number, col: number): void {
    console.log(`AI落子: row=${row}, col=${col}`);
    
    // 落子
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = 2; // AI是白方
    this.chessBoard = newBoard;
    
    // 增加能量
    // 记录上一步位置
    this.lastMove = { row: row, col: col };
    if (this.isSkillMode && this.energy[1] < 5) {
      const newEnergy = [...this.energy];
      newEnergy[1] += 1;
      this.energy = newEnergy;
    }
    
    // 检查胜负
    if (this.checkWinWithPhantom(row, col)) {
      this.gameOver = true;
      this.winner = 2;
      this.message = 'AI获胜！';
      return;
    }
    
    // 切换回玩家
    this.currentPlayer = 1;
    this.message = '黑方落子';
    
    // 处理倒计时
    this.processTurnCountdown();
  }
  
  // 找到最佳封锁位置（画地为牢）
  findBestBlockPosition(): AIMove | null {
    // 寻找对手可能形成连珠的关键位置
    let bestPos: AIMoveCandidate | null = null;
    
    for (let row = 0; row < this.BOARD_SIZE; row++) {
      for (let col = 0; col < this.BOARD_SIZE; col++) {
        if (this.chessBoard[row][col] === 0) {
          const score = this.evaluatePositionForPlayer(row, col, 1); // 评估对黑方的价值
          const current: AIMoveCandidate = { row, col, score };
          if (!bestPos || score > bestPos.score) {
            bestPos = current;
          }
        }
      }
    }
    
    // 只有得分足够高才封锁
    if (bestPos && bestPos.score > 500) {
      const result: AIMove = { row: bestPos.row, col: bestPos.col };
      return result;
    }
    return null;
  }
  
  // 找到最佳移除位置（飞沙走石）
  findBestRemovePosition(): AIMove | null {
    // 寻找对手的关键棋子
    let bestPos: AIMoveCandidate | null = null;
    
    for (let row = 0; row < this.BOARD_SIZE; row++) {
      for (let col = 0; col < this.BOARD_SIZE; col++) {
        const cell = this.chessBoard[row][col];
        if (cell === 1) { // 黑棋
          const score = this.evaluatePieceImportance(row, col, 1);
          const current: AIMoveCandidate = { row, col, score };
          if (!bestPos || score > bestPos.score) {
            bestPos = current;
          }
        }
      }
    }
    
    // 只有重要性足够高才移除
    if (bestPos && bestPos.score > 1000) {
      const result: AIMove = { row: bestPos.row, col: bestPos.col };
      return result;
    }
    return null;
  }
  
  // 评估棋子的重要性
  evaluatePieceImportance(row: number, col: number, player: number): number {
    let score = 0;
    const directions = [[0, 1], [1, 0], [1, 1], [1, -1]];
    
    for (const dir of directions) {
      const lineInfo = this.countLineWithPiece(row, col, dir[0], dir[1], player);
      if (lineInfo.count >= 3) {
        score += lineInfo.count * 1000;
      } else if (lineInfo.count >= 2) {
        score += lineInfo.count * 100;
      }
    }
    
    return score;
  }
  
  // 计算包含指定棋子的连线数
  countLineWithPiece(row: number, col: number, dx: number, dy: number, player: number): LineCount {
    let count = 1;
    
    // 正向
    for (let i = 1; i < 5; i++) {
      const newRow = row + i * dx;
      const newCol = col + i * dy;
      if (this.isOutOfBounds(newRow, newCol)) break;
      if (this.chessBoard[newRow][newCol] === player) {
        count++;
      } else {
        break;
      }
    }
    
    // 反向
    for (let i = 1; i < 5; i++) {
      const newRow = row - i * dx;
      const newCol = col - i * dy;
      if (this.isOutOfBounds(newRow, newCol)) break;
      if (this.chessBoard[newRow][newCol] === player) {
        count++;
      } else {
        break;
      }
    }
    
    const result: LineCount = { count };
    return result;
  }
  
  // AI执行画地为牢技能
  executeAISkillPrison(row: number, col: number): void {
    console.log(`AI使用画地为牢: row=${row}, col=${col}`);
    
    // 扣除能量
    const newEnergy = [...this.energy];
    newEnergy[1] -= 2;
    this.energy = newEnergy;
    
    // 设置禁地
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = 4;
    this.chessBoard = newBoard;
    
    const key = `${row},${col}`;
    this.forbiddenMap.set(key, 6);
    
    // 切换回玩家
    this.currentPlayer = 1;
    this.message = '黑方落子';
    this.processTurnCountdown();
  }
  
  // AI执行飞沙走石技能
  executeAISkillFly(row: number, col: number): void {
    console.log(`AI使用飞沙走石: row=${row}, col=${col}`);
    
    // 扣除能量
    const newEnergy = [...this.energy];
    newEnergy[1] -= 4;
    this.energy = newEnergy;
    
    // 移除棋子
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = 0;
    this.chessBoard = newBoard;
    
    // 切换回玩家
    this.currentPlayer = 1;
    this.message = '黑方落子';
    this.processTurnCountdown();
  }
  
  // 统计棋盘上的棋子数量（用于调试）
  countPieces(): number {
    let count = 0;
    for (let row = 0; row < this.BOARD_SIZE; row++) {
      for (let col = 0; col < this.BOARD_SIZE; col++) {
        if (this.chessBoard[row] && this.chessBoard[row][col] > 0) {
          count++;
        }
      }
    }
    return count;
  }
  
  // 检查是否获胜（包含幻影棋子）
  checkWinWithPhantom(row: number, col: number): boolean {
    const player = this.currentPlayer;
    
    // 检查方向：水平、垂直、主对角线、副对角线
    const directions = [
      [0, 1],   // 水平向右
      [1, 0],   // 垂直向下
      [1, 1],   // 主对角线
      [1, -1]   // 副对角线
    ];
    
    for (let d = 0; d < directions.length; d++) {
      const direction = directions[d];
      const dx = direction[0];
      const dy = direction[1];
      let count = 1; // 当前位置已经有一个棋子
      
      // 正向检查
      for (let i = 1; i < 5; i++) {
        const newRow = row + i * dx;
        const newCol = col + i * dy;
        
        if (newRow < 0 || newRow >= this.BOARD_SIZE || newCol < 0 || newCol >= this.BOARD_SIZE) {
          break;
        }
        
        const cell = this.chessBoard[newRow][newCol];
        // 计算玩家自己的棋子或对应幻影棋子，忽略禁地(4)
        // 黑方(player=1)可以连接黑棋(1)和黑方幻影(5)
        // 白方(player=2)可以连接白棋(2)和白方幻影(6)
        const phantomValue = player === 1 ? 5 : 6;
        if (cell === player || cell === phantomValue) {
          count++;
        } else {
          break;
        }
      }
      
      // 反向检查
      for (let i = 1; i < 5; i++) {
        const newRow = row - i * dx;
        const newCol = col - i * dy;
        
        if (newRow < 0 || newRow >= this.BOARD_SIZE || newCol < 0 || newCol >= this.BOARD_SIZE) {
          break;
        }
        
        const cell = this.chessBoard[newRow][newCol];
        // 计算玩家自己的棋子或对应幻影棋子，忽略禁地(4)
        // 黑方(player=1)可以连接黑棋(1)和黑方幻影(5)
        // 白方(player=2)可以连接白棋(2)和白方幻影(6)
        const phantomValue = player === 1 ? 5 : 6;
        if (cell === player || cell === phantomValue) {
          count++;
        } else {
          break;
        }
      }
      
      // 如果连成五子，返回true
      if (count >= 5) {
        return true;
      }
    }
    
    return false;
  }
  
  // 处理回合倒计时（幻影棋子和禁地）
  processTurnCountdown(): void {
    // 先处理禁地倒计时
    this.updateForbiddenMap();
    
    // 处理幻影棋子倒计时
    this.updatePhantomMap();
  }
  
  // 更新幻影棋子倒计时
  updatePhantomMap(): void {
    const keysToRemove: string[] = [];
    const newBoard = [...this.chessBoard];
    let boardUpdated = false;
    
    this.phantomMap.forEach((data: PhantomData, key: string) => {
      const newTimer = data.timer - 1;
      
      if (newTimer <= 0) {
        // 倒计时结束，移除幻影棋子
        keysToRemove.push(key);
        const coords = key.split(',');
        const row = parseInt(coords[0]);
        const col = parseInt(coords[1]);
        newBoard[row] = [...newBoard[row]];
        newBoard[row][col] = 0;
        boardUpdated = true;
      } else {
        // 更新倒计时，保留玩家信息
        const newData: PhantomData = { player: data.player, timer: newTimer };
        this.phantomMap.set(key, newData);
      }
    });
    
    // 移除倒计时结束的幻影棋子
    keysToRemove.forEach((key: string) => {
      this.phantomMap.delete(key);
    });
    
    // 如果棋盘有更新，触发UI更新
    if (boardUpdated) {
      this.chessBoard = newBoard;
    }
  }
}