/**
 * 分布式流转管理工具类
 * 提供跨设备游戏协同能力
 */
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
const TAG = 'DistributedGameManager';

// 设备信息
export interface DeviceInfo {
  deviceId: string;
  deviceName: string;
  deviceType: string;
  isOnline: boolean;
}

// 分布式游戏管理类
export class DistributedGameManager {
  private static instance: DistributedGameManager;
  private deviceManager: distributedDeviceManager.DeviceManager | null = null;
  private deviceList: DeviceInfo[] = [];
  private onDeviceChangeCallback: ((devices: DeviceInfo[]) => void) | null = null;

  private constructor() {
    this.initDeviceManager();
  }

  // 获取单例实例
  public static getInstance(): DistributedGameManager {
    if (!DistributedGameManager.instance) {
      DistributedGameManager.instance = new DistributedGameManager();
    }
    return DistributedGameManager.instance;
  }

  // 初始化设备管理器
  private initDeviceManager(): void {
    try {
      this.deviceManager = distributedDeviceManager.createDeviceManager('com.example.jnwzq');
      
      // 监听设备状态变化
      this.deviceManager.on('deviceStateChange', (data: distributedDeviceManager.DeviceBasicInfo) => {
        hilog.info(DOMAIN, TAG, 'Device state changed: %{public}s', JSON.stringify(data));
        this.updateDeviceList();
      });
      
      // 初始获取设备列表
      this.updateDeviceList();
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to init device manager: %{public}s', JSON.stringify(err));
    }
  }

  // 更新设备列表
  private updateDeviceList(): void {
    if (!this.deviceManager) {
      return;
    }

    try {
      const devices = this.deviceManager.getAvailableDeviceListSync();
      this.deviceList = devices.map(device => ({
        deviceId: device.networkId,
        deviceName: device.deviceName,
        deviceType: device.deviceType,
        isOnline: true
      }));
      
      if (this.onDeviceChangeCallback) {
        this.onDeviceChangeCallback(this.deviceList);
      }
      
      hilog.info(DOMAIN, TAG, 'Device list updated, count: %{public}d', this.deviceList.length);
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to update device list: %{public}s', JSON.stringify(err));
    }
  }

  // 获取可用设备列表
  public getAvailableDevices(): DeviceInfo[] {
    return this.deviceList;
  }

  // 设置设备变化回调
  public onDeviceChange(callback: (devices: DeviceInfo[]) => void): void {
    this.onDeviceChangeCallback = callback;
  }

  // 检查是否有可用设备
  public hasAvailableDevices(): boolean {
    return this.deviceList.length > 0;
  }

  // 获取设备数量
  public getDeviceCount(): number {
    return this.deviceList.length;
  }

  // 销毁资源
  public destroy(): void {
    if (this.deviceManager) {
      this.deviceManager.off('deviceStateChange');
    }
    this.deviceList = [];
    this.onDeviceChangeCallback = null;
  }
}
