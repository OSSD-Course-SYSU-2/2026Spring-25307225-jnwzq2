@Entry
@Component
struct TestGomoku {
  @State chessBoard: number[][] = [];
  private readonly BOARD_SIZE: number = 15;
  private readonly CELL_SIZE: number = 40;
  
  aboutToAppear(): void {
    this.initBoard();
  }
  
  initBoard(): void {
    const board: number[][] = [];
    for (let i = 0; i < this.BOARD_SIZE; i++) {
      board[i] = [];
      for (let j = 0; j < this.BOARD_SIZE; j++) {
        board[i][j] = 0;
      }
    }
    // 设置一些测试棋子
    board[7][7] = 1; // 中心黑棋
    board[7][8] = 2; // 中心右边白棋
    board[8][7] = 3; // 中心下方幻影
    board[8][8] = 4; // 右下角禁地
    this.chessBoard = board;
  }
  
  build() {
    Column() {
      Text('五子棋测试页面')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })
      
      // 棋盘区域
      Column() {
        ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], (row: number) => {
          Row() {
            ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], (col: number) => {
              Stack() {
                // 棋盘格子背景
                Rect()
                  .width(this.CELL_SIZE)
                  .height(this.CELL_SIZE)
                  .fill('#DEB887')
                  .border({ width: 1, color: '#000000' })
                
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
                console.log(`点击格子: row=${row}, col=${col}, value=${this.chessBoard[row][col]}`);
              })
            })
          }
        })
      }
      .border({ width: 1, color: '#000000' })
      .backgroundColor('#DEB887')
      .margin({ top: 10, bottom: 20 })
      
      // 图例
      Column() {
        Row() {
          Circle()
            .width(20)
            .height(20)
            .fill('#000000')
            .margin({ right: 10 })
          Text('黑棋')
            .fontSize(16)
        }
        .margin({ bottom: 10 })
        
        Row() {
          Circle()
            .width(20)
            .height(20)
            .fill('#FFFFFF')
            .border({ width: 1, color: '#000000' })
            .margin({ right: 10 })
          Text('白棋')
            .fontSize(16)
        }
        .margin({ bottom: 10 })
        
        Row() {
          Circle()
            .width(20)
            .height(20)
            .fill('rgba(128, 128, 128, 0.5)')
            .border({ width: 1, color: '#666666' })
            .margin({ right: 10 })
          Text('幻影棋子')
            .fontSize(16)
        }
        .margin({ bottom: 10 })
        
        Row() {
          Column() {
            Line()
              .width(20)
              .height(2)
              .backgroundColor('#FF0000')
              .rotate({ angle: 45 })
            
            Line()
              .width(20)
              .height(2)
              .backgroundColor('#FF0000')
              .rotate({ angle: -45 })
          }
          .margin({ right: 10 })
          Text('禁地')
            .fontSize(16)
        }
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding({ left: 10, right: 10 })
  }
}