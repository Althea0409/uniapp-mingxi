<template>
  <view class="settings-page">
    <text>设置</text>
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

const save = () => {
  storage.set(StorageKeys.AI_API_KEY, apiKey.value || '');
  storage.set(StorageKeys.AI_BASE_URL, baseUrl.value || '');
  storage.set(StorageKeys.AI_MODEL, model.value || '');
  appStore.showToast('保存成功', 'success');
  appStore.navigateBack(1);
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
};

const useBailianDefault = () => {
  baseUrl.value = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
  model.value = 'qwen-plus';
};

const useProxyDefault = () => {
  baseUrl.value = '/api';
  apiKey.value = '';
  if (!model.value) model.value = 'gpt-4o-mini';
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.content { padding: 24rpx 32rpx calc(24rpx + var(--window-bottom)) 32rpx; box-sizing: border-box; }
.section { display: flex; flex-direction: column; gap: 24rpx; }
.title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.desc-row { display: flex; align-items: center; }
.desc { font-size: $font-size-sm; color: $text-secondary; }
.form { display: flex; flex-direction: column; gap: 16rpx; }
.form-item { display: flex; flex-direction: column; gap: 8rpx; }
.label { font-size: $font-size-sm; color: $text-secondary; }
.input { height: 80rpx; border: 1rpx solid $divider-color; border-radius: 12rpx; padding: 0 20rpx; font-size: $font-size-base; color: $text-primary; background: $card-bg; }
.quick-row { display: flex; gap: 16rpx; }
.actions { display: flex; justify-content: space-between; gap: 16rpx; margin-top: 8rpx; }
.tips { display: flex; flex-direction: column; gap: 8rpx; }
.tip { font-size: $font-size-xs; color: $text-secondary; }
.settings-page { min-height: 100vh; background-color: $bg-color; }
</style>

