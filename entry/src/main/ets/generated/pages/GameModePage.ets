import { GameModeSelectionModule } from '../view/GameModeSelectionModule';
import { GameRulesGuidanceModule } from '../view/GameRulesGuidanceModule';

@Component
export struct GameModePage {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        GameModeSelectionModule()
        GameRulesGuidanceModule()
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .height("100%")
    .width('100%')
    .align(Alignment.Top)
    .backgroundColor($r('app.color.page_bg_color'))
  }
}