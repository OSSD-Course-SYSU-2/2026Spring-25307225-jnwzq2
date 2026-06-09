import { GameModeSelectionModuleStyleA } from '../view/GameModeSelectionModuleStyleA';
import { GameRulesReadModule } from '../view/GameRulesReadModule';

@Component
export struct MainPage {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        GameModeSelectionModuleStyleA()
        GameRulesReadModule()
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