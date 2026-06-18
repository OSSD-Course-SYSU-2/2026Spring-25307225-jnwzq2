import router from '@ohos.router';

@Entry
@Component
struct AIBattlePage {
  @State selectedMode: string = 'skill'; // 'normal' 或 'skill'
  @State selectedDifficulty: string = 'medium'; // 'easy', 'medium', 'hard'
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        // 标题区域
        Column() {
          Text('🤖')
            .fontSize(56)
            .margin({ bottom: 15 })
          
          Text('人机对战')
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2C3E50')
            .letterSpacing(3)
          
          Text('挑战智能AI对手')
            .fontSize(16)
            .fontColor('#7F8C8D')
            .margin({ top: 8 })
        }
        .margin({ top: 40, bottom: 30 })
        
        // AI难度选择
        Column() {
          Text('🎚️ 选择AI难度')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2C3E50')
            .margin({ bottom: 15 })
          
          Row() {
            // 简单
            Column() {
              Text('🌱')
                .fontSize(28)
                .margin({ bottom: 6 })
              
              Text('简单')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.selectedDifficulty === 'easy' ? '#27AE60' : '#7F8C8D')
              
              Text('适合新手')
                .fontSize(11)
                .fontColor('#95A5A6')
                .margin({ top: 3 })
            }
            .width('30%')
            .padding(12)
            .backgroundColor(this.selectedDifficulty === 'easy' ? '#E8F5E9' : '#FFFFFF')
            .borderRadius(12)
            .border({ 
              width: this.selectedDifficulty === 'easy' ? 2 : 1, 
              color: this.selectedDifficulty === 'easy' ? '#27AE60' : '#E0E0E0' 
            })
            .onClick(() => {
              this.selectedDifficulty = 'easy';
            })
            
            // 中等
            Column() {
              Text('⚡')
                .fontSize(28)
                .margin({ bottom: 6 })
              
              Text('中等')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.selectedDifficulty === 'medium' ? '#F39C12' : '#7F8C8D')
              
              Text('平衡挑战')
                .fontSize(11)
                .fontColor('#95A5A6')
                .margin({ top: 3 })
            }
            .width('30%')
            .padding(12)
            .backgroundColor(this.selectedDifficulty === 'medium' ? '#FFF9E6' : '#FFFFFF')
            .borderRadius(12)
            .border({ 
              width: this.selectedDifficulty === 'medium' ? 2 : 1, 
              color: this.selectedDifficulty === 'medium' ? '#F39C12' : '#E0E0E0' 
            })
            .onClick(() => {
              this.selectedDifficulty = 'medium';
            })
            
            // 困难
            Column() {
              Text('🔥')
                .fontSize(28)
                .margin({ bottom: 6 })
              
              Text('困难')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.selectedDifficulty === 'hard' ? '#E74C3C' : '#7F8C8D')
              
              Text('高手挑战')
                .fontSize(11)
                .fontColor('#95A5A6')
                .margin({ top: 3 })
            }
            .width('30%')
            .padding(12)
            .backgroundColor(this.selectedDifficulty === 'hard' ? '#FFEBEE' : '#FFFFFF')
            .borderRadius(12)
            .border({ 
              width: this.selectedDifficulty === 'hard' ? 2 : 1, 
              color: this.selectedDifficulty === 'hard' ? '#E74C3C' : '#E0E0E0' 
            })
            .onClick(() => {
              this.selectedDifficulty = 'hard';
            })
          }
          .width('85%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .margin({ bottom: 20 })
        
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
        Button(this.selectedMode === 'normal' ? '🎯 开始人机对战' : '✨ 开始人机对战')
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
              params: { 
                mode: this.selectedMode,
                battleType: 'ai', // 人机对战
                difficulty: this.selectedDifficulty // AI难度
              }
            });
          })
        
        // 返回按钮
        Button('🔙 返回模式选择')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('80%')
          .height(50)
          .backgroundColor('#95A5A6')
          .fontColor('#FFFFFF')
          .borderRadius(25)
          .shadow({ radius: 6, color: 'rgba(149, 165, 166, 0.3)', offsetX: 0, offsetY: 3 })
          .margin({ bottom: 30 })
          .onClick(() => {
            router.back();
          })
        
        // 游戏说明卡片
        Column() {
          Text('📋 游戏说明')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2C3E50')
            .margin({ bottom: 15 })
          
          Column() {
            this.buildRuleItem('1️⃣', '你执黑棋先行，AI执白棋')
            this.buildRuleItem('2️⃣', '轮流落子，AI会自动应对')
            if (this.selectedMode === 'skill') {
              this.buildRuleItem('3️⃣', '每落一子获得1点能量')
              this.buildRuleItem('4️⃣', '使用能量施放技能卡牌')
            }
            this.buildRuleItem(this.selectedMode === 'skill' ? '5️⃣' : '3️⃣', '先连成五子者获胜')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .width('85%')
        .padding(20)
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .shadow({ radius: 10, color: 'rgba(0, 0, 0, 0.1)', offsetX: 0, offsetY: 2 })
        .margin({ bottom: 30 })
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
      colors: [['#E3F2FD', 0.0], ['#F3E5F5', 0.5], ['#E8F5E9', 1.0]]
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
}
