import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = '五子棋游戏';

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 30 })
      
      Button('开始游戏')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .width(200)
        .height(50)
        .backgroundColor('#4CAF50')
        .fontColor('#FFFFFF')
        .margin({ bottom: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/GomokuGame'
          });
        })
      
      Text('游戏说明：')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 10 })
      
      Text('1. 点击棋盘落子')
        .fontSize(14)
        .margin({ bottom: 5 })
      
      Text('2. 每落一子获得1点能量')
        .fontSize(14)
        .margin({ bottom: 5 })
      
      Text('3. 使用能量施放技能卡牌')
        .fontSize(14)
        .margin({ bottom: 5 })
      
      Text('4. 先连成五子者获胜')
        .fontSize(14)
        .margin({ bottom: 20 })
      
      Text('技能卡牌：')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })
      
      Text('• 飞沙走石 (4能量)：移除任意棋子')
        .fontSize(14)
        .margin({ bottom: 5 })
      
      Text('• 镜花水月 (2能量)：放置幻影棋子')
        .fontSize(14)
        .margin({ bottom: 5 })
      
      Text('• 画地为牢 (2能量)：封锁位置3回合')
        .fontSize(14)
        .margin({ bottom: 20 })
      
      Button('测试页面')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .width(200)
        .height(50)
        .backgroundColor('#FF9800')
        .fontColor('#FFFFFF')
        .margin({ bottom: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/TestGomoku'
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
    .padding({ left: 20, right: 20 })
  }
}
