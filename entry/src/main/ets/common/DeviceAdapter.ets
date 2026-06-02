/**
 * 设备适配工具类
 * 用于获取设备信息和实现多设备适配
 */
import { deviceInfo } from '@kit.BasicServicesKit';

// 设备类型枚举
export enum DeviceType {
  PHONE = 'phone',
  TABLET = 'tablet',
  PC = '2in1',
  UNKNOWN = 'unknown'
}

// 设备适配工具类
export class DeviceAdapter {
  private static instance: DeviceAdapter;
  private deviceType: DeviceType = DeviceType.PHONE;

  private constructor() {
    this.detectDeviceType();
  }

  // 获取单例实例
  public static getInstance(): DeviceAdapter {
    if (!DeviceAdapter.instance) {
      DeviceAdapter.instance = new DeviceAdapter();
    }
    return DeviceAdapter.instance;
  }

  // 检测设备类型
  private detectDeviceType(): void {
    const deviceTypeStr = deviceInfo.deviceType;
    if (deviceTypeStr === 'phone' || deviceTypeStr === 'default') {
      this.deviceType = DeviceType.PHONE;
    } else if (deviceTypeStr === 'tablet') {
      this.deviceType = DeviceType.TABLET;
    } else if (deviceTypeStr === '2in1') {
      this.deviceType = DeviceType.PC;
    } else {
      this.deviceType = DeviceType.UNKNOWN;
    }
  }

  // 获取当前设备类型
  public getDeviceType(): DeviceType {
    return this.deviceType;
  }

  // 判断是否为手机设备
  public isPhone(): boolean {
    return this.deviceType === DeviceType.PHONE;
  }

  // 判断是否为平板设备
  public isTablet(): boolean {
    return this.deviceType === DeviceType.TABLET;
  }

  // 判断是否为PC设备
  public isPC(): boolean {
    return this.deviceType === DeviceType.PC;
  }

  // 获取推荐的棋盘大小（根据设备类型）
  public getRecommendedBoardSize(): number {
    switch (this.deviceType) {
      case DeviceType.PHONE:
        return 320;
      case DeviceType.TABLET:
        return 480;
      case DeviceType.PC:
        return 600;
      default:
        return 320;
    }
  }

  // 获取推荐的字体大小
  public getRecommendedFontSize(): number {
    switch (this.deviceType) {
      case DeviceType.PHONE:
        return 14;
      case DeviceType.TABLET:
        return 16;
      case DeviceType.PC:
        return 18;
      default:
        return 14;
    }
  }

  // 获取推荐的按钮大小
  public getRecommendedButtonSize(): number {
    switch (this.deviceType) {
      case DeviceType.PHONE:
        return 40;
      case DeviceType.TABLET:
        return 48;
      case DeviceType.PC:
        return 56;
      default:
        return 40;
    }
  }
}
