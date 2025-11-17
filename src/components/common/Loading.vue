<template>
  <view v-if="visible" class="loading-container" :class="{ 'loading-fullscreen': fullscreen }">
    <view class="loading-content">
      <view class="loading-spinner" :class="`loading-${type}`"></view>
      <text v-if="text" class="loading-text">{{ text }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
interface Props {
  // 是否显示
  visible?: boolean;
  // 加载文字
  text?: string;
  // 加载类型
  type?: 'spinner' | 'circular';
  // 是否全屏
  fullscreen?: boolean;
}

withDefaults(defineProps<Props>(), {
  visible: false,
  text: '加载中...',
  type: 'spinner',
  fullscreen: false,
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.loading-container {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40rpx;
}

.loading-fullscreen {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: $z-index-modal;
  padding: 0;
}

.loading-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.7);
  border-radius: $border-radius;
  padding: 40rpx;
}

.loading-fullscreen .loading-content {
  min-width: 200rpx;
}

.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  margin-bottom: 16rpx;
  animation: rotate 0.8s linear infinite;
}

.loading-spinner {
  border: 6rpx solid rgba(255, 255, 255, 0.3);
  border-top-color: #FFFFFF;
  border-radius: 50%;
}

.loading-circular {
  border-radius: 50%;
  background: conic-gradient(
    transparent 0deg,
    transparent 270deg,
    #FFFFFF 270deg,
    #FFFFFF 360deg
  );
}

.loading-text {
  font-size: $font-size-sm;
  color: #FFFFFF;
  line-height: 1.5;
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>

