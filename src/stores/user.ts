// 用户Store
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { UserInfo } from '@/types/user';
import { storage, StorageKeys } from '@/utils/storage';

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref<string>(storage.get(StorageKeys.TOKEN) || '');
  const userInfo = ref<UserInfo | null>(storage.get(StorageKeys.USER_INFO));
  
  // 计算属性
  const isLogin = computed(() => !!token.value && !!userInfo.value);
  const userId = computed(() => userInfo.value?.id || '');
  const userName = computed(() => userInfo.value?.name || '');
  const userAvatar = computed(() => userInfo.value?.avatar || '/static/avatar/default.png');
  const userLevel = computed(() => userInfo.value?.level || 0);
  const userExp = computed(() => userInfo.value?.exp || 0);
  const userPoints = computed(() => userInfo.value?.points || 0);
  
  // 方法
  /**
   * 登录
   * @param phone 手机号
   * @param password 密码
   */
  async function login(phone: string, password: string) {
    try {
      // Mock登录逻辑
      // 实际项目中这里应该调用API
      const mockToken = 'mock_token_' + Date.now();
      const mockUserInfo: UserInfo = {
        id: '1001',
        phone: phone,
        name: '小明同学',
        avatar: '/static/avatar/default.png',
        level: 8,
        exp: 80,
        points: 1250,
        badges: 12,
        school: '明蹊中学',
        grade: '高二',
        class: '3班',
      };
      
      // 保存到状态和本地存储
      token.value = mockToken;
      userInfo.value = mockUserInfo;
      storage.set(StorageKeys.TOKEN, mockToken);
      storage.set(StorageKeys.USER_INFO, mockUserInfo);
      
      return {
        success: true,
        message: '登录成功',
      };
    } catch (error: any) {
      return {
        success: false,
        message: error.message || '登录失败',
      };
    }
  }
  
  /**
   * 退出登录
   */
  function logout() {
    token.value = '';
    userInfo.value = null;
    storage.remove(StorageKeys.TOKEN);
    storage.remove(StorageKeys.USER_INFO);
    
    // 跳转到登录页
    uni.reLaunch({
      url: '/pages/auth/login',
    });
  }
  
  /**
   * 更新用户信息
   * @param data 用户信息
   */
  function updateUserInfo(data: Partial<UserInfo>) {
    if (userInfo.value) {
      userInfo.value = { ...userInfo.value, ...data };
      storage.set(StorageKeys.USER_INFO, userInfo.value);
    }
  }
  
  /**
   * 增加经验值
   * @param exp 经验值
   */
  function addExp(exp: number) {
    if (userInfo.value) {
      userInfo.value.exp += exp;
      // 经验值满100升级
      if (userInfo.value.exp >= 100) {
        userInfo.value.level += 1;
        userInfo.value.exp = userInfo.value.exp - 100;
      }
      storage.set(StorageKeys.USER_INFO, userInfo.value);
    }
  }
  
  /**
   * 增加积分
   * @param points 积分
   */
  function addPoints(points: number) {
    if (userInfo.value) {
      userInfo.value.points += points;
      storage.set(StorageKeys.USER_INFO, userInfo.value);
    }
  }
  
  /**
   * 获取用户信息
   */
  async function getUserInfo() {
    // Mock获取用户信息
    // 实际项目中这里应该调用API
    if (userInfo.value) {
      return userInfo.value;
    }
    return null;
  }
  
  return {
    // 状态
    token,
    userInfo,
    // 计算属性
    isLogin,
    userId,
    userName,
    userAvatar,
    userLevel,
    userExp,
    userPoints,
    // 方法
    login,
    logout,
    updateUserInfo,
    addExp,
    addPoints,
    getUserInfo,
  };
});

