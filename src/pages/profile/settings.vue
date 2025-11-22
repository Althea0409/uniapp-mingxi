<template>
  <view class="settings-page">
    <scroll-view scroll-y class="content">
      <!-- AI配置 -->
      <Card>
        <view class="section">
          <text class="title">AI助手配置</text>
          <text class="desc">配置AI学习助手的API信息</text>
          
          <view class="form">
            <view class="form-item">
              <text class="label">API Key</text>
              <input 
                class="input" 
                v-model="apiKey" 
                type="password"
                placeholder="请输入API Key"
              />
            </view>
            
            <view class="form-item">
              <text class="label">Base URL</text>
              <input 
                class="input" 
                v-model="baseUrl" 
                placeholder="请输入Base URL"
              />
            </view>
            
            <view class="form-item">
              <text class="label">Model</text>
              <input 
                class="input" 
                v-model="model" 
                placeholder="请输入模型名称"
              />
            </view>
            
            <view class="quick-row">
              <Button text="使用OpenAI" type="secondary" size="small" @click="useOpenAIDefault" />
              <Button text="使用通义千问" type="secondary" size="small" @click="useBailianDefault" />
              <Button text="使用代理" type="secondary" size="small" @click="useProxyDefault" />
            </view>
            
            <view class="tips">
              <text class="tip">• 使用代理时，Base URL填写 /api</text>
              <text class="tip">• API Key留空时，将使用代理模式</text>
            </view>
            
            <view class="actions">
              <Button text="清空" type="secondary" size="small" @click="clearAll" />
              <Button text="保存" type="primary" size="small" @click="save" />
            </view>
          </view>
        </view>
      </Card>

      <!-- 应用设置 -->
      <Card>
        <view class="section">
          <text class="title">应用设置</text>
          
          <view class="form">
            <view class="form-item">
              <view class="desc-row">
                <text class="label">消息通知</text>
                <switch :checked="notifications" @change="onNotificationChange" />
              </view>
            </view>
            
            <view class="form-item">
              <view class="desc-row">
                <text class="label">学习提醒</text>
                <switch :checked="studyReminder" @change="onStudyReminderChange" />
              </view>
            </view>
            
            <view class="form-item">
              <view class="desc-row">
                <text class="label">自动保存草稿</text>
                <switch :checked="autoSave" @change="onAutoSaveChange" />
              </view>
            </view>
          </view>
        </view>
      </Card>

      <!-- 关于 -->
      <Card>
        <view class="section">
          <text class="title">关于</text>
          
          <view class="form">
            <view class="form-item">
              <text class="label">版本号</text>
              <text class="desc">v1.0.0</text>
            </view>
            
            <view class="form-item">
              <text class="label">开发者</text>
              <text class="desc">明蹊智慧学习团队</text>
            </view>
          </view>
        </view>
      </Card>

      <!-- 数据管理 -->
      <Card>
        <view class="section">
          <text class="title">数据管理</text>
          
          <view class="form">
            <Button text="清除缓存" type="secondary" size="large" @click="clearCache" />
            <Button text="导出数据" type="secondary" size="large" @click="exportData" />
          </view>
        </view>
      </Card>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { storage, StorageKeys } from '@/utils/storage';
import { useAppStore } from '@/stores/app';

const appStore = useAppStore();

const apiKey = ref<string>(storage.get(StorageKeys.AI_API_KEY) || '');
const baseUrl = ref<string>(storage.get(StorageKeys.AI_BASE_URL) || 'https://api.openai.com/v1');
const model = ref<string>(storage.get(StorageKeys.AI_MODEL) || 'gpt-4o-mini');

const notifications = ref<boolean>(storage.get(StorageKeys.NOTIFICATIONS) !== false);
const studyReminder = ref<boolean>(storage.get(StorageKeys.STUDY_REMINDER) !== false);
const autoSave = ref<boolean>(storage.get(StorageKeys.AUTO_SAVE) !== false);

const save = () => {
  storage.set(StorageKeys.AI_API_KEY, apiKey.value || '');
  storage.set(StorageKeys.AI_BASE_URL, baseUrl.value || '');
  storage.set(StorageKeys.AI_MODEL, model.value || '');
  appStore.showToast('保存成功', 'success');
  setTimeout(() => {
    uni.navigateBack();
  }, 1000);
};

const clearAll = () => {
  apiKey.value = '';
  baseUrl.value = '';
  model.value = '';
  storage.remove(StorageKeys.AI_API_KEY);
  storage.remove(StorageKeys.AI_BASE_URL);
  storage.remove(StorageKeys.AI_MODEL);
  appStore.showToast('已清空', 'success');
};

const useOpenAIDefault = () => {
  baseUrl.value = 'https://api.openai.com/v1';
  if (!model.value) model.value = 'gpt-4o-mini';
  appStore.showToast('已切换到OpenAI配置', 'success');
};

const useBailianDefault = () => {
  baseUrl.value = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
  model.value = 'qwen-plus';
  appStore.showToast('已切换到通义千问配置', 'success');
};

const useProxyDefault = () => {
  baseUrl.value = '/api';
  apiKey.value = '';
  if (!model.value) model.value = 'gpt-4o-mini';
  appStore.showToast('已切换到代理配置', 'success');
};

const onNotificationChange = (e: any) => {
  notifications.value = e.detail.value;
  storage.set(StorageKeys.NOTIFICATIONS, notifications.value);
};

const onStudyReminderChange = (e: any) => {
  studyReminder.value = e.detail.value;
  storage.set(StorageKeys.STUDY_REMINDER, studyReminder.value);
};

const onAutoSaveChange = (e: any) => {
  autoSave.value = e.detail.value;
  storage.set(StorageKeys.AUTO_SAVE, autoSave.value);
};

const clearCache = () => {
  uni.showModal({
    title: '清除缓存',
    content: '确定要清除所有缓存数据吗？此操作不可恢复。',
    success: (res) => {
      if (res.confirm) {
        // 清除部分缓存，保留用户信息
        storage.remove(StorageKeys.STUDY_STATS);
        storage.remove(StorageKeys.GROWTH_LOG);
        appStore.showToast('缓存已清除', 'success');
      }
    }
  });
};

const exportData = () => {
  appStore.showLoading('正在导出数据...');
  
  // 收集所有用户数据
  const userInfo = userStore.userInfo;
  const courses = storage.get(StorageKeys.COURSES) || [];
  const homework = storage.get(StorageKeys.HOMEWORK) || [];
  const preview = storage.get(StorageKeys.PREVIEW) || [];
  const schedule = storage.get(StorageKeys.SCHEDULE) || [];
  const growthLog = storage.get(StorageKeys.GROWTH_LOG) || [];
  const achievements = storage.get(StorageKeys.ACHIEVEMENTS) || [];
  const studyStats = storage.get(StorageKeys.STUDY_STATS) || {};
  
  const exportData = {
    exportTime: new Date().toISOString(),
    userInfo,
    courses,
    homework,
    preview,
    schedule,
    growthLog,
    achievements,
    studyStats
  };
  
  // 转换为JSON字符串
  const jsonStr = JSON.stringify(exportData, null, 2);
  
  // 创建文件并下载（H5环境）
  if (typeof window !== 'undefined') {
    const blob = new Blob([jsonStr], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `mingxi-data-${new Date().getTime()}.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    
    appStore.hideLoading();
    appStore.showToast('数据导出成功', 'success');
  } else {
    // 小程序环境，复制到剪贴板
    uni.setClipboardData({
      data: jsonStr,
      success: () => {
        appStore.hideLoading();
        appStore.showToast('数据已复制到剪贴板', 'success');
      },
      fail: () => {
        appStore.hideLoading();
        appStore.showToast('导出失败，请稍后重试', 'error');
      }
    });
  }
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.settings-page {
  min-height: 100vh;
  background-color: $bg-color;
}

.content {
  padding: 24rpx 32rpx calc(24rpx + var(--window-bottom)) 32rpx;
  box-sizing: border-box;
}

.section {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.desc {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.desc-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.form-item {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.label {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.input {
  height: 80rpx;
  border: 1rpx solid $divider-color;
  border-radius: 12rpx;
  padding: 0 20rpx;
  font-size: $font-size-base;
  color: $text-primary;
  background: $card-bg;
}

.quick-row {
  display: flex;
  gap: 16rpx;
  flex-wrap: wrap;
}

.actions {
  display: flex;
  justify-content: space-between;
  gap: 16rpx;
  margin-top: 8rpx;
}

.tips {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  padding: 16rpx;
  background: $bg-color;
  border-radius: $border-radius;
}

.tip {
  font-size: $font-size-xs;
  color: $text-secondary;
  line-height: 1.6;
}
</style>
