import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = '五子棋游戏';
  @State selectedMode: string = 'skill'; // 'normal' 或 'skill'
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        // 标题区域
        Column() {
          Text('🎮')
            .fontSize(56)
            .margin({ bottom: 15 })
          
          Text(this.message)
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2C3E50')
            .letterSpacing(3)
          
          Text('经典策略对战游戏')
            .fontSize(16)
            .fontColor('#7F8C8D')
            .margin({ top: 8 })
        }
        .margin({ top: 40, bottom: 30 })
        
        // 游戏模式选择
        Column() {
          Text('🎯 选择游戏模式')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2C3E50')
            .margin({ bottom: 15 })
          
          Row() {
            // 普通模式
            Column() {
              Text('♟️')
                .fontSize(32)
                .margin({ bottom: 8 })
              
              Text('普通版')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.selectedMode === 'normal' ? '#27AE60' : '#7F8C8D')
              
              Text('经典五子棋')
                .fontSize(12)
                .fontColor('#95A5A6')
                .margin({ top: 4 })
            }
            .width('45%')
            .padding(15)
            .backgroundColor(this.selectedMode === 'normal' ? '#E8F5E9' : '#FFFFFF')
            .borderRadius(12)
            .border({ 
              width: this.selectedMode === 'normal' ? 2 : 1, 
              color: this.selectedMode === 'normal' ? '#27AE60' : '#E0E0E0' 
            })
            .shadow({ 
              radius: this.selectedMode === 'normal' ? 8 : 4, 
              color: this.selectedMode === 'normal' ? 'rgba(39, 174, 96, 0.2)' : 'rgba(0, 0, 0, 0.05)', 
              offsetX: 0, 
              offsetY: 2 
            })
            .onClick(() => {
              this.selectedMode = 'normal';
            })
            
            Blank().width('10%')
            
            // 技能模式
            Column() {
              Text('✨')
                .fontSize(32)
                .margin({ bottom: 8 })
              
              Text('技能版')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.selectedMode === 'skill' ? '#9B59B6' : '#7F8C8D')
              
              Text('技能卡牌对战')
                .fontSize(12)
                .fontColor('#95A5A6')
                .margin({ top: 4 })
            }
            .width('45%')
            .padding(15)
            .backgroundColor(this.selectedMode === 'skill' ? '#F3E5F5' : '#FFFFFF')
            .borderRadius(12)
            .border({ 
              width: this.selectedMode === 'skill' ? 2 : 1, 
              color: this.selectedMode === 'skill' ? '#9B59B6' : '#E0E0E0' 
            })
            .shadow({ 
              radius: this.selectedMode === 'skill' ? 8 : 4, 
              color: this.selectedMode === 'skill' ? 'rgba(155, 89, 182, 0.2)' : 'rgba(0, 0, 0, 0.05)', 
              offsetX: 0, 
              offsetY: 2 
            })
            .onClick(() => {
              this.selectedMode = 'skill';
            })
          }
          .width('85%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .margin({ bottom: 25 })
        
        // 开始游戏按钮
        Button(this.selectedMode === 'normal' ? '🎯 开始普通版游戏' : '✨ 开始技能版游戏')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .height(60)
          .backgroundColor(this.selectedMode === 'normal' ? '#27AE60' : '#9B59B6')
          .fontColor('#FFFFFF')
          .borderRadius(30)
          .shadow({ 
            radius: 10, 
            color: this.selectedMode === 'normal' ? 'rgba(39, 174, 96, 0.4)' : 'rgba(155, 89, 182, 0.4)', 
            offsetX: 0, 
            offsetY: 5 
          })
          .margin({ bottom: 15 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/GomokuGame',
              params: { mode: this.selectedMode }
            });
          })
        
        Button('🧪 测试页面')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('80%')
          .height(50)
          .backgroundColor('#FF9800')
          .fontColor('#FFFFFF')
          .borderRadius(25)
          .shadow({ radius: 6, color: 'rgba(255, 152, 0, 0.3)', offsetX: 0, offsetY: 3 })
          .margin({ bottom: 30 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/TestGomoku'
            });
          })
        
        // 游戏说明卡片
        Column() {
          Text('📋 游戏说明')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2C3E50')
            .margin({ bottom: 15 })
          
          Column() {
            this.buildRuleItem('1️⃣', '点击棋盘落子')
            if (this.selectedMode === 'skill') {
              this.buildRuleItem('2️⃣', '每落一子获得1点能量')
              this.buildRuleItem('3️⃣', '使用能量施放技能卡牌')
            }
            this.buildRuleItem(this.selectedMode === 'skill' ? '4️⃣' : '2️⃣', '先连成五子者获胜')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .width('85%')
        .padding(20)
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .shadow({ radius: 10, color: 'rgba(0, 0, 0, 0.1)', offsetX: 0, offsetY: 2 })
        .margin({ bottom: 20 })
        
        // 技能卡牌卡片（仅在技能模式下显示）
        if (this.selectedMode === 'skill') {
          Column() {
            Text('✨ 技能卡牌介绍')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#2C3E50')
              .margin({ bottom: 15 })
            
            Column() {
              this.buildSkillItem(
                '🌪️', 
                '飞沙走石', 
                '4能量', 
                '移除棋盘上任意一颗棋子（包括对手的），可以破坏对手的连珠布局', 
                '#E74C3C',
                '战术技能'
              )
              this.buildSkillItem(
                '🔮', 
                '镜花水月', 
                '5能量', 
                '在空位放置幻影棋子，3回合后消失。幻影棋子参与胜利判定，可用于虚张声势', 
                '#9B59B6',
                '策略技能'
              )
              this.buildSkillItem(
                '🔒', 
                '画地为牢', 
                '2能量', 
                '封锁任意空位3回合，期间双方都无法在该位置落子，可用于防守或限制对手', 
                '#3498DB',
                '防守技能'
              )
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            
            // 技能使用提示
            Column() {
              Text('💡 使用提示')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#F39C12')
                .margin({ bottom: 8 })
              
              Text('• 点击技能按钮后，再点击棋盘目标位置')
                .fontSize(13)
                .fontColor('#666666')
                .margin({ bottom: 5 })
              
              Text('• 能量不足时技能按钮会变灰')
                .fontSize(13)
                .fontColor('#666666')
                .margin({ bottom: 5 })
              
              Text('• 合理搭配技能可以扭转战局')
                .fontSize(13)
                .fontColor('#666666')
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#FFF9E6')
            .borderRadius(8)
            .margin({ top: 15 })
          }
          .width('85%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 10, color: 'rgba(0, 0, 0, 0.1)', offsetX: 0, offsetY: 2 })
          .margin({ bottom: 30 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: 30 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 135,
      colors: [['#E8F5E9', 0.0], ['#F3E5F5', 0.5], ['#E3F2FD', 1.0]]
    })
  }
  
  // 构建规则项
  @Builder
  buildRuleItem(icon: string, text: string) {
    Row() {
      Text(icon)
        .fontSize(16)
        .margin({ right: 8 })
      
      Text(text)
        .fontSize(15)
        .fontColor('#555555')
    }
    .width('100%')
    .margin({ bottom: 8 })
    .padding({ left: 10, right: 10 })
  }
  
  // 构建技能项
  @Builder
  buildSkillItem(icon: string, name: string, cost: string, desc: string, color: string, type: string) {
    Column() {
      Row() {
        Text(icon)
          .fontSize(28)
          .margin({ right: 12 })
        
        Column() {
          Row() {
            Text(name)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(color)
            
            Text(`(${cost})`)
              .fontSize(14)
              .fontColor('#888888')
              .margin({ left: 8 })
          }
          
          Text(type)
            .fontSize(11)
            .fontColor(color)
            .backgroundColor(color + '20')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .borderRadius(4)
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      
      Text(desc)
        .fontSize(13)
        .fontColor('#666666')
        .margin({ top: 10, left: 40 })
        .lineHeight(20)
    }
    .width('100%')
    .padding(15)
    .backgroundColor('#F8F9FA')
    .borderRadius(10)
    .margin({ bottom: 12 })
    .alignItems(HorizontalAlign.Start)
  }
}
