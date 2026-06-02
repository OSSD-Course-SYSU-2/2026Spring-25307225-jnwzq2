/**
 * 断点系统工具类
 * 用于实现一次开发多端部署的响应式布局
 */
import { mediaquery } from '@kit.ArkUI';

// 断点类型定义
export enum BreakpointType {
  SM = 'sm',   // 小屏设备：手机竖屏 (320vp - 600vp)
  MD = 'md',   // 中屏设备：折叠屏、平板竖屏 (600vp - 840vp)
  LG = 'lg'    // 大屏设备：平板横屏、PC (840vp+)
}

// 断点范围常量
export class BreakpointConstants {
  static readonly RANGE_SM: string = '(320vp<=width<600vp)';
  static readonly RANGE_MD: string = '(600vp<=width<840vp)';
  static readonly RANGE_LG: string = '(840vp<=width)';
}

// 断点系统管理类
export class BreakpointSystem {
  private smListener: mediaquery.MediaQueryListener | null = null;
  private mdListener: mediaquery.MediaQueryListener | null = null;
  private lgListener: mediaquery.MediaQueryListener | null = null;
  private currentBreakpoint: BreakpointType = BreakpointType.SM;
  private breakpointChangeCallback: ((breakpoint: BreakpointType) => void) | null = null;

  // 注册断点监听
  public register(): void {
    this.smListener = mediaquery.matchMediaSync(BreakpointConstants.RANGE_SM);
    this.mdListener = mediaquery.matchMediaSync(BreakpointConstants.RANGE_MD);
    this.lgListener = mediaquery.matchMediaSync(BreakpointConstants.RANGE_LG);

    if (this.smListener) {
      this.smListener.on('change', (result: mediaquery.MediaQueryResult) => {
        if (result.matches) {
          this.updateCurrentBreakpoint(BreakpointType.SM);
        }
      });
    }

    if (this.mdListener) {
      this.mdListener.on('change', (result: mediaquery.MediaQueryResult) => {
        if (result.matches) {
          this.updateCurrentBreakpoint(BreakpointType.MD);
        }
      });
    }

    if (this.lgListener) {
      this.lgListener.on('change', (result: mediaquery.MediaQueryResult) => {
        if (result.matches) {
          this.updateCurrentBreakpoint(BreakpointType.LG);
        }
      });
    }
  }

  // 注销监听
  public unregister(): void {
    if (this.smListener) {
      this.smListener.off('change');
    }
    if (this.mdListener) {
      this.mdListener.off('change');
    }
    if (this.lgListener) {
      this.lgListener.off('change');
    }
  }

  // 更新当前断点
  private updateCurrentBreakpoint(breakpoint: BreakpointType): void {
    this.currentBreakpoint = breakpoint;
    if (this.breakpointChangeCallback) {
      this.breakpointChangeCallback(breakpoint);
    }
  }

  // 获取当前断点
  public getCurrentBreakpoint(): BreakpointType {
    return this.currentBreakpoint;
  }

  // 设置断点变化回调
  public onBreakpointChange(callback: (breakpoint: BreakpointType) => void): void {
    this.breakpointChangeCallback = callback;
  }
}

// 断点值映射工具类
export class BreakpointValue<T> {
  private smValue: T | undefined;
  private mdValue: T | undefined;
  private lgValue: T | undefined;

  constructor(sm?: T, md?: T, lg?: T) {
    this.smValue = sm;
    this.mdValue = md;
    this.lgValue = lg;
  }

  // 根据断点获取对应值
  public getValue(breakpoint: BreakpointType): T | undefined {
    switch (breakpoint) {
      case BreakpointType.SM:
        return this.smValue;
      case BreakpointType.MD:
        return this.mdValue;
      case BreakpointType.LG:
        return this.lgValue;
      default:
        return this.smValue;
    }
  }
}
