// 本地存储工具封装
// 基于uni-app的uni.storage进行二次封装

class Storage {
  /**
   * 存储数据
   * @param key 键名
   * @param value 值
   */
  set(key: string, value: any): void {
    try {
      const data = JSON.stringify(value);
      uni.setStorageSync(key, data);
    } catch (error) {
      console.error('Storage set error:', error);
    }
  }

  /**
   * 获取数据
   * @param key 键名
   * @param defaultValue 默认值
   * @returns 返回存储的值，如果不存在则返回默认值
   */
  get<T = any>(key: string, defaultValue: T | null = null): T | null {
    try {
      const data = uni.getStorageSync(key);
      if (data) {
        return JSON.parse(data) as T;
      }
      return defaultValue;
    } catch (error) {
      console.error('Storage get error:', error);
      return defaultValue;
    }
  }

  /**
   * 删除数据
   * @param key 键名
   */
  remove(key: string): void {
    try {
      uni.removeStorageSync(key);
    } catch (error) {
      console.error('Storage remove error:', error);
    }
  }

  /**
   * 清空所有数据
   */
  clear(): void {
    try {
      uni.clearStorageSync();
    } catch (error) {
      console.error('Storage clear error:', error);
    }
  }

  /**
   * 获取所有键名
   * @returns 返回所有键名数组
   */
  keys(): string[] {
    try {
      const info = uni.getStorageInfoSync();
      return info.keys;
    } catch (error) {
      console.error('Storage keys error:', error);
      return [];
    }
  }

  /**
   * 获取存储信息
   * @returns 返回存储信息
   */
  getInfo(): UniApp.GetStorageInfoSuccessCallbackResult | null {
    try {
      return uni.getStorageInfoSync();
    } catch (error) {
      console.error('Storage getInfo error:', error);
      return null;
    }
  }
}

// 导出单例
export const storage = new Storage();

// 常用的存储键名常量
export const StorageKeys = {
  TOKEN: 'token',
  USER_INFO: 'userInfo',
  REMEMBER_PASSWORD: 'rememberPassword',
  COURSES: 'courses',
  HOMEWORK: 'homework',
  PREVIEW: 'preview',
  SCHEDULE: 'schedule',
  ENCOURAGEMENT: 'encouragement',
  ACHIEVEMENTS: 'achievements',
  STUDY_STATS: 'studyStats',
};

