<template>
  <view class="login-page">
    <!-- 顶部装饰背景 -->
    <view class="login-header">
      <view class="header-wave"></view>
      <view class="header-content">
        <view class="logo-wrap">
          <image class="logo" src="/static/logo.png" mode="aspectFit" />
        </view>
        <text class="slogan">明 蹊</text>
      </view>
    </view>

    <!-- 登录表单 -->
    <view class="login-form">
      <Card :margin="'24rpx 0'" :padding="'68rpx'">
        <!-- 手机号输入 -->
        <view class="form-item">
          <view class="form-label">
            <text class="icon">📱</text>
            <input
              v-model="formData.phone"
              type="number"
              placeholder="请输入手机号"
              maxlength="11"
              :class="['form-input', { 'input-error': errors.phone }]"
              @blur="validatePhone"
            />
          </view>
          <text v-if="errors.phone" class="error-text">{{ errors.phone }}</text>
        </view>

        <!-- 密码输入 -->
        <view class="form-item">
          <view class="form-label">
            <text class="icon">🔒</text>
            <input
              v-model="formData.password"
              :password="!showPassword"
              placeholder="请输入密码"
              :class="['form-input', { 'input-error': errors.password }]"
              @blur="validatePassword"
            />
            <text class="icon-btn" @tap="showPassword = !showPassword">
              {{ showPassword ? '👁️' : '🙈' }}
            </text>
          </view>
          <text v-if="errors.password" class="error-text">{{ errors.password }}</text>
        </view>

        <!-- 记住密码和忘记密码 -->
        <view class="form-options">
          <label class="checkbox-label" @tap="formData.remember = !formData.remember">
            <text class="checkbox">{{ formData.remember ? '☑' : '☐' }}</text>
            <text class="option-text">记住密码</text>
          </label>
          <text class="forget-text" @tap="handleForgetPassword">忘记密码?</text>
        </view>

        <!-- 登录按钮 -->
        <view class="form-button">
          <Button
            text="登录"
            type="primary"
            size="large"
            :loading="loading"
            @click="handleLogin"
          />
        </view>

        <!-- 分割线 -->
        <view class="divider">
          <view class="divider-line"></view>
          <text class="divider-text">或</text>
          <view class="divider-line"></view>
        </view>

        <!-- 微信登录按钮 -->
        <view class="form-button">
          <Button
            text="微信一键登录"
            type="secondary"
            size="large"
            @click="handleWechatLogin"
          />
        </view>
      </Card>

      <!-- 底部文字 -->
      <view class="login-footer">
        <text class="footer-text">还没有账号？</text>
        <text class="link-text" @tap="goToRegister">立即注册</text>
      </view>

      <view class="agreement">
        <text class="agreement-text link-text" @tap="showAgreement('user')">用户协议</text>
        <text class="agreement-text"> | </text>
        <text class="agreement-text link-text" @tap="showAgreement('privacy')">隐私政策</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { useUserStore } from '@/stores/user';
import { useAppStore } from '@/stores/app';
import { validatePhone as checkPhone } from '@/utils/validate';
import { storage, StorageKeys } from '@/utils/storage';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';

const userStore = useUserStore();
const appStore = useAppStore();

// 表单数据
const formData = reactive({
  phone: '',
  password: '',
  remember: false,
});

// 错误信息
const errors = reactive({
  phone: '',
  password: '',
});

// 其他状态
const loading = ref(false);
const showPassword = ref(false);

// 验证手机号
const validatePhone = () => {
  if (!formData.phone) {
    errors.phone = '请输入手机号';
    return false;
  }
  if (!checkPhone(formData.phone)) {
    errors.phone = '手机号格式不正确';
    return false;
  }
  errors.phone = '';
  return true;
};

// 验证密码
const validatePassword = () => {
  if (!formData.password) {
    errors.password = '请输入密码';
    return false;
  }
  if (formData.password.length < 6) {
    errors.password = '密码至少6位';
    return false;
  }
  errors.password = '';
  return true;
};

// 验证表单
const validateForm = () => {
  const phoneValid = validatePhone();
  const passwordValid = validatePassword();
  return phoneValid && passwordValid;
};

// 登录
const handleLogin = async () => {
  if (!validateForm()) {
    return;
  }

  loading.value = true;
  
  try {
    const result = await userStore.login(formData.phone, formData.password);
    
    if (result.success) {
      // 保存记住密码信息
      if (formData.remember) {
        storage.set(StorageKeys.REMEMBER_PASSWORD, {
          phone: formData.phone,
          password: formData.password,
        });
      } else {
        storage.remove(StorageKeys.REMEMBER_PASSWORD);
      }
      
      appStore.showToast('登录成功', 'success');
      
      // 延迟跳转，让用户看到成功提示
      setTimeout(() => {
        uni.reLaunch({
          url: '/pages/home/index',
        });
      }, 1000);
    } else {
      appStore.showToast(result.message, 'error');
    }
  } catch (error: any) {
    appStore.showToast(error.message || '登录失败', 'error');
  } finally {
    loading.value = false;
  }
};

// 微信登录
const handleWechatLogin = async () => {
  loading.value = true;
  
  try {
    // 模拟微信登录流程
    // #ifdef MP-WEIXIN
    // 微信小程序环境
    const loginRes = await new Promise((resolve, reject) => {
      uni.login({
        provider: 'weixin',
        success: resolve,
        fail: reject
      });
    });
    
    if (loginRes.code) {
      // 这里应该调用后端API，用code换取用户信息
      // 模拟登录成功
      const mockToken = 'wechat_token_' + Date.now();
      const mockUserInfo: any = {
        id: 'wx_' + Date.now(),
        phone: '',
        name: '微信用户',
        avatar: 'static/avatar/default.svg',
        level: 1,
        exp: 0,
        points: 0,
        badges: 0,
        school: '明蹊中学',
        grade: '初一',
        class: '2班',
      };
      
      userStore.$patch({ token: mockToken, userInfo: mockUserInfo });
      storage.set(StorageKeys.TOKEN, mockToken);
      storage.set(StorageKeys.USER_INFO, mockUserInfo);
      
      appStore.showToast('微信登录成功', 'success');
      setTimeout(() => {
        uni.reLaunch({
          url: '/pages/home/index',
        });
      }, 1000);
    }
    // #endif
    
    // #ifndef MP-WEIXIN
    // 非微信小程序环境，模拟登录
    setTimeout(() => {
      const mockToken = 'wechat_token_' + Date.now();
      const mockUserInfo: any = {
        id: 'wx_' + Date.now(),
        phone: '',
        name: '微信用户',
        avatar: 'static/avatar/default.svg',
        level: 1,
        exp: 0,
        points: 0,
        badges: 0,
        school: '明蹊中学',
        grade: '初一',
        class: '2班',
      };
      
      userStore.$patch({ token: mockToken, userInfo: mockUserInfo });
      storage.set(StorageKeys.TOKEN, mockToken);
      storage.set(StorageKeys.USER_INFO, mockUserInfo);
      
      appStore.showToast('微信登录成功（模拟）', 'success');
      setTimeout(() => {
        uni.reLaunch({
          url: '/pages/home/index',
        });
      }, 1000);
    }, 800);
    // #endif
  } catch (error: any) {
    appStore.showToast(error.message || '微信登录失败', 'error');
  } finally {
    loading.value = false;
  }
};

// 忘记密码
const handleForgetPassword = () => {
  appStore.showToast('请联系管理员重置密码', 'none');
};

// 跳转注册页
const goToRegister = () => {
  uni.navigateTo({
    url: '/pages/auth/register',
  });
};

// 显示协议
const showAgreement = (type: 'user' | 'privacy') => {
  const title = type === 'user' ? '用户协议' : '隐私政策';
  appStore.showToast(`查看${title}`, 'none');
};

// 页面加载时恢复记住的密码
onMounted(() => {
  const remembered = storage.get(StorageKeys.REMEMBER_PASSWORD);
  if (remembered) {
    formData.phone = remembered.phone || '';
    formData.password = remembered.password || '';
    formData.remember = true;
  }
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.login-page {
  min-height: 100vh;
  background-color: $bg-color;
}

// 顶部装饰
.login-header {
  position: relative;
  height: 480rpx;
  background: $gradient-primary;
  overflow: hidden;
  
  .header-wave {
    position: absolute;
    bottom: -2rpx;
    left: 0;
    right: 0;
    height: 60rpx;
    background-color: $bg-color;
    border-radius: 100% 100% 0 0 / 60rpx 60rpx 0 0;
    z-index: 0;
  }
  
  .header-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    padding-bottom: 80rpx;
    position: relative;
    z-index: 1;
    
    .logo-wrap {
      width: 160rpx;
      height: 160rpx;
      border-radius: 80rpx;
      background-color: #FFFFFF;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.1);
      margin-bottom: 32rpx;
    }
    
    .logo {
      width: 120rpx;
      height: 120rpx;
    }
    
    .slogan {
      font-size: $font-size-xl;
      color: $text-white;
      font-weight: bold;
    }
  }
}

// 登录表单
.login-form {
  padding: 0 48rpx;
  margin-top: 0;
  position: relative;
  z-index: 2;
  min-height: calc(100vh - 600rpx);
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.form-item {
  margin-bottom: 32rpx;
}

.form-label {
  display: flex;
  align-items: center;
  padding: 24rpx;
  background-color: $bg-color;
  border-radius: $border-radius;
  
  .icon {
    font-size: 36rpx;
    margin-right: 16rpx;
  }
  
  .form-input {
    flex: 1;
    font-size: $font-size-base;
    color: $text-primary;
  }
  
  .icon-btn {
    font-size: 32rpx;
    padding: 0 8rpx;
    cursor: pointer;
  }
}

.input-error {
  color: $error-color;
}

.error-text {
  display: block;
  margin-top: 8rpx;
  margin-left: 24rpx;
  font-size: $font-size-xs;
  color: $error-color;
}

// 表单选项
.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 48rpx;
  padding: 0 8rpx;
}

.checkbox-label {
  display: flex;
  align-items: center;
  
  .checkbox {
    font-size: 32rpx;
    margin-right: 8rpx;
    color: $primary-color;
  }
  
  .option-text {
    font-size: $font-size-sm;
    color: $text-secondary;
  }
}

.forget-text {
  font-size: $font-size-sm;
  color: $primary-color;
  cursor: pointer;
}

// 按钮
.form-button {
  margin-bottom: 32rpx;
}

// 分割线
.divider {
  display: flex;
  align-items: center;
  margin: 32rpx 0;
  
  .divider-line {
    flex: 1;
    height: 1rpx;
    background-color: $divider-color;
  }
  
  .divider-text {
    margin: 0 24rpx;
    font-size: $font-size-sm;
    color: $text-placeholder;
  }
}

// 底部
.login-footer {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 48rpx;
  
  .footer-text {
    font-size: $font-size-base;
    color: $text-secondary;
  }
  
  .link-text {
    font-size: $font-size-base;
    color: $primary-color;
    margin-left: 8rpx;
    cursor: pointer;
  }
}

.agreement {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 32rpx;
  padding-bottom: 48rpx;
  
  .agreement-text {
    font-size: $font-size-xs;
    color: $text-placeholder;
    cursor: pointer;
    
    &.link-text {
      color: $primary-color;
    }
  }
}
</style>

