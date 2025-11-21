<template>
  <view class="register-page">

    <!-- 进度指示器 -->
    <view class="progress-container">
      <view class="progress-steps">
        <view v-for="(step, index) in steps" :key="index"
          :class="['step-item', { active: currentStep > index, current: currentStep === index + 1 }]">
          <view class="step-circle">
            <text v-if="currentStep > index + 1" class="step-icon">✓</text>
            <text v-else class="step-number">{{ index + 1 }}</text>
          </view>
          <text class="step-label">{{ step }}</text>
        </view>
        <view class="progress-line" :style="{ width: progressWidth }"></view>
      </view>
    </view>

    <!-- 表单内容 -->
    <view class="register-form">
      <Card>
        <!-- 第一步：基本信息 -->
        <view v-if="currentStep === 1" class="form-step">
          <text class="step-title">基本信息</text>

          <!-- 姓名 -->
          <view class="form-item">
            <view class="form-label">
              <text class="icon">👤</text>
              <input v-model="formData.name" placeholder="请输入真实姓名"
                :class="['form-input', { 'input-error': errors.name }]" @blur="validateField('name')" />
            </view>
            <text v-if="errors.name" class="error-text">{{ errors.name }}</text>
          </view>

          <!-- 手机号 -->
          <view class="form-item">
            <view class="form-label">
              <text class="icon">📱</text>
              <input v-model="formData.phone" type="number" placeholder="请输入手机号" maxlength="11"
                :class="['form-input', { 'input-error': errors.phone }]" @blur="validateField('phone')" />
            </view>
            <text v-if="errors.phone" class="error-text">{{ errors.phone }}</text>
          </view>

          <!-- 验证码 -->
          <view class="form-item">
            <view class="form-label">
              <text class="icon">🔢</text>
              <input v-model="formData.code" type="number" placeholder="请输入验证码" maxlength="6"
                :class="['form-input code-input', { 'input-error': errors.code }]" @blur="validateField('code')" />
              <view class="code-btn-wrapper">
                <Button :text="codeText" type="text" size="small" :disabled="codeCountdown > 0" @click="sendCode" />
              </view>
            </view>
            <text v-if="errors.code" class="error-text">{{ errors.code }}</text>
          </view>

          <!-- 密码 -->
          <view class="form-item">
            <view class="form-label">
              <text class="icon">🔒</text>
              <input v-model="formData.password" :password="!showPassword" placeholder="请设置密码（8-16位字母+数字）"
                :class="['form-input', { 'input-error': errors.password }]" @blur="validateField('password')"
                @input="onPasswordInput" />
              <text class="icon-btn" @tap="showPassword = !showPassword">
                {{ showPassword ? '👁️' : '🙈' }}
              </text>
            </view>
            <text v-if="errors.password" class="error-text">{{ errors.password }}</text>
            <view v-if="formData.password && !errors.password" class="password-strength">
              <text class="strength-label">密码强度：</text>
              <view class="strength-bars">
                <view v-for="i in 3" :key="i" :class="['strength-bar', { active: i <= strengthLevel }]"
                  :style="{ backgroundColor: strengthColor }"></view>
              </view>
              <text class="strength-text" :style="{ color: strengthColor }">{{ strengthText }}</text>
            </view>
          </view>

          <!-- 确认密码 -->
          <view class="form-item">
            <view class="form-label">
              <text class="icon">🔐</text>
              <input v-model="formData.confirmPassword" password placeholder="请再次输入密码"
                :class="['form-input', { 'input-error': errors.confirmPassword }]"
                @blur="validateField('confirmPassword')" />
            </view>
            <text v-if="errors.confirmPassword" class="error-text">{{ errors.confirmPassword }}</text>
          </view>
        </view>

        <!-- 第二步：学校信息 -->
        <view v-if="currentStep === 2" class="form-step">
          <text class="step-title">学校信息</text>

          <!-- 学校 -->
          <view class="form-item">
            <view class="form-label">
              <text class="icon">🏫</text>
              <input v-model="formData.school" placeholder="请输入学校名称"
                :class="['form-input', { 'input-error': errors.school }]" @blur="validateField('school')" />
            </view>
            <text v-if="errors.school" class="error-text">{{ errors.school }}</text>
          </view>

          <!-- 年级 -->
          <view class="form-item">
            <picker mode="selector" :range="gradeList" @change="onGradeChange">
              <view class="form-label">
                <text class="icon">📚</text>
                <text :class="['form-input picker-input', { placeholder: !formData.grade }]">
                  {{ formData.grade || '请选择年级' }}
                </text>
                <text class="arrow-icon">▼</text>
              </view>
            </picker>
            <text v-if="errors.grade" class="error-text">{{ errors.grade }}</text>
          </view>

          <!-- 班级 -->
          <view class="form-item">
            <view class="form-label">
              <text class="icon">🎓</text>
              <input v-model="formData.class" type="text" placeholder="请输入班级（如：3班）"
                :class="['form-input', { 'input-error': errors.class }]" @blur="validateField('class')" />
            </view>
            <text v-if="errors.class" class="error-text">{{ errors.class }}</text>
          </view>
        </view>

        <!-- 第三步：完成注册 -->
        <view v-if="currentStep === 3" class="form-step">
          <text class="step-title">确认信息</text>

          <view class="info-preview">
            <view class="preview-item">
              <text class="preview-label">姓名：</text>
              <text class="preview-value">{{ formData.name }}</text>
            </view>
            <view class="preview-item">
              <text class="preview-label">手机号：</text>
              <text class="preview-value">{{ formData.phone }}</text>
            </view>
            <view class="preview-item">
              <text class="preview-label">学校：</text>
              <text class="preview-value">{{ formData.school }}</text>
            </view>
            <view class="preview-item">
              <text class="preview-label">年级：</text>
              <text class="preview-value">{{ formData.grade }}</text>
            </view>
            <view class="preview-item">
              <text class="preview-label">班级：</text>
              <text class="preview-value">{{ formData.class }}</text>
            </view>
          </view>

          <!-- 用户协议 -->
          <view class="agreement-check">
            <label class="checkbox-label" @tap="formData.agree = !formData.agree">
              <text class="checkbox">{{ formData.agree ? '☑' : '☐' }}</text>
              <text class="agreement-text">
                我已阅读并同意
                <text class="link-text" @tap.stop="showAgreement('user')">《用户协议》</text>
                和
                <text class="link-text" @tap.stop="showAgreement('privacy')">《隐私政策》</text>
              </text>
            </label>
            <text v-if="errors.agree" class="error-text">{{ errors.agree }}</text>
          </view>
        </view>

        <!-- 按钮组 -->
        <view class="form-buttons">
          <Button v-if="currentStep > 1" text="上一步" type="secondary" size="large" @click="prevStep" />
          <Button v-if="currentStep < 3" text="下一步" type="primary" size="large" @click="nextStep" />
          <Button v-if="currentStep === 3" text="完成注册" type="primary" size="large" :loading="loading"
            @click="handleRegister" />
        </view>
      </Card>

      <!-- 底部文字 -->
      <view class="register-footer">
        <text class="footer-text">已有账号？</text>
        <text class="link-text" @tap="goToLogin">立即登录</text>
      </view>
    </view>


  </view>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue';
import { useUserStore } from '@/stores/user';
import { useAppStore } from '@/stores/app';
import {
  validatePhone,
  validatePassword,
  validateCode,
  validateName,
  isEmpty,
  getPasswordStrength,
} from '@/utils/validate';
import type { RegisterForm } from '@/types/user';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';

const userStore = useUserStore();
const appStore = useAppStore();

// 步骤配置
const steps = ['基本信息', '学校信息', '完成注册'];
const currentStep = ref(1);

// 表单数据
const formData = reactive<RegisterForm>({
  name: '',
  phone: '',
  code: '',
  password: '',
  confirmPassword: '',
  school: '',
  grade: '',
  class: '',
  agree: false,
});

// 错误信息
const errors = reactive({
  name: '',
  phone: '',
  code: '',
  password: '',
  confirmPassword: '',
  school: '',
  grade: '',
  class: '',
  agree: '',
});

// 其他状态
const loading = ref(false);
const showPassword = ref(false);
const codeCountdown = ref(0);


// 年级列表
const gradeList = ['高一', '高二', '高三', '初一', '初二', '初三'];

// 验证码文字
const codeText = computed(() => {
  return codeCountdown.value > 0 ? `${codeCountdown.value}s后重试` : '获取验证码';
});

// 进度条宽度
const progressWidth = computed(() => {
  return `${((currentStep.value - 1) / 2) * 100}%`;
});

// 密码强度
const passwordStrength = computed(() => {
  if (!formData.password) return 'weak';
  return getPasswordStrength(formData.password);
});

const strengthLevel = computed(() => {
  const map = { weak: 1, medium: 2, strong: 3 };
  return map[passwordStrength.value];
});

const strengthColor = computed(() => {
  const map = { weak: '#F5222D', medium: '#FAAD14', strong: '#52C41A' };
  return map[passwordStrength.value];
});

const strengthText = computed(() => {
  const map = { weak: '弱', medium: '中', strong: '强' };
  return map[passwordStrength.value];
});

// 验证单个字段
const validateField = (field: keyof typeof errors): boolean => {
  switch (field) {
    case 'name':
      if (isEmpty(formData.name)) {
        errors.name = '请输入姓名';
        return false;
      }
      if (!validateName(formData.name)) {
        errors.name = '姓名格式不正确';
        return false;
      }
      errors.name = '';
      return true;

    case 'phone':
      if (isEmpty(formData.phone)) {
        errors.phone = '请输入手机号';
        return false;
      }
      if (!validatePhone(formData.phone)) {
        errors.phone = '手机号格式不正确';
        return false;
      }
      errors.phone = '';
      return true;

    case 'code':
      if (isEmpty(formData.code)) {
        errors.code = '请输入验证码';
        return false;
      }
      if (!validateCode(formData.code)) {
        errors.code = '验证码格式不正确';
        return false;
      }
      errors.code = '';
      return true;

    case 'password':
      if (isEmpty(formData.password)) {
        errors.password = '请输入密码';
        return false;
      }
      if (!validatePassword(formData.password)) {
        errors.password = '密码必须为8-16位，包含字母和数字';
        return false;
      }
      errors.password = '';
      return true;

    case 'confirmPassword':
      if (isEmpty(formData.confirmPassword)) {
        errors.confirmPassword = '请再次输入密码';
        return false;
      }
      if (formData.confirmPassword !== formData.password) {
        errors.confirmPassword = '两次密码输入不一致';
        return false;
      }
      errors.confirmPassword = '';
      return true;

    case 'school':
      if (isEmpty(formData.school)) {
        errors.school = '请输入学校名称';
        return false;
      }
      errors.school = '';
      return true;

    case 'grade':
      if (isEmpty(formData.grade)) {
        errors.grade = '请选择年级';
        return false;
      }
      errors.grade = '';
      return true;

    case 'class':
      if (isEmpty(formData.class)) {
        errors.class = '请输入班级';
        return false;
      }
      errors.class = '';
      return true;

    case 'agree':
      if (!formData.agree) {
        errors.agree = '请阅读并同意用户协议和隐私政策';
        return false;
      }
      errors.agree = '';
      return true;

    default:
      return true;
  }
};

// 验证当前步骤
const validateCurrentStep = (): boolean => {
  if (currentStep.value === 1) {
    return (
      validateField('name') &&
      validateField('phone') &&
      validateField('code') &&
      validateField('password') &&
      validateField('confirmPassword')
    );
  } else if (currentStep.value === 2) {
    return (
      validateField('school') &&
      validateField('grade') &&
      validateField('class')
    );
  } else if (currentStep.value === 3) {
    return validateField('agree');
  }
  return false;
};

// 密码输入事件
const onPasswordInput = () => {
  // 清除密码错误
  if (errors.password) {
    errors.password = '';
  }
};

// 发送验证码
const sendCode = () => {
  if (!validateField('phone')) {
    return;
  }

  // Mock发送验证码
  appStore.showToast('验证码已发送', 'success');
  codeCountdown.value = 60;

  const timer = setInterval(() => {
    codeCountdown.value--;
    if (codeCountdown.value <= 0) {
      clearInterval(timer);
    }
  }, 1000);
};

// 下一步
const nextStep = () => {
  if (!validateCurrentStep()) {
    appStore.showToast('请完善信息', 'none');
    return;
  }
  currentStep.value++;
};

// 上一步
const prevStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--;
  }
};

// 年级选择
const onGradeChange = (e: any) => {
  formData.grade = gradeList[e.detail.value];
  showGradePicker.value = false;
  validateField('grade');
};

// 注册
const handleRegister = async () => {
  if (!validateCurrentStep()) {
    return;
  }
  loading.value = true;
  try {
    const res = await fetch('/api/auth/register', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({
        name: formData.name,
        phone: formData.phone,
        password: formData.password,
        school: formData.school,
        grade: formData.grade,
        class: formData.class,
      }),
    });
    const data = await res.json();
    if (!res.ok) {
      appStore.showToast(data?.error || '注册失败', 'none');
      return;
    }
    appStore.showToast('注册成功', 'success');
    setTimeout(() => {
      uni.redirectTo({ url: '/pages/auth/login' });
    }, 800);
  } catch (error: any) {
    appStore.showToast(error?.message || '注册失败', 'none');
  } finally {
    loading.value = false;
  }
};

// 返回
const handleBack = () => {
  if (currentStep.value > 1) {
    prevStep();
  } else {
    uni.navigateBack();
  }
};

// 跳转登录页
const goToLogin = () => {
  uni.navigateBack();
};

// 显示协议
const showAgreement = (type: 'user' | 'privacy') => {
  const title = type === 'user' ? '用户协议' : '隐私政策';
  appStore.showToast(`查看${title}`, 'none');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.register-page {
  min-height: 100vh;
  background-color: $bg-color;
}


// 进度指示器
.progress-container {
  padding: 48rpx 32rpx;
  background-color: $card-bg;
}

.progress-steps {
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.step-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 1;

  .step-circle {
    width: 64rpx;
    height: 64rpx;
    border-radius: 50%;
    background-color: $bg-color;
    border: 4rpx solid $border-color;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16rpx;
    transition: $transition-base;
  }

  .step-number,
  .step-icon {
    font-size: $font-size-lg;
    color: $text-disabled;
    font-weight: bold;
  }

  .step-label {
    font-size: $font-size-xs;
    color: $text-secondary;
  }

  &.current .step-circle {
    background-color: $primary-color;
    border-color: $primary-color;
  }

  &.current .step-number {
    color: $text-white;
  }

  &.active .step-circle {
    background-color: $primary-color;
    border-color: $primary-color;
  }

  &.active .step-icon {
    color: $text-white;
  }
}

.progress-line {
  position: absolute;
  top: 32rpx;
  left: 10%;
  width: 0;
  height: 4rpx;
  background: $gradient-primary;
  transition: width 0.5s ease;
  z-index: 0;
}

// 表单
.register-form {
  padding: 0 32rpx;
  margin-top: 32rpx;
}

.form-step {
  .step-title {
    display: block;
    font-size: $font-size-xl;
    font-weight: bold;
    color: $text-primary;
    margin-bottom: 32rpx;
  }
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

    &.placeholder {
      color: $text-placeholder;
    }
  }

  .code-input {
    flex: 1;
    margin-right: 16rpx;
  }

  .code-btn-wrapper {
    flex-shrink: 0;
  }

  .picker-input {
    flex: 1;
  }

  .arrow-icon {
    font-size: 24rpx;
    color: $text-placeholder;
    margin-left: 8rpx;
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

// 密码强度
.password-strength {
  display: flex;
  align-items: center;
  margin-top: 16rpx;
  padding: 0 24rpx;

  .strength-label {
    font-size: $font-size-xs;
    color: $text-secondary;
    margin-right: 16rpx;
  }

  .strength-bars {
    display: flex;
    gap: 8rpx;
    margin-right: 16rpx;
  }

  .strength-bar {
    width: 60rpx;
    height: 8rpx;
    background-color: $divider-color;
    border-radius: 4rpx;
    transition: $transition-fast;

    &.active {
      background-color: currentColor;
    }
  }

  .strength-text {
    font-size: $font-size-xs;
    font-weight: bold;
  }
}

// 信息预览
.info-preview {
  padding: 24rpx;
  background-color: $bg-color;
  border-radius: $border-radius;
  margin-bottom: 32rpx;
}

.preview-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16rpx 0;
  border-bottom: 1rpx solid $divider-color;

  &:last-child {
    border-bottom: none;
  }

  .preview-label {
    font-size: $font-size-base;
    color: $text-secondary;
  }

  .preview-value {
    font-size: $font-size-base;
    color: $text-primary;
    font-weight: bold;
  }
}

// 协议勾选
.agreement-check {
  margin-bottom: 48rpx;
}

.checkbox-label {
  display: flex;
  align-items: flex-start;

  .checkbox {
    font-size: 32rpx;
    margin-right: 8rpx;
    color: $primary-color;
    flex-shrink: 0;
  }

  .agreement-text {
    font-size: $font-size-sm;
    color: $text-secondary;
    line-height: 1.6;
  }

  .link-text {
    color: $primary-color;
    cursor: pointer;
  }
}

// 按钮组
.form-buttons {
  display: flex;
  gap: 24rpx;
  margin-top: 48rpx;
}

// 底部
.register-footer {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 48rpx;
  padding-bottom: 48rpx;

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
</style>
