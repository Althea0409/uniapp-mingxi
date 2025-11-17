// 应用全局Store
import { defineStore } from 'pinia';
import { ref } from 'vue';
import { storage, StorageKeys } from '@/utils/storage';

export const useAppStore = defineStore('app', () => {
  // 状态
  const loading = ref<boolean>(false);
  const tabBarIndex = ref<number>(0);
  const encouragement = ref<string>('');
  
  // 激励语列表（从本地存储或默认列表获取）
  const encouragementList = ref<string[]>(
    storage.get(StorageKeys.ENCOURAGEMENT) || [
      '每一次努力都在为梦想铺路！',
      '今天的你比昨天更优秀！',
      '坚持下去，你一定能成功！',
      '相信自己，你可以做到！',
      '学习使我快乐，进步让我成长！',
      '不积跬步，无以至千里！',
      '天道酬勤，你的努力不会白费！',
      '成功就是把不可能变成可能！',
      '每天进步一点点，成功就在眼前！',
      '保持热爱，奔赴山海！',
    ]
  );
  
  // 方法
  /**
   * 显示加载中
   */
  function showLoading(title: string = '加载中...') {
    loading.value = true;
    uni.showLoading({
      title,
      mask: true,
    });
  }
  
  /**
   * 隐藏加载中
   */
  function hideLoading() {
    loading.value = false;
    uni.hideLoading();
  }
  
  /**
   * 显示Toast提示
   * @param title 提示文字
   * @param icon 图标类型
   */
  function showToast(title: string, icon: 'success' | 'error' | 'none' = 'none') {
    uni.showToast({
      title,
      icon,
      duration: 2000,
    });
  }
  
  /**
   * 显示确认对话框
   * @param content 内容
   * @param title 标题
   */
  function showConfirm(content: string, title: string = '提示'): Promise<boolean> {
    return new Promise((resolve) => {
      uni.showModal({
        title,
        content,
        success: (res) => {
          resolve(res.confirm);
        },
        fail: () => {
          resolve(false);
        },
      });
    });
  }
  
  /**
   * 设置TabBar索引
   * @param index 索引
   */
  function setTabBarIndex(index: number) {
    tabBarIndex.value = index;
  }
  
  /**
   * 随机获取激励语
   */
  function getRandomEncouragement(): string {
    const randomIndex = Math.floor(Math.random() * encouragementList.value.length);
    encouragement.value = encouragementList.value[randomIndex];
    return encouragement.value;
  }
  
  /**
   * 添加激励语
   * @param text 激励语
   */
  function addEncouragement(text: string) {
    if (!encouragementList.value.includes(text)) {
      encouragementList.value.push(text);
      storage.set(StorageKeys.ENCOURAGEMENT, encouragementList.value);
    }
  }
  
  /**
   * 页面跳转
   * @param url 页面路径
   * @param type 跳转类型
   */
  function navigateTo(url: string, type: 'navigateTo' | 'redirectTo' | 'switchTab' | 'reLaunch' = 'navigateTo') {
    uni[type]({
      url,
      fail: (err) => {
        console.error('页面跳转失败:', err);
        showToast('页面跳转失败', 'error');
      },
    });
  }
  
  /**
   * 返回上一页
   * @param delta 返回层数
   */
  function navigateBack(delta: number = 1) {
    uni.navigateBack({
      delta,
      fail: () => {
        // 如果没有上一页，跳转到首页
        navigateTo('/pages/home/index', 'switchTab');
      },
    });
  }
  
  return {
    // 状态
    loading,
    tabBarIndex,
    encouragement,
    encouragementList,
    // 方法
    showLoading,
    hideLoading,
    showToast,
    showConfirm,
    setTabBarIndex,
    getRandomEncouragement,
    addEncouragement,
    navigateTo,
    navigateBack,
  };
});

