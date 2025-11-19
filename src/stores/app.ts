// 应用全局Store
import { defineStore } from 'pinia';
import { ref } from 'vue';
import { storage, StorageKeys } from '@/utils/storage';
import encouragementJson from '@/mock/encouragement.json';

export const useAppStore = defineStore('app', () => {
  // 状态
  const loading = ref<boolean>(false);
  const tabBarIndex = ref<number>(0);
  const encouragement = ref<string>('');
  const encourageVisible = ref<boolean>(false);
  const encourageType = ref<'fatigue'|'encourage'|'celebration'|'daily'>('encourage');
  
  // 激励语列表（从本地存储或默认列表获取）
  const encouragementList = ref<string[]>(
    storage.get(StorageKeys.ENCOURAGEMENT) || encouragementJson.encouragement
  );
  const todayStudyMinutes = ref<number>((storage.get(StorageKeys.STUDY_STATS)?.todayStudyMinutes) || 0);
  const consecutiveWrong = ref<number>((storage.get(StorageKeys.STUDY_STATS)?.consecutiveWrong) || 0);
  
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

  function triggerEncouragement(type: 'fatigue'|'encourage'|'celebration'|'daily' = 'encourage') {
    encourageType.value = type;
    encouragement.value = getRandomEncouragement();
    encourageVisible.value = true;
    const logs = (storage.get(StorageKeys.GROWTH_LOG) as any) || [];
    logs.push({ type: 'encourage', encourageType: type, text: encouragement.value, at: Date.now() });
    storage.set(StorageKeys.GROWTH_LOG, logs);
  }

  function closeEncouragement() {
    encourageVisible.value = false;
  }
  function recordStudySession(minutes: number) {
    todayStudyMinutes.value += minutes;
    storage.set(StorageKeys.STUDY_STATS, { todayStudyMinutes: todayStudyMinutes.value, consecutiveWrong: consecutiveWrong.value });
    if (minutes >= 60 || todayStudyMinutes.value >= 120) triggerEncouragement('fatigue');
  }
  function logTask(title: string, subject: string, duration: number, reason?: string) {
    const logs = (storage.get(StorageKeys.GROWTH_LOG) as any) || [];
    logs.push({ type: 'task', title, subject, duration, reason, finishedAt: Date.now() });
    storage.set(StorageKeys.GROWTH_LOG, logs);
  }
  function recordWrongAnswer(count: number = 1) {
    consecutiveWrong.value += count;
    storage.set(StorageKeys.STUDY_STATS, { todayStudyMinutes: todayStudyMinutes.value, consecutiveWrong: consecutiveWrong.value });
    if (consecutiveWrong.value >= 3) triggerEncouragement('encourage');
  }
  function resetWrongAnswer() {
    consecutiveWrong.value = 0;
    storage.set(StorageKeys.STUDY_STATS, { todayStudyMinutes: todayStudyMinutes.value, consecutiveWrong: consecutiveWrong.value });
  }
  function recordDailyCheckin(hour: number) {
    if (hour >= 21) triggerEncouragement('daily');
  }
  
  /**
   * 页面跳转
   * @param url 页面路径
   * @param type 跳转类型
   */
  function navigateTo(url: string, type: 'navigateTo' | 'redirectTo' | 'switchTab' | 'reLaunch' = 'navigateTo') {
    const common = {
      fail: (err: any) => {
        console.error('页面跳转失败:', err);
        showToast('页面跳转失败', 'error');
      },
    } as any;
    if (type === 'navigateTo') {
      uni.navigateTo({ url, ...common });
    } else if (type === 'redirectTo') {
      uni.redirectTo({ url, ...common });
    } else if (type === 'switchTab') {
      uni.switchTab({ url });
    } else {
      uni.reLaunch({ url, ...common });
    }
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
    encourageVisible,
    encourageType,
    // 方法
    showLoading,
    hideLoading,
    showToast,
    showConfirm,
    setTabBarIndex,
    getRandomEncouragement,
    addEncouragement,
    triggerEncouragement,
    closeEncouragement,
    recordStudySession,
    logTask,
    recordWrongAnswer,
    resetWrongAnswer,
    recordDailyCheckin,
    navigateTo,
    navigateBack,
  };
});

