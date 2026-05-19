// 技能卡牌类型定义
interface SkillCard {
  name: string;
  cost: number;
  mode: string;
  desc: string;
}

@Entry
@Component
struct GomokuGame {
  // 棋盘常量
  private readonly BOARD_SIZE: number = 15; // 15x15 棋盘
  private readonly CELL_SIZE: number = 24;  // 每个格子大小（适配手机屏幕）
  private readonly BOARD_COLOR: string = '#DEB887'; // 木纹色
  private readonly GRID_COLOR: string = '#000000';  // 黑色网格线
  
  // 游戏状态
  @State chessBoard: number[][] = []; // 棋盘数组 0:空 1:黑棋 2:白棋 3:幻影 4:禁地
  @State currentPlayer: number = 1; // 1:黑方 2:白方
  @State energy: number[] = [0, 0]; // [黑方能量, 白方能量]
  @State gameMode: string = 'normal'; // 'normal', 'skill_fly', 'skill_mirror', 'skill_prison'
  @State message: string = '黑方落子';
  @State gameOver: boolean = false;
  @State winner: number = 0;
  
  // 技能卡牌数据
  private readonly skills: SkillCard[] = [
    { name: '镜花水月', cost: 5, mode: 'skill_mirror', desc: '放置幻影棋子，2回合后消失，参与胜利判定' },
    { name: '飞沙走石', cost: 4, mode: 'skill_fly', desc: '移除任意一颗棋子' },
    { name: '画地为牢', cost: 2, mode: 'skill_prison', desc: '封锁空位3回合' }
  ];
  
  // 禁地倒计时记录
  private forbiddenMap: Map<string, number> = new Map();
  // 幻影棋子倒计时记录（2回合后消失）
  private phantomMap: Map<string, number> = new Map();
  
  // 初始化棋盘
  aboutToAppear(): void {
    console.log('GomokuGame 组件初始化');
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
    this.forbiddenMap.clear();
    this.phantomMap.clear();
    console.log('棋盘数组初始化完成，长度:', this.chessBoard.length);
  }
  
  // 绘制棋盘
  build() {
    Column() {
      // 顶部状态栏
      Text(this.message)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 8 })
        .fontColor(this.currentPlayer === 1 ? '#000000' : '#666666')
      
      // 棋盘区域
      Column() {
        // 棋盘网格
        ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], (row: number) => {
          Row() {
            ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], (col: number) => {
              // 棋盘格子
              Stack() {
                // 棋盘格子背景
                Rect()
                  .width(this.CELL_SIZE)
                  .height(this.CELL_SIZE)
                  .fill(this.BOARD_COLOR)
                  .border({ width: 1, color: this.GRID_COLOR })
                
                // 根据棋盘状态显示不同的内容
                if (this.chessBoard[row][col] === 1) {
                  // 黑棋
                  Circle()
                    .width(this.CELL_SIZE * 0.8)
                    .height(this.CELL_SIZE * 0.8)
                    .fill('#000000')
                } else if (this.chessBoard[row][col] === 2) {
                  // 白棋
                  Circle()
                    .width(this.CELL_SIZE * 0.8)
                    .height(this.CELL_SIZE * 0.8)
                    .fill('#FFFFFF')
                    .border({ width: 1, color: '#000000' })
                } else if (this.chessBoard[row][col] === 3) {
                  // 幻影棋子（镜花水月）
                  Circle()
                    .width(this.CELL_SIZE * 0.8)
                    .height(this.CELL_SIZE * 0.8)
                    .fill('rgba(128, 128, 128, 0.5)')
                    .border({ width: 1, color: '#666666' })
                } else if (this.chessBoard[row][col] === 4) {
                  // 禁地（画地为牢）
                  // 红色叉号
                  Column() {
                    Line()
                      .width(this.CELL_SIZE * 0.8)
                      .height(2)
                      .backgroundColor('#FF0000')
                      .rotate({ angle: 45 })
                    
                    Line()
                      .width(this.CELL_SIZE * 0.8)
                      .height(2)
                      .backgroundColor('#FF0000')
                      .rotate({ angle: -45 })
                  }
                }
              }
              .width(this.CELL_SIZE)
              .height(this.CELL_SIZE)
              .backgroundColor('#F0F0F0')
              .border({ width: 1, color: '#CCCCCC' })
              .onClick(() => {
                console.log(`点击格子: row=${row}, col=${col}`);
                this.onGridClick(row, col);
              })
            })
          }
        })
      }
      .border({ width: 1, color: '#000000' })
      .backgroundColor(this.BOARD_COLOR)
      .margin({ top: 10, bottom: 10 })
      
      // 游戏控制区域（垂直布局）
      Column() {
        // 黑方控制面板
        this.buildPlayerPanel(0, '黑方', '#000000')
        
        // 分隔线
        Divider()
          .width('80%')
          .height(1)
          .color('#CCCCCC')
          .margin({ top: 10, bottom: 10 })
        
        // 白方控制面板
        this.buildPlayerPanel(1, '白方', '#FFFFFF')
      }
      .width('100%')
      .padding({ left: 10, right: 10 })
      
      // 重新开始按钮
      if (this.gameOver) {
        Button('重新开始')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('80%')
          .height(40)
          .backgroundColor('#4CAF50')
          .fontColor('#FFFFFF')
          .margin({ top: 15 })
          .onClick(() => {
            this.initBoard();
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding({ left: 5, right: 5, bottom: 10 })
  }
  
  // 构建玩家控制面板
  @Builder
  buildPlayerPanel(playerIndex: number, playerName: string, pieceColor: string) {
    Column() {
      // 玩家标识和能量
      Row() {
        Text(playerName)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(playerIndex === 0 ? '#000000' : '#666666')
        
        Blank()
        
        // 能量进度条
        Row() {
          ForEach([0, 1, 2, 3, 4], (item: number) => {
            Circle()
              .width(16)
              .height(16)
              .fill(item < this.energy[playerIndex] ? '#4CAF50' : '#E0E0E0')
              .margin({ right: 2 })
          })
        }
      }
      .width('100%')
      .margin({ bottom: 8 })
      
      // 技能按钮（横向排列）
      Row() {
        ForEach(this.skills, (skill: SkillCard, index: number) => {
          Button(skill.name)
            .fontSize(9)
            .fontWeight(FontWeight.Medium)
            .width(60)
            .height(30)
            .margin({ right: 4 })
            .backgroundColor(this.energy[playerIndex] >= skill.cost ? '#2196F3' : '#BDBDBD')
            .fontColor('#FFFFFF')
            .enabled(this.energy[playerIndex] >= skill.cost && this.currentPlayer === playerIndex + 1 && !this.gameOver)
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
    .padding({ top: 8, bottom: 8, left: 10, right: 10 })
    .backgroundColor(this.currentPlayer === playerIndex + 1 ? '#E8F5E8' : '#FFFFFF')
    .border({ width: 2, color: this.currentPlayer === playerIndex + 1 ? '#4CAF50' : '#E0E0E0' })
    .borderRadius(8)
  }
  
  // 处理棋盘格子点击
  onGridClick(row: number, col: number): void {
    if (this.gameOver) return;
    
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
    
    // 增加能量（上限为5）
    const playerIndex = this.currentPlayer - 1;
    if (this.energy[playerIndex] < 5) {
      const newEnergy = [...this.energy];
      newEnergy[playerIndex] += 1;
      this.energy = newEnergy;
      console.log(`能量更新: 玩家${this.currentPlayer}, 能量${this.energy[playerIndex]}`);
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
  
  // 处理技能：飞沙走石 - 移除棋子
  handleSkillFly(row: number, col: number): void {
    const cellValue = this.chessBoard[row][col];
    
    // 只能移除黑棋或白棋（不能移除空位、幻影或禁地）
    if (cellValue !== 1 && cellValue !== 2) {
      return;
    }
    
    // 移除棋子 - 创建新数组以触发UI更新
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = 0;
    this.chessBoard = newBoard;
    
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
    
    // 放置幻影棋子 - 创建新数组以触发UI更新
    const newBoard = [...this.chessBoard];
    newBoard[row] = [...newBoard[row]];
    newBoard[row][col] = 3;
    this.chessBoard = newBoard;
    
    // 记录幻影棋子，2回合后消失
    const key = `${row},${col}`;
    this.phantomMap.set(key, 2);
    
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
        // 计算玩家自己的棋子或幻影棋子(3)，忽略禁地(4)
        if (cell === player || cell === 3) {
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
        // 计算玩家自己的棋子或幻影棋子(3)，忽略禁地(4)
        if (cell === player || cell === 3) {
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
    
    this.phantomMap.forEach((timer: number, key: string) => {
      const newTimer = timer - 1;
      
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
        // 更新倒计时
        this.phantomMap.set(key, newTimer);
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