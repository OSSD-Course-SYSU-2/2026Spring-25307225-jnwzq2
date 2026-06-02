import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;
const TAG = 'EntryAbility';

// 游戏状态数据结构
interface GameState {
  currentPlayer: number;      // 当前玩家 (1或2)
  board: number[][];          // 棋盘状态
  energy1: number;            // 玩家1能量
  energy2: number;            // 玩家2能量
  gameOver: boolean;          // 游戏是否结束
  winner: number;             // 获胜者
}

export default class EntryAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    
    // 处理应用接续
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      hilog.info(DOMAIN, TAG, 'Application continued from another device');
      this.restoreGameState(want);
    }
    
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
  }

  // 应用接续：保存游戏状态
  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    hilog.info(DOMAIN, TAG, 'onContinue called');
    
    try {
      // 从AppStorage获取当前游戏状态
      const gameState = AppStorage.get<GameState>('currentGameState');
      if (gameState) {
        wantParam['gameState'] = JSON.stringify(gameState);
        hilog.info(DOMAIN, TAG, 'Game state saved for continuation');
        return AbilityConstant.OnContinueResult.AGREE;
      }
      return AbilityConstant.OnContinueResult.AGREE;
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to save game state: %{public}s', JSON.stringify(err));
      return AbilityConstant.OnContinueResult.REJECT;
    }
  }

  // 恢复游戏状态
  private restoreGameState(want: Want): void {
    if (want.parameters && want.parameters['gameState']) {
      try {
        const gameStateStr = want.parameters['gameState'] as string;
        const gameState: GameState = JSON.parse(gameStateStr);
        
        // 将恢复的游戏状态保存到AppStorage
        AppStorage.setOrCreate<GameState>('currentGameState', gameState);
        AppStorage.setOrCreate<boolean>('isContinuation', true);
        
        hilog.info(DOMAIN, TAG, 'Game state restored successfully');
      } catch (err) {
        hilog.error(DOMAIN, TAG, 'Failed to restore game state: %{public}s', JSON.stringify(err));
      }
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }
}